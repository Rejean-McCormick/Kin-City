"""Sanity checks v23: delivered source/assets must be connected to the world.
These tests do NOT replace an actual Studio run.
"""
import json
import struct
import unittest
import wave
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
S=ROOT/'src/server'

class V23Construction(unittest.TestCase):
    def test_furniture_all_institutions(self):
        text=(S/'SculptedFurnitureV23.luau').read_text()
        for place in ('city_hall','ekoh_tower','library','campus','justice_palace','innovation_lab','museum','orgo_center'):
            self.assertIn(place+'=',text)
        self.assertIn('Instance.new("Seat")',text)
        self.assertIn('FurnitureV23.decorate', (S/'InteriorGenerator.luau').read_text())
    def test_local_exhibits(self):
        text=(S/'LivingExhibitsV23.luau').read_text()
        for needed in ('PromptTriggered','HumanoidRootPart','KinExhibitV23','Chapitre suivant','Atlas.start'):
            self.assertIn(needed,text)
        self.assertIn('LivingExhibitsV23.start(state.world)',(S/'init.server.luau').read_text())
    def test_lighting_not_tripled(self):
        text=(S/'InteriorScenography.luau').read_text()
        self.assertIn('CrystalLuminairesV23',text)
        self.assertNotIn('Lustre en verre',text)
        self.assertNotIn('Instance.new("PointLight")',(S/'CrystalLuminairesV23.luau').read_text())
    def test_audio_and_mesh_files(self):
        audio=json.loads((ROOT/'config/audio.json').read_text())
        self.assertFalse(audio['enabled'])
        for name in ('archives','laboratory','harbor','botanical','civic'):
            self.assertIsNone(audio[name+'_sound_id'])
        for path in (ROOT/'assets/audio').glob('kin-city-*.wav'):
            with wave.open(str(path),'rb') as wav:
                self.assertEqual(wav.getnchannels(),1)
                self.assertGreater(wav.getnframes(),10000)
        meshes=json.loads((ROOT/'config/meshes.json').read_text())
        for key in ('mineral_column','opal_spire','crystal_rosette','opal_arch','opal_chandelier'):
            self.assertIsNone(meshes[key])
        for path in (ROOT/'assets/meshes-v23').glob('*.obj'):
            source=path.read_text()
            self.assertGreater(source.count('\nf '),25,path.name)
            self.assertGreater(source.count('\nv '),25,path.name)
    def test_material_maps(self):
        from PIL import Image
        self.assertEqual(len(list((ROOT/'assets/materials-v23').glob('*-color.png'))),4)
        for path in (ROOT/'assets/materials-v23').glob('*-normal.png'):
            with Image.open(path) as img:self.assertEqual(img.size,(512,512))
    def test_release(self):
        from sys import path as sys_path
        sys_path.insert(0,str(ROOT/'tools'))
        from build_release import build
        from tempfile import TemporaryDirectory
        import shutil
        with TemporaryDirectory() as d:
            target=Path(d)/'test_repo'
            shutil.copytree(ROOT,target,ignore=shutil.ignore_patterns('.git','__pycache__'))
            result=build(target)
            self.assertEqual(result['version'],'26.0.0')
            self.assertIn('KinCity_Installation_Directe_v26.luau',result['artifacts'])

if __name__=='__main__':unittest.main()
