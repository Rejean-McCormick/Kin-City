import json, unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[4]
PLACE=ROOT/'contrib/places/museum'

class B07Museum(unittest.TestCase):
    def test_recipe_is_b07(self):
        data=json.loads((PLACE/'recipe.json').read_text())
        self.assertEqual(data['owner_branch'],'B07')
        self.assertEqual(data['place_key'],'museum')
        self.assertEqual(data['implementation_status'],'INTEGRATION_PROPOSED')

    def test_scene_data_has_six_rooms_and_barred_door_policy(self):
        code=(PLACE/'MuseumSceneData.luau').read_text(encoding='utf8')
        self.assertIn('entry_policy="BARRED_EXTERIOR_PROMPT"',code)
        self.assertIn('broadcast_screen_policy="YOUTUBE_BROADCAST_NEARBY_VISIBLE"',code)
        self.assertEqual(code.count('room_id='),6)
        self.assertIn('target_door_id="city.kreative.museum.entry"',code)

    def test_scene_module_exports_build(self):
        code=(PLACE/'MuseumScene.luau').read_text(encoding='utf8')
        self.assertIn('function MuseumScene.build(context: any): any',code)
        self.assertIn('KinB07MuseumScene',code)
        self.assertIn('B07 garde la porte extérieure barrée',code)

if __name__=='__main__':
    unittest.main()
