#!/usr/bin/env python3
"""Exporte le plan canonique v3 en ModuleScripts Luau, sans APIs, IA ni fichiers Roblox fictifs."""
from __future__ import annotations
import argparse
import json
import hashlib
from pathlib import Path
from compile_plan import compile_plan
from art_deco_catalog import load_art_deco

ROOT = Path(__file__).resolve().parents[1]

def lua_literal(obj, depth=0):
    pad = "  " * depth
    next_pad = "  " * (depth + 1)
    if obj is None: return "nil"
    if obj is True: return "true"
    if obj is False: return "false"
    if isinstance(obj, str):
        # JSON string syntax (UTF-8, escaped quote/backslash/control) is a compatible Lua string subset.
        return json.dumps(obj, ensure_ascii=False)
    if isinstance(obj, (int, float)) and not isinstance(obj, bool): return repr(obj)
    if isinstance(obj, list):
        if not obj: return "{}"
        return "{\n" + "\n".join(next_pad + lua_literal(v, depth+1) + "," for v in obj) + "\n" + pad + "}"
    if isinstance(obj, dict):
        if not obj: return "{}"
        return "{\n" + "\n".join(next_pad + "[" + lua_literal(k) + "] = " + lua_literal(v, depth+1) + "," for k,v in sorted(obj.items())) + "\n"+pad+"}"
    raise TypeError(f"unsupported: {type(obj)}")

def put(path: Path, obj, title):
    path.parent.mkdir(parents=True,exist_ok=True)
    path.write_text("--!strict\n-- Généré automatiquement : " + title + "\n-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.\nreturn " + lua_literal(obj) + "\n",encoding="utf8")

def build_fingerprint(root: Path, plan_hash: str) -> dict:
    """Empreinte des données ET des générateurs/runtime, distincte du plan canonique."""
    digest=hashlib.sha256()
    included=[]
    for directory,pattern in (("catalog","*.json"),("config","*.json"),("src/server","*.luau"),
                              ("src/client","*.luau")):
        for source in sorted((root/directory).rglob(pattern)):
            if not source.is_file(): continue
            name=source.relative_to(root).as_posix()
            data=source.read_bytes()
            digest.update(name.encode("utf8")+b"\0"+len(data).to_bytes(8,"big")+data)
            included.append(name)
    # Hand-authored palette modules affect geometry/signage and must invalidate reuse.
    for name in ("HexagonalDistricts.luau","SignTheme.luau","ArtDecoTheme.luau"):
        source=root/'src/shared'/name
        if source.exists():
            data=source.read_bytes()
            digest.update(name.encode('utf8')+b'\0'+data)
            included.append('src/shared/'+name)
    digest.update(b"canonical-plan\0"+plan_hash.encode("ascii"))
    return {"sha256":digest.hexdigest(),"plan_sha256":plan_hash,"input_count":len(included),"version":"build-v29"}

def export(root: Path):
    art_deco=load_art_deco(root)
    plan=compile_plan(root)
    registry=json.loads((root/'config/place_ids.json').read_text(encoding='utf8'))
    config=json.loads((root/'config/runtime.json').read_text(encoding='utf8'))
    expected={p['place_key'] for p in plan['places']}
    if set(registry)!=expected:raise ValueError('config/place_ids.json keys must match place catalog')
    for key,v in registry.items():
        if v is not None and (not isinstance(v,int) or isinstance(v,bool) or v<=0): raise ValueError(f'Invalid PlaceId for {key}')
    if config['mode'] not in ('LOCAL_UNIVERSE','MULTI_PLACE'):raise ValueError('mode invalide')
    if config['mode']=='MULTI_PLACE' and any(v is None for v in registry.values()):
        raise ValueError('MULTI_PLACE exige tous les PlaceIds publiés')
    out=root/'src/shared'
    (out/'ArtDecoData.luau').unlink(missing_ok=True)
    put(root/'src/server/ArtDecoData.luau',art_deco,'Art Deco : manifeste privé référencé, placements et budgets')
    put(out/'BuildIdentity.luau',build_fingerprint(root,plan['canonical_sha256']),'empreinte exacte du build v29')
    origins=json.loads((root/'config/interior_origins.json').read_text(encoding='utf8'))
    if set(origins)!=expected-{'city'}: raise ValueError('Origines intérieures incomplètes')
    put(out/'InteriorOrigins.luau',origins,'positions stables des intérieurs')
    put(out/'WorldPlan.luau',plan,'plan spatial Kin City')
    put(out/'PlaceRouting.luau',registry,'routage de publication')
    put(out/'RuntimeConfig.luau',{'mode':config['mode']},'mode d’exécution v28')
    put(out/'Buildings.luau',json.loads((root/'catalog/buildings.json').read_text(encoding='utf8'))['buildings'],'noms et gabarits des bâtiments')
    avatar_path=root/'config/king_klown.json'
    avatar=json.loads(avatar_path.read_text()) if avatar_path.exists() else {'ownerUserId':0,'studioPreview':True}
    if type(avatar.get('ownerUserId')) is not int or avatar['ownerUserId']<0:
        raise ValueError('ownerUserId must be a nonnegative integer')
    if type(avatar.get('studioPreview')) is not bool: raise ValueError('studioPreview must be boolean')
    put(out/'KingKlownConfig.luau',avatar,'King Klown v7 : attribution serveur')
    journey_path=root/'config/library_journey.json'
    if journey_path.exists():
        journey=json.loads(journey_path.read_text(encoding='utf8'))
        put(out/'LibraryJourney.luau',journey,'parcours de lecture v28')
    put(out/'Messages.luau',json.loads((root/'catalog/messages.fr.json').read_text(encoding='utf8'))['messages'],'textes fr-CA')
    put(out/'AudioManifest.luau',json.loads((root/'config/audio.json').read_text(encoding='utf8')),'manifest sonore utilisateur')
    put(out/'MeshManifest.luau',json.loads((root/'config/meshes.json').read_text(encoding='utf8')),'IDs optionnels des modèles OBJ / bibliothèque Studio v25')
    put(out/'CrystalTheme.luau',json.loads((root/'catalog/crystal_theme.json').read_text(encoding='utf8')),'direction artistique sarcelle/cristal v17')
    visual=json.loads((root/'config/visual.json').read_text(encoding='utf8'))
    if visual['profile'] not in ('LITE','STANDARD','SHOWCASE'): raise ValueError('Profil visuel non supporté')
    put(out/'VisualConfig.luau',{'profile':visual['profile'],'settings':visual['profiles'][visual['profile']]},'budget géométrique cristal v17')
    build=root/'build'
    build.mkdir(parents=True,exist_ok=True)
    (build/'world-plan.json').write_text(json.dumps(plan,ensure_ascii=False,sort_keys=True,indent=2)+'\n',encoding='utf8')
    print('EXPORT OK',plan['canonical_sha256'],'/ mode',config['mode'],'/ places',len(plan['places']))
    return plan

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--root',type=Path,default=ROOT);args=parser.parse_args()
    export(args.root)
if __name__=='__main__':main()
