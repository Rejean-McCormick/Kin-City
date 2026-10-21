#!/usr/bin/env python3
"""Build a compact single-Place full-universe Command Bar installer from v30 sources.
Includes optional v27-compatible geometry fallbacks provided by the owner.
Never substitutes published PlaceIds, assets or external networks.
"""
from pathlib import Path
from export_roblox import export, lua_literal
from make_studio_installer import quote_luau

ROOT=Path(__file__).resolve().parents[1]
OUTPUT=ROOT/'KinCity_Installation_Univers_Complet_v30.0.7.luau'

def compact_luau(text: str) -> str:
    # All project sources are checked to avoid Lua multiline strings: those
    # can have meaningful leading whitespace or whole-line comment text.
    if '[[' in text or '[=[' in text:
        raise ValueError('Multiline Lua source not supported by safe compact mode')
    return '\n'.join(line.strip() for line in text.splitlines()
                     if line.strip() and not line.lstrip().startswith('--'))+'\n'

def generate(root=ROOT):
    export(root)
    out=['''-- KIN CITY v30.0.7 — UNIVERS COMPLET / PARCOURS DE QUARTIER / PNJ / LUMIÈRE 65 %
-- COLLER LE FICHIER EN ENTIER dans la Command Bar Roblox Studio, Play arrete.
-- Une seule Place : ville + 8 institutions, sans publication ni appel HTTP.
-- Les scripts et fonctions Roblox ne peuvent etre executes que dans Studio.
assert(not game:GetService("RunService"):IsRunning(), "Kin City : arreter Play avant installation")
print("KIN CITY : debut installation UNIVERS COMPLET (ville + 8 institutions)")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local oldAvatar=SS:FindFirstChild("KinCityKingKlownAvatar")
local preservedOwner=oldAvatar and oldAvatar:GetAttribute("OwnerUserId") or 0
local runtime=SS:FindFirstChild("KinCityRuntime")
if preservedOwner==0 and runtime then preservedOwner=runtime:GetAttribute("KingKlownOwnerUserId") or 0 end
local oldAura=SP:FindFirstChild("KinCityKingKlownAura")
if oldAvatar then oldAvatar:Destroy() end
if oldAura then oldAura:Destroy() end
for _,pair in ipairs({{RS,"KinCityShared"},{SS,"KinCityRuntime"},{SP,"KinCityUI"}}) do
  local old=pair[1]:FindFirstChild(pair[2]);if old then old:Destroy() end
end
local shared=Instance.new("Folder")
shared.Name="KinCityShared";shared.Parent=RS
local server=Instance.new("Script")
server.Name="KinCityRuntime";server.Enabled=false
server:SetAttribute("KingKlownOwnerUserId",preservedOwner)
server.Parent=SS
local client=Instance.new("LocalScript")
client.Name="KinCityUI";client.Enabled=false;client.Parent=SP
local modules=0
local function source(parent,name,code)
  local child=Instance.new("ModuleScript")
  child.Name=name;child.Source=code;child.Parent=parent
  modules+=1
end
''']
    for filename in sorted((root/'src/shared').glob('*.luau')):
        if filename.stem=='RuntimeConfig':
            code='return '+lua_literal({'mode':'LOCAL_UNIVERSE'})
        else:
            code=compact_luau(filename.read_text(encoding='utf8'))
        out.append('source(shared,'+lua_literal(filename.stem)+','+quote_luau(code)+')\n')
    for filename in sorted((root/'src/server').glob('*.luau')):
        if filename.name=='init.server.luau':continue
        code=compact_luau(filename.read_text(encoding='utf8'))
        out.append('source(server,'+lua_literal(filename.stem)+','+quote_luau(code)+')\n')
    for filename in sorted((root/'src/client').glob('*.luau')):
        if filename.name=='init.client.luau':continue
        code=compact_luau(filename.read_text(encoding='utf8'))
        out.append('source(client,'+lua_literal(filename.stem)+','+quote_luau(code)+')\n')
    out.append('server.Source='+quote_luau(compact_luau((root/'src/server/init.server.luau').read_text(encoding='utf8')))+'\n')
    out.append('client.Source='+quote_luau(compact_luau((root/'src/client/init.client.luau').read_text(encoding='utf8')))+'\n')
    out.append('''print("KIN CITY : "..tostring(modules).." modules charges, debut du monde en EDITION...")
local ok,built=xpcall(function()
  local builder=require(server:WaitForChild("WorldBuilder"))
  return builder.build()
end,function(err)
  if debug and type(debug.traceback)=="function" then return debug.traceback(tostring(err),2) end
  return tostring(err)
end)
if not ok then
  warn("KIN CITY : GENERATION ECHOUEE. Copiez cette erreur depuis View > Output :\\n"..tostring(built))
  error("KIN CITY : la ville n'a PAS ete installee. Voir Output pour la cause : "..tostring(built))
end
local world=workspace:FindFirstChild("KinCityGenerated")
assert(world and world:GetAttribute("KinBuildState")=="Ready", "KIN CITY : KinCityGenerated pas pret")
local city=world:FindFirstChild("Ville")
local interiors=world:FindFirstChild("Bâtiments visitables")
assert(city and #city:GetDescendants()>50, "KIN CITY : la ville n'est pas visible / pas generee")
local expected={"campus","city_hall","ekoh_tower","innovation_lab","justice_palace","library","museum","orgo_center"}
for _,key in ipairs(expected) do
  local place=interiors and interiors:FindFirstChild("Intérieur — "..key)
  assert(place and #place:GetDescendants()>20, "KIN CITY : interieur absent : "..key)
end
local cam=workspace.CurrentCamera
if cam then cam.CameraType=Enum.CameraType.Custom;cam.CFrame=CFrame.lookAt(Vector3.new(230,230,270),Vector3.new(0,0,0)) end
server.Enabled=true;client.Enabled=true
print("KIN CITY : MONDE PRÊT - la ville et les 8 institutions existent. Parts "..tostring(world:GetAttribute("KinGeneratedParts")).." ; secours v27 "..tostring(world:GetAttribute("KinGeneratorFallbacks")))
print("KIN CITY : dossiers : Workspace.KinCityGenerated.Ville et Workspace.KinCityGenerated['Bâtiments visitables']")
print("KIN CITY : utiliser les portes dans Play pour visiter les institutions chargees a leurs origines locales.")
''')
    data=''.join(out)
    OUTPUT.write_text(data,encoding='utf8')
    print('COMPLETE INSTALLER',OUTPUT,len(data.encode('utf8')),'bytes',modules if False else '')
    return OUTPUT

if __name__=='__main__':generate()
