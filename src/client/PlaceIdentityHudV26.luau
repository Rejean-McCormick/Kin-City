--!strict
-- Guide propre à une Place; ne présente jamais la carte de la ville au milieu d'une institution.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("KinCityShared")
local Runtime=require(Shared:WaitForChild("RuntimeConfig"))
local names={city="VILLE EXTÉRIEURE",city_hall="HÔTEL DE VILLE",ekoh_tower="TOUR EKOH",
 library="GRANDE BIBLIOTHÈQUE",campus="UNIVERSITÉ KONNECTED",
 justice_palace="PALAIS DE JUSTICE",innovation_lab="PARC DE L'INNOVATION",
 museum="MUSÉE KREATIVE",orgo_center="CENTRE ORGO"}
local Hud={}
function Hud.start()
 if Runtime.mode=="LOCAL_UNIVERSE" then return end
 local player=Players.LocalPlayer
 local key=Runtime.target_place_key or "city"
 local gui=Instance.new("ScreenGui")
 gui.Name="KinCityPlaceIdentityV26"
 gui.ResetOnSpawn=false
 gui.DisplayOrder=3
 gui.Parent=player:WaitForChild("PlayerGui")
 local frame=Instance.new("Frame")
 frame.Name="Emplacement actuel"
 frame.AnchorPoint=Vector2.new(0.5,0)
 frame.Position=UDim2.new(0.5,0,0,10)
 frame.Size=UDim2.fromOffset(325,42)
 frame.BackgroundColor3=Color3.fromRGB(30,104,100)
 frame.BackgroundTransparency=0.08
 frame.Parent=gui
 local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,10);corner.Parent=frame
 local text=Instance.new("TextLabel")
 text.Name="Nom de la Place"
 text.Size=UDim2.fromScale(1,1)
 text.BackgroundTransparency=1
 text.TextColor3=Color3.fromRGB(237,253,252)
 text.TextScaled=true
 text.Font=Enum.Font.GothamBold
 text.Text=names[key] or key
 text.Parent=frame
 local sub=Instance.new("TextLabel")
 sub.Name="Statut du passage"
 sub.BackgroundTransparency=1
 sub.Text=if Runtime.mode=="SPLIT_PREVIEW" then "Aperçu indépendant • passages actifs après publication" else "Place indépendante • entrées et sorties par les portes"
 sub.Position=UDim2.new(0,0,1,2)
 sub.Size=UDim2.fromOffset(325,18)
 sub.TextSize=11
 sub.TextColor3=Color3.fromRGB(232,217,175)
 sub.Font=Enum.Font.Gotham
 sub.Parent=frame
end
return Hud
