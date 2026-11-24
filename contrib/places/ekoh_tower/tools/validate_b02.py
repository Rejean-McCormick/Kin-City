#!/usr/bin/env python3
"""B02 independent preflight based on original V3 canonical snapshots.
Does NOT certify KC33-B09 compatibility, Roblox Luau execution or art assets.
"""
from __future__ import annotations
import argparse,json,math,re,sys,hashlib
from pathlib import Path
HERE=Path(__file__).resolve().parents[1]

def read(path):return json.loads(Path(path).read_text(encoding='utf8'))

def rect_xy(panel):
    x,y,z=panel['pos'];w,h,d=panel['size'];r=math.radians(panel['yaw_degrees'])
    xrad=abs(math.cos(r))*w/2+abs(math.sin(r))*d/2
    zrad=abs(math.sin(r))*w/2+abs(math.cos(r))*d/2
    return (x-xrad,x+xrad,z-zrad,z+zrad)

def intersects(a,b):return a[0]<b[1] and a[1]>b[0] and a[2]<b[3] and a[3]>b[2]

def validate(scene,fixture,compiled=None):
    errors=[];fail=lambda s:errors.append(s)
    if scene.get('place_key')!='ekoh_tower' or scene.get('schema_version')!='kincity.b02-ekoh-scene/1.0':fail('Place/schéma invalide')
    contract=scene['contract'];known={x['door_id']:x for x in fixture['doors']}
    if len(known)!=2 or set(known)!=set(['city.central.ekoh_tower.entry','ekoh_tower.exit']):fail('Contrat portes modifié')
    if contract['entry_door_id'] not in known or contract['exit_door_id'] not in known:fail('Identifiant porte manquant')
    else:
      entrance,leave=known[contract['entry_door_id']],known[contract['exit_door_id']]
      if entrance['destination_anchor_id']!=contract['entry_anchor_id']:fail('Ancre arrivée modifiée')
      if leave['source_anchor_id']!=contract['exit_anchor_id']:fail('Ancre sortie modifiée')
      if leave['destination_anchor_id']!=contract['return_anchor_id']:fail('Ancre de retour modifiée')
      if entrance['return_door_id']!=leave['door_id'] or leave['return_door_id']!=entrance['door_id']:fail('Portes non réciproques')
    if contract['interaction_mode']!='stub':fail('Fonction EkoH présentée comme réelle')
    if contract['interaction_id']!=fixture['interaction']['interaction_id']:fail('Interaction métier renommée')
    if contract['interaction_anchor_id']!=fixture['interaction']['anchor_id']:fail('Ancre panneau renommée')
    rooms=scene['rooms'];panels=scene['panels'];byid={v['room_id']:v for v in rooms}
    if len(rooms)!=6 or len(byid)!=6:fail('6 salles distinctes requises')
    can={v['room_id']:v for v in fixture['rooms']}
    ext={v['room_id']:v for v in fixture['additional_wings']}
    if set(byid)!=set(can)|set(ext):fail('Salles canoniques/ailes manquantes')
    for k,r in byid.items():
        original=can.get(k,ext.get(k))
        if not original:continue
        if r['center']!=original.get('center_studs',original.get('center')):fail('Position modifiée : '+k)
        if r['size']!=original.get('size_studs',original.get('size')):fail('Emprise modifiée : '+k)
        if r['canonical']!=(k in can):fail('Statut canonique incohérent : '+k)
    if len(panels)!=6 or len(set(p['id'] for p in panels))!=6:fail('6 panneaux distincts requis')
    if set(p['room_id'] for p in panels)!=set(byid):fail('Une décoration par salle requise')
    for pan in panels:
        id,room=pan['id'],pan['room_id']
        if not id.startswith('ekoh_tower.b02.') or room not in byid:fail('ID de décor non local '+id);continue
        if any(any(ord(c)<32 for c in t) for t in (pan['title'],pan['subtitle'],pan['story'])):fail('Texte invalide: '+id)
        if not all(isinstance(x,(int,float)) and math.isfinite(x) for x in pan['pos']+pan['size']):fail('Coordonnée non finie '+id);continue
        w,h,d=pan['size'];y=pan['pos'][1]
        if w<=0 or h<=0 or d<=0 or y-h/2<7.0 or y+h/2>16.0:fail('Panneau sur passage avatar/ceiling : '+id)
        room=byid[room];cx,_,cz=room['center'];sx,_,sz=room['size'];panelrect=rect_xy(pan)
        if panelrect[0]<cx-sx/2+.5 or panelrect[1]>cx+sx/2-.5 or panelrect[2]<cz-sz/2+.5 or panelrect[3]>cz+sz/2-.5:
            fail('Panneau hors salle / trop proche de la bordure : '+id)
        for protected in scene['protected_anchors']+scene['protected_portals']:
            px,pz=protected['pos'];bx,bz=protected['clearance_xz'];area=(px-bx,px+bx,pz-bz,pz+bz)
            if intersects(panelrect,area):fail('Obstruction dans le plan XY/XZ : '+id+' / '+protected['id'])
    profile=scene['profiles']; expected={'LITE':6,'STANDARD':24,'SHOWCASE':42}
    for key,count in expected.items():
        if profile[key]['max_parts_estimated']<count:fail('Budget dépassé: '+key)
        if profile[key]['max_surfaceguis']!=6 or profile[key]['max_panels']!=6:fail('UI budget incorrect: '+key)
    if scene['visual_language']['primary_hex']!='#1E6864':fail('Couleur commune modifiée')
    if len(set(p['id'] for p in scene['panels']))!=6:fail('IDs panneaux dupliqués')
    if compiled is not None:
        # Compare source V3 for already public contract; not KC33 which requires B09 input.
        canon=next(p for p in read(compiled)['places'] if p['place_key']=='ekoh_tower')
        if {r['room_id'] for r in canon['rooms']}!=set(can):fail('Contrat compilé V3 divergent')
    return errors

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--scene',type=Path,default=HERE/'scene.json')
    ap.add_argument('--fixture',type=Path,default=HERE/'fixtures/canonical_v3_snapshot.json')
    ap.add_argument('--original-world-plan',type=Path,default=None)
    a=ap.parse_args()
    errors=validate(read(a.scene),read(a.fixture),a.original_world_plan)
    for x in errors:print('FAIL',x)
    print('B02 PREFLIGHT:', 'PASS' if not errors else 'FAIL', '6 salles, 2 portes, 3 ancres, 6 panneaux, 3 profils')
    if errors:sys.exit(1)
if __name__=='__main__':main()
