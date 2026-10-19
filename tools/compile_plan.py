#!/usr/bin/env python3
"""Compilateur déterministe du plan logique (IR JSON), jamais un fichier Roblox.
usage: python tools/compile_plan.py --out build/world-plan.json
"""
from __future__ import annotations
import json,math,argparse,hashlib,sys
from pathlib import Path
from collections import deque
from validate_spatial import validate,load
ROOT=Path(__file__).resolve().parents[1]

def is_blocked(x,z, structures, margin=6):
    for item in structures:
        cx,cy,cz=item['center_studs'];w,d=item['footprint_studs']; theta=math.radians(item['yaw_degrees'])
        dx=x-cx;dz=z-cz
        localx=math.cos(theta)*dx-math.sin(theta)*dz
        localz=math.sin(theta)*dx+math.cos(theta)*dz
        if abs(localx)<=w/2+margin and abs(localz)<=d/2+margin:return True
    return False

def nav_path(origin,dest,structures,step=10,world_radius=480):
    # A* (constant-cost BFS on 4-connected grid) with pre-validated clear cells.
    def grid(pt):return (round(pt[0]/step),round(pt[2]/step))
    source=grid(origin);goal=grid(dest)
    def valid(node):
        x,z=node[0]*step,node[1]*step
        return math.hypot(x,z)<=world_radius and not is_blocked(x,z,structures)
    if not valid(source) or not valid(goal):return None
    q=deque([source]);came={source:None}
    while q:
        current=q.popleft()
        if current==goal:break
        for neighbor in ((current[0]+1,current[1]),(current[0]-1,current[1]),(current[0],current[1]+1),(current[0],current[1]-1)):
            if neighbor not in came and valid(neighbor):came[neighbor]=current;q.append(neighbor)
    if goal not in came:return None
    rev=[];node=goal
    while node is not None:rev.append([node[0]*step,0,node[1]*step]);node=came[node]
    rev.reverse()
    # simplify collinear segments for compact reproducible route paths
    compact=[]
    for p in rev:
        compact.append(p)
        while len(compact)>=3:
            a,b,c=compact[-3:]
            if (b[0]-a[0])*(c[2]-b[2])==(b[2]-a[2])*(c[0]-b[0]):compact.pop(-2)
            else:break
    return compact

def compile_plan(root=ROOT):
    errors=validate(root)
    if errors:raise ValueError('Plan invalide : '+'; '.join(errors[:12]))
    spatial=load(root,'spatial'); city=load(root,'city'); buildings=load(root,'buildings')['buildings'];places=load(root,'places')['places']
    sp_by_key={v['place_key']:v for v in spatial['places']}
    city_anchors={a['anchor_id']:a for a in sp_by_key['city']['anchors']}
    structures=sorted(spatial['structures'],key=lambda x:x['building_id'])
    walkways=[]
    for b in sorted(buildings,key=lambda x:x['building_id']):
        dst=city_anchors['city.'+b['building_id']+'.return_spawn']['position_studs']
        p=nav_path(city_anchors['city.central.spawn']['position_studs'],dst,structures)
        if p is None:raise ValueError(f"Accès piéton impossible : {b['building_id']}")
        walkways.append({'building_id':b['building_id'],'start':'city.central.spawn','arrival':'city.'+b['building_id']+'.return_spawn','path_xyz_studs':p,'width_studs':6})
    place_summaries=[]
    for p in sorted(places,key=lambda x:x['place_key']):
        g=sp_by_key[p['place_key']]
        place_summaries.append({'place_key':p['place_key'],'place_id':p['place_id'],'publication_state':p['publication_state'],
            'room_count':len(g['rooms']),'anchor_count':len(g['anchors']),'furnishing_count':len(g['furnishings']),
            'bounds':g['bounds'],'rooms':sorted(g['rooms'],key=lambda x:x['room_id']),
            'portals':sorted(g['portals'],key=lambda x:x['portal_id']),
            'furnishings':sorted(g['furnishings'],key=lambda x:x['furnishing_id']),
            'anchors':sorted(g['anchors'],key=lambda x:x['anchor_id'])})
    content={'schema_version':'kincity.plan/1.0','compiler':'offline-plan-1','city_id':city['city_id'],
             'seed':city['seed'],'mode':'WORLD_STUB','units':'stud','structures':structures,'places':place_summaries,'pedestrian_paths':walkways,
             'interactions':sorted(load(root,'interactions')['interactions'],key=lambda x:x['interaction_id']),
             'doors':sorted(load(root,'doors')['doors'],key=lambda x:x['door_id']),
             'assets':sorted(load(root,'assets')['assets'],key=lambda x:x['asset_id']),
             'styles':load(root,'style_guide')['styles']}
    canonical=json.dumps(content,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode('utf-8')
    content['canonical_sha256']=hashlib.sha256(canonical).hexdigest()
    return content

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--root',type=Path,default=ROOT);ap.add_argument('--out',type=Path,default=Path('build/world-plan.json'));ns=ap.parse_args()
    try:plan=compile_plan(ns.root)
    except ValueError as exc:print('ÉCHEC :',exc);return 1
    ns.out.parent.mkdir(parents=True,exist_ok=True)
    ns.out.write_text(json.dumps(plan,ensure_ascii=False,sort_keys=True,indent=2)+'\n',encoding='utf-8')
    print('PLAN HORS MOTEUR OK :',plan['canonical_sha256'],'places',len(plan['places']),'chemins',len(plan['pedestrian_paths']),'→',ns.out)
    print('ATTENTION : aucun .rbxl, aucun jeu Roblox publié ou testé.')
    return 0
if __name__=='__main__':sys.exit(main())
