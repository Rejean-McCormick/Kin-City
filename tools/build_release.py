#!/usr/bin/env python3
"""Release v26: ville seule + huit intérieurs, plus secours historique local.
Sans PlaceId inventé ni connexion réseau. Si les vrais IDs sont configurés et
MULTI_PLACE sélectionné, les neuf scripts basculent en publication.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import shutil
from pathlib import Path
from make_studio_installer import generate
import runpy
from export_roblox import build_fingerprint

ROOT=Path(__file__).resolve().parents[1]
def sha256(path:Path)->str:
    return hashlib.sha256(path.read_bytes()).hexdigest()
def build(root:Path):
    runpy.run_path(str(root/'tools/generate_v24_meshes.py'))
    runpy.run_path(str(root/'tools/generate_v25_meshes.py'))
    local=generate(root)
    local_copy=root/'KinCity_Installation_Univers_Local_v26.luau'
    shutil.copyfile(local,local_copy)
    registry=json.loads((root/'config/place_ids.json').read_text(encoding='utf8'))
    installers={}
    for key in registry:
        installers[key]=generate(root,place_key=key)
    direct=root/'KinCity_Installation_Directe_v26.luau'
    shutil.copyfile(installers['city'],direct)
    plan=json.loads((root/'build/world-plan.json').read_text(encoding='utf8'))
    identity=build_fingerprint(root,plan['canonical_sha256'])
    place_packages=[]
    for key in registry:
        is_city=key=='city'
        place_packages.append({
            'place_key':key,
            'role':'exterior_city' if is_city else 'institution_interior',
            'installer':installers[key].name,
            'published_place_id':registry[key],
            'canonical_doors':sum(d['source_place_key']==key for d in plan['doors']),
            'canonical_interactions':sum(i['place_key']==key for i in plan['interactions']),
            'anchors':next(len(p['anchors']) for p in plan['places'] if p['place_key']==key),
            'generates_city':is_city,
            'generates_institution_interior':not is_city,
        })
    package_json=root/'build/place-package-plan.json'
    package_json.write_text(json.dumps({
        'version':'26.0.0','source_world_plan_sha256':plan['canonical_sha256'],
        'packages':place_packages,'published_place_ids_required_for_interplace_travel':True,
        'preview_has_interplace_teleportation':False,
    },ensure_ascii=False,sort_keys=True,indent=2)+'\n',encoding='utf8')
    tracked=[root/'build/world-plan.json',package_json,local,local_copy,direct]
    tracked.extend(installers.values())
    tracked.extend(sorted((root/'src/shared').glob('*.luau')))
    tracked.extend(sorted((root/'assets/meshes-v24').glob('*.obj')))
    tracked.extend(sorted((root/'assets/meshes-v25').glob('*.obj')))
    tracked.extend([root/'KinCity_Enregistrer_Mesh_Studio_v25.luau',
        root/'KinCity_Enregistrer_Materiau_Studio_v25.luau',
        root/'KinCity_Diagnostic_Studio_v25.luau',
        root/'KinCity_Diagnostic_Places_v26.luau'])
    configured=json.loads((root/'config/runtime.json').read_text(encoding='utf8'))['mode']
    manifest={
        'version':'26.0.0','mode':'WORLD_STUB','runtime_mode':configured,
        'place_install_mode':'MULTI_PLACE' if configured=='MULTI_PLACE' else 'SPLIT_PREVIEW',
        'art_style':'#1E6864 + cristal opalin',
        'plan_sha256':plan['canonical_sha256'],'build_sha256':identity['sha256'],
        'place_installers':{key:path.name for key,path in installers.items()},
        'place_ids_configured':sum(isinstance(n,int) and not isinstance(n,bool) for n in registry.values()),
        'artifacts':{p.relative_to(root).as_posix():sha256(p) for p in tracked},
    }
    output=root/'build/release-manifest.json'
    output.write_text(json.dumps(manifest,ensure_ascii=False,sort_keys=True,indent=2)+'\n',encoding='utf8')
    print('RELEASE v26',len(installers),'installateurs indépendants; build',identity['sha256'][:16])
    return manifest

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--root',type=Path,default=ROOT)
    args=ap.parse_args();build(args.root)
