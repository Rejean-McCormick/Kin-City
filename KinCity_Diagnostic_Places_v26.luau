-- Kin City v26 — Diagnostic de séparation; à coller dans la Command Bar Studio.
-- Lecture seule. Aucun réseau, aucune écriture dans le monde.
local RS=game:GetService("ReplicatedStorage")
local shared=RS:FindFirstChild("KinCityShared")
assert(shared,"Installez une Place Kin City avant ce diagnostic.")
local cfg=require(shared:WaitForChild("RuntimeConfig"))
local routing=require(shared:WaitForChild("PlaceRouting"))
local world=workspace:FindFirstChild("KinCityGenerated")
assert(world,"Le monde Kin City n'est pas généré.")
print("KIN CITY DIAGNOSTIC V26")
print("Mode:",cfg.mode,"Place ciblée:",cfg.target_place_key or "univers local")
print("État:",world:GetAttribute("KinBuildState"),"Révision:",world:GetAttribute("KinWorldBuilderRevision"))
print("Place active:",world:GetAttribute("KinActivePlace"),"Séparation:",world:GetAttribute("KinSeparatedWorld"))
print("PlaceIds configurés:")
for _,key in ipairs({"city","city_hall","ekoh_tower","library","campus","justice_palace","innovation_lab","museum","orgo_center"}) do
 print("   ",key,routing[key] or "NON PUBLIÉ")
end
local city=world:FindFirstChild("Ville")
local interiors=world:FindFirstChild("Bâtiments visitables")
local interiorCount=0
if interiors then
 for _,item in ipairs(interiors:GetChildren()) do
  if item:IsA("Model") then interiorCount+=1 end
 end
end
local promptCount=0
local partCount=0
for _,item in ipairs(world:GetDescendants()) do
 if item:IsA("ProximityPrompt") then promptCount+=1 end
 if item:IsA("BasePart") then partCount+=1 end
end
print("Ville extérieure générée:",city~=nil)
print("Intérieurs institutionnels générés:",interiorCount)
print("Parts:",partCount,"Prompts:",promptCount)
print("Portes canoniques attendues:",world:GetAttribute("KinCanonicalDoorCount"))
print("Interactions canoniques attendues:",world:GetAttribute("KinCanonicalInteractionCount"))
if cfg.mode~="LOCAL_UNIVERSE" then
 assert((cfg.target_place_key=="city" and city~=nil and interiorCount==0)
     or (cfg.target_place_key~="city" and city==nil and interiorCount==1),
     "RUPTURE INVALIDE : la Place contient un monde qui ne lui appartient pas")
 print("SÉPARATION CONFIRMÉE PAR L'ARBRE DE SCÈNE. Les transitions publiées restent à tester dans Roblox.")
else
 print("MODE DE SECOURS : les 8 intérieurs et la ville coexistent pour les essais locaux.")
end
