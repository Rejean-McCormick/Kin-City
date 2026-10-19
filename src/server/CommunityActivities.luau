--!strict
-- Activités réellement locales : éclairages des halles et rotation d'une sculpture.
-- L'achat, l'inscription et les services institutionnels restent des stubs.
local Players=game:GetService("Players")
local PromptService=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Activities={}
function Activities.start(world,reply)
    local states={}
    local arts={}
    -- Index construit une seule fois, plutôt que parcourir toute la ville à chaque E.
    local lamps={}
    local sculptures={}
    for _,desc in ipairs(world:GetDescendants()) do
        if desc:IsA("BasePart") then
            local lightId=desc:GetAttribute("KinCommunityLamp")
            if type(lightId)=="string" then
                lamps[lightId]=lamps[lightId] or {}
                table.insert(lamps[lightId],desc)
            end
        end
    end
    for _,desc in ipairs(world:GetDescendants()) do
        if desc:IsA("Model") then
            local artId=desc:GetAttribute("KinCommunityArt")
            if type(artId)=="string" then sculptures[artId]=desc end
        end
    end
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local action=host:GetAttribute("KinCommunityAction")
        local id=host:GetAttribute("KinCommunityId")
        if type(id)~="string" or (action~="lights" and action~="art") then return end
        if not RateLimiter.allowed(player,"community/"..id,0.75) then return end
        local char=player.Character
        local human=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not human or human.Health<=0 or not hrp or (hrp.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        local message=""
        if action=="lights" then
            local enabled=not (states[id]~=false)
            states[id]=enabled
            for _,bulb in ipairs(lamps[id] or {}) do
                if bulb.Parent then
                    local point=bulb:FindFirstChildOfClass("PointLight")
                    if point then point.Enabled=enabled end
                    bulb.Transparency=if enabled then 0 else 0.6
                end
            end
            message=if enabled then "Les luminaires de la halle sont allumés." else "Les luminaires de la halle sont éteints."
        else
            local model=sculptures[id]
            if not model or not model.Parent then return end
            if arts[id] then return end
            arts[id]=true
            local origin=model:GetPivot()
            task.spawn(function()
                local ok,reason=pcall(function()
                    local started=os.clock()
                    while model.Parent and world.Parent do
                        local t=math.clamp((os.clock()-started)/1.8,0,1)
                        local eased=t*t*(3-2*t)
                        model:PivotTo(origin*CFrame.Angles(0,eased*math.pi*2,0))
                        if t>=1 then break end
                        RunService.Heartbeat:Wait()
                    end
                end)
                if not ok then warn("Kin City mobile communautaire",reason) end
                arts[id]=nil
            end)
            message="Le mobile tourne : expérience locale activée."
        end
        if player.Parent==Players then
            reply:FireClient(player,{kind="interaction.reply.v1",status="LOCAL_SUCCESS",title="Espace communautaire",message=message,notice="Interaction physique de Kin City · aucune opération kOA"})
        end
    end)
end
return Activities
