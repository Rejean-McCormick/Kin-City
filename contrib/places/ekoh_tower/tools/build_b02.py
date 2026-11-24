#!/usr/bin/env python3
"""Generate the idempotent B02 Luau decorator from one canonical scene.json.
No Roblox write operations, no network, no publication, no KC33 mutation.
"""
import json
import sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
SCENE=ROOT/'scene.json'
TEMPLATE=ROOT/'B02EkohInterior.template.luau'
OUTPUT=ROOT/'B02EkohInterior.luau'

def literal(value):
    if value is None:return 'nil'
    if value is True:return 'true'
    if value is False:return 'false'
    if isinstance(value,str):return json.dumps(value,ensure_ascii=False)
    if isinstance(value,(float,int)):
        if not (float('-inf') < value < float('inf')):raise ValueError('Non finite number')
        return str(value)
    if isinstance(value,list):return '{'+','.join(literal(x) for x in value)+'}'
    if isinstance(value,dict):
        # Escaped bracket keys prevent Luau keywords from breaking source.
        return '{'+','.join('['+literal(k)+']='+literal(v) for k,v in sorted(value.items()))+'}'
    raise TypeError(type(value))

def build():
    source=json.loads(SCENE.read_text(encoding='utf8'))
    if source.get('place_key')!='ekoh_tower':raise ValueError('Wrong place')
    template=TEMPLATE.read_text(encoding='utf8')
    if template.count('--__B02_SCENE_SPEC__')!=1:raise ValueError('Unsafe marker count')
    output=template.replace('--__B02_SCENE_SPEC__','local SPEC='+literal(source))
    OUTPUT.write_text(output,encoding='utf8')
    return OUTPUT
if __name__=='__main__':print(build())
