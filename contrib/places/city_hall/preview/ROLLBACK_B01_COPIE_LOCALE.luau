-- KC34 B01 : annule seulement l'habillage B01 sur une COPIE LOCALE Roblox Studio.
assert(game:GetService("RunService"):IsStudio() and not game:GetService("RunService"):IsRunning(),"Arrêter Play dans Studio")
assert(game.PlaceId==0,"Production et Places publiées interdites")
local matches={}
for _,v in ipairs(workspace:GetDescendants()) do
  if v:IsA("Model") and v.Name=="Intérieur — city_hall" and v:GetAttribute("KinPlaceKey")=="city_hall" then
    table.insert(matches,v)
  end
end
assert(#matches==1,"Intérieur B01 ambigu ou absent")
local overlay=matches[1]:FindFirstChild("KinB01CityHallDecor")
if overlay then
  overlay:Destroy()
  print("B01 : décor retiré, scènes et portes intactes")
else
  print("B01 : aucune couche décorative à retirer")
end
