import importlib.util,json,hashlib,math,re,unittest,os
from pathlib import Path
HERE=Path(__file__).resolve().parents[1]
SRC=Path(os.environ.get('KINCITY_BASE_ROOT', str(HERE.parents[2]/'source/Kin-City')))
SCENE=json.loads((HERE/'scene_recipe.json').read_text(encoding='utf8'))

class B08Tests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  if not (SRC/'catalog/spatial.json').is_file():
   raise RuntimeError('KINCITY_BASE_ROOT doit désigner les sources Kin-City compatibles pour valider les contrats.')
 def test_01_identity(self):
  self.assertEqual(SCENE['place_key'],'orgo_center')
  self.assertEqual(SCENE['owner_branch'],'B08')
  self.assertEqual(len(SCENE['rooms']),6)
  self.assertEqual(len({x['id'] for x in SCENE['rooms']}),6)
 def test_02_contracts_against_original(self):
  buildings=json.loads((SRC/'catalog/buildings.json').read_text())['buildings']
  b=next(x for x in buildings if x['interior_place_key']=='orgo_center')
  self.assertEqual(b['building_id'],'orgo.admin_center')
  d=json.loads((SRC/'catalog/doors.json').read_text())['doors'];d=[x for x in d if 'orgo_center' in (x['source_place_key'],x['destination_place_key'])]
  self.assertEqual(set(x['door_id'] for x in d),{'city.orgo.admin_center.entry','orgo_center.exit'})
  self.assertEqual(d[0]['return_door_id'],d[1]['door_id'])
  self.assertEqual(d[1]['return_door_id'],d[0]['door_id'])
 def test_03_canonical_rooms_preserved(self):
  spat=json.loads((SRC/'catalog/spatial.json').read_text());p=next(x for x in spat['places'] if x['place_key']=='orgo_center')
  expected={x['room_id']:(x['center_studs'][0],x['center_studs'][2],x['size_studs'][0],x['size_studs'][2]) for x in p['rooms']}
  local={x['id']:(x['center'][0],x['center'][1],x['size'][0],x['size'][1]) for x in SCENE['rooms']}
  for k,v in expected.items():self.assertEqual(v,local[k])
 def test_04_extensions_preserved(self):
  wings=(SRC/'src/server/InteriorWings.luau').read_text()
  for suff in ('west_wing','east_wing','rear_atrium'):
   self.assertIn('key..".'+suff+'"',wings)
   self.assertIn('orgo_center.'+suff,{x['id'] for x in SCENE['rooms']})
  dims=[x['size'] for x in SCENE['rooms'] if x['id'].endswith(('.west_wing','.east_wing','.rear_atrium'))]
  self.assertEqual(dims,[[52,50],[52,50],[100,56]])
 def test_05_reserved_anchors_unchanged(self):
  p=next(x for x in json.loads((SRC/'catalog/spatial.json').read_text())['places'] if x['place_key']=='orgo_center')
  keyed={a['anchor_id']:tuple(a['position_studs'][i] for i in (0,2)) for a in p['anchors']}
  self.assertEqual(len(SCENE['protected_anchors']),len(keyed))
  for a in SCENE['protected_anchors']:self.assertEqual(tuple(a['center']),keyed[a['id']])
 def test_06_connectors_unchanged(self):
  p=next(x for x in json.loads((SRC/'catalog/spatial.json').read_text())['places'] if x['place_key']=='orgo_center')
  static={a['portal_id'] for a in p['portals']}
  self.assertTrue(static.issubset(set(c['id'] for c in SCENE['protected_connectors'])))
  self.assertEqual(len(SCENE['protected_connectors']),6)
 def test_07_decor_namespaced_unique(self):
  els=SCENE['decorations'];self.assertEqual(len(els),24)
  self.assertEqual(len(set(x['id'] for x in els)),len(els))
  for d in els:self.assertTrue(d['id'].startswith('orgo_center.b08.'))
 def test_08_decorations_within_room_footprints(self):
  rooms={r['id']:r for r in SCENE['rooms']}
  for d in SCENE['decorations']:
   r=rooms[d['room']];x,y,z=d['position'];cx,cz=r['center'];w,depth=r['size']
   if d['kind']=='medallion':half=4.2
   elif d['kind'] in ('sign','subtitle'):half=7.6
   else:half=.4
   self.assertLessEqual(abs(x-cx)+half,w/2+0.01,d['id'])
   self.assertLessEqual(abs(z-cz),depth/2+0.01,d['id'])
   self.assertGreaterEqual(y,0,d['id']);self.assertLessEqual(y,16,d['id'])
 def test_09_floor_items_clear_protected_portals_and_anchors(self):
  masks=SCENE['protected_anchors']+SCENE['protected_connectors']
  for d in SCENE['decorations']:
   if d['kind']!='medallion':continue
   x,z=d['position'][0],d['position'][2]
   for m in masks:
    dist=math.hypot(x-m['center'][0],z-m['center'][1]);self.assertGreater(dist,m['radius']+4,d['id']+' vs '+m['id'])
 def test_10_quality_levels(self):
  levels=SCENE['quality_profiles'];self.assertEqual(levels,{'LITE':0,'STANDARD':1,'SHOWCASE':2})
  totals={k:sum(levels[e['profile']]<=limit for e in SCENE['decorations']) for k,limit in levels.items()}
  self.assertEqual(totals,{'LITE':8,'STANDARD':18,'SHOWCASE':24})
 def test_11_recipe_b09_format(self):
  r=json.loads((HERE/'recipe.json').read_text());self.assertEqual(r['place_key'],'orgo_center');self.assertEqual(r['owner_branch'],'B08')
  self.assertEqual(r['decorations'],[]);self.assertEqual(r['implementation_status'],'NOT_CONNECTED_TO_WORLD_BUILDER')
 def test_12_installer_determinism(self):
  module=HERE/'src/generate_preview.py'
  spec=importlib.util.spec_from_file_location('b08_preview',module);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
  from tempfile import TemporaryDirectory
  with TemporaryDirectory() as tmp:
   a=m.generate(out=Path(tmp)/'preview.luau').read_bytes()
   b=(HERE/'studio/B08_STUDIO_PREVIEW_LOCAL.luau').read_bytes()
   self.assertEqual(a,b)
 def test_13_installer_safety_and_scope(self):
  t=(HERE/'studio/B08_STUDIO_PREVIEW_LOCAL.luau').read_text(encoding='utf8')
  for v in ['game.PlaceId==0','not RunService:IsRunning()','KinRoutingMode','LOCAL_UNIVERSE','KinPlaceKey','orgo_center','KinAnchorId','B08_OrgoDecor_V1']:
   self.assertIn(v,t)
  self.assertNotIn('TeleportAsync',t);self.assertNotIn('HttpService',t);self.assertNotIn('InsertService',t)
  self.assertNotIn('KinCityGenerated:Destroy()',t)
  self.assertIn('p.CanCollide=false',t);self.assertIn('p.CanQuery=false',t)
 def test_14_no_real_service_advertised(self):
  text=(HERE/'scene_recipe.json').read_text().lower()
  self.assertNotIn('service connecté":true',text)
  self.assertIn('aucun service externe connecté',text)
 def test_16_luau_lexical_structure(self):
  script=(HERE/'studio/B08_STUDIO_PREVIEW_LOCAL.luau').read_text(encoding='utf8')
  lexer=SRC/'tools/check_luau_structure_v29.py'
  spec=importlib.util.spec_from_file_location('kc_luau_lexer',lexer)
  module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
  self.assertIsNone(module.check(script))
 def test_15_package_isolation(self):
  self.assertTrue(all('orgo_center' in str(x) for x in HERE.rglob('*') if x.is_file()))

if __name__=='__main__':unittest.main()
