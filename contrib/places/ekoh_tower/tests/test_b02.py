"""B02 isolated positive/negative contract tests, independent of Roblox Studio."""
from __future__ import annotations
import copy
import hashlib
import json
import sys
import tempfile
import unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from validate_b02 import read,validate
from build_b02 import build, OUTPUT

class B02(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.scene=read(ROOT/'scene.json')
        cls.fixture=read(ROOT/'fixtures/canonical_v3_snapshot.json')
    def errors(self,edit):
        scene=copy.deepcopy(self.scene)
        edit(scene)
        return validate(scene,self.fixture)
    def test_01_six_rooms_and_two_doors(self):
        self.assertEqual(validate(self.scene,self.fixture),[])
        self.assertEqual(len(self.scene['rooms']),6)
        self.assertEqual(len(self.fixture['doors']),2)
    def test_02_generated_module_reproducible(self):
        before=hashlib.sha256(OUTPUT.read_bytes()).hexdigest()
        build()
        after=hashlib.sha256(OUTPUT.read_bytes()).hexdigest()
        self.assertEqual(before,after)
    def test_03_unique_panels_by_room(self):
        self.assertEqual({r['room_id'] for r in self.scene['rooms']},{p['room_id'] for p in self.scene['panels']})
    def test_04_door_mutation_rejected(self):
        self.assertTrue(any('Ancre' in e for e in self.errors(lambda d:d['contract'].update(entry_anchor_id='WRONG'))))
    def test_05_return_door_mutation_rejected(self):
        self.assertTrue(any('Identifiant porte' in e for e in self.errors(lambda d:d['contract'].update(exit_door_id='fake'))))
    def test_06_pretend_real_ekoh_api_rejected(self):
        self.assertTrue(any('réelle' in e for e in self.errors(lambda d:d['contract'].update(interaction_mode='real'))))
    def test_07_palette_mutation_rejected(self):
        self.assertTrue(any('Couleur' in e for e in self.errors(lambda d:d['visual_language'].update(primary_hex='#FF0000'))))
    def test_08_missing_room_rejected(self):
        self.assertTrue(any('Salles' in e or '6 salles' in e for e in self.errors(lambda d:d['rooms'].pop())))
    def test_09_duplicate_decor_id_rejected(self):
        self.assertTrue(any('distincts' in e for e in self.errors(lambda d:d['panels'][1].update(id=d['panels'][0]['id']))))
    def test_10_panel_in_spawn_area_rejected(self):
        self.assertTrue(any('Obstruction' in e for e in self.errors(lambda d:d['panels'][0].update(pos=[0,10.8,-32]))))
    def test_11_panel_in_portal_area_rejected(self):
        self.assertTrue(any('Obstruction' in e for e in self.errors(lambda d:d['panels'][1].update(pos=[-47.1,10.8,16]))))
    def test_12_panel_outside_room_rejected(self):
        self.assertTrue(any('hors salle' in e for e in self.errors(lambda d:d['panels'][0].update(pos=[0,10.8,99]))))
    def test_13_panel_at_avatar_height_rejected(self):
        self.assertTrue(any('avatar' in e for e in self.errors(lambda d:d['panels'][0].update(pos=[0,3,-13]))))
    def test_14_unbudgeted_profile_rejected(self):
        self.assertTrue(any('Budget' in e for e in self.errors(lambda d:d['profiles']['LITE'].update(max_parts_estimated=3))))
    def test_15_panels_are_all_noninteractive(self):
        src=OUTPUT.read_text(encoding='utf8')
        self.assertIn('KinB02NonFunctional',src)
        self.assertIn('CanCollide=false',src)
        self.assertIn('CanTouch=false',src)
        self.assertIn('CanQuery=false',src)
        for disallowed in ['TeleportService','DataStoreService','HttpService','RemoteEvent','ProximityPrompt','Kick(']:
            self.assertNotIn(disallowed,src)
    def test_16_guarded_idempotence_and_no_global_mutation(self):
        src=OUTPUT.read_text(encoding='utf8')
        for required in ['KinPlaceKey','KinB02_EkoH_Atlas','ALREADY_BUILT','KinB02Revision','KinB02Profile','FindFirstChild(room.room_id)']:
            self.assertIn(required,src)
        self.assertNotIn('WorldBuilder',src)
        self.assertNotIn('PlaceRouting',src)
    def test_17_absent_room_preflight(self):
        src=OUTPUT.read_text(encoding='utf8')
        self.assertLess(src.index('for _,room in ipairs(SPEC.rooms)'),src.index('root=Instance.new("Folder")'))
    def test_18_quality_profiles_costed(self):
        self.assertEqual({p:6+18*i for i,p in enumerate(['LITE','STANDARD','SHOWCASE'])},
                         {'LITE':6,'STANDARD':24,'SHOWCASE':42})
        self.assertTrue(all(self.scene['profiles'][k]['max_parts_estimated']>=v for k,v in [('LITE',6),('STANDARD',24),('SHOWCASE',42)]))
    def test_19_fixtures_v3_pinned(self):
        self.assertEqual(self.fixture['source_zip_sha256'],'6696d12dc6c9fefd845e9180a11c4f9412ea439989ef97bd0ef35eb091192798')
        self.assertEqual(self.fixture['interaction']['provider_mode'],'stub')
    def test_20_no_asset_fallback_required(self):
        src=OUTPUT.read_text(encoding='utf8')
        for disallowed in ['MeshPart','InsertService','AssetService','require(', 'HttpGet']:
            self.assertNotIn(disallowed,src)

if __name__=='__main__': unittest.main()
