#!/usr/bin/env python3
"""Produce KC35 enhanced staging installers without editing frozen KC33 tooling.

Actual staging Place IDs must be provided by an authorized Roblox operator.
Does not create Roblox Places, upload assets, or test TeleportService.
"""
from pathlib import Path
import argparse
from build_staging_places import ROOT,make,read_ids
from b09_bundle_branches import generate as bundle
from build_release import build

NEEDLE='''  return require(server:WaitForChild("WorldBuilder")).build()
end,debug.traceback)'''
REPLACE='''  local worldState=require(server:WaitForChild("WorldBuilder")).build()
  local results=require(server:WaitForChild("BranchRuntime")).apply(worldState)
  assert(results.ready,"KC35: certaines contributions sont incompletes : "..table.concat(results.failed," | "))
  return worldState
end,debug.traceback)'''

def generate(root,ids,out):
    keys=read_ids(ids,root)
    bundle(root)
    build(root)
    created=make(root,ids,out)
    for filename in created:
        file=Path(out)/filename
        s=file.read_text(encoding='utf8')
        if s.count(NEEDLE)!=1:raise ValueError('Installer staging non patchable : '+filename)
        s=s.replace(NEEDLE,REPLACE)
        # In city Studio Edition, cinema.ensure() is still used in B09 code;
        # apply locking AFTER cinema creation, only for city.
        if filename=='INSTALLER_STAGING_CITY.luau':
            needle='require(server:WaitForChild("OutdoorCinema")).ensure()'
            if needle not in s:raise ValueError('Cinéma de staging introuvable')
            s=s.replace(needle,needle+'\nrequire(server:WaitForChild("MuseumBroadcastBarrier")).start()')
        file.write_text(s,encoding='utf8')
    return created

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--ids',type=Path,required=True)
    p.add_argument('--out',type=Path,required=True)
    a=p.parse_args()
    print('\n'.join(generate(ROOT,a.ids,a.out)))
