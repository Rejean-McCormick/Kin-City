#!/usr/bin/env python3
"""Génère un script autonome à COLLER dans la Command Bar de Roblox Studio (mode Edit).
Roblox Studio seul peut confirmer l'exécution; ce script ne touche à aucun compte/serveur.
"""
from pathlib import Path
import argparse
import json
from export_roblox import lua_literal
from export_roblox import export

ROOT=Path(__file__).resolve().parents[1]

def quote_luau(src: str) -> str:
    for n in range(0,7):
        eq='='*n
        end=']'+eq+']'
        if end not in src and ('['+eq+'[') not in src:
            return '['+eq+'[\n'+src+'\n'+end
    raise ValueError('No safe multiline delimiter')

def generate(root=ROOT, place_key=None, *, preview=None):
    """place_key=None => legacy LOCAL_UNIVERSE.
    place_key='city'|interior => install a single physical Roblox Place.
    preview=True => SPLIT_PREVIEW with no invented published PlaceIds.
    preview=False => MULTI_PLACE; requires all real PlaceIds.
    """
    export(root)
    manifest=json.loads((root/'config/place_ids.json').read_text(encoding='utf8'))
    runtime=json.loads((root/'config/runtime.json').read_text(encoding='utf8'))
    if place_key is not None:
        if place_key not in manifest: raise ValueError('Unknown place_key: '+place_key)
        if preview is None: preview=runtime['mode']!='MULTI_PLACE'
        if not preview and (runtime['mode']!='MULTI_PLACE' or any(v is None for v in manifest.values())):
            raise ValueError('A real published MULTI_PLACE install requires all published PlaceIds')
        target_mode='SPLIT_PREVIEW' if preview else 'MULTI_PLACE'
    else:
        target_mode=runtime['mode']

    template='''-- Kin City WORLD_STUB — installation dans Roblox Studio (mode Édition seulement)
-- Collez ce fichier entier dans View > Command Bar et exécutez UNE fois.
-- Aucun appel HTTP / aucune API / aucun jeton.
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerScriptService")
local SP = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local existing = RS:FindFirstChild("KinCityShared")
if existing then existing:Destroy() end
existing = SS:FindFirstChild("KinCityRuntime")
if existing then existing:Destroy() end
existing = SP:FindFirstChild("KinCityUI")
if existing then existing:Destroy() end
local shared = Instance.new("Folder")
shared.Name = "KinCityShared"
shared.Parent = RS
local server = Instance.new("Script")
server.Name = "KinCityRuntime"
server.Enabled = false
server.Parent = SS
local client = Instance.new("LocalScript")
client.Name = "KinCityUI"
client.Enabled = false
client.Parent = SP
local function source(parent, name, className, content)
    local v=Instance.new(className)
    v.Name=name
    v.Source=content
    v.Parent=parent
end
'''
    content=[template]
    for fname in sorted((root/'src/shared').glob('*.luau')):
        module_source=fname.read_text(encoding="utf8")
        if fname.stem=='RuntimeConfig' and place_key is not None:
            module_source='--!strict\n-- Identité propre à cette installation.\nreturn '+lua_literal(
                {'mode':target_mode,'target_place_key':place_key})+'\n'
        content.append(f'source(shared,{repr(fname.stem)},"ModuleScript",{quote_luau(module_source)})\n')
    for fname in sorted((root/'src/server').glob('*.luau')):
        if fname.name=='init.server.luau':continue
        content.append(f'source(server,"{fname.stem}","ModuleScript",{quote_luau(fname.read_text(encoding="utf8"))})\n')
    for fname in sorted((root/'src/client').glob('*.luau')):
        if fname.name=='init.client.luau':continue
        content.append(f'source(client,"{fname.stem}","ModuleScript",{quote_luau(fname.read_text(encoding="utf8"))})\n')
    content.append('server.Source='+quote_luau((root/'src/server/init.server.luau').read_text(encoding='utf8'))+'\n')
    content.append('client.Source='+quote_luau((root/'src/client/init.client.luau').read_text(encoding='utf8'))+'\n')
    camera=('CFrame.lookAt(Vector3.new(230,230,270),Vector3.new(0,0,0))' if place_key is None or place_key=='city'
            else 'CFrame.lookAt(Vector3.new(150,115,200),Vector3.new(0,8,45))')
    content.append('''-- Instancier aussi les bâtiments en mode édition : la scène ne reste pas vide.
local buildOk, buildErr=pcall(function()
    require(server:WaitForChild("WorldBuilder")).build()
end)
if not buildOk then
    error("Kin City : erreur de génération Studio : "..tostring(buildErr))
end
pcall(function()
    local camera=workspace.CurrentCamera
    if camera then camera.CFrame=__KIN_CAMERA__ end
end)
server.Enabled = true
client.Enabled = true
-- StreamingEnabled se configure dans les propriétés de Workspace dans Studio.
local streamingOk, streamingValue=pcall(function() return workspace.StreamingEnabled end)
if streamingOk then
    print("KIN CITY : Workspace.StreamingEnabled = "..tostring(streamingValue).." (paramètre Studio)")
end
print("KIN CITY v26 : Place installée séparément, ville allégée et institutions indépendantes; identité sarcelle-cristal, WORLD_STUB.")
''')
    content=[chunk.replace('__KIN_CAMERA__', camera) for chunk in content]
    if place_key is None:
        path=root/'KinCity_Installer_CommandBar.luau'
    else:
        path=root/f'KinCity_Installation_Place_{place_key}_v26.luau' 
    path.write_text(''.join(content),encoding='utf8')
    print('INSTALLER OK', path, path.stat().st_size, 'octets')
    return path

if __name__=='__main__':
    a=argparse.ArgumentParser()
    a.add_argument('--root',type=Path,default=ROOT)
    a.add_argument('--place',default=None,help='city ou une des 8 institutions')
    a.add_argument('--published',action='store_true',help='Exiger les vrais PlaceIds, pour publication')
    args=a.parse_args()
    generate(args.root,place_key=args.place,preview=False if args.published else None)
