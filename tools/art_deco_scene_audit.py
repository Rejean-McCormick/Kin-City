"""Execute the actual pure planners and audit each streamed zone's source costs.

These are source triangle/clone reservations, not GPU measurements or FPS claims.
No licensed model bytes are needed; the manifest supplies geometry metadata.
"""
import json
from pathlib import Path
from lupa import LuaRuntime
from art_deco_catalog import load_art_deco
from compile_plan import compile_plan
ROOT=Path(__file__).resolve().parents[1]

def audit(root=ROOT):
    data=load_art_deco(root);world=compile_plan(root)
    lua=LuaRuntime(unpack_returned_tuples=True)
    lua.execute('table.clone=function(t) local r={} for k,v in pairs(t) do r[k]=v end return r end')
    layout=lua.execute((root/'src/server/ArtDecoLayout.luau').read_text())
    surfaces=lua.execute((root/'src/server/ArtDecoSurfacePlan.luau').read_text())
    wings=lua.execute((root/'src/server/InteriorWings.luau').read_text())
    rooms=lua.execute((root/'src/server/ArtDecoRooms.luau').read_text())
    records={r['asset_key']:r for r in data['manifest']['assets']}
    table=lambda obj:lua.table_from(obj,recursive=True)
    def cost(keys):
        return {'triangles':sum(records[k]['triangles_mesh_definitions'] for k in keys),
                'parts':sum(records[k]['primitives']+2 for k in keys),'clones':len(keys)}
    profiles={}
    for name,profile in data['config']['profiles'].items():
        result={'city':{'institution_shells':{},'pavilions':cost([data['placements']['pavilion']['asset']]*18)},'interiors':{}}
        for structure in world['structures']:
            recipe=data['placements']['buildings'][structure['building_id']]
            plan=layout.compile(*structure['footprint_studs'],structure['height_studs'],table(recipe))
            keys=[slot.asset for slot in plan.primary_shells.values()]+[plan.primary_feature.asset]
            keys += [s.asset for s in plan.slots.values() if s.name.startswith('EntranceColumn')]
            measured=cost(keys)
            for dimension,value in measured.items():
                assert value<=profile['pools']['building'][dimension],(name,structure['building_id'],dimension,value)
            result['city']['institution_shells'][structure['building_id']]=measured
        for canonical in world['places']:
            if canonical['place_key']=='city':continue
            place=wings.expand(table(canonical));key=canonical['place_key']
            program=table(data['placements']['interior_programs'][key]);assets=table(data['placements']['surfaces'])
            keys=[];room_counts={}
            for index,room in place.rooms.items():
                slots=surfaces.room(room,place,program,index,assets,table(profile))
                source_keys=[s.asset for s in slots.values()];keys+=source_keys
                room_counts[room.room_id]=len(source_keys)
            keys += [s.asset for s in surfaces.portals(place,assets).values()]
            keys += [s.asset for s in surfaces.upper(assets).values()]
            stair_asset=data['placements']['stair_skins']['kreative' if key=='museum' else 'default']
            keys += [stair_asset]*2
            measured=cost(keys)
            for dimension,value in measured.items():
                assert value<=profile['pools']['architecture'][dimension],(name,key,dimension,value,profile['pools']['architecture'][dimension])
            furniture=[]
            fm=data['placements']['room_furniture']
            for index,room in place.rooms.items():
                slots=rooms.compile(room,place,program,index)
                for i,slot in slots.items():
                    if i>profile['room_stations']:break
                    if slot.role=='work':furniture += [fm['desk'],fm['seat']]
                    elif slot.role=='lounge':furniture += [fm['seat'],fm['seat'],fm['coffee']]
                    else:furniture += [program.feature]
                if index==1:furniture += [data['placements']['lobby_canopy']['asset'],fm['chandelier']]
            for item in place.furnishings.values():
                recipe=data['placements']['furnishings'].get(item.asset_id)
                if recipe:furniture.append(recipe['asset'])
            furniture.append(data['placements']['lobby_accent']['asset'])
            furnishing_cost=cost(furniture)
            for dimension,value in furnishing_cost.items():
                assert value<=profile['pools']['interior'][dimension],(name,key,'furniture',dimension,value)
            result['interiors'][key]={'architecture':measured,'furniture':furnishing_cost,'rooms':room_counts}
        vegetation=cost([data['placements']['environment']['palm']['asset']]*profile['pools']['environment']['clones'])
        for dimension,value in vegetation.items():
            assert value<=profile['pools']['environment'][dimension],(name,'vegetation',dimension,value)
        profiles[name]=result
    return {'scope':'Planned source geometry only; no Studio execution, FPS, memory or total legacy geometry measurement.', 'profiles':profiles}

if __name__=='__main__':
    import argparse
    parser=argparse.ArgumentParser();parser.add_argument('--output',type=Path)
    args=parser.parse_args();result=audit()
    if args.output:args.output.write_text(json.dumps(result,indent=2)+'\n')
    for name,profile in result['profiles'].items():
        city=sum(r['triangles'] for r in profile['city']['institution_shells'].values())+profile['city']['pavilions']['triangles']
        print(name,'city imported building/pavilion triangles:',city,
            'interior architecture range:', min(r['architecture']['triangles'] for r in profile['interiors'].values()),
            max(r['architecture']['triangles'] for r in profile['interiors'].values()))
