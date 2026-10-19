"""Contrôles structurels v19 hors moteur : le rendu réel doit être testé dans Roblox."""
from pathlib import Path
import json
import unittest
R=Path(__file__).resolve().parents[1]
class ConstructionV19(unittest.TestCase):
    def test_artistic_modules_wired_into_builders(self):
        wiring={'FacadeGenerator':'CrystalPorticosV19.make(',
                'InteriorGenerator':'CrystalRoomStoriesV19).make(',
                'CityGenerator':'OpalWayfindingV19.make(',
                'ResidentialQuarters':'CrystalEverydayV19.frame(',
                'StationArcades':'CrystalEverydayV19.frame(',
                'PromenadeCommerce':'CrystalEverydayV19.frame('}
        for mod,call in wiring.items():
            self.assertIn(call,(R/'src/server'/f'{mod}.luau').read_text(encoding='utf8'),mod)
    def test_art_themes_match_eight_institutions(self):
        code=(R/'src/server/CrystalPorticosV19.luau').read_text(encoding='utf8')
        mural=(R/'src/server/CrystalRoomStoriesV19.luau').read_text(encoding='utf8')
        names={item['interior_place_key'] for item in json.loads((R/'catalog/buildings.json').read_text())['buildings']}
        self.assertEqual(len(names),8)
        for name in names:
            self.assertIn(name+'=',code)
            self.assertIn(name+'=',mural)
    def test_no_new_interaction_or_physics_and_lod_tags(self):
        for mod in ('CrystalPorticosV19','CrystalRoomStoriesV19','OpalWayfindingV19','CrystalEverydayV19'):
            src=(R/'src/server'/f'{mod}.luau').read_text(encoding='utf8')
            self.assertNotIn('HttpService',src)
            self.assertNotIn('RunService',src)
        self.assertIn('KinOptionalDetail',(R/'src/server/CrystalEverydayV19.luau').read_text())
        self.assertIn('part.CanCollide=false',(R/'src/server/CrystalKit.luau').read_text().replace('object.CanCollide=false','part.CanCollide=false'))
if __name__=='__main__':unittest.main()
