--!strict
-- Kin City v18 : une seule opération de déplacement/transport par joueur.
-- Réserve la session avant toute attente asynchrone; vérifie le personnage
-- après RequestStreamAroundAsync; empêche une ancienne requête de téléporter
-- un nouveau personnage. Pas de réseau HTTP et aucune autorité client.
local Players=game:GetService("Players")
local TravelSession={}
local current={}
local serial=0

function TravelSession.begin(player,kind)
    if not player or player.Parent~=Players or current[player] then return nil end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not char or not char.Parent or not hum or hum.Health<=0 or not root
        or root.Anchored or hum.SeatPart then return nil end
    if player:GetAttribute("KinBusActive") or player:GetAttribute("KinFerryActive") then return nil end
    serial+=1
    local token={id=serial,kind=kind,character=char,zone=player:GetAttribute("KinZone")}
    current[player]=token
    return token
end

function TravelSession.active(player)
    return current[player]~=nil
end

function TravelSession.valid(player,token)
    if not token or current[player]~=token or player.Parent~=Players then return false end
    local char=token.character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return player.Character==char and char.Parent~=nil and hum~=nil and hum.Health>0
        and root~=nil and root.Parent~=nil
        and player:GetAttribute("KinZone")==token.zone
end

function TravelSession.finish(player,token)
    if current[player]==token then current[player]=nil end
end

function TravelSession.cancel(player)
    current[player]=nil
end

Players.PlayerRemoving:Connect(function(player)
    current[player]=nil
end)
return TravelSession
