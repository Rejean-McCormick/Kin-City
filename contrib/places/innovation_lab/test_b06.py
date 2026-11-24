#!/usr/bin/env python3
"""Offline geometry, interface and deterministic generation checks for B06.
Requires only Python stdlib and the original uploaded KinCity source ZIP.
Does not claim Roblox scene, Lua runtime, or published teleport validation.
"""
import hashlib,json,sys,unittest
from pathlib import Path
from zipfile import ZipFile
HERE=Path(__file__).resolve().parent
LAYOUT=HERE/'room_layout.json'
ORIGINAL=HERE.parents[2]/'BASE_KINCITY_V3_ORIGINAL.zip'
PROFILE=['LITE','STANDARD','SHOWCASE']

def load_manifest(zip_name):
    with ZipFile(ORIGINAL) as z:
        return json.loads(z.read('KinCity_ArtDeco_V3/source/Kin-City/'+zip_name))

class B06Static(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.d=json.loads(LAYOUT.read_text())
        cls.s=load_manifest('catalog/spatial.json')
        cls.rooms={r['room_id']:r for p in cls.s['places'] if p['place_key']=='innovation_lab' for r in p['rooms']}
        cls.doors=load_manifest('catalog/doors.json')['doors']
        cls.inter=load_manifest('catalog/interactions.json')['interactions']
        cls.module=(HERE/'KonstructScene.luau').read_text()
    def test_place_identity_and_colors(self):
        self.assertEqual(self.d['place_key'],'innovation_lab')
        self.assertEqual(self.d['building_id'],'keenkonnect.innovation_lab')
        self.assertEqual(self.d['accent_hex'],'#D0BF86')
        self.assertEqual(self.d['structural_teal_hex'],'#1E6864')
        self.assertEqual(self.d['interaction_mode'],'stub')
    def test_all_six_rooms_and_extensions(self):
        self.assertEqual(len(self.d['rooms']),6)
        self.assertEqual({x['room_id'] for x in self.d['rooms']},
          {'innovation_lab.'+x for x in ('lobby','gallery','chamber','west_wing','east_wing','rear_atrium')})
        for x in self.d['rooms']:
            if x['room_id'] in self.rooms:
                self.assertEqual(self.rooms[x['room_id']]['center_studs'],x['center_studs'])
                self.assertEqual(self.rooms[x['room_id']]['size_studs'],x['size_studs'])
    def test_portals_unmodified_and_preserved(self):
        self.assertEqual(len(self.d['protected_portals']),6)
        known={d['portal_id'] for p in self.s['places'] if p['place_key']=='innovation_lab' for d in p['portals']}
        self.assertTrue(known.issubset({d['portal_id'] for d in self.d['protected_portals']}))
        self.assertEqual(len(known),2)
        self.assertEqual(len([d for d in self.d['protected_portals'] if 'to_' in d['portal_id']]),4)
    def test_two_reciprocal_doors(self):
        subset={d['door_id']:d for d in self.doors if 'innovation_lab' in (d['source_place_key'],d['destination_place_key'])}
        self.assertEqual(set(subset), {self.d['door_entry'],self.d['door_exit']})
        for d in subset.values():self.assertIn(d['return_door_id'],subset)
    def test_interaction_is_canonical_and_stub(self):
        i=[i for i in self.inter if i['place_key']=='innovation_lab']
        self.assertEqual(len(i),1)
        self.assertEqual(i[0]['interaction_id'],self.d['canonical_interaction_id'])
        self.assertEqual(i[0]['anchor_id'],self.d['canonical_interaction_anchor'])
        self.assertEqual(i[0]['provider_mode'],'stub')
    def test_all_details_are_namespaced_and_in_bounds(self):
        room={x['room_id']:x for x in self.d['rooms']}
        ids=set()
        for item in self.d['details']:
            self.assertNotIn(item['id'],ids)
            ids.add(item['id'])
            self.assertTrue(item['id'].startswith('innovation_lab.decor.'))
            self.assertIn(item['room_id'],room)
            self.assertIn(item['tier'],PROFILE)
            self.assertIn(item['style'],('wall_ribbon','hanging_cartouche','diamond_star'))
            x,y,z=item['position_studs'];r=room[item['room_id']]
            cx,cy,cz=r['center_studs'];sx,sy,sz=r['size_studs']
            self.assertLessEqual(abs(x-cx)+item['width_studs']/2,sx/2-1)
            self.assertLessEqual(abs(z-cz),sz/2-1)
            self.assertGreaterEqual(y,9.0)
            self.assertLessEqual(y+1.25,16)
    def test_profiles_part_budget(self):
        caps=self.d['profiles'];counts=[]
        for profile in PROFILE:
            chosen=[d for d in self.d['details'] if PROFILE.index(d['tier'])<=PROFILE.index(profile)]
            count=sum(2 if d['style']=='wall_ribbon' else 3 for d in chosen)
            self.assertLessEqual(count,caps[profile]['max_parts'])
            counts.append(count)
        self.assertEqual(counts,[24,33,60])
    def test_deterministic_generated_luau(self):
        sys.path.insert(0,str(HERE))
        import build_scene
        before=(HERE/'KonstructScene.luau').read_bytes()
        after=build_scene.render().encode('utf8')
        self.assertEqual(before,after)
        self.assertIn('CanCollide=false',self.module)
        self.assertIn('CanQuery=false',self.module)
        self.assertIn('context.placeKey==PLACE_KEY',self.module)
        self.assertIn('model.Parent=context.parent',self.module)
    def test_recipe_schema_compatible(self):
        j=json.loads((HERE/'recipe.json').read_text())
        self.assertEqual(j['schema_version'],'kincity.place-recipe/1.0')
        self.assertEqual(j['owner_branch'],'B06')
        self.assertEqual(j['requires_contracts_version'],'KC34-DOC-1.0')
        self.assertEqual(j['decorations'],[])
    def test_guards_against_unknown_rooms(self):
        for d in self.d['details']:
            self.assertIn(d['room_id'],{r['room_id'] for r in self.d['rooms']})
        self.assertEqual(self.d['scene_status'],'OFFLINE_CONTRIBUTION_NOT_CONNECTED')

if __name__=='__main__':unittest.main(verbosity=2)
