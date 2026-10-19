-- Kin City v25 : Command Bar de Roblox Studio, EN MODE ÉDITION.
-- 1) Importez les textures dans Studio et configurez un SurfaceAppearance
--    (ColorMap, NormalMap, RoughnessMap; MetalnessMap facultative).
-- 2) Nommez le SurfaceAppearance: sarcelle_pierre, opale_massive,
--    champagne_mineral ou pierre_promenoir.
-- 3) Sélectionnez le SurfaceAppearance (ou le MeshPart qui le contient),
--    puis exécutez ce script. Aucun téléversement ni API externe.
local Selection=game:GetService("Selection")
local ServerStorage=game:GetService("ServerStorage")
local allowed={sarcelle_pierre=true,opale_massive=true,champagne_mineral=true,pierre_promenoir=true}
local selected=Selection:Get()
assert(#selected==1,"Sélectionner exactement un SurfaceAppearance (ou un MeshPart contenant un SurfaceAppearance).")
local item=selected[1]
local source=if item:IsA("SurfaceAppearance") then item else item:FindFirstChildOfClass("SurfaceAppearance")
assert(source and source:IsA("SurfaceAppearance"),"La sélection ne contient pas de SurfaceAppearance.")
local key=if allowed[source.Name] then source.Name elseif allowed[item.Name] then item.Name else nil
assert(key,"Nom invalide. Utiliser sarcelle_pierre, opale_massive, champagne_mineral ou pierre_promenoir.")
assert(source.ColorMap~="","ColorMap est requis : importez au moins la carte de couleur.")
local root=ServerStorage:FindFirstChild("KinCityMaterialLibrary")
if not root then
    root=Instance.new("Folder")
    root.Name="KinCityMaterialLibrary"
    root.Parent=ServerStorage
end
local old=root:FindFirstChild(key)
if old then old:Destroy() end
local copy=source:Clone()
copy.Name=key
copy:SetAttribute("KinMaterialSource","Import Studio local")
copy.Parent=root
print("KIN CITY v25 : matériau PBR enregistré : "..key..". Régénérer Kin City pour le voir sur les MeshParts associés.")
