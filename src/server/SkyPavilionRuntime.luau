--!strict
-- V15 · Mécanismes d'observatoire et carnet de visites par joueur.
-- Toutes les opérations ont lieu dans la session Roblox. Aucune identité/économie kOA.
local Players=game:GetService("Players")
local Prompts=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
local COMPLETE_STATIONS=16
local PALETTE_OFF=Color3.fromRGB(79,109,124)

local function notify(remote,player,title,message)
    if player.Parent~=Players then return end
    remote:FireClient(player,{
        kind="interaction.reply.v1",status="LOCAL_SUCCESS",title=title,message=message,
        notice="Expérience locale · aucune opération kOA",
    })
end

local function animate(model,duration,turns)
    if not model or not model.Parent then return end
    local start=model:GetPivot()
    local begun=os.clock()
    while model.Parent and model:IsDescendantOf(workspace) do
        local delta=math.clamp((os.clock()-begun)/duration,0,1)
        local smoothed=delta*delta*(3-2*delta)
        model:PivotTo(start*CFrame.Angles(0,smoothed*math.pi*2*turns,0))
        if delta>=1 then break end
        RunService.Heartbeat:Wait()
    end
    if model.Parent then model:PivotTo(start) end
end

local function valid(prompt,host,player,world)
    if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) or not prompt.Enabled then return false end
    if player:GetAttribute("KinZone")~=host:GetAttribute("KinSkyPlaceKey") then return false end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return hum~=nil and hum.Health>0 and root~=nil and (root.Position-host.Position).Magnitude<=prompt.MaxActivationDistance+3
end

function Runtime.start(world,remote)
    local machines={}
    local lamps={}
    local running={}
    local modes={}
    local discovered={}
    for _,obj in ipairs(world:GetDescendants()) do
        if obj:IsA("Model") then
            local id=obj:GetAttribute("KinSkyMechanismId")
            if type(id)=="string" then machines[id]=obj end
        elseif obj:IsA("BasePart") then
            local key=obj:GetAttribute("KinSkyLampPlace")
            if type(key)=="string" then
                lamps[key]=lamps[key] or {}
                table.insert(lamps[key],{part=obj,color=obj.Color})
                modes[key]=true
            end
        end
    end
    Players.PlayerRemoving:Connect(function(player) discovered[player]=nil end)
    Prompts.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") then return end
        local action=host:GetAttribute("KinSkyAction")
        if action~="animate" and action~="lighting" then return end
        if not valid(prompt,host,player,world) then return end
        local key=host:GetAttribute("KinSkyPlaceKey")
        if type(key)~="string" then return end
        if action=="lighting" then
            if not RateLimiter.allowed(player,"skylight/"..key,0.8) then return end
            local on=not modes[key]
            modes[key]=on
            for _,lamp in ipairs(lamps[key] or {}) do
                if lamp.part.Parent then
                    lamp.part.Color=if on then lamp.color else PALETTE_OFF
                    lamp.part.Material=if on then Enum.Material.Neon else Enum.Material.Metal
                    local light=lamp.part:FindFirstChildOfClass("PointLight")
                    if light then light.Enabled=on end
                end
            end
            notify(remote,player,"Observatoire · "..key,if on then "Les projecteurs de la verrière sont activés." else "Les projecteurs sont en mode doux.")
            return
        end
        local id=host:GetAttribute("KinSkyMachineId")
        if type(id)~="string" then return end
        if not RateLimiter.allowed(player,"sky/"..id,1) then return end
        local model=machines[id]
        if not model or not model.Parent then return end
        if running[id] then
            notify(remote,player,"Observatoire","Une démonstration est déjà en cours.")
            return
        end
        running[id]=true
        local title=host:GetAttribute("KinSkyStationTitle") or "Station expérimentale"
        local byPlayer=discovered[player]
        if not byPlayer then byPlayer={};discovered[player]=byPlayer end
        if not byPlayer[id] then byPlayer[id]=true end
        local count=0
        for _ in pairs(byPlayer) do count+=1 end
        remote:FireClient(player,{
            kind="sky.discovery.v1",place_key=key,station_id=id,
            title=title,visited=count,total=COMPLETE_STATIONS,
        })
        notify(remote,player,title,"Observe le mécanisme en mouvement. Découverte "..tostring(count).." / "..tostring(COMPLETE_STATIONS)..".")
        task.spawn(function()
            local ok,err=pcall(animate,model,5,2)
            if not ok then warn("Kin City sky apparatus",id,err) end
            running[id]=nil
        end)
    end)
end
return Runtime
