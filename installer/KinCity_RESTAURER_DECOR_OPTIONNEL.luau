-- KIN CITY / KOALI v31.9.7 — RESTAURER LE DECOR EN EDITION
-- Exécuter dans la Command Bar (Play ARRETE), si l'on veut revoir les batiments dans l'éditeur.
-- ATTENTION : cette operation reconstruit les objets; elle peut remettre le fichier publie a une taille excessive.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Executer uniquement dans Studio, Play arrete")
local SS=game:GetService("ServerScriptService")
local runtime=SS:FindFirstChild("KinCityRuntime")
assert(runtime and runtime:IsA("Script"),"KinCityRuntime absent")
local builder=runtime:FindFirstChild("WorldBuilder")
assert(builder and builder:IsA("ModuleScript"),"WorldBuilder absent")
print("KIN CITY v31.9.7 : reconstruction du decor en mode Edition...")
local result=require(builder).build()
assert(result and result.world and result.world:GetAttribute("KinBuildState")=="Ready",
    "La reconstruction n'a pas atteint le statut Ready")
local cinema=runtime:FindFirstChild("OutdoorCinema")
if cinema and cinema:IsA("ModuleScript") then require(cinema).ensure() end
print("KIN CITY : decor restaure. Pieces :",result.world:GetAttribute("KinGeneratedParts"))
print("AVERTISSEMENT : ce decor volumineux peut faire echouer une nouvelle publication.")
