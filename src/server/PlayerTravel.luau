--!strict
local Players=game:GetService("Players")
local TeleportService=game:GetService("TeleportService")
local Spatial=require(script.Parent.Spatial)
local Plan=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("WorldPlan"))
local RateLimiter=require(script.Parent.RateLimiter)
local TravelSession=require(script.Parent.TravelSession)
local PlayerTravel={}
local where={}
local doorById={}
for _,d in ipairs(Plan.doors) do doorById[d.door_id]=d end
local replyEvent=nil

local function report(player,status,message)
    if replyEvent and player.Parent==Players then
        replyEvent:FireClient(player,{kind="travel.failure.v1",status=status,message=message})
    end
end
local function destination(place,anchor)
    local cf=Spatial.anchorCFrame(place,anchor)
    if not cf then return nil end
    return cf*CFrame.new(0,1.4,0)
end
local function move(player,place,anchor,existingToken)
    local cf=destination(place,anchor)
    if not cf then
        if existingToken then TravelSession.finish(player,existingToken) end
        return false
    end
    local token=existingToken or TravelSession.begin(player,"spawn")
    if not token then return false end
    if Spatial.mode()=="LOCAL_UNIVERSE" then
        -- Le stream est opportuniste : après toute suspension la session
        -- et le personnage doivent encore être valides.
        pcall(function() player:RequestStreamAroundAsync(cf.Position,4) end)
    end
    if not TravelSession.valid(player,token) then
        TravelSession.finish(player,token)
        return false
    end
    token.character:PivotTo(cf)
    where[player]={place=place,anchor=anchor}
    player:SetAttribute("KinZone",place)
    TravelSession.finish(player,token)
    return true
end
local function safeStart(currentPlace)
    if currentPlace=="city" then return "city.central.spawn" end
    local place=Spatial.place(currentPlace)
    assert(place,"Place inconnue: "..tostring(currentPlace))
    for _,a in ipairs(place.anchors) do
        if a.role=="spawn" then return a.anchor_id end
    end
    error("No safe start for "..currentPlace)
end
local function arrivalFromJoin(player,currentPlace)
    if Spatial.mode()=="LOCAL_UNIVERSE" then return nil end
    local ok,join=pcall(function()return player:GetJoinData() end)
    if not ok or type(join)~="table" then return nil end
    local td=join.TeleportData
    if type(td)~="table" or td.v~=1 then return nil end
    local src=doorById[td.sourceDoorId]
    if not src or src.destination_place_key~=currentPlace then return nil end
    if src.destination_anchor_id~=td.destinationAnchorId then return nil end
    return td.destinationAnchorId
end
function PlayerTravel.setup(state,events)
    replyEvent=events
    local startKey=state.currentPlace
    local function register(player)
        local requested=arrivalFromJoin(player,startKey)
        local anchor=requested or safeStart(startKey)
        where[player]={place=startKey,anchor=anchor}
        player:SetAttribute("KinZone",startKey)
        player.CharacterAdded:Connect(function(char)
            TravelSession.cancel(player)
            task.defer(function()
                char:WaitForChild("HumanoidRootPart",12)
                if player.Character~=char then return end
                local current=where[player]
                if current then move(player,current.place,current.anchor) end
            end)
        end)
        if player.Character then
            task.defer(function()
                local current=where[player]
                if current then move(player,current.place,current.anchor) end
            end)
        end
    end
    Players.PlayerAdded:Connect(register)
    for _,p in ipairs(Players:GetPlayers()) do register(p) end
    Players.PlayerRemoving:Connect(function(p)
        where[p]=nil
        TravelSession.cancel(p)
        RateLimiter.clear(p)
    end)
    TeleportService.TeleportInitFailed:Connect(function(p,result,message,placeId,options)
        report(p,"UNAVAILABLE","Le passage a échoué. Réessayez.")
    end)
end

local allowedShuttles={}
for _,door in ipairs(Plan.doors) do
    if door.source_place_key=="city" then allowedShuttles[door.source_anchor_id]=true end
end
allowedShuttles["city.central.spawn"]=true

function PlayerTravel.tryShuttle(player,data)
    local current=where[player]
    if not current or current.place~="city" or not allowedShuttles[data.anchor] then return end
    if not RateLimiter.allowed(player,"shuttle",2.0) then return end
    if not move(player,"city",data.anchor) then
        report(player,"BUSY","Un autre déplacement est en cours.")
    end
end

function PlayerTravel.tryLift(player,data)
    local current=where[player]
    if not current or current.place~=data.place_key then return end
    if typeof(data.destination)~="Vector3" then return end
    if not RateLimiter.allowed(player,"lift/"..tostring(data.lift_id),1.2) then return end
    local token=TravelSession.begin(player,"lift")
    if not token then return end
    if Spatial.mode()=="LOCAL_UNIVERSE" then
        pcall(function() player:RequestStreamAroundAsync(data.destination,4) end)
    end
    if TravelSession.valid(player,token) then
        token.character:PivotTo(CFrame.new(data.destination))
    end
    TravelSession.finish(player,token)
end

function PlayerTravel.tryDoor(player,door,state)
    local zone=where[player]
    if not zone or zone.place~=door.source_place_key then return end
    if not RateLimiter.allowed(player,"door",1.6) then return end
    local dest=door.destination_place_key
    local anchor=door.destination_anchor_id
    local token=TravelSession.begin(player,"door")
    if not token then return end
    if Spatial.mode()=="LOCAL_UNIVERSE" then
        if not move(player,dest,anchor,token) then
            report(player,"UNAVAILABLE","Passage indisponible actuellement.")
        end
        return
    end
    if Spatial.mode()=="SPLIT_PREVIEW" then
        TravelSession.finish(player,token)
        report(player,"UNPUBLISHED","Intérieur dans une Place distincte : publication requise. Utiliser l’aperçu dédié dans Studio.")
        return
    end
    local targetId=Spatial.placeId(dest)
    if not targetId then
        TravelSession.finish(player,token)
        report(player,"UNPUBLISHED","Ce lieu n'est pas publié.")
        return
    end
    if not TravelSession.valid(player,token) then
        TravelSession.finish(player,token)
        return
    end
    local opts=Instance.new("TeleportOptions")
    opts:SetTeleportData({v=1,sourceDoorId=door.door_id,destinationAnchorId=anchor})
    local success,reason=pcall(function()
        TeleportService:TeleportAsync(targetId,{player},opts)
    end)
    TravelSession.finish(player,token)
    if not success then
        warn("Kin City transit failure",door.door_id,reason)
        report(player,"ERROR","Impossible de franchir cette porte.")
    end
end
return PlayerTravel
