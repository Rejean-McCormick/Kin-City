--!strict
-- Expériences manipulables : effets déterministes locaux côté serveur.
local ProximityPromptService=game:GetService("ProximityPromptService")
local TweenService=game:GetService("TweenService")
local RateLimiter=require(script.Parent.RateLimiter)
local Experiments={}
local descriptions={
    optics="La lumière blanche peut être décomposée en différentes couleurs.",
    astronomy="Les orbites décrivent le mouvement des corps autour d'un autre.",
    ecology="La diversité des organismes aide à maintenir les écosystèmes.",
    engineering="Un levier échange distance et force autour d'un point d'appui.",
    water="L'eau en mouvement peut transmettre de l'énergie mécanique.",
    energy="Un circuit fermé permet la circulation du courant électrique.",
    sound="Les sons résultent de vibrations qui se propagent dans un milieu.",
    nature="Les plantes s'adaptent à leur milieu et utilisent l'énergie lumineuse.",
}
local function parentExhibit(part)
    local node=part.Parent
    while node do
        if node:IsA("Model") and type(node:GetAttribute("KinScienceExhibitId"))=="string" then return node end
        node=node.Parent
    end
    return nil
end
function Experiments.start(world,reply)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled or not player then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local exhibitId=host:GetAttribute("KinScienceExhibitId")
        local kind=host:GetAttribute("KinScienceKind")
        if type(exhibitId)~="string" or type(kind)~="string" then return end
        local root=parentExhibit(host)
        if not root or root:GetAttribute("KinScienceExhibitId")~=exhibitId then return end
        local char=player.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health<=0 then return end
        if (hrp.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"science/"..exhibitId,1.5) then return end
        local active=not (root:GetAttribute("KinExperimentActive")==true)
        root:SetAttribute("KinExperimentActive",active)
        local duration=TweenInfo.new(1.1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
        for _,p in ipairs(root:GetDescendants()) do
            if p:IsA("BasePart") then
                if p:GetAttribute("KinScienceLight") then
                    TweenService:Create(p,duration,{Transparency=if active then 0.1 else 0.75}):Play()
                    local light=p:FindFirstChildOfClass("PointLight")
                    if light then light.Brightness=if active then 1.7 else 0.1 end
                elseif p:GetAttribute("KinScienceRotor") then
                    local baseline=p:GetAttribute("KinScienceRest")
                    if typeof(baseline)~="CFrame" then baseline=p.CFrame;p:SetAttribute("KinScienceRest",baseline) end
                    TweenService:Create(p,duration,{CFrame=if active then baseline*CFrame.Angles(0,math.rad(30),0) else baseline}):Play()
                end
            end
        end
        prompt.ActionText=if active then "Réinitialiser" else "Expérimenter"
        reply:FireClient(player,{
            kind="interaction.reply.v1",status="LOCAL_SUCCESS",
            title=root.Name,message=if active then "Expérience activée" else "Expérience réinitialisée",
            notice=descriptions[kind] or "Expérience interactive locale."
        })
    end)
end
return Experiments
