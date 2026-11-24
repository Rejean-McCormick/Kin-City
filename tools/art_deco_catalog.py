"""Validate Art Deco integration metadata without distributing licensed meshes."""
import json, math
from pathlib import Path

def load_art_deco(root: Path):
    manifest=json.loads((root/'catalog/art_deco_assets.json').read_text(encoding='utf-8'))
    placements=json.loads((root/'catalog/art_deco_placements.json').read_text(encoding='utf-8'))
    config=json.loads((root/'config/art_deco.json').read_text(encoding='utf-8'))
    records=manifest['assets']; keys={a['asset_key'] for a in records}
    if len(records)!=121 or len(keys)!=121: raise ValueError('Art Deco: expected 121 unique assets')
    if len({a['source_name'] for a in records})!=121: raise ValueError('Art Deco: duplicate source names')
    for a in records:
        if a['source_name']!='KC32__'+a['asset_key']: raise ValueError('Art Deco: unstable source key')
        if len(a['sha256'])!=64 or any(c not in '0123456789abcdef' for c in a['sha256']): raise ValueError('Art Deco: invalid hash')
        if len(a['source_bounds'])!=3 or any(type(v) not in (int,float) or not math.isfinite(v) or v<0 for v in a['source_bounds']) or not any(a['source_bounds']): raise ValueError('Art Deco: invalid source bounds')
        if type(a['triangles_mesh_definitions']) is not int or a['triangles_mesh_definitions']<=0: raise ValueError('Art Deco: invalid triangle count')
    buildings=json.loads((root/'catalog/buildings.json').read_text())['buildings']
    expected={b['building_id']:b['interior_place_key'] for b in buildings}
    if placements['buildings'].keys()!=expected.keys(): raise ValueError('Art Deco: building coverage mismatch')
    shapes={'civic','observatory','court','atelier','library','campus','gallery','services'}
    if set(placements['interior_programs'])!=set(expected.values()): raise ValueError('Art Deco: missing interior programs')
    for key,recipe in placements['buildings'].items():
        if recipe['place_key']!=expected[key] or recipe['shape'] not in shapes: raise ValueError('Art Deco: invalid building recipe')
        if not .15<=recipe['body_height_ratio']<=.8: raise ValueError('Art Deco: invalid body height')
        if recipe['entry_width']<8 or recipe['entry_height']<8: raise ValueError('Art Deco: invalid public entrance')
        if any(recipe[field] not in keys for field in ['feature_asset','columns_asset','window_asset','shell_asset']): raise ValueError('Art Deco: unknown module')
        if len(recipe['shell_source_size'])!=3 or any(v<=0 for v in recipe['shell_source_size']): raise ValueError('Art Deco: invalid shell dimensions')
    for program in placements['interior_programs'].values():
        if program['role'] not in shapes or program['feature'] not in keys: raise ValueError('Art Deco: invalid room program')
    for recipe in list(placements['street'].values())+list(placements['furnishings'].values())+list(placements['environment'].values())+[placements['lobby_canopy']]:
        if recipe['asset'] not in keys: raise ValueError('Art Deco: unknown prop')
        if len(recipe['envelope'])!=3 or any(type(v) not in (float,int) or not math.isfinite(v) or v<=0 for v in recipe['envelope']): raise ValueError('Art Deco: invalid envelope')
    if any(key not in keys for key in list(placements['surfaces'].values())+list(placements['room_furniture'].values())): raise ValueError('Art Deco: unknown architectural source')
    if placements['pavilion']['asset'] not in keys: raise ValueError('Art Deco: unknown pavilion source')
    if not placements['pavilion'].get('variants') or any(k not in keys for k in placements['pavilion']['variants']):
        raise ValueError('Art Deco: unknown pavilion variant')
    if set(placements['stair_skins'])!={'default','kreative'} or any(k not in keys for k in placements['stair_skins'].values()):
        raise ValueError('Art Deco: unknown stair skin')
    if placements['lobby_accent']['asset'] not in keys or any(v<=0 for v in placements['lobby_accent']['envelope']):
        raise ValueError('Art Deco: unknown lobby accent')
    if config['production_place_id']!=72097868581669: raise ValueError('Art Deco: production exclusion cannot be changed here')
    test=config['test_place_id']
    if test is not None and (type(test) is not int or test<=0 or test==config['production_place_id']): raise ValueError('Art Deco: invalid test PlaceId')
    if type(config['enabled']) is not bool or type(config['allow_local_test']) is not bool: raise ValueError('Art Deco: invalid flags')
    owner_counts={'building':8,'pavilion':6,'architecture':8,'street':6,'paving':6,'interior':8,'environment':6}
    for profile in ('LITE','STANDARD','SHOWCASE'):
        for key in ('triangles','parts','clones'):
            n=config['profiles'][profile][key]
            if type(n) is not int or n<=0: raise ValueError('Art Deco: invalid budget')
            total=0
            for pool,count in owner_counts.items():
                per_owner=config['profiles'][profile]['pools'][pool][key]
                if type(per_owner) is not int or per_owner<=0: raise ValueError('Art Deco: invalid pool budget')
                total+=count*per_owner
            if total>n: raise ValueError('Art Deco: reservations exceed global budget')
        for field in ['wall_pitch','floor_tiles','room_stations','near_lights']:
            if type(config['profiles'][profile][field]) is not int or config['profiles'][profile][field]<=0: raise ValueError('Art Deco: invalid surface or LOD setting')
        for field in ['lamp_steps','bench_steps','road_steps']:
            steps=config['profiles'][profile][field]
            if len(set(steps))!=len(steps) or any(type(step) is not int or step<1 or step>(19 if field=='road_steps' else 8) for step in steps): raise ValueError('Art Deco: invalid street cadence')
    return {'manifest':manifest,'placements':placements,'config':config}

if __name__=='__main__':
    data=load_art_deco(Path(__file__).resolve().parents[1])
    print('Art Deco OK:',len(data['manifest']['assets']),'assets; 8 contextual building recipes')
