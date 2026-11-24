#!/usr/bin/env python3
"""Audite l'alignement du pack documentaire avec les sources KC33 (pas le runtime Studio)."""
import argparse,json,hashlib,re,sys
from pathlib import Path
BASE=Path(__file__).resolve().parents[1]
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def j(p):return json.loads(p.read_text(encoding='utf8'))
def check(root):
 lock=j(BASE/'contrats/empreintes_kc33.json')['sha256'];idx=j(BASE/'contrats/index_machine.json')
 missing=[name for name in lock if not (root/name).exists()]
 assert not missing, f'Fichiers sources absents: {missing}'
 changes=[name for name,s in lock.items() if digest(root/name)!=s]
 if changes:
  raise AssertionError('La source n’est plus la baseline KC33; revue B09 nécessaire: '+', '.join(changes))
 places=j(root/'catalog/places.json')['places'];doors=j(root/'catalog/doors.json')['doors'];builds=j(root/'catalog/buildings.json')['buildings'];context=j(root/'catalog/art_deco_contexts.json')['assets'];ints=j(root/'catalog/interactions.json')['interactions'];plan=j(root/'build/world-plan.json');spa=j(root/'catalog/spatial.json')
 keys={v['place_key'] for v in places}; assert len(keys)==9 and keys==set(idx['place_keys'])
 assert len(doors)==16 and len({x['door_id'] for x in doors})==16
 door_by_id={d['door_id']:d for d in doors}
 for d in doors:
  r=door_by_id[d['return_door_id']]
  assert r['return_door_id']==d['door_id'] and r['source_place_key']==d['destination_place_key'] and r['destination_place_key']==d['source_place_key'],d
 assert len(builds)==8 and len(ints)==8
 assert sum(len(v['anchors']) for v in spa['places'])==49
 assert sum(len(p['rooms']) for p in plan['places'])==24
 assert 'rear_atrium' in (root/'src/server/InteriorWings.luau').read_text()
 assert len(context)==121 and sum(a['status']=='configured' for a in context)==41
 assert len(list((BASE/'branches').glob('B*.md')))==10
 for n,key in enumerate([b['interior_place_key'] for b in builds]+['integration','city'],1):
  # Builds canonical order may evolve, in that case detect drift rather than silently reorder.
  assert idx['branches'][n-1]['owner_key']==key,(n,key)
 print('RÉFÉRENTIEL ALIGNE KC33: 9 Places, 10 branches, 16 portes, 49 ancres, 24+24 salles, 41/121 assets.')
if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('--kc33-source',type=Path,required=True);args=ap.parse_args()
 try:check(args.kc33_source)
 except Exception as e:print('ÉCHEC:',e,file=sys.stderr);sys.exit(1)
