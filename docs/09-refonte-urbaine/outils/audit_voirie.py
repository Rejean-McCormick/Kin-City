#!/usr/bin/env python3
"""Audit documentaire KC35/KC36 : intersections emprises bâtiments / six axes.
Usage: python audit_voirie.py CHEMIN_VERS_build/world-plan.json --json RESULTAT.json
Dépendance explicite: pip install shapely
Ne modifie jamais les fichiers Roblox, les Plans ou le Package central.
"""
import argparse, json, math
from pathlib import Path
from shapely.geometry import Polygon, LineString

AXES=(
 ('keenKonnect',0,-1),('ethiKos',math.sqrt(3)/2,-.5),
 ('Kreative',math.sqrt(3)/2,.5),('UCKK',0,1),
 ('Ekole',-math.sqrt(3)/2,.5),('KonnectED',-math.sqrt(3)/2,-.5)
)

def polygon(b):
    x,z=b['center_studs'][0],b['center_studs'][2]
    w,d=b['footprint_studs']
    a=math.radians(b['yaw_degrees'])
    return Polygon([(x+math.cos(a)*lx+math.sin(a)*lz,
                     z-math.sin(a)*lx+math.cos(a)*lz)
                    for lx,lz in ((-w/2,-d/2),(w/2,-d/2),(w/2,d/2),(-w/2,d/2))])

def audit(plan):
    result=[]
    for b in plan['structures']:
        envelope=polygon(b)
        for name,x,z in AXES:
            road=LineString(((x*62,z*62),(x*442,z*442))).buffer(9.5,cap_style='flat')
            area=envelope.intersection(road).area
            if area>1e-4:
                result.append({'building_id':b['building_id'],
                               'avenue':name,
                               'intersection_area_studs2':round(area,1)})
    return sorted(result,key=lambda c:-c['intersection_area_studs2'])

def main():
    cli=argparse.ArgumentParser(description=__doc__)
    cli.add_argument('world_plan',type=Path)
    cli.add_argument('--json',type=Path,dest='output')
    args=cli.parse_args()
    plan=json.loads(args.world_plan.read_text(encoding='utf-8'))
    if len(plan['structures'])!=8:
        raise SystemExit('Cette règle d’audit est prévue pour les 8 édifices KC35 ; vérifier le contrat avant généralisation.')
    clashes=audit(plan)
    report={'source':str(args.world_plan),'canonical_sha256':plan.get('canonical_sha256'),
            'assumptions':'rectangular oriented envelope, 19-stud radial avenue, r=62..442; NO Studio verification',
            'clash_count':len(clashes),'clashes':clashes}
    print(json.dumps(report,ensure_ascii=False,indent=2))
    if args.output:args.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    return 1 if clashes else 0

if __name__=='__main__':raise SystemExit(main())
