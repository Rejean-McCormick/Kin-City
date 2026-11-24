"""B04 guardrail and manifest tests. NOT a Roblox Studio or Luau compiler test."""
import hashlib,json,re,unittest
from pathlib import Path
CAMPUS=Path(__file__).resolve().parents[1]
REPO=Path(__file__).resolve().parents[4]
load=lambda name:json.loads((REPO/name).read_text(encoding='utf8'))

class B04Static(unittest.TestCase):
    def test_01_place_identity_and_historical_door_unchanged(self):
        b=next(x for x in load('catalog/buildings.json')['buildings'] if x['interior_place_key']=='campus')
        self.assertEqual((b['building_id'],b['district_id'],b['entry_door_id'],b['exit_door_id']),
            ('konnected.university','uckk','city.konnected.university.entry','campus.exit'))
    def test_02_door_reciprocity_and_anchors(self):
        ds=load('catalog/doors.json')['doors'];e=next(d for d in ds if d['door_id']=='city.konnected.university.entry')
        x=next(d for d in ds if d['door_id']=='campus.exit')
        self.assertEqual(e['return_door_id'],x['door_id']);self.assertEqual(x['return_door_id'],e['door_id'])
        self.assertEqual((e['destination_place_key'],e['destination_anchor_id']),('campus','campus.lobby.spawn'))
        self.assertEqual((x['source_place_key'],x['source_anchor_id'],x['destination_anchor_id']),('campus','campus.exit.door','city.konnected.university.return_spawn'))
    def test_03_six_room_ids_match_runtime_and_program(self):
        rooms=next(p for p in load('build/world-plan.json')['places'] if p['place_key']=='campus')['rooms']
        ids={r['room_id'] for r in rooms}
        self.assertEqual(ids,{'campus.lobby','campus.gallery','campus.chamber'})
        luau=(REPO/'src/server/InteriorWings.luau').read_text(encoding='utf8')
        for room in ('west_wing','east_wing','rear_atrium'):self.assertIn('key..".'+room+'"',luau)
        prog=load('catalog/buildings.json'); self.assertEqual(len(load('catalog/buildings.json')['buildings']),8)
        brief=json.loads((CAMPUS/'campus_program.json').read_text())
        self.assertEqual({r['room_id'] for r in brief['room_plan']},ids|{'campus.west_wing','campus.east_wing','campus.rear_atrium'})
    def test_04_courses_stay_stub_and_canonical_board(self):
        x=next(i for i in load('catalog/interactions.json')['interactions'] if i['place_key']=='campus')
        self.assertEqual((x['interaction_id'],x['anchor_id'],x['capability_id'],x['provider_mode']),
            ('konnected.university.board_01','hall.board_01','uckk.courses.browse','stub'))
    def test_05_palette_exact(self):
        a=(CAMPUS/'CampusDecor.luau').read_text()
        self.assertIn('Color3.fromRGB(117,142,166)',a)
        self.assertIn('Color3.fromRGB(30,104,100)',a)
        self.assertEqual(json.loads((CAMPUS/'campus_program.json').read_text())['accent'],'#758EA6')
    def test_06_no_remote_or_teleport_behavior_in_overlay(self):
        s=(CAMPUS/'CampusDecor.luau').read_text()
        for token in ['TeleportService','RemoteEvent','HttpService','DataStoreService','LoadAsset','InsertService','ProximityPrompt','SetAsync']:
            self.assertNotIn('Instance.new("'+token+'")',s)
        self.assertNotIn('TeleportAsync',s)
    def test_07_noncollidable_overlay_and_target_guard(self):
        s=(CAMPUS/'CampusDecor.luau').read_text()
        for token in ['obj.Anchored=true','obj.CanCollide=false','obj.CanQuery=false','obj.CanTouch=false','KinPlaceKey")=="campus"','KinB04Revision','KinOptionalDetail']:
            self.assertIn(token,s)
    def test_08_visual_profile_choices_and_idempotency(self):
        s=(CAMPUS/'CampusDecor.luau').read_text()
        for label in ('LITE','STANDARD','SHOWCASE'):self.assertIn('profile=="'+label+'"',s)
        self.assertIn('interior:FindFirstChild(ROOT_NAME)',s)
        self.assertIn('return {created=0,skipped=1,revision=REVISION}',s)
    def test_09_room_placement_avoids_central_exit_corridor(self):
        s=(CAMPUS/'CampusDecor.luau').read_text()
        # Lobby decorations must be centered on ±31 X, never x≈0 at the protected exit.
        self.assertIn('origin,-31,-44.15',s);self.assertIn('origin,31,-44.15',s)
        self.assertNotRegex(s,r'panel\(hall,origin,0(?:\.0)?,')
    def test_10_preview_studio_guard_before_world_change(self):
        s=(CAMPUS/'INSTALLER_B04_PREVIEW_LOCAL.luau').read_text()
        create=s.index('local module=Instance.new("ModuleScript")')
        for check in ['run:IsStudio()','not run:IsRunning()','game.PlaceId==0','KinCityGenerated','Intérieur — campus','KinPlaceKey']:
            self.assertIn(check,s[:create])
        self.assertNotIn('TeleportAsync',s)
    def test_11_recipe_schema_conforms_to_b09(self):
        r=json.loads((CAMPUS/'recipe.json').read_text())
        self.assertEqual(r['schema_version'],'kincity.place-recipe/1.0');self.assertEqual(r['place_key'],'campus')
        self.assertEqual(r['owner_branch'],'B04');self.assertEqual(r['requires_contracts_version'],'KC34-DOC-1.0')
        self.assertEqual(r['seed_policy'],'CITY_SEED_XOR_PLACE_HASH')
        self.assertEqual(r['profiles_supported'],['LITE','STANDARD','SHOWCASE'])
        self.assertEqual(r['decorations'],[])
        self.assertEqual(r['implementation_status'],'INTEGRATION_PROPOSED')
    def test_12_contribution_does_not_embed_business_sources(self):
        files=[p for p in CAMPUS.rglob('*') if p.is_file()]
        self.assertTrue(all('.glb' not in p.name and '.rbxm' not in p.name and '.rbxl' not in p.name for p in files))
        self.assertEqual(len([p for p in files if p.suffix=='.luau']),2)

if __name__=='__main__':unittest.main(verbosity=2)
