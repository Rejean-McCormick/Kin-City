-- KIN CITY / KOALI v31.9.7 — PUBLICATION ALLEGEE (VOLONTAIREMENT DESTRUCTIVE POUR LE DECOR D'EDITION)
-- A EXECUTER dans la Command Bar de Roblox Studio, Play ARRETE.
-- OBJECTIF : reduire le poids de la Place en retirant Workspace.KinCityGenerated.
-- IMPORTANT : les scripts ne sont PAS effaces. KinCityRuntime -> WorldBuilder.build(true)
-- reconstruit la ville a l'execution du serveur (Play et serveurs publies).
-- Ce script NE PUBLIE PAS. Apres son execution : Fichier > Publier sous > ancienne Experience > Place de depart > Ecraser.
-- Ce script ne touche pas aux audios, aux modules, au cinema, aux DataStores ou a d'autres modeles.

local RunService=game:GetService("RunService")
assert(RunService:IsStudio(), "Ce script doit etre lance dans Roblox Studio")
assert(not RunService:IsRunning(), "ARRETE Play avant de lancer ce script")

local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
local shared=RS:FindFirstChild("KinCityShared")
local runtime=SS:FindFirstChild("KinCityRuntime")
local client=SP and SP:FindFirstChild("KinCityUI")

assert(shared and shared:IsA("Folder"), "KinCityShared introuvable. Arret sans modification.")
assert(runtime and runtime:IsA("Script") and runtime.Enabled, "KinCityRuntime absent ou desactive. Arret sans modification.")
assert(client and client:IsA("LocalScript") and client.Enabled, "KinCityUI absent ou desactive. Arret sans modification.")
local worldBuilder=runtime:FindFirstChild("WorldBuilder")
assert(worldBuilder and worldBuilder:IsA("ModuleScript"), "WorldBuilder introuvable. Arret sans modification.")
assert(runtime.Source:find("WorldBuilder.build(true)",1,true), "Le runtime ne reconstruit pas le monde. Arret sans modification.")
assert(worldBuilder.Source:find("function WorldBuilder.build(reuseExisting)",1,true), "WorldBuilder non conforme. Arret sans modification.")
assert(client:FindFirstChild("KinCityMusicPlayer"), "Lecteur absent. Arret sans modification.")
assert(shared:FindFirstChild("MusicLibrary"), "Catalogue musical absent. Arret sans modification.")
local idModule=shared:FindFirstChild("MusicAssetIds")
assert(idModule and idModule:IsA("ModuleScript"), "MusicAssetIds absent. Arret sans modification.")

local ids=require(idModule)
local total,configured=0,0
for key,value in pairs(ids) do
    if type(key)=="string" and key:sub(1,10)=="kin_track_" then
        total+=1
        if type(value)=="number" and value>0 then configured+=1 end
    end
end
assert(total==49 and configured==48,
    "Catalogue musical inattendu ("..configured.."/"..total.."). Arret sans modification.")

print("========== KOALI v31.9.7 : PUBLICATION ALLEGEE ==========")
print("PlaceId",game.PlaceId,"GameId",game.GameId)
print("[OK] Scripts serveur et client actifs")
print("[OK] WorldBuilder regenere la ville au demarrage")
print("[OK] Lecteur musical present et IDs audio : "..configured.."/"..total)

local world=workspace:FindFirstChild("KinCityGenerated")
if world then
    assert(world:IsA("Folder"), "KinCityGenerated n'est pas un Folder. Arret sans modification.")
    assert(world:GetAttribute("KinBuildState")=="Ready", "Monde non pret. Arret sans modification.")
    local parts=0
    for _,obj in ipairs(world:GetDescendants()) do
        if obj:IsA("BasePart") then parts+=1 end
    end
    print("Suppression volontaire de la geometrie d'EDITION : "..parts.." pieces")
    world:Destroy()
else
    print("Aucun KinCityGenerated en edition : publication deja allegee.")
end

assert(not workspace:FindFirstChild("KinCityGenerated"), "La geometrie n'a pas pu etre retiree")
print("[OK] KinCityGenerated absent de la Place a televerser.")
print("[IMPORTANT] La ville est vide en mode Edition. C'EST NORMAL.")
print("[TEST] Lance Play : le serveur doit recreer la ville. Arrete Play ensuite.")
print("[PUBLIER] Fichier > Publier sous > EXPERIENCE EXISTANTE > PLACE DE DEPART > ECRASER.")
print("[ATTENTION] Si Roblox renvoie encore HTTP 403, la suppression du decor ne regle pas une erreur de droits/authentification.")
print("[RESTAURER] Utilise le fichier KinCity_v31_9_7_RESTAURER_DECOR_EDITION_COMMAND_BAR.luau si necessaire.")
print("================ FIN PREPARATION =================")
