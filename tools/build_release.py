#!/usr/bin/env python3
"""Reproducible single-Place test release; never generate historical publishing installers."""
import argparse
import hashlib
import json
from pathlib import Path
from make_universe_recovery_installer import generate
from art_deco_catalog import load_art_deco
ROOT=Path(__file__).resolve().parents[1]
def build(root=ROOT):
    load_art_deco(root)
    from art_deco_context_manifest import generate as generate_contexts
    generate_contexts(root)
    from validate_v28_journey import validate
    errors=validate(root)
    if errors: raise ValueError('; '.join(errors))
    from make_art_deco_library_tools import generate as generate_library_tools
    generate_library_tools(root)
    if (root/'contrib/places').exists():
        from b09_bundle_branches import generate as bundle_branches
        bundle_branches(root)
    generate(root)
    plan=json.loads((root/'build/world-plan.json').read_text())
    paths=[root/'installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau',root/'build/world-plan.json']
    for folder,pattern in [('src','*.luau'),('catalog','*.json'),('config','*.json'),('studio','*.luau')]:
        paths.extend(sorted((root/folder).rglob(pattern)))
    manifest={'version':'kc35-all-branches-local-staging','base':'supplied snapshot; remote HEAD not verified',
        'test_only':True,'production_place_excluded':72097868581669,
        'canonical_plan_sha256':plan['canonical_sha256'],
        'artifacts':{p.relative_to(root).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
    (root/'build/release-manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,sort_keys=True,indent=2)+'\n')
    print('RELEASE: official test installer only;',len(paths),'source/data artifacts')
    return manifest
if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--root',type=Path,default=ROOT)
    build(parser.parse_args().root)
