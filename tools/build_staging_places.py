#!/usr/bin/env python3
"""Nine staging-only Studio Command Bar installers. Does not publish Places.

Only run with nine real staging PlaceIds belonging to the SAME unpublished/test
experience, each containing an authorized copy of the 121 imported models.
"""
import argparse
import json
import re
import sys
from pathlib import Path
from export_roblox import lua_literal
from art_deco_catalog import load_art_deco
from build_imported_test_installer import generate as generate_local
from make_studio_installer import quote_luau
ROOT=Path(__file__).resolve().parents[1]
PRODUCTION_ID=72097868581669

OLD_LOCAL_GUARD='''assert((game.PlaceId==0 and artDecoTarget.allow_local_test) or
    (artDecoTarget.test_place_id~=nil and game.PlaceId==artDecoTarget.test_place_id),
    "Art Deco : PlaceId de test non configure ; aucune modification effectuee")'''
OLD_LIBRARY_GUARD='''assert((game.PlaceId==0 and config.allow_local_test) or
    (config.test_place_id~=nil and game.PlaceId==config.test_place_id),"Test PlaceId mismatch")'''

def read_ids(path,root=ROOT):
    mapping=json.loads(Path(path).read_text(encoding='utf8'))
    expected={p['place_key'] for p in json.loads((root/'catalog/places.json').read_text())['places']}
    if type(mapping)!=dict or set(mapping)!=expected:
        raise ValueError('Exactement neuf cles de Places requises : '+', '.join(sorted(expected)))
    if any(type(v)!=int or v<=0 or v==PRODUCTION_ID for v in mapping.values()):
        raise ValueError('Les neuf PlaceIds de STAGING doivent être entiers, positifs et hors production.')
    if len(set(mapping.values()))!=len(mapping):raise ValueError('PlaceIds de staging dupliqués.')
    return mapping

def stage_library(code,config):
    head=code.index('local config=')
    expected=code.index('local expected=',head)
    code=code[:head]+'local config='+lua_literal(config)+'\n'+code[expected:]
    assert OLD_LIBRARY_GUARD in code
    return code.replace(OLD_LIBRARY_GUARD, '''assert(table.find(config.test_place_ids,game.PlaceId)~=nil,
    "Place de staging non autorisee")''')

def replace_module(code,destination,name,body):
    pattern=r'(?ms)^source\('+re.escape(destination)+','+re.escape(json.dumps(name))+r',\[\[.*?^\]\]\)'
    code,count=re.subn(pattern,lambda _: 'source('+destination+','+json.dumps(name)+','+quote_luau(body)+')',code)
    if count!=1:raise ValueError('Module de remplacement ambigu : '+name+' '+str(count))
    return code

def stage_engine(local_code,key,routing,config,root=ROOT):
    code=local_code
    assert OLD_LOCAL_GUARD in code
    expected_id=routing[key]
    code=code.replace(OLD_LOCAL_GUARD, f'''assert(game.PlaceId=={expected_id} and
    table.find(artDecoTarget.test_place_ids,game.PlaceId)~=nil,
    "Mauvaise Place de staging ; installation bloquée")''')
    # Initial guard must use the actual staging config, not the local JSON.
    code=re.sub(r'local artDecoTarget=\{.*?\}\nassert\(game.PlaceId~=',
       lambda m:'local artDecoTarget='+lua_literal(config)+'\nassert(game.PlaceId~=',
       code,count=1,flags=re.S)
    code=replace_module(code,'shared','RuntimeConfig','return '+lua_literal({
        'mode':'MULTI_PLACE','target_place_key':key}))
    code=replace_module(code,'shared','PlaceRouting','return '+lua_literal(routing))
    data=load_art_deco(root)
    data['config']=config
    code=replace_module(code,'server','ArtDecoData','return '+lua_literal(data))
    start=code.index('print("KIN CITY : "..tostring(modules).." modules charges, debut du monde en EDITION...")')
    code=code[:start]+'''print("KIN CITY : préparation staging MULTI_PLACE")
local ok,reason=xpcall(function()
  return require(server:WaitForChild("WorldBuilder")).build()
end,debug.traceback)
if not ok then error("Construction staging en échec : "..tostring(reason)) end
local world=assert(workspace:FindFirstChild("KinCityGenerated"))
assert(world:GetAttribute("KinBuildState")=="Ready" and world:GetAttribute("KinRoutingMode")=="MULTI_PLACE",
    "Erreur de routage ou monde incomplet")
'''
    if key=='city':
        code+='''assert(world:FindFirstChild("Ville") and world:GetAttribute("KinInteriorCount")==0,
  "La ville ne doit pas charger les huit intérieurs distants")
require(server:WaitForChild("OutdoorCinema")).ensure()
'''
    else:
        code+=f'''assert(world:GetAttribute("KinInteriorCount")==1 and not world:FindFirstChild("Ville"),
  "Chaque Place intérieure ne doit contenir qu'un intérieur")
local interiors=assert(world:FindFirstChild("Bâtiments visitables"))
assert(interiors:FindFirstChild("Intérieur — {key}"),"Intérieur staging absent")
'''
    code+='''server.Enabled=true;client.Enabled=true
print("KIN CITY : staging MULTI_PLACE construit et vérifié en Édition ; téléportations non testées.")
'''
    return code

def make(root,ids,out):
    ids=read_ids(ids,root)
    out=Path(out);out.mkdir(parents=True,exist_ok=True)
    generate_local(out/'_BASE_LOCAL_TEMP.luau',root)
    (out/'_BASE_LOCAL_TEMP.luau').unlink()
    prep=(root/'studio/PrepareArtDecoLibrary.luau').read_text(encoding='utf8')
    config=dict(load_art_deco(root)['config'])
    config['test_place_ids']=[ids[key] for key in sorted(ids)]
    produced=[]
    for key in sorted(ids):
        target_id=ids[key]
        head=f'''-- KIN CITY STAGING / {key} ({target_id}). PLACE DE TEST UNIQUEMENT.
-- ATTENTION: efface la génération Kin City existante DANS LA PLACE CIBLE.
-- Ne crée ni ne publie de Place, n'upload aucun modèle et n'active pas la production.
assert(game:GetService("RunService"):IsStudio(),"Studio uniquement")
assert(not game:GetService("RunService"):IsRunning(),"Arreter Play")
assert(game.PlaceId=={target_id},"Mauvaise Place / aucune modification")
assert(game.PlaceId~={PRODUCTION_ID},"Production interdite")
assert(workspace:GetAttribute("KinArtDecoTestPlace")==true,
  "Copie de staging à marquer MANUELLEMENT avant installation")
assert(workspace.StreamingEnabled,"StreamingEnabled requis")
'''
        engine=stage_engine((root/'installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau').read_text(encoding='utf8'),key,ids,config,root)
        # Keep source import guard BEFORE any deletion; all 121 models are required.
        check=f'''local shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local runtime=assert(game:GetService("ServerScriptService"):FindFirstChild("KinCityRuntime"))
local result=assert(workspace:FindFirstChild("KinCityGenerated"))
assert(result:GetAttribute("KinActivePlace")=="{key}")
local meshCount=0
for _,v in ipairs(result:GetDescendants()) do if v:IsA("MeshPart") then meshCount+=1 end end
assert(meshCount>0,"Aucun mesh Art Deco effectivement instancié")
print("STAGING {key} : "..meshCount.." MeshParts ; contrôle Studio manuel et teleportations requis")
'''
        payload=head+'\ndo\n'+stage_library(prep,config)+'\nend\n'+engine+'\ndo\n'+check+'\nend\n'
        filename=f'INSTALLER_STAGING_{key.upper()}.luau'
        (out/filename).write_text(payload,encoding='utf8')
        produced.append(filename)
    (out/'README_STAGING.txt').write_text('''NE PAS LANCER SUR LA PRODUCTION. NE PUBLIE AUCUNE PLACE.
1. Créer NEUF Places dans UNE MÊME expérience Roblox privée de STAGING.
2. Y copier les 121 sources du pack sous licence et activer StreamingEnabled.
3. Sauvegarder chaque Place en .rbxl ou version privée avant écrasement.
4. Dans chacune, arrêter Play puis exécuter manuellement dans la Command Bar :
   workspace:SetAttribute("KinArtDecoTestPlace", true)
5. Copier tout le script INSTALLER_STAGING_<NOM>.luau correspondant.
6. Répéter neuf fois; aucun identifiant ne doit pointer vers la production.
7. Tester les portes aller/retour dans le client Roblox publié (PAS Studio).
8. Mesurer mémoire, rendu, temps de chargement et collisions sur mobile.
Aucun upload des meshes et aucune publication ne sont effectués par ces scripts.
Les identifiants doivent référer à des Places de la même expérience de staging,
sinon TeleportService ne permettra pas les transitions.
''',encoding='utf8')
    (out/'place_ids_staging.json').write_text(json.dumps(ids,indent=2)+'\n',encoding='utf8')
    return produced

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--ids',required=True,type=Path,help='JSON des neuf PlaceIds réels de préproduction')
    ap.add_argument('--out',required=True,type=Path,help='Répertoire cible des neuf scripts')
    a=ap.parse_args();print('\n'.join(make(ROOT,a.ids,a.out)))
