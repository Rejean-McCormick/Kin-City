"""Même source serveur/client pour le costume autonome et les neuf Places."""
from pathlib import Path
import json
from make_studio_installer import quote_luau
ROOT=Path(__file__).resolve().parents[1]
def generate_avatar(root=ROOT):
    config=json.loads((root/'config/king_klown.json').read_text())
    server=(root/'src/server/KingKlownAvatar.luau').read_text()
    client=(root/'src/client/KingKlownAura.luau').read_text()
    performance=(root/'src/client/KingKlownPerformance.luau').read_text()
    text='''-- King Klown v7 — coller en ÉDITION dans la barre Commande.
-- Costume seul : aucun bâtiment reconstruit. R15 / R6, aura purement visuelle.
-- Groupe Roblox : renseigner votre vrai UserId ci-dessous avant installation.
local OWNER_USER_ID = %d
assert(not game:GetService("RunService"):IsRunning(),"Arrêtez Play avant l'installation.")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local old=SS:FindFirstChild("KinCityKingKlownAvatar")
if OWNER_USER_ID==0 and old then OWNER_USER_ID=old:GetAttribute("OwnerUserId") or 0 end
if old then old:Destroy() end
local oldClient=SP:FindFirstChild("KinCityKingKlownAura")
if oldClient then oldClient:Destroy() end
local runtime=Instance.new("Script")
runtime.Name="KinCityKingKlownAvatar";runtime.Enabled=false
runtime:SetAttribute("OwnerUserId",OWNER_USER_ID)
local avatar=Instance.new("ModuleScript")
avatar.Name="Avatar"
avatar.Source=SERVER_SOURCE
avatar.Parent=runtime
runtime.Source='require(script.Avatar).start({ownerUserId=script:GetAttribute("OwnerUserId") or 0,studioPreview=true})'
runtime.Parent=SS
local client=Instance.new("LocalScript")
client.Name="KinCityKingKlownAura";client.Enabled=false
local aura=Instance.new("ModuleScript")
aura.Name="Aura";aura.Source=CLIENT_SOURCE;aura.Parent=client
local gestures=Instance.new("ModuleScript")
gestures.Name="Performance";gestures.Source=PERFORMANCE_SOURCE;gestures.Parent=client
client.Source='require(script.Aura).start();require(script.Performance).start()' 
client.Parent=SP
runtime.Enabled=true;client.Enabled=true
print("King Klown v7 installé. Lancez Play : tête ronde, sourire détendu et aura locale.")
''' % config['ownerUserId']
    text=text.replace('SERVER_SOURCE',quote_luau(server)).replace('CLIENT_SOURCE',quote_luau(client)).replace('PERFORMANCE_SOURCE',quote_luau(performance))
    path=root/'KingKlown_v7.luau';path.write_text(text);return path
if __name__=='__main__': print(generate_avatar())
