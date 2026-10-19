--!strict
-- Interactions locales pour marinas, maisons insulaires et sentiers.
-- Tous les compteurs sont éphémères (session). Aucune autorité kOA, réseau ou DataStore.
local Players=game:GetService("Players")
local PromptService=game:GetService("ProximityPromptService")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local Limiter=require(script.Parent.RateLimiter)
local Runtime={}
local marinaSeen={}
local roomsSeen={}
local trailsSeen={}
local rotating={}
local function send(reply,player,title,msg,notice)
    if player.Parent==Players then
        reply:FireClient(player,{kind="interaction.reply.v1",status="LOCAL_SUCCESS",title=title,message=msg,notice=notice or "Activité locale • aucun service kOA sollicité."})
    end
end
local function findPart(model,attribute,id)
    for _,desc in ipairs(model:GetDescendants()) do
        if desc:IsA("BasePart") and desc:GetAttribute(attribute)==id then return desc end
    end
    return nil
end
local function register(player)
    marinaSeen[player]={};roomsSeen[player]={};trailsSeen[player]={}
    player:SetAttribute("KinMarinaDiscoveries",0)
    player:SetAttribute("KinMarinaTotal",2)
    player:SetAttribute("KinAnnexRoomsVisited",0)
    player:SetAttribute("KinAnnexRoomsTotal",12)
    player:SetAttribute("KinIslandTrailVisits",0)
    player:SetAttribute("KinIslandTrailTotal",24)
end
local function mark(player,registry,key,attribute)
    local discovered=registry[player]
    if not discovered or discovered[key] then return false end
    discovered[key]=true
    local count=0
    for _ in pairs(discovered) do count+=1 end
    player:SetAttribute(attribute,count)
    return true
end
local function interactionInReach(prompt,player,world)
    local host=prompt.Parent
    if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return nil end
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health<=0 or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return nil end
    return host
end
local function marinaAction(host,player,reply)
    local action=host:GetAttribute("KinMarinaAction")
    local id=host:GetAttribute("KinMarinaId")
    if type(id)~="string" or (action~="beacon" and action~="crane" and action~="collect") then return false end
    local building=host.Parent
    if not building or not building:IsA("Model") or building:GetAttribute("KinMarinaId")~=id then return false end
    if not Limiter.allowed(player,"marina/"..id.."/"..action,0.9) then return true end
    if action=="collect" then
        local fresh=mark(player,marinaSeen,id,"KinMarinaDiscoveries")
        send(reply,player,building.Name,if fresh then "Nouveau port inscrit dans ton carnet maritime !" else "Cette marina figure déjà dans ton carnet.",
            string.format("Marinas visitées : %d/2",player:GetAttribute("KinMarinaDiscoveries") or 0))
    elseif action=="beacon" then
        local on=not (building:GetAttribute("KinMarinaLightActive")==false)
        building:SetAttribute("KinMarinaLightActive",not on)
        local lens=findPart(building,"KinMarinaLightLens",id)
        if lens then
            lens.Material=if on then Enum.Material.Glass else Enum.Material.Neon
            lens.Transparency=if on then 0.55 else 0.02
        end
        local beam=findPart(building,"KinMarinaBeam",id)
        if beam then beam.Transparency=if on then 1 else 0.25 end
        send(reply,player,"Phare de la marina",if on then "Phare éteint." else "Phare allumé : le faisceau balaye le lac.")
    elseif action=="crane" then
        local arm=findPart(building,"KinMarinaCraneArm",id)
        if arm then
            local rest=arm:GetAttribute("KinCraneHome")
            if typeof(rest)~="CFrame" then rest=arm.CFrame;arm:SetAttribute("KinCraneHome",rest) end
            local active=not (building:GetAttribute("KinCraneExtended")==true)
            building:SetAttribute("KinCraneExtended",active)
            TweenService:Create(arm,TweenInfo.new(2.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
                {CFrame=if active then rest*CFrame.Angles(0,math.rad(64),0) else rest}):Play()
        end
        send(reply,player,"Grue du port","La grue effectue sa manoeuvre locale.")
    end
    return true
end
local function annexAction(host,player,reply)
    local id=host:GetAttribute("KinAnnexExperienceId")
    if type(id)~="string" then return false end
    local model=host.Parent
    local islandId=host:GetAttribute("KinAnnexIslandId")
    if not model or not model:IsA("Model") or model:GetAttribute("KinAnnexIslandId")~=islandId then return false end
    if not Limiter.allowed(player,"annex/"..id,0.9) then return true end
    mark(player,roomsSeen,id,"KinAnnexRoomsVisited")
    local active=not (host:GetAttribute("KinAnnexActive")==true)
    host:SetAttribute("KinAnnexActive",active)
    local stem=id:match("%.room%.([AB])$")
    if stem then
        local z=if stem=="A" then 6 else 28
        local consolePos=host.Position
        for _,obj in ipairs(model:GetDescendants()) do
            if obj:IsA("BasePart") and obj:GetAttribute("KinAnnexReactive")==true and obj:GetAttribute("KinAnnexRoomZ")==z then
                TweenService:Create(obj,TweenInfo.new(0.65),{Transparency=if active then 0.02 else 0.55}):Play()
            end
        end
    end
    send(reply,player,"Maison des découvertes",if active then "Les collections de cette salle s'illuminent." else "La salle retrouve son éclairage de repos.",
        string.format("Salles découvertes : %d/12",player:GetAttribute("KinAnnexRoomsVisited") or 0))
    return true
end
local function trailAction(host,player,reply)
    local id=host:GetAttribute("KinIslandTrailId")
    if type(id)~="string" then return false end
    local n=host:GetAttribute("KinTrailStopNumber")
    if type(n)~="number" or n<1 or n>4 then return false end
    if not Limiter.allowed(player,"trail/"..id,0.5) then return true end
    local fresh=mark(player,trailsSeen,id,"KinIslandTrailVisits")
    send(reply,player,"Sentier de l'archipel",if fresh then "Nouvelle halte de randonnée découverte !" else "Tu connais déjà cette halte.",
        string.format("Haltes insulaires : %d/24",player:GetAttribute("KinIslandTrailVisits") or 0))
    return true
end
function Runtime.start(world,reply)
    Players.PlayerAdded:Connect(register)
    for _,p in ipairs(Players:GetPlayers()) do register(p) end
    Players.PlayerRemoving:Connect(function(p) marinaSeen[p]=nil;roomsSeen[p]=nil;trailsSeen[p]=nil end)
    for _,obj in ipairs(world:GetDescendants()) do
        if obj:IsA("BasePart") and obj:GetAttribute("KinMarinaBeam") then
            local model=obj.Parent
            local id=obj:GetAttribute("KinMarinaBeam")
            if model and model:IsA("Model") then
                model:SetAttribute("KinMarinaLightActive",true)
                local lens=findPart(model,"KinMarinaLightLens",id)
                if lens then table.insert(rotating,{beam=obj,lens=lens,marina=model,angle=0}) end
            end
        end
    end
    local accumulator=0
    local heartbeat=RunService.Heartbeat:Connect(function(dt)
        accumulator+=dt
        if accumulator<0.12 then return end
        local step=accumulator;accumulator=0
        if not world.Parent then return end
        for _,entry in ipairs(rotating) do
            if entry.beam.Parent and entry.lens.Parent and entry.marina:GetAttribute("KinMarinaLightActive")==true then
                entry.angle=(entry.angle+step*0.8)%(math.pi*2)
                local center=entry.lens.Position
                entry.beam.CFrame=CFrame.new(center)*CFrame.Angles(0,entry.angle,0)*CFrame.new(0,0,-9)
            end
        end
    end)
    world.Destroying:Connect(function() heartbeat:Disconnect() end)
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled or not player then return end
        local host=interactionInReach(prompt,player,world)
        if not host then return end
        if host:GetAttribute("KinMarinaAction") then
            marinaAction(host,player,reply)
        elseif host:GetAttribute("KinAnnexExperienceId") then
            annexAction(host,player,reply)
        elseif host:GetAttribute("KinIslandTrailId") then
            trailAction(host,player,reply)
        end
    end)
end
return Runtime
