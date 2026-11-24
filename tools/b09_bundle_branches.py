#!/usr/bin/env python3
"""Bundle reviewed KC34 branch Modules into src/server for Rojo + Studio installers.

This is a deterministic COPY/REWRITE of Luau ModuleScripts, not a runtime build.
No RemoteEvent, PlaceId, or canonical plan is changed here. B08 uses the KC33 rebase.
"""
from pathlib import Path
import hashlib
import re
ROOT=Path(__file__).resolve().parents[1]
SOURCES={
 'B01CityHallScene':('city_hall/CityHallScene.luau',{'CityHallSpec':'B01CityHallSpec'}),
 'B01CityHallSpec':('city_hall/CityHallSpec.luau',{}),
 'B02EkohInterior':('ekoh_tower/B02EkohInterior.luau',{}),
 'B03LibraryScene':('library/LibraryScene.luau',{'LibrarySceneData':'B03LibrarySceneData'}),
 'B03LibrarySceneData':('library/LibrarySceneData.luau',{}),
 'B04CampusDecor':('campus/CampusDecor.luau',{}),
 'B05KorumPreview':('justice_palace/PreviewBuilder.luau',{'SceneData':'B05KorumData'}),
 'B05KorumData':('justice_palace/SceneData.luau',{}),
 'B06KonstructScene':('innovation_lab/KonstructScene.luau',{}),
 'B07MuseumScene':('museum/MuseumScene.luau',{'MuseumSceneData':'B07MuseumData'}),
 'B07MuseumData':('museum/MuseumSceneData.luau',{}),
 'B08OrgoScene':('orgo_center/OrgoScene.luau',{'OrgoSceneData':'B08OrgoData'}),
 'B08OrgoData':('orgo_center/OrgoSceneData.luau',{}),
 'B10Wayfinding':('city/Wayfinding.luau',{}),
}

def generate(root=ROOT):
    files=[]
    for name,(rel,requires) in SOURCES.items():
        src=root/'contrib/places'/rel
        if not src.is_file():raise ValueError('Fichier de branche absent: '+str(src))
        code=src.read_text(encoding='utf8')
        for original,new in requires.items():
            # Both script.Parent.foo and script.Parent:WaitForChild("foo") variants.
            code,n1=re.subn(r'(script\.Parent\s*\.\s*)'+re.escape(original)+r'\b',lambda m:m[1]+new,code)
            code,n2=re.subn(r'(script\.Parent:WaitForChild\(["\'])'+re.escape(original)+r'(["\']\))',
                             lambda m:m[1]+new+m[2],code)
            if n1+n2==0:raise ValueError('Dépendance Lua non reconnue : '+name+' -> '+original)
        digest=hashlib.sha256(src.read_bytes()).hexdigest()
        marker='-- KC35 B09 GENERATED from contrib/places/'+rel+' sha256='+digest+'\n'
        if code.startswith('--!strict\n'):code='--!strict\n'+marker+code[len('--!strict\n'):]
        else:code=marker+code
        dst=root/'src/server'/(name+'.luau')
        dst.parent.mkdir(parents=True,exist_ok=True)
        dst.write_text(code,encoding='utf8')
        files.append(str(dst.relative_to(root)))
    return files
if __name__=='__main__':print('\n'.join(generate()))
