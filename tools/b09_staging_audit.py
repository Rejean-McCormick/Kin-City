#!/usr/bin/env python3
"""Offline ONLY audit of KC33 nine-Place staging generation.

--self-test uses synthetic IDs in a temporary directory; no IDs are persisted.
--ids checks the provided mapping but cannot verify its Roblox universe membership.
"""
from __future__ import annotations
import argparse,json,re,sys,tempfile
from pathlib import Path
from build_staging_places import ROOT,PRODUCTION_ID,read_ids,make

KEYS=tuple(sorted(json.loads((ROOT/'catalog/places.json').read_text())['places'],key=lambda p:p['place_key']))

def audit_ids(ids_path,repo=ROOT):
    mapping=read_ids(ids_path,repo)
    additional_prod=json.loads((repo/'config/art_deco.json').read_text())['production_place_id']
    if not isinstance(additional_prod,int) or additional_prod!=PRODUCTION_ID:
        raise ValueError('Production IDs incohérents entre config et builder, génération bloquée')
    if additional_prod in mapping.values():raise ValueError('Place de production dans staging')
    return mapping

def inspect_outputs(out,ids):
    failures=[]
    for key,pid in ids.items():
        f=out/f'INSTALLER_STAGING_{key.upper()}.luau'
        if not f.is_file():failures.append('Installateur absent: '+key);continue
        code=f.read_text(encoding='utf8')
        for invariant in ('assert(game.PlaceId=='+str(pid), 'KinArtDecoTestPlace', 'MULTI_PLACE',
                          'Production interdite','KinActivePlace'):
            if invariant not in code:failures.append(f'{key}: garde absent: {invariant}')
        if re.search(r'assert\(game.PlaceId=='+str(PRODUCTION_ID)+r'[^\d]',code):
            failures.append(f'{key}: cible la production')
    return failures

def self_test(repo=ROOT):
    ids={p['place_key']:700000001+i for i,p in enumerate(KEYS)}
    with tempfile.TemporaryDirectory(prefix='kincity-b09-staging-') as temp:
        temp=Path(temp);ids_path=temp/'ids.json';ids_path.write_text(json.dumps(ids))
        check=audit_ids(ids_path,repo)
        out=temp/'out';files=make(repo,ids_path,out)
        failures=inspect_outputs(out,check)
        if len(files)!=9:failures.append('Nombre incorrect de scripts: '+str(len(files)))
        if (out/'place_ids_staging.json').exists():pass # Temporary synthetic only
    return failures

def main():
    p=argparse.ArgumentParser(description=__doc__)
    g=p.add_mutually_exclusive_group(required=True)
    g.add_argument('--self-test',action='store_true')
    g.add_argument('--ids',type=Path)
    p.add_argument('--out',type=Path,help='Générer uniquement après revue humaine')
    a=p.parse_args()
    try:
        if a.self_test:errors=self_test()
        else:
            ids=audit_ids(a.ids)
            errors=[]
            if a.out:
                # Deliberately NOT publishing anything; caller must verify same universe.
                make(ROOT,a.ids,a.out);errors=inspect_outputs(a.out,ids)
            else:print('IDs structurellement valides; univers Roblox non vérifiable hors client.')
    except (OSError,ValueError,AssertionError) as e:errors=[str(e)]
    print(json.dumps({'offline_status':'FAIL' if errors else 'PASS','errors':errors,
          'roblox_publication':'NOT_PERFORMED','teleports':'NOT_TESTED','universe_membership':'NOT_VERIFIED'},ensure_ascii=False))
    return bool(errors)
if __name__=='__main__':sys.exit(main())
