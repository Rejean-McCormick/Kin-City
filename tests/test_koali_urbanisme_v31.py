"""New city model invariants; doesn't require Roblox or optional Lua interpreters."""
from pathlib import Path
import json, math, re, unittest
R=Path(__file__).resolve().parents[1]
def catalog(key):return json.loads((R/'catalog'/f'{key}.json').read_text(encoding='utf8'))
class KoaliUrbanismeV31(unittest.TestCase):
 def test_six_sections_and_branding(self):
  ds=catalog('districts')['districts']; assert len(ds)==7
  names={d['district_id']:d['name'] for d in ds}
  self.assertEqual({k:names[k] for k in ['keenkonnect','ethikos','kreative','uckk','ekole','konnected']},
   {'keenkonnect':'keenKonnect','ethikos':'ethiKos','kreative':'Kreative','uckk':'UCKK','ekole':'Ekole','konnected':'KonnectED'})
 def test_koali_owns_the_interface(self):
  self.assertIn('interface spatiale de Koali',catalog('city')['display_name'])
  self.assertNotIn('orgo',catalog('city')['district_ids'])
 def test_eight_institutions_keep_original_routes(self):
  b=catalog('buildings')['buildings']; self.assertEqual(len(b),8)
  old={d['building_id'] for d in b}
  self.assertEqual(old,{'central.city_hall','central.ekoh_tower','konnected.library','konnected.university','ethikos.justice_palace','keenkonnect.innovation_lab','kreative.museum','orgo.admin_center'})
  for build in b:self.assertNotEqual(build['name'],'Centre administratif')
  self.assertEqual(next(v['district_id'] for v in b if v['building_id']=='konnected.university'),'uckk')
  self.assertEqual(next(v['district_id'] for v in b if v['building_id']=='orgo.admin_center'),'central')
 def test_door_anchors_follow_relocated_buildings(self):
  sp=catalog('spatial');anchors={v['anchor_id']:v for v in sp['places'][0]['anchors']}
  for structure in sp['structures']:
   bid=structure['building_id']; x,_,z=structure['center_studs']
   th=math.radians(structure['yaw_degrees']);front=structure['footprint_studs'][1]/2+1
   for suffix,distance in [('front_door',front),('return_spawn',front+13)]:
    anchor=anchors['city.'+bid+'.'+suffix]['position_studs']
    self.assertAlmostEqual(anchor[0],x-math.sin(th)*distance,delta=.002)
    self.assertAlmostEqual(anchor[2],z-math.cos(th)*distance,delta=.002)
 def test_six_functional_axes_without_legacy_generated_lots(self):
  urban=(R/'src/server/KoaliUrbanism.luau').read_text()
  self.assertIn('for _,s in ipairs(Districts.sections) do avenue(root,s) end',urban)
  self.assertIn('local radii={164,278,365}',urban)
  for label in ['Konstruct','Stockage','Korum','Konsultations','Smart Vote','Konservation','Kontact','Médiathèque','Kristal','Konstellation','Knowledge','CertifiKation']:
   self.assertIn(label,urban)
  generator=(R/'src/server/CityGenerator.luau').read_text()
  self.assertIn('KoaliUrbanism.make(city,plan)',generator)
  self.assertNotIn('    PromenadeCommerce.make(city)',generator)
  self.assertNotIn('    ResidentialQuarters.make(city)',generator)
  self.assertNotIn('    IntermodalHub.make(city)',generator)
 def test_no_silent_city_reversion(self):
  source=(R/'src/server/WorldBuilder.luau').read_text()
  self.assertIn('aucun secours v27 silencieux',source)
 def test_public_prompts_are_stubs_not_real_apis(self):
  source=(R/'src/server/KoaliUrbanism.luau').read_text()
  self.assertIn('KinBackendConnected',source)
  self.assertIn('KinStubInteractionId',source)
  self.assertNotIn('HttpService',source)
 def test_camera_privilege_fixed(self):
  source=(R/'src/client/ArrivalCamera.luau').read_text()
  self.assertNotIn('player.DevCameraOcclusionMode=',source)
if __name__=='__main__':unittest.main()
