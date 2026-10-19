"""v24: contrôle des NOUVEAUX systèmes livrés, sans prétendre exécuter Roblox Studio."""
import json
import tempfile
import unittest
from pathlib import Path
from importlib.util import spec_from_file_location,module_from_spec
ROOT=Path(__file__).resolve().parents[1]
S=ROOT/'src/server'

class V24Build(unittest.TestCase):
    def test_registry_names_and_fallback(self):
        reg=(S/'StudioAssetLibraryV24.luau').read_text()
        kit=(S/'ReusableMeshesV23.luau').read_text()
        for name in ['mineral_column','opal_spire','crystal_rosette','opal_arch','opal_chandelier',
                     'crystal_canopy','mineral_planter','opal_console']:
            self.assertIn(name,reg)
            self.assertIn(name,json.loads((ROOT/'config/meshes.json').read_text()))
        self.assertIn('ServerStorage',reg)
        self.assertIn('StudioLibrary.instantiate',kit)
        self.assertIn('Instance.new("SpecialMesh")',kit)
        self.assertIn('nativeArch',kit)
    def test_asset_registration_command(self):
        source=(ROOT/'KinCity_Enregistrer_Mesh_Studio_v25.luau').read_text()
        for token in ['Selection','ServerStorage','KinCityAssetLibrary','Clone()','KinImportedSource']:
            self.assertIn(token,source)
        self.assertNotIn('HttpService',source)
    def test_staging_all_eight_institutions(self):
        stage=(S/'InstitutionStagecraftV24.luau').read_text()
        for name in ['city_hall','ekoh_tower','library','campus','justice_palace','innovation_lab','museum','orgo_center']:
            self.assertIn(name+'=',stage)
        self.assertIn('StageV24.decorate', (S/'InteriorGenerator.luau').read_text())
        self.assertIn('if Kit.profile=="LITE"',stage)
    def test_exterior_studio_asset_placements(self):
        facade=(S/'InstitutionFacadeKitV24.luau').read_text()
        city=(S/'CrystalLandingsV24.luau').read_text()
        self.assertIn('FacadeKitV24.make', (S/'FacadeGenerator.luau').read_text())
        self.assertIn('CrystalLandingsV24.make', (S/'CityGenerator.luau').read_text())
        for key in ['opal_arch','mineral_column','crystal_rosette','opal_spire','crystal_canopy']:
            self.assertIn(key,facade)
        for key in ['mineral_planter','opal_console']:
            self.assertIn(key,city)
    def test_new_obj_geometry(self):
        assets=ROOT/'assets/meshes-v24'
        for name in ['crystal-canopy','mineral-planter','opal-console']:
            path=assets/(name+'.obj')
            self.assertTrue(path.is_file())
            lines=path.read_text().splitlines()
            self.assertGreater(sum(l.startswith('f ') for l in lines),20)
            points=[[float(v) for v in line.split()[1:]] for line in lines if line.startswith('v ')]
            self.assertTrue(points)
            self.assertLessEqual(max(abs(c) for p in points for c in p),0.501)
    def test_current_release_manifest(self):
        obj=json.loads((ROOT/'build/release-manifest.json').read_text())
        self.assertEqual(obj['version'],'26.0.0')
        self.assertEqual(obj['mode'],'WORLD_STUB')
        self.assertIn('KinCity_Installation_Directe_v26.luau',obj['artifacts'])
        self.assertIn('KinCity_Installer_CommandBar.luau',obj['artifacts'])
    def test_no_network_in_new_modules(self):
        for name in ['StudioAssetLibraryV24.luau','InstitutionFacadeKitV24.luau',
                     'InstitutionStagecraftV24.luau','CrystalLandingsV24.luau']:
            code=(S/name).read_text()
            for needle in ['HttpService','DataStoreService','OnServerEvent']:
                self.assertNotIn(needle,code)

if __name__=='__main__':unittest.main()
