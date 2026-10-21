"""V20 offline assertions for generated sources (not Roblox runtime verification)."""
from pathlib import Path
import re
import unittest
R=Path(__file__).resolve().parents[1]
S=R/'src/server'
class V20Art(unittest.TestCase):
    def test_biomes_are_connected_to_original_tree_sites(self):
        city=(S/'CityGenerator.luau').read_text(encoding='utf8')
        trees=(S/'BotanicalKitV20.luau').read_text(encoding='utf8')
        self.assertIn('BotanicalKitV20.tree(parent,x,z,seed)',city)
        self.assertIn('tree(gardens,x,z,i)',city)
        self.assertIn('seed%3',trees)
        self.assertIn('Crystal.profile',trees)
        self.assertNotIn('math.random',trees)
        self.assertNotIn('PointLight',trees)
    def test_cabinet_art_is_built_per_institution_room(self):
        room=(S/'InteriorGenerator.luau').read_text(encoding='utf8')
        craft=(S/'InstitutionCraftV20.luau').read_text(encoding='utf8')
        self.assertIn('InstitutionCraftV20.decorate(folder,place.place_key,room,origin,roomIndex)',room)
        for key in ['city_hall','ekoh_tower','library','campus','justice_palace','innovation_lab','museum','orgo_center']:
            self.assertIn(key+'=',craft)
        self.assertIn('Kit.profile=="LITE"',craft)
        self.assertIn('Kit.accent(placeKey)',craft)
        self.assertNotIn('Factory.prompt',craft)
    def test_glazing_is_not_global_glass_mesh(self):
        facade=(S/'FacadeGenerator.luau').read_text(encoding='utf8')
        self.assertIn('mineralPane("WindowFront"',facade)
        self.assertIn('mineralPane("SideWindowL"',facade)
        self.assertIn('pane.CanQuery=false',facade)
        self.assertIn('Enum.Material.SmoothPlastic',facade)
        self.assertNotIn('Enum.Material.Glass',facade)
    def test_no_active_konnaxion_or_external_apis_added(self):
        for name in ['BotanicalKitV20','InstitutionCraftV20']:
            src=(S/(name+'.luau')).read_text(encoding='utf8')
            for word in ['HttpService','DataStoreService','MessagingService','OnServerEvent','PostAsync']:
                self.assertNotIn(word,src)
            self.assertIn('KinArtTheme',src)
    def test_v20_revision_touches_generation(self):
        builder=(S/'WorldBuilder.luau').read_text(encoding='utf8')
        self.assertIn('construction-v30.0.7-',builder)
        release=(R/'tools/build_release.py').read_text(encoding='utf8')
        self.assertIn('KinCity_Installation_Directe_v30.luau',release)
if __name__=='__main__': unittest.main()
