"""Rebuild and zip KC33 without requiring Roblox Studio or commercial mesh bytes.

Always keep current source in `KinCity_ArtDeco_V3/source/Kin-City`. Runs offline
build validators but deliberately does not label them Roblox execution tests.
"""
import argparse
import json
import subprocess
import sys
import zipfile
from pathlib import Path
from build_imported_test_installer import generate
from art_deco_context_manifest import generate as contexts
from build_release import build
from validate_v28_journey import validate
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT.parents[1]

def package(output):
    assert (BASE/'LIRE_EN_PREMIER.txt').exists(),BASE
    contexts(ROOT)
    errors=validate(ROOT)
    if errors:raise RuntimeError(str(errors))
    build(ROOT)
    generate(BASE/'INSTALLER_KINCITY_KC33_LOCAL.luau',ROOT)
    tests=subprocess.run([sys.executable,str(ROOT/'tools/verify_kc33_upgrade.py')],cwd=ROOT,capture_output=True,text=True)
    if tests.returncode:raise RuntimeError('KC33 static checks failed:\n'+tests.stderr)
    lexical=subprocess.run([sys.executable,str(ROOT/'tools/check_luau_structure_v29.py')],cwd=ROOT,capture_output=True,text=True)
    if lexical.returncode:raise RuntimeError('KC33 delimiter checks failed:\n'+lexical.stdout)
    output=Path(output);output.parent.mkdir(parents=True,exist_ok=True)
    with zipfile.ZipFile(output,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=8) as z:
        for path in sorted(BASE.rglob('*')):
            if not path.is_file():continue
            relative=path.relative_to(BASE)
            if any(bit in ('.git','.pytest_cache','__pycache__') for bit in relative.parts) or path.suffix in ('.pyc','.glb','.gltf','.rbxm','.rbxl'):continue
            arc=Path(BASE.name)/relative
            z.write(path,arc.as_posix())
    return output
if __name__=='__main__':
    arg=argparse.ArgumentParser();arg.add_argument('--out',required=True,type=Path)
    print(package(arg.parse_args().out))
