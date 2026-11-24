"""Audit hors ligne sans copier les modèles commerciaux. Python 3.10+."""
import argparse, collections, csv, hashlib, json, pathlib, struct

def audit(models, inventory):
    rows=list(csv.DictReader(inventory.open(encoding='utf-8-sig')))
    expected={r['nom_export_v32_attendu']:r for r in rows}
    files={p.stem:p for p in models.glob('*.glb')}
    if len(expected)!=121 or files.keys()!=expected.keys():
        raise ValueError({'expected':len(expected),'missing':sorted(expected.keys()-files.keys()),'extra':sorted(files.keys()-expected.keys())})
    entries=[]
    for name,p in sorted(files.items()):
        b=p.read_bytes()
        magic,version,size=struct.unpack_from('<III',b)
        assert magic==0x46546C67 and version==2 and size==len(b), name
        length,kind=struct.unpack_from('<II',b,12)
        assert kind==0x4E4F534A and 20+length<=len(b), name
        d=json.loads(b[20:20+length]); accessors=d.get('accessors',[])
        triangles=0; roles=set(); primitives=0; vertices=0; colored=0
        for mesh in d.get('meshes',[]):
            for prim in mesh.get('primitives',[]):
                assert prim.get('mode',4)==4, (name,'non triangle primitive')
                attributes=prim['attributes']; count=accessors[prim['indices']]['count'] if 'indices' in prim else accessors[attributes['POSITION']]['count']
                assert count%3==0, name
                triangles+=count//3; primitives+=1
                vertices+=accessors[attributes['POSITION']]['count']
                colored+=int('COLOR_0' in attributes)
                if 'material' in prim: roles.add(d['materials'][prim['material']]['name'])
        entries.append({'asset_key':expected[name]['nom_modele_original'],'source_name':name,'category':expected[name]['categorie'],'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b),'triangles_mesh_definitions':triangles,'vertex_accessor_count':vertices,'primitives':primitives,'primitives_with_vertex_colors':colored,'used_material_roles':sorted(roles),'usage_candidate':expected[name]['usage_potentiel_a_valider'],'roblox_asset_id':None,'imported_bounds_studs':None,'imported_pivot':None,'placement_status':'pending_HEAD_and_Studio_validation'})
    return {'scope':'Supplied normalized GLB files; no Roblox import or GitHub HEAD verified','count':len(entries),'categories':dict(collections.Counter(x['category'] for x in entries)),'triangles_mesh_definitions':sum(x['triangles_mesh_definitions'] for x in entries),'assets_using_accent':sum('KC32_ACCENT' in x['used_material_roles'] for x in entries),'assets':entries}

if __name__=='__main__':
    parser=argparse.ArgumentParser(); parser.add_argument('models',type=pathlib.Path); parser.add_argument('inventory',type=pathlib.Path); parser.add_argument('output',type=pathlib.Path); args=parser.parse_args()
    result=audit(args.models,args.inventory); args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({k:v for k,v in result.items() if k!='assets'},ensure_ascii=False,indent=2))
