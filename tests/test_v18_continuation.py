"""Tests ciblés sur la construction v18. Ne simulent PAS le moteur Roblox."""
import json
import shutil
import tempfile
import unittest
from pathlib import Path
import sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from compile_plan import compile_plan
from export_roblox import build_fingerprint

class TestV18Build(unittest.TestCase):
    def test_build_fingerprint_covers_crystal_visual_mode_and_code(self):
        plan=compile_plan(ROOT)
        old=build_fingerprint(ROOT,plan['canonical_sha256'])['sha256']
        with tempfile.TemporaryDirectory() as temp:
            base=Path(temp)
            for folder in ('catalog','config','src/server','src/client'):
                shutil.copytree(ROOT/folder,base/folder)
            self.assertEqual(old,build_fingerprint(base,plan['canonical_sha256'])['sha256'])
            for path,change in (
                ('catalog/crystal_theme.json',lambda s:s.replace('C5F4F0','D5F4F0')),
                ('config/visual.json',lambda s:s.replace('12','13',1)),
                ('config/runtime.json',lambda s:s.replace('LOCAL_UNIVERSE','MULTI_PLACE')),
                ('src/server/CrystalKit.luau',lambda s:s+'\n-- changed\n'),
            ):
                file=base/path
                before=file.read_text(encoding='utf8')
                after=change(before)
                self.assertNotEqual(before,after,path)
                file.write_text(after,encoding='utf8')
                self.assertNotEqual(old,build_fingerprint(base,plan['canonical_sha256'])['sha256'],path)
                file.write_text(before,encoding='utf8')
                self.assertEqual(old,build_fingerprint(base,plan['canonical_sha256'])['sha256'])

    def test_full_plan_json_matches_compiler(self):
        current=json.loads((ROOT/'build/world-plan.json').read_text(encoding='utf8'))
        self.assertEqual(current,compile_plan(ROOT))
        module=(ROOT/'src/shared/BuildIdentity.luau').read_text(encoding='utf8')
        self.assertIn(build_fingerprint(ROOT,current['canonical_sha256'])['sha256'],module)

    def test_interior_origins_are_explicit_and_spaced(self):
        origins=json.loads((ROOT/'config/interior_origins.json').read_text(encoding='utf8'))
        plan=compile_plan(ROOT)
        self.assertEqual(set(origins),{p['place_key'] for p in plan['places']}-{'city'})
        for i,(key,a) in enumerate(origins.items()):
            self.assertEqual(len(a),3)
            self.assertGreaterEqual((a[0]**2+a[2]**2)**0.5,800)
            for other,b in list(origins.items())[i+1:]:
                self.assertGreater((a[0]-b[0])**2+(a[2]-b[2])**2,600**2,(key,other))
        self.assertIn('InteriorOrigins[key]',(ROOT/'src/server/Spatial.luau').read_text(encoding='utf8'))

    def test_interactions_and_ready_flag_are_shared_by_full_and_partial_build(self):
        builder=(ROOT/'src/server/WorldBuilder.luau').read_text(encoding='utf8')
        editor=(ROOT/'src/server/WorldEditor.luau').read_text(encoding='utf8')
        binder=(ROOT/'src/server/CanonicalInteractions.luau').read_text(encoding='utf8')
        self.assertIn('KinBuildState","Ready"',builder)
        self.assertIn('KinBuildState","Building"',builder)
        self.assertIn('KinBuildState")~="Ready"',builder)
        self.assertIn('CanonicalInteractions.bindPlace(',builder)
        self.assertIn('CanonicalInteractions.bindPlace(',editor)
        self.assertIn('KinInteractionId',binder)

    def test_player_travel_session_integrates_all_transports(self):
        session=(ROOT/'src/server/TravelSession.luau').read_text(encoding='utf8')
        self.assertIn('player.Character==char',session)
        self.assertIn('current[player] then return nil',session)
        for name in ['PlayerTravel','IntermodalTransfers','Tramways','IslandFerries','BoulevardBuses']:
            source=(ROOT/f'src/server/{name}.luau').read_text(encoding='utf8')
            self.assertIn('TravelSession.begin(',source,name)
            self.assertIn('TravelSession.finish(',source,name)

if __name__=='__main__': unittest.main()
