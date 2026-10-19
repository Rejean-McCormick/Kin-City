-- Kin City v25 : coller en mode Édition dans la Command Bar, après installation.
-- Inventaire réel de la scène installée, pas un test FPS ni de mémoire GPU.
local SS=game:GetService("ServerStorage")
local root=workspace:FindFirstChild("KinCityGenerated")
assert(root,"Kin City n'est pas installée dans ce Workspace")
print("KIN CITY — DIAGNOSTIC V25")
for _,key in ipairs({"KinBuildState","KinWorldBuilderRevision","KinBuildVisualProfile","KinBuildSeconds",
    "KinGeneratedParts","KinGeneratedMeshes","KinGeneratedLights","KinGeneratedPrompts",
    "KinGeneratedMaterials","KinGeneratedSeats","KinGeneratedOptionalDetails"}) do
    print(key,root:GetAttribute(key))
end
local assets=SS:FindFirstChild("KinCityAssetLibrary")
local materials=SS:FindFirstChild("KinCityMaterialLibrary")
print("Meshes Studio enregistrés",assets and #assets:GetChildren() or 0)
print("Matériaux Studio enregistrés",materials and #materials:GetChildren() or 0)
print("Workspace.StreamingEnabled",workspace.StreamingEnabled,"(modifiable dans les propriétés Studio, pas ici)")
print("Mesurer les FPS, mémoire, réseau et streaming avec le MicroProfiler et les outils Studio : non mesurés par ce script.")
