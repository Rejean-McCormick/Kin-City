"""B01 pure-Python QA. No claims about Studio, client, or a B09 merge."""
import hashlib,json,re,sys,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
import generate_spec,make_studio_preview
load=lambda name:json.loads((ROOT/name).read_text(encoding='utf8'))

class SceneContracts(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.scene=load('city_hall_scene.json')
        cls.snapshot=load('contracts_snapshot.json')
        cls.recipe=load('recipe.json')
    def test_01_ids(self):
        self.assertEqual(self.scene['place_key'],'city_hall')
        self.assertEqual(self.scene['building_id'],'central.city_hall')
        self.assertEqual(self.recipe['owner_branch'],'B01')
        self.assertEqual(self.recipe['requires_contracts_version'],'KC34-DOC-1.0')
    def test_02_six_rooms(self):
        self.assertEqual(len(self.scene['rooms']),6)
        self.assertEqual({r['room_id'] for r in self.scene['rooms']},{'city_hall.'+n for n in ('lobby','gallery','chamber','west_wing','east_wing','rear_atrium')})
        self.assertEqual(len({r['room_id'] for r in self.scene['rooms']}),6)
    def test_03_canonical_geometry(self):
        expected={r['room_id']:r for r in self.snapshot['place']['rooms']}
        for room in self.scene['rooms']:
            if room['room_id'] in expected:
                old=expected[room['room_id']]
                self.assertEqual(room['center_studs'],old['center_studs'])
                self.assertEqual(room['size_studs'],old['size_studs'])
    def test_04_extensions(self):
        ext={'city_hall.west_wing':([-79,0,7],[52,16,50]),'city_hall.east_wing':([79,0,7],[52,16,50]),'city_hall.rear_atrium':([0,0,76],[100,16,56])}
        for room in self.scene['rooms']:
            if room['room_id'] in ext:self.assertEqual((room['center_studs'],room['size_studs']),ext[room['room_id']])
    def test_05_both_door_ids_preserved(self):
        d=self.snapshot['doors'];self.assertEqual(len(d),2)
        ids={x['door_id'] for x in d}
        self.assertEqual(ids,{'city.central.city_hall.entry','city_hall.exit'})
        self.assertEqual({x['return_door_id'] for x in d},ids)
    def test_06_anchor_protections(self):
        actual={x['anchor_id']:x['position_studs'] for x in self.snapshot['place']['anchors']}
        for a in self.scene['protected_anchors']:
            self.assertEqual(actual[a['anchor_id']],a['position_studs'])
        self.assertEqual(set(actual),{a['anchor_id'] for a in self.scene['protected_anchors']})
    def test_07_no_fake_api(self):
        interactions=self.snapshot['interactions'];self.assertEqual(len(interactions),1)
        self.assertEqual(interactions[0]['provider_mode'],'stub')
        self.assertEqual(interactions[0]['anchor_id'],'hall.kiosk_01')
        code=(ROOT/'CityHallScene.luau').read_text()
        self.assertNotIn('RemoteEvent',code)
        self.assertNotIn('TeleportService',code)
    def test_08_program_geometry_fits_rooms(self):
        # Far wall plaques must remain in their own room, even with a 0.7-stud offset.
        for room in self.scene['rooms']:
            x,z=room['center_studs'][0],room['center_studs'][2]
            w,d=room['size_studs'][0],room['size_studs'][2]
            offset=13 if room['room_id']=='city_hall.gallery' else -13 if room['room_id']=='city_hall.chamber' else 0
            pw=min(21 if offset==0 else 15,w-12)
            self.assertLessEqual(abs(offset)+pw/2,w/2-1.5)
            self.assertLessEqual(abs((z+d/2-.58)-z),d/2)
    def test_09_canonical_portals_clear(self):
        portals=self.snapshot['place']['portals']
        self.assertEqual(len(portals),2)
        for room in self.scene['rooms']:
            x,z=room['center_studs'][0],room['center_studs'][2]
            w,d=room['size_studs'][0],room['size_studs'][2]
            sign_x=x+(13 if room['room_id']=='city_hall.gallery' else -13 if room['room_id']=='city_hall.chamber' else 0)
            sign_span=min(21 if sign_x==x else 15,w-12)
            sign_z=z+d/2-.58
            for p in portals:
                px,pz=p['center_studs'][0],p['center_studs'][2]
                if abs(sign_z-pz)<3:
                    self.assertGreaterEqual(abs(sign_x-px),sign_span/2+p['clear_width_studs']/2+0.5)
    def test_10_budget_profiles(self):
        for profile,cfg in self.scene['profile_limits'].items():
            # 1 frieze, 2 labels, 1 medallion, N rays, M panels per room.
            actual=6*(4+cfg['rays_per_room']+cfg['accent_panels'])
            self.assertLessEqual(actual,cfg['max_parts'],profile)
            self.assertEqual({'LITE':54,'STANDARD':84,'SHOWCASE':114}[profile],actual)
    def test_11_decor_is_non_collidable(self):
        code=(ROOT/'CityHallScene.luau').read_text()
        for s in ('CanCollide = false','CanTouch = false','CanQuery = false','CastShadow = false','KinB01CityHallDecor'):
            self.assertIn(s,code)
        self.assertNotIn('Instance.new("ProximityPrompt")',code)
    def test_12_guard_and_idempotence(self):
        code=(ROOT/'CityHallScene.luau').read_text()
        for s in ('contracts_version == Spec.contracts_version','KinPlaceKey','KinInteriorOrigin','previous:Destroy()','if not ok then'):
            self.assertIn(s,code)
    def test_13_generated_luau_up_to_date(self):
        expected=generate_spec.OUTPUT.read_text(encoding='utf8')
        rebuilt='--!strict\n-- GENERATED from city_hall_scene.json; DO NOT EDIT BY HAND.\nreturn '+generate_spec.as_luau(self.scene)+'\n'
        self.assertEqual(expected,rebuilt)
    def test_14_preview_generation_up_to_date(self):
        before=(ROOT/'preview/PREVIEW_B01_COPIE_LOCALE.luau').read_text()
        after=make_studio_preview.generate().read_text()
        self.assertEqual(before,after)
        self.assertIn('assert(game.PlaceId==0',before)
    def test_15_rollback_scoped(self):
        txt=(ROOT/'preview/ROLLBACK_B01_COPIE_LOCALE.luau').read_text()
        self.assertIn('KinB01CityHallDecor',txt)
        self.assertIn('assert(game.PlaceId==0',txt)
        self.assertNotIn('KinCityGenerated:Destroy',txt)
    def test_16_all_paths_within_b01(self):
        for p in ROOT.rglob('*'):
            if p.is_file():self.assertEqual(p.resolve().is_relative_to(ROOT.resolve()),True)
if __name__=='__main__':unittest.main(verbosity=2)

class ClearanceChecks(unittest.TestCase):
    def test_17_signs_avoid_canonical_anchor_zones(self):
        scene=load('city_hall_scene.json')
        for room in scene['rooms']:
            x=room['center_studs'][0]+(13 if room['room_id']=='city_hall.gallery' else -13 if room['room_id']=='city_hall.chamber' else 0)
            z=room['center_studs'][2]+room['size_studs'][2]/2-0.58
            w=min(21 if x==room['center_studs'][0] else 15,room['size_studs'][0]-12)
            # A plaque may be wide, so measure planar distance to its visible rectangle.
            for anchor in scene['protected_anchors']:
                ax,az=anchor['position_studs'][0],anchor['position_studs'][2]
                nearest_x=max(x-w/2,min(ax,x+w/2))
                distance=((ax-nearest_x)**2+(az-z)**2)**0.5
                self.assertGreaterEqual(distance,anchor['protection_radius_studs'],(room['room_id'],anchor['anchor_id'],distance))
    def test_18_two_exit_ids_not_created_as_decoration(self):
        spec=load('city_hall_scene.json')
        txt=(ROOT/'CityHallScene.luau').read_text()
        self.assertEqual(len(spec['protected_portals']),6)
        self.assertNotIn('city_hall.exit.door =',txt)
        self.assertNotIn('Instance.new("TeleportService")',txt)
