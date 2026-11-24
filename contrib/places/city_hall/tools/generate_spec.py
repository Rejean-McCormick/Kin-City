#!/usr/bin/env python3
"""B01 standalone JSON->Luau serializer. Does not edit KC33 files."""
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1]
INPUT=ROOT/'city_hall_scene.json'
OUTPUT=ROOT/'CityHallSpec.luau'

def as_luau(value):
    if value is None:return 'nil'
    if isinstance(value,bool):return 'true' if value else 'false'
    if isinstance(value,(int,float)):return repr(value)
    if isinstance(value,str):return json.dumps(value,ensure_ascii=False)
    if isinstance(value,list):return '{'+','.join(as_luau(v) for v in value)+'}'
    if isinstance(value,dict):
        return '{'+','.join('['+as_luau(k)+']='+as_luau(v) for k,v in value.items())+'}'
    raise TypeError(type(value))

def generate():
    spec=json.loads(INPUT.read_text(encoding='utf8'))
    assert len(spec['rooms'])==6
    output='--!strict\n-- GENERATED from city_hall_scene.json; DO NOT EDIT BY HAND.\nreturn '+as_luau(spec)+'\n'
    OUTPUT.write_text(output,encoding='utf8')
    return output
if __name__=='__main__':generate();print(OUTPUT)
