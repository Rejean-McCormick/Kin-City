#!/usr/bin/env python3
"""Ajoute un écran extérieur à une Place existante sans reconstruire KinCityGenerated."""
from pathlib import Path
from make_studio_installer import quote_luau

ROOT=Path(__file__).resolve().parents[1]
OUTPUT=ROOT/'KinCity_Koali_v31_9_3_AJOUT_CINEMA_SANS_REGENERATION.luau'

def generate(root=ROOT):
    server=(root/'src/server/OutdoorCinema.luau').read_text(encoding='utf8')
    client=(root/'src/client/OutdoorCinemaClient.luau').read_text(encoding='utf8')
    data='''-- KOALI v31.9.3 : ajoute seulement l'écran et son déclencheur, sans regénérer la ville.
assert(not game:GetService("RunService"):IsRunning(),"Arrêter Play avant le correctif cinéma.")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local runtime=SS:FindFirstChild("KinCityRuntime")
local ui=SP:FindFirstChild("KinCityUI")
assert(runtime and ui, "Installer d'abord Kin City Koali v31.9.2 ou supérieur")
local function install(parent,name,content)
    local mod=parent:FindFirstChild(name)
    if mod and not mod:IsA("ModuleScript") then mod:Destroy();mod=nil end
    if not mod then mod=Instance.new("ModuleScript");mod.Name=name;mod.Parent=parent end
    mod.Source=content
    return mod
end
'''
    data+='local serverModule=install(runtime,"OutdoorCinema",'+quote_luau(server)+')\n'
    data+='install(ui,"OutdoorCinemaClient",'+quote_luau(client)+')\n'
    data+='''local oldServer=SS:FindFirstChild("KinCityOutdoorCinemaRuntime")
if oldServer then oldServer:Destroy() end
local service=Instance.new("Script")
service.Name="KinCityOutdoorCinemaRuntime"
service.Source='require(script.Parent:WaitForChild("KinCityRuntime"):WaitForChild("OutdoorCinema")).start()'
service.Parent=SS
local oldClient=SP:FindFirstChild("KinCityOutdoorCinemaClient")
if oldClient then oldClient:Destroy() end
local display=Instance.new("LocalScript")
display.Name="KinCityOutdoorCinemaClient"
display.Source='require(script.Parent:WaitForChild("KinCityUI"):WaitForChild("OutdoorCinemaClient")).start()'
display.Parent=SP
require(serverModule).ensure()
print("KOALI v31.9.3 : écran cinéma créé sans toucher à KinCityGenerated.")
print("Configurer Workspace.KinCityOutdoorCinema > attribut KinVideoAssetId avec l'ID Roblox de votre vidéo.")
'''
    path=root/OUTPUT.name
    path.write_text(data,encoding='utf8')
    print('PATCH',path,len(data.encode('utf8')),'bytes')
    return path

if __name__=='__main__': generate()
