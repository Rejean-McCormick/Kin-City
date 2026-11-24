#!/usr/bin/env python3
"""Validate nine declarative Place contribution manifests (not a runtime loader)."""
from __future__ import annotations
import argparse,json,sys
from pathlib import Path
try:
    from b09_contracts import KEYS,CONTRACT
except ImportError:
    from tools.b09_contracts import KEYS,CONTRACT

def check(root):
    issues=[]
    for place in KEYS:
        f=root/'contrib/places'/place/'recipe.json'
        if not f.is_file():issues.append(f'Absence de recette pour {place}');continue
        try:d=json.loads(f.read_text(encoding='utf8'))
        except Exception as e:issues.append(f'{place} JSON invalide : {e}');continue
        if d.get('schema_version')!='kincity.place-recipe/1.0':issues.append(f'{place}: schema_version')
        if d.get('place_key')!=place:issues.append(f'{place}: place_key')
        if d.get('requires_contracts_version')!=CONTRACT:issues.append(f'{place}: contracts_version')
        if d.get('owner_branch')!= ('B10' if place=='city' else 'B0'+str(KEYS.index(place))):issues.append(f'{place}: owner_branch')
        if d.get('seed_policy')!='CITY_SEED_XOR_PLACE_HASH':issues.append(f'{place}: seed_policy')
        if d.get('profiles_supported')!=['LITE','STANDARD','SHOWCASE']:issues.append(f'{place}: profils requis dans ordre canonique')
        if not isinstance(d.get('decorations'),list):issues.append(f'{place}: decorations tableau requis')
        for i,p in enumerate(d.get('decorations',[]) if isinstance(d.get('decorations'),list) else []):
            if not isinstance(p,dict) or not set(['id','asset_key','anchor_id','min_profile']).issubset(p):issues.append(f'{place}: décoration {i} invalide');continue
            if not p['id'].startswith(place+'.'):issues.append(f'{place}: décoration {i} ID hors namespace')
            if p['min_profile'] not in ('LITE','STANDARD','SHOWCASE'):issues.append(f'{place}: décoration {i} profil invalide')
    return issues

def main():
    p=argparse.ArgumentParser();p.add_argument('--repo',type=Path,required=True)
    a=p.parse_args();errors=check(a.repo)
    print('RECETTES B09:', 'OK' if not errors else 'FAIL',len(KEYS),'Places')
    for e in errors:print('ERROR:',e)
    return bool(errors)
if __name__=='__main__':sys.exit(main())
