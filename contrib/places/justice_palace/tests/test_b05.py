"""B05 static contract tests. Run: python -m unittest discover -s contrib/places/justice_palace/tests -v"""
import json
import math
import os
import unittest
from pathlib import Path

HERE=Path(__file__).resolve().parents[1]
SCENE=json.loads((HERE/'scene_plan.json').read_text(encoding='utf8'))
RECIPE=json.loads((HERE/'recipe.json').read_text(encoding='utf8'))
SNAPSHOT=json.loads((HERE/'canonical_snapshot.json').read_text(encoding='utf8'))
KIN_ROOT=Path(os.environ.get('KINCITY_ORIGINAL', '/mnt/data/B05_work/KinCity_ArtDeco_V3/source/Kin-City'))

class B05Static(unittest.TestCase):
 def test_contract_identity(self):
  self.assertEqual(SCENE['place_key'],'justice_palace')
  self.assertEqual(SCENE['building_id'],'ethikos.justice_palace')
  self.assertEqual(SCENE['style']['sector_hex'].lower(),'#a97c4f')
  self.assertEqual(RECIPE['owner_branch'],'B05')
  self.assertEqual(RECIPE['requires_contracts_version'],'KC34-DOC-1.0')
  self.assertEqual(RECIPE['implementation_status'],'INTEGRATION_PROPOSED')
 def test_six_rooms_and_four_extensions_portals(self):
  ids=[x['room_id'] for x in SCENE['rooms']]
  self.assertEqual(len(ids),6)
  self.assertEqual(len(set(ids)),6)
  self.assertEqual(len(SCENE['protected']['extension_portals']),4)
 def test_protected_routes_not_altered(self):
  protected=SCENE['protected']
  self.assertEqual(protected['entry_door_id'],'city.ethikos.justice_palace.entry')
  self.assertEqual(protected['exit_door_id'],'justice_palace.exit')
  self.assertEqual(protected['spawn_anchor_id'],'justice_palace.lobby.spawn')
  self.assertEqual(protected['exit_anchor_id'],'justice_palace.exit.door')
  self.assertEqual(protected['interaction_anchor_id'],'hall.terminal_01')
 def test_features_distinct_and_safe(self):
  fs=SCENE['features'];self.assertEqual(len(fs),24)
  self.assertEqual(len({f['id'] for f in fs}),24)
  byroom={r['room_id']:r for r in SCENE['rooms']}
  self.assertEqual({f['room_id'] for f in fs},set(byroom))
  for f in fs:
   self.assertEqual(f['collision_policy'],'no_collision')
   self.assertTrue(f['id'].startswith('justice_palace.b05.'))
   self.assertIn(f['kind'],{'rosette','frieze','pilaster','sconce'})
   self.assertIn(f['min_profile'],{'LITE','STANDARD','SHOWCASE'})
   x,y,z=f['position_studs'];room=byroom[f['room_id']]
   cx,_,cz=room['center'];w,_,d=room['size']
   self.assertLessEqual(abs(x-cx),w/2-2.0, f['id'])
   self.assertLessEqual(abs(z-cz),d/2-1.4, f['id'])
   height=f['width_studs'] if f['kind'] in ('pilaster','rosette') else 1.6
   self.assertGreater(y-height/2,1.0, f['id'])
   self.assertLess(y+height/2,15.9, f['id'])
 def test_keepout_circles(self):
  circles=[z for z in SCENE['zones_to_keep_clear'] if z['type']=='circle']
  for f in SCENE['features']:
   x,_,z=f['position_studs']
   for obstacle in circles:
    ox,oz=obstacle['xz']
    self.assertGreater(math.hypot(x-ox,z-oz),obstacle['radius_studs'],(f['id'],obstacle['name']))
 def test_six_features_lite_twelve_standard_twentyfour_showcase(self):
  vals={'LITE':1,'STANDARD':2,'SHOWCASE':3};fs=SCENE['features']
  for profile,lim in [('LITE',6),('STANDARD',12),('SHOWCASE',24)]:
   included=[f for f in fs if vals[profile]>=vals[f['min_profile']]]
   self.assertEqual(len(included),lim)
   self.assertEqual(len(included)*3,SCENE['budget']['estimated_native_parts'][profile])
 def test_candidate_assets_known(self):
  if not KIN_ROOT.is_dir(): self.skipTest('Original package source not locally mounted')
  catalog=json.loads((KIN_ROOT/'catalog/art_deco_assets.json').read_text())['assets']
  keys={v['asset_key'] for v in catalog}
  for f in SCENE['features']:
   if f.get('asset_candidate'):self.assertIn(f['asset_candidate'],keys)
 def test_source_routes_original(self):
  if not KIN_ROOT.is_dir():self.skipTest('Original package source not locally mounted')
  ds=json.loads((KIN_ROOT/'catalog/doors.json').read_text())['doors']
  observed={d['door_id'] for d in ds}
  for name in ('entry_door_id','exit_door_id'):
   self.assertIn(SCENE['protected'][name],observed)
  c={p['place_key']:p for p in json.loads((KIN_ROOT/'catalog/spatial.json').read_text())['places']}
  self.assertEqual({a['anchor_id'] for a in c['justice_palace']['anchors']},
   {'hall.terminal_01','justice_palace.exit.door','justice_palace.lobby.spawn'})
 def test_code_is_not_autopublishing_or_teleporting(self):
  s=(HERE/'PreviewBuilder.luau').read_text()
  for forbidden in ('TeleportService','DataStoreService','HttpService','InsertService','game:Shutdown','game.PlaceId ='):
   self.assertNotIn(forbidden,s)
  self.assertIn('CanCollide=false',s)
  self.assertIn('replace_decoration==true',s)
  self.assertIn('ctx.place_key==\'justice_palace\'',s)
 def test_luau_generated_from_json_stable(self):
  from pathlib import Path
  # A lightweight source-data consistency guard without requiring a Luau interpreter.
  lua=(HERE/'SceneData.luau').read_text()
  for f in SCENE['features']:
   self.assertIn(f['id'],lua)
  self.assertEqual(lua.count('justice_palace.b05.'),24)
  self.assertIn('kincity.b05-scene/1.0',lua)
 def test_source_generation_reproducible(self):
  import sys
  sys.path.insert(0,str(HERE/"tools"))
  from regenerate_luau import output
  self.assertEqual((HERE/"SceneData.luau").read_text(),output())
 def test_b09_schema_shape(self):
  self.assertEqual(set(RECIPE),{'schema_version','place_key','owner_branch','requires_contracts_version','recipe_revision','seed_policy','profiles_supported','decorations','implementation_status'})
  self.assertEqual(RECIPE['schema_version'],'kincity.place-recipe/1.0')
  self.assertEqual(RECIPE['decorations'],[])
  self.assertEqual(RECIPE['profiles_supported'],['LITE','STANDARD','SHOWCASE'])

if __name__=='__main__':unittest.main()
