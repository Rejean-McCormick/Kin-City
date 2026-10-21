-- Importer assets/kingklown-v7/kingklown-hair-v7.obj puis sélectionner le MeshPart.
assert(not game:GetService("RunService"):IsRunning(),"Arrêtez Play.")
local selection=game:GetService("Selection"):Get()
assert(#selection==1 and selection[1]:IsA("MeshPart"),"Sélectionnez le MeshPart importé des cheveux.")
local storage=game:GetService("ServerStorage")
local library=storage:FindFirstChild("KinCityAssetLibrary")
if not library then library=Instance.new("Folder");library.Name="KinCityAssetLibrary";library.Parent=storage end
local old=library:FindFirstChild("kingklown_hair_v7")
if old then old:Destroy() end
local mesh=selection[1]:Clone();mesh:ClearAllChildren();mesh.Name="kingklown_hair_v7";mesh.Parent=library
print("Chevelure enregistrée. Lancez Play pour la voir sur King Klown.")
