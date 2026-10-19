#!/usr/bin/env python3
"""Validation spatiale + résolution stricte assets Kin City (barrière A).
N'exécute PAS Roblox. python tools/validate_spatial.py [--root PATH].
"""
from __future__ import annotations
import argparse, json, math, sys
from pathlib import Path

COLLISION_EXTRA=8.0

def load(root, name):
    return json.loads((root/'catalog'/f'{name}.json').read_text(encoding='utf-8'))

def finite3(pos):
    return isinstance(pos,list) and len(pos)==3 and all(isinstance(v,(int,float)) and math.isfinite(v) for v in pos)

def in_room(point,room,eps=1.5):
    x,y,z=point; cx,cy,cz=room['center_studs']; sx,sy,sz=room['size_studs']
    return abs(x-cx)<=sx/2+eps and abs(z-cz)<=sz/2+eps and -eps<=y<=sy+eps

def validate(root:Path):
    errors=[]
    try:
        spatial=load(root,'spatial'); assets=load(root,'assets'); styles=load(root,'style_guide')
        buildings=load(root,'buildings')['buildings']; places=load(root,'places')['places']
        doors=load(root,'doors')['doors']; interactions=load(root,'interactions')['interactions']
    except (OSError,ValueError,KeyError) as exc:return [f'Chargement catalogue : {exc}']
    # JSON Schema check: dependency required for industrial-grade static qualification.
    try:
        from jsonschema import Draft202012Validator
    except ImportError:
        errors.append('jsonschema requis : pip install -r requirements-dev.txt')
    else:
        for name,doc in [('spatial',spatial),('assets',assets),('style_guide',styles)]:
            schema=json.loads((root/'schemas'/f'{name}.schema.json').read_text(encoding='utf-8'))
            try: Draft202012Validator.check_schema(schema)
            except Exception as exc:errors.append(f'Invalid schema {name}: {exc}');continue
            for e in Draft202012Validator(schema).iter_errors(doc):
                errors.append(f'{name}: {list(e.absolute_path)}: {e.message}')
    if spatial.get('schema_version')!='kincity.spatial/1.0':errors.append('Version spatiale incompatible')
    assets_by_id={a['asset_id']:a for a in assets.get('assets',[])}
    styles_by_id=styles.get('styles',{})
    building_by_id={b['building_id']:b for b in buildings}
    place_by_key={p['place_key']:p for p in places}
    sp_by_key={p['place_key']:p for p in spatial.get('places',[])}
    structures={b['building_id']:b for b in spatial.get('structures',[])}
    if len(assets_by_id)!=len(assets.get('assets',[])):errors.append('Asset ID dupliqué')
    if len(sp_by_key)!=len(spatial.get('places',[])):errors.append('Définition de Place dupliquée')
    if len(structures)!=len(spatial.get('structures',[])):errors.append('Définition bâtiment dupliquée')
    if set(sp_by_key)!=set(place_by_key): errors.append(f'Place spatiale vs catalogue: {set(sp_by_key)^set(place_by_key)}')
    if set(structures)!=set(building_by_id):errors.append(f'Implantations vs bâtiments: {set(structures)^set(building_by_id)}')
    for a in assets.get('assets',[]):
        if not a.get('license') or not a.get('revision') or not a.get('generator'):
            errors.append(f"Asset sans provenance suffisante : {a.get('asset_id')}")
        for dep in a.get('dependencies',[]):
            if dep not in assets_by_id:errors.append(f'Asset manquant dépendance: {dep}')
    for bid,building in building_by_id.items():
        st=structures.get(bid)
        if not st:continue
        if st.get('facade_asset_id')!=building['exterior_template']:errors.append(f'{bid}: asset facade ne correspond pas au template')
        for key in ['exterior_template','interior_template']:
            if building[key] not in assets_by_id:errors.append(f'{bid}: asset template introuvable {building[key]}')
        if st.get('style_id') not in styles_by_id:errors.append(f'{bid}: style introuvable {st.get("style_id")}')
        if st.get('entrance_clearance_studs',0)<6:errors.append(f'{bid}: entrée insuffisamment dégagée')
        if not finite3(st.get('center_studs')):errors.append(f'{bid}: centre XYZ invalide')
    # conservative collision of rotated rectangles by circumscribed circles (false positives possible).
    city=sp_by_key.get('city',{})
    radius=city.get('bounds',{}).get('radius_studs',0)
    scene=list(structures.values())
    for i,a in enumerate(scene):
        ax,ay,az=a['center_studs']; aw,ad=a['footprint_studs']
        ra=math.hypot(aw/2,ad/2)
        if math.hypot(ax,az)+ra>radius:errors.append(f"{a['building_id']}: hors limites ville")
        for b in scene[i+1:]:
            bx,_,bz=b['center_studs'];bw,bd=b['footprint_studs'];rb=math.hypot(bw/2,bd/2)
            if math.hypot(ax-bx,az-bz)<ra+rb+COLLISION_EXTRA:
                errors.append(f"{a['building_id']} / {b['building_id']}: collision/enveloppes trop proches")
    for key,place in place_by_key.items():
        sp=sp_by_key.get(key)
        if not sp:continue
        anchors=sp.get('anchors',[]);amap={v['anchor_id']:v for v in anchors}
        if len(amap)!=len(anchors):errors.append(f'{key}: ancre spatiale dupliquée')
        if set(amap)!=set(place['anchors']):errors.append(f'{key}: ancre(s) absente(s)/non déclarée(s): {set(amap)^set(place["anchors"])}')
        rooms={r['room_id']:r for r in sp.get('rooms',[])}
        for aid,anc in amap.items():
            pos=anc.get('position_studs');
            if not finite3(pos):errors.append(f'{key}/{aid}: XYZ invalide');continue
            if key=='city':
                if math.hypot(pos[0],pos[2])>radius:errors.append(f'{key}/{aid}: ancre hors ville')
            else:
                bounds=sp['bounds']['size_studs']
                if abs(pos[0])>bounds[0]/2 or abs(pos[2])>bounds[1]/2:errors.append(f'{key}/{aid}: ancre hors limites')
                if anc.get('room_id'):
                    room=rooms.get(anc['room_id'])
                    if room is None or not in_room(pos,room,2):errors.append(f'{key}/{aid}: ancre hors pièce {anc.get("room_id")}')
        for r in rooms.values():
            cx,cy,cz=r['center_studs']; sx,sy,sz=r['size_studs']; bounds=sp['bounds']['size_studs']
            if abs(cx)+sx/2>bounds[0]/2 or abs(cz)+sz/2>bounds[1]/2:
                errors.append(f'{key}/{r["room_id"]}: pièce sort de la Place')
        portals=sp.get('portals',[])
        graph={k:set() for k in rooms}
        for portal in portals:
            src=portal['from_room'];dst=portal['to_room']
            if src not in rooms or dst not in rooms:
                errors.append(f'{key}: portal {portal["portal_id"]} vers pièce inconnue')
                continue
            if portal.get('clear_width_studs',0)<7:
                errors.append(f'{key}: portal {portal["portal_id"]} trop étroit')
            graph[src].add(dst);graph[dst].add(src)
        if key!='city' and rooms:
            start=key+'.lobby';seen={start};agenda=[start]
            while agenda:
                for nxt in graph.get(agenda.pop(),[]):
                    if nxt not in seen:seen.add(nxt);agenda.append(nxt)
            if seen!=set(rooms):errors.append(f'{key}: plan de pièces non connecté')
        f_ids=set()
        for furnishing in sp.get('furnishings',[]):
            fid=furnishing['furnishing_id']
            if fid in f_ids:errors.append(f'{key}: furnishing_id dupliqué {fid}')
            f_ids.add(fid)
            if furnishing['asset_id'] not in assets_by_id:errors.append(f'{key}/{fid}: asset introuvable {furnishing["asset_id"]}')
            r=rooms.get(furnishing['room_id'])
            if r is None or not in_room(furnishing['position_studs'],r,2):errors.append(f'{key}/{fid}: prop hors pièce')
            anc=furnishing.get('anchor_id')
            if anc is not None and (anc not in amap or amap[anc]['role']!='interaction'):
                errors.append(f"{key}/{fid}: ancre d'interaction absente ou mauvais rôle {anc}")
    for door in doors:
        p=sp_by_key.get(door['source_place_key'],{})
        anc=next((a for a in p.get('anchors',[]) if a['anchor_id']==door['source_anchor_id']),None)
        if anc is None or anc['role']!='door':errors.append(f"{door['door_id']}: source non ancrée comme porte")
        p=sp_by_key.get(door['destination_place_key'],{})
        anc=next((a for a in p.get('anchors',[]) if a['anchor_id']==door['destination_anchor_id']),None)
        if anc is None or anc['role']!='spawn':errors.append(f"{door['door_id']}: destination non ancrée comme spawn")
    for inter in interactions:
        p=sp_by_key.get(inter['place_key'],{})
        anc=next((a for a in p.get('anchors',[]) if a['anchor_id']==inter['anchor_id']),None)
        if anc is None or anc['role']!='interaction':errors.append(f"{inter['interaction_id']}: pas d'ancre physique interaction")
        if not any(f.get('anchor_id')==inter['anchor_id'] for f in p.get('furnishings',[])):
            errors.append(f"{inter['interaction_id']}: aucun objet meuble avec ancre correspondante")
    return sorted(set(errors))

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--root',type=Path,default=Path(__file__).resolve().parents[1]);ns=ap.parse_args()
    errors=validate(ns.root)
    print(f'VALIDATION SPATIALE : {"ÉCHEC" if errors else "OK"} — {len(errors)} erreur(s)')
    for e in errors:print('[ERREUR]',e)
    return 1 if errors else 0
if __name__=='__main__':sys.exit(main())
