--!strict
-- Kin City v16 : fonctionnement des expositions physiques; aucune opération kOA.
local Players=game:GetService("Players")
local ProximityPromptService=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
local OFF=Color3.fromRGB(63,82,91)
local TOTAL=16
local function send(remote,player,title,message)
    if player.Parent~=Players then return end
    remote:FireClient(player,{
        kind="interaction.reply.v1",status="LOCAL_SUCCESS",title=title,message=message,
        notice="Installation locale · aucun service kOA",
    })
end
local function eligible(prompt,host,player,world)
    if not prompt.Enabled or not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return false end
    local zone=host:GetAttribute("KinV16PlaceKey")
    if type(zone)~="string" or player:GetAttribute("KinZone")~=zone then return false end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return hum~=nil and hum.Health>0 and root~=nil and (root.Position-host.Position).Magnitude<=prompt.MaxActivationDistance+3
end
local function spin(model,seconds,turns)
    local start=model:GetPivot()
    local begun=os.clock()
    while model.Parent and model:IsDescendantOf(workspace) do
        local a=math.clamp((os.clock()-begun)/seconds,0,1)
        local eased=a*a*(3-2*a)
        model:PivotTo(start*CFrame.Angles(0,eased*math.pi*2*turns,0))
        if a>=1 then break end
        RunService.Heartbeat:Wait()
    end
    if model.Parent then model:PivotTo(start) end
end
function Runtime.start(world,remote)
    local machines={}
    local lamps={}
    local active={}
    local lightOn={}
    local visited={}
    for _,obj in ipairs(world:GetDescendants()) do
        if obj:IsA("Model") then
            local id=obj:GetAttribute("KinV16MechanismId")
            if type(id)=="string" then machines[id]=obj end
        elseif obj:IsA("BasePart") then
            local place=obj:GetAttribute("KinV16LampPlace")
            if type(place)=="string" then
                lamps[place]=lamps[place] or {}
                table.insert(lamps[place],{part=obj,color=obj.Color})
                lightOn[place]=true
            end
        end
    end
    Players.PlayerRemoving:Connect(function(player) visited[player]=nil end)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") then return end
        local action=host:GetAttribute("KinV16Action")
        if action~="mechanism" and action~="lighting" then return end
        if not eligible(prompt,host,player,world) then return end
        local place=host:GetAttribute("KinV16PlaceKey")
        if type(place)~="string" then return end
        if action=="lighting" then
            if not RateLimiter.allowed(player,"winglight/"..place,0.8) then return end
            local nextState=not lightOn[place]
            lightOn[place]=nextState
            for _,rec in ipairs(lamps[place] or {}) do
                local lamp=rec.part
                if lamp.Parent then
                    lamp.Material=if nextState then Enum.Material.Neon else Enum.Material.Metal
                    lamp.Color=if nextState then rec.color else OFF
                    local light=lamp:FindFirstChildOfClass("PointLight")
                    if light then light.Enabled=nextState end
                end
            end
            send(remote,player,"Grande galerie",if nextState then "L'éclairage de la galerie est activé." else "La galerie passe en ambiance douce.")
            return
        end
        local id=host:GetAttribute("KinV16MechanismId")
        if type(id)~="string" then return end
        if not RateLimiter.allowed(player,"wing/"..id,1) then return end
        local model=machines[id]
        if not model or not model.Parent then return end
        if active[id] then
            send(remote,player,"Galerie des découvertes","La démonstration est déjà en cours.")
            return
        end
        active[id]=true
        local records=visited[player]
        if not records then records={};visited[player]=records end
        records[id]=true
        local count=0
        for _ in pairs(records) do count+=1 end
        send(remote,player,"Galerie des découvertes","Démonstration activée. Oeuvres distinctes découvertes : "..count.." / "..TOTAL..".")
        task.spawn(function()
            local ok,err=pcall(spin,model,5,2)
            if not ok then warn("Kin City v16 : mécanisme",id,err) end
            active[id]=nil
        end)
    end)
end
return Runtime
