#!/usr/bin/env python3
"""Generate Luau scene data and guarded local Studio Command Bar preview (B03 only).

No Roblox APIs, assets or production IDs are downloaded or published.
"""
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parent

def luau(v):
    if v is None:return 'nil'
    if v is True:return 'true'
    if v is False:return 'false'
    if isinstance(v,str):return json.dumps(v,ensure_ascii=False)
    if isinstance(v,(int,float)):return str(v)
    if isinstance(v,list):return '{'+','.join(luau(x) for x in v)+'}'
    if isinstance(v,dict):return '{'+','.join('['+luau(k)+']='+luau(x) for k,x in v.items())+'}'
    raise TypeError(type(v))

def generate(root=ROOT):
    scene=json.loads((root/'scene_plan.json').read_text(encoding='utf8'))
    data='--!strict\n-- Generated from scene_plan.json. Do not edit by hand.\nreturn '+luau(scene)+'\n'
    (root/'LibrarySceneData.luau').write_text(data,encoding='utf8')
    source=(root/'LibraryScene.luau').read_text(encoding='utf8')
    reference='local Data=require(script.Parent:WaitForChild("LibrarySceneData"))'
    if source.count(reference)!=1:raise ValueError('Unexpected library script layout')
    source=source.replace(reference,'local Data=__B03_SCENE_DATA')
    guard='''-- B03 KC34 LOCAL PREVIEW ONLY. Paste in Studio Command Bar; no publication.
-- Only adds wall overlays inside KinCityGenerated/Intérieur — library.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"B03: Studio EDITION only")
assert(game.PlaceId==0,"B03: local unpublished Place required")
local generated=assert(workspace:FindFirstChild("KinCityGenerated"),"B03: generated KC world missing")
local interiors=assert(generated:FindFirstChild("Bâtiments visitables"),"B03: interior container missing")
local interior=assert(interiors:FindFirstChild("Intérieur — library"),"B03: library interior missing")
assert(interior:IsA("Model") and interior:GetAttribute("KinPlaceKey")=="library","B03: wrong target")
local origin=interior:GetAttribute("KinInteriorOrigin")
assert(typeof(origin)=="Vector3","B03: missing library origin")
'''
    script=guard+'\nlocal __B03_SCENE_DATA=(function()\n'+data+'\nend)()\n'
    script+='local __B03=(function()\n'+source+'\nend)()\n'
    script+='local result=__B03.build({place_key="library",interiorModel=interior,origin=origin,profile="STANDARD",authorized=true})\n'
    script+='print("B03 LOCAL PREVIEW: "..result.status..", "..tostring(result.created_decorations).." éléments / "..tostring(result.created_parts).." pièces")\n'
    (root/'STUDIO_APERCU_LOCAL_B03.luau').write_text(script,encoding='utf8')
    return (root/'LibrarySceneData.luau'),(root/'STUDIO_APERCU_LOCAL_B03.luau')
if __name__=='__main__':
    print(*generate(),sep='\n')
