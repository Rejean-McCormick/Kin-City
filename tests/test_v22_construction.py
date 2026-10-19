"""Garanties de câblage des nouvelles constructions (pas un émulateur Roblox)."""
from pathlib import Path
import unittest
R=Path(__file__).resolve().parents[1]
S=R/'src/server'; C=R/'src/client'
class LargeArtPass(unittest.TestCase):
 def test_eight_institutional_roofs(self):
  code=(S/'InstitutionSkylineV22.luau').read_text()
  for key in ('city_hall','ekoh_tower','library','campus','justice_palace','innovation_lab','museum','orgo_center'):
   self.assertIn(key+'=',code)
  self.assertEqual(1,(S/'FacadeGenerator.luau').read_text().count('SkylineV22.make(model,structure,building)'))
 def test_six_rooms_by_eight_institutions_are_decorated(self):
  code=(S/'InstitutionStoriesV22.luau').read_text()
  for key in ('city_hall','ekoh_tower','library','campus','justice_palace','innovation_lab','museum','orgo_center'):
   self.assertIn(key+'=',code)
  self.assertEqual(1,(S/'InteriorGenerator.luau').read_text().count('StoriesV22.decorate(folder,place.place_key,room,origin,roomIndex)'))
  self.assertIn('CollectionService:AddTag(marker,"KinCityGalleryV22")',code)
 def test_rest_stops_follow_existing_roads(self):
  self.assertEqual(1,(S/'CityGenerator.luau').read_text().count('CrystalRestStopsV22.make(city,plan)'))
  code=(S/'CrystalRestStopsV22.luau').read_text()
  self.assertIn('plan.pedestrian_paths',code)
  self.assertIn('Instance.new("Seat")',code)
 def test_local_quality_and_gallery(self):
  client=(C/'init.client.luau').read_text()
  for name in ('LocalVisualDirectorV22','GalleryJournalV22'):
   self.assertEqual(1,client.count('require(script.'+name+').start()'))
  quality=(C/'LocalVisualDirectorV22.luau').read_text()
  self.assertIn('KinCityLocalQuality',quality)
  self.assertIn('Enum.KeyCode.V',quality)
  journal=(C/'GalleryJournalV22.luau').read_text()
  self.assertIn('Enum.KeyCode.T',journal)
  self.assertIn('KinCityGalleryV22',journal)
  self.assertNotIn('Instance.new("RemoteEvent")',quality)
 def test_ornaments_have_no_collisions_or_fake_koa(self):
  code=(S/'ArtisanGeometryV22.luau').read_text()
  self.assertIn('Kit.part(parent',code)
  root='\n'.join(p.read_text() for p in (S/'InstitutionSkylineV22.luau',S/'InstitutionStoriesV22.luau'))
  for external in ('HttpService','PostAsync','DataStoreService','OnServerEvent'):
   self.assertNotIn(external,root)
 def test_houses_get_a_front_roof_not_covering_gardens(self):
  src=(S/'ResidentialQuarters.luau').read_text()
  roof=(S/'NeighborhoodRooflinesV22.luau').read_text()
  self.assertIn('NeighborhoodRooflinesV22.make(m,base,w,d,21.2,group.style,groupIndex*4+index)',src)
  self.assertIn('depth*0.18',roof)
 def test_repeated_glazing_is_opaline_in_homes_and_arcades(self):
  rules=(S/'OpalGlazingV22.luau').read_text()
  self.assertIn('Enum.Material.SmoothPlastic',rules)
  self.assertIn('Kit.profile=="SHOWCASE" and hero',rules)
  self.assertIn('OpalGlazingV22.apply', (S/'ResidentialQuarters.luau').read_text())
  self.assertIn('OpalGlazingV22.apply', (S/'StationArcades.luau').read_text())
 def test_build_version(self):
  self.assertIn('construction-v26.0.0-',(S/'WorldBuilder.luau').read_text())
  self.assertIn('KinCity_Installation_Directe_v26.luau',(R/'tools/build_release.py').read_text())
if __name__=='__main__': unittest.main()
