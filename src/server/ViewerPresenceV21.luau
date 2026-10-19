--!strict
-- Suspension légère des mouvements décoratifs quand aucun visiteur ne voit la zone.
-- Ne retire aucun personnage, prompt ou emplacement du monde.
local Players=game:GetService("Players")
local Presence={}
function Presence.near(position:Vector3,radius:number):boolean
    local r2=radius*radius
    for _,player in ipairs(Players:GetPlayers()) do
        local character=player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        if root and root:IsA("BasePart") and humanoid and humanoid.Health>0 then
            local offset=root.Position-position
            if offset:Dot(offset)<=r2 then return true end
        end
    end
    return false
end
return Presence
