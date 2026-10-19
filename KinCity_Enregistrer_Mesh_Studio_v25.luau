-- KIN CITY : sélectionner un MeshPart importé (ou son Model), puis exécuter
-- dans la Command Bar Roblox Studio, en mode Édition.
-- Choisir UNE des onze clés ci-dessous. Relancer cette commande pour chaque mesh.
-- La bibliothèque demeure dans ServerStorage même après réinstallation de Kin City.
local KIN_KEY = "mineral_column"
local permitted = {
    mineral_column=true, opal_spire=true, crystal_rosette=true,
    opal_arch=true, opal_chandelier=true,
    crystal_canopy=true, mineral_planter=true, opal_console=true,
    opal_lattice=true, mineral_pediment=true, harbor_crest=true,
}
assert(permitted[KIN_KEY],"Cle d'asset Kin City inconnue: "..tostring(KIN_KEY))
local Selection=game:GetService("Selection")
local ServerStorage=game:GetService("ServerStorage")
local selected=Selection:Get()
assert(#selected==1,"Selectionne un seul MeshPart importe ou son Model, puis relance la commande")
local candidate=selected[1]
local mesh=if candidate:IsA("MeshPart") then candidate else candidate:FindFirstChildWhichIsA("MeshPart",true)
assert(mesh and mesh:IsA("MeshPart"),"Aucun MeshPart dans la selection : importe d'abord le .obj")
local root=ServerStorage:FindFirstChild("KinCityAssetLibrary")
if not root then root=Instance.new("Folder");root.Name="KinCityAssetLibrary";root.Parent=ServerStorage end
local old=root:FindFirstChild(KIN_KEY)
if old then old:Destroy() end
local saved=mesh:Clone()
saved.Name=KIN_KEY
saved.CFrame=CFrame.new(0,0,0)
saved.Anchored=true
saved.CanCollide=false
saved.CanTouch=false
saved.CanQuery=false
saved:SetAttribute("KinImportedSource",mesh.Name)
saved.Parent=root
print("Kin City : modèle enregistré -> ServerStorage.KinCityAssetLibrary."..KIN_KEY)
print("Le prochain lancement de l'installateur Kin City utilisera ce modèle là où la clé est employée.")
