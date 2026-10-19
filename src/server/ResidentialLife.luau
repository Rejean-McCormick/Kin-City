--!strict
-- Les lanternes sont une action purement physique, sans identité ni métier kOA.
local ProximityPromptService=game:GetService("ProximityPromptService")
local Players=game:GetService("Players")
local RateLimiter=require(script.Parent.RateLimiter)
local Life={}
function Life.start(world,reply)
    local states={}
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        if host:GetAttribute("KinResidentialAction")~="lights" then return end
        local id=host:GetAttribute("KinResidentialQuarterId")
        if type(id)~="string" or not RateLimiter.allowed(player,"residential/"..id,0.8) then return end
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        local enabled=(states[id]==false) -- Les lanternes sont déjà allumées à la génération.
        states[id]=enabled
        -- Coloration locale des lanternes, par ID stable de quartier.
        for _,item in ipairs(world:GetDescendants()) do
            if item:IsA("BasePart") and item:GetAttribute("KinResidentialLampGroup")==id then
                local light=item:FindFirstChildOfClass("PointLight")
                if light then light.Enabled=enabled end
                local original=item:GetAttribute("KinResidentialDefaultColor")
                if typeof(original)=="Color3" then item.Color=if enabled then original else Color3.fromRGB(75,89,91) end
            end
        end
        if player.Parent==Players then
            reply:FireClient(player,{
                kind="interaction.reply.v1",status="LOCAL_SUCCESS",title="Lanternes du quartier",
                message=if enabled then "Les lanternes éclairent la place commune." else "Les lanternes de la place sont éteintes.",
                notice="Activité locale · aucun service externe"
            })
        end
    end)
end
return Life
