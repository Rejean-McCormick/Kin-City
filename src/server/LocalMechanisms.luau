--!strict
-- Service central des mécanismes purement LOCAUX. Aucune requête réseau.
local ProximityPromptService=game:GetService("ProximityPromptService")
local TweenService=game:GetService("TweenService")
local RateLimiter=require(script.Parent.RateLimiter)
local Mechanisms={}

function Mechanisms.start(world,reply)
    -- Les ouvrages ont été générés dans Studio : les attributs restent la source de vérité.
    -- Le routeur métier ignore volontairement ces prompts.
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") then return end
        local id=host:GetAttribute("KinLocalMechanismId")
        if type(id)~="string" or not prompt.Enabled or not host:IsDescendantOf(world) then return end
        local parent=host.Parent
        if not parent or not parent:IsA("Model") or parent:GetAttribute("KinPublicSpaceId")~=id then return end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not root then return end
        if (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"mechanism/"..id,1.5) then return end
        local active=not (parent:GetAttribute("KinLocalMechanismActive")==true)
        parent:SetAttribute("KinLocalMechanismActive",active)
        for _,part in ipairs(parent:GetDescendants()) do
            if part:IsA("BasePart") then
                if part:GetAttribute("KinReactiveLight")==true then
                    TweenService:Create(part,TweenInfo.new(0.65),{Transparency=active and 0.05 or 0.65}):Play()
                    local light=part:FindFirstChildOfClass("PointLight")
                    if light then light.Enabled=active end
                end
                if part:GetAttribute("KinReactiveRotor")==true then
                    local initial=part:GetAttribute("KinRotorRestFrame")
                    if typeof(initial)~="CFrame" then
                        initial=part.CFrame
                        part:SetAttribute("KinRotorRestFrame",initial)
                    end
                    local destination=if active then initial*CFrame.Angles(0,math.pi,0) else initial
                    TweenService:Create(part,TweenInfo.new(1.2,Enum.EasingStyle.Sine),{CFrame=destination}):Play()
                end
            end
        end
        prompt.ActionText=active and "Désactiver" or "Activer"
        reply:FireClient(player,{
            kind="interaction.reply.v1",status="LOCAL_SUCCESS",title="Installation interactive",
            message=active and "Installation activée" or "Installation désactivée",
            notice="Cette démonstration fonctionne dans Roblox, sans accès à kOA."
        })
    end)
end
return Mechanisms
