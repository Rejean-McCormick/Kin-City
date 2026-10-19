"""Contrats statiques v25. Ces tests ne remplacent pas Roblox Studio."""
from pathlib import Path
import json
import tempfile
import shutil
import unittest

R=Path(__file__).resolve().parents[1]
S=R/'src/server'

class SecondaryArchitecture(unittest.TestCase):
    def test_57_existing_buildings_are_connected(self):
        expected={
            'CommunityBuildings.luau':['SecondaryArchitectureV25.hall(m,cf,"market",color)',
                                       'SecondaryArchitectureV25.hall(m,cf,"community",color)'],
            'PromenadeCommerce.luau':['SecondaryArchitectureV25.boutique(mdl,base,item.kind,tint)'],
            'StationArcades.luau':['SecondaryArchitectureV25.arcade(m,cf,#data.id,tint)'],
            'ResidentialQuarters.luau':['SecondaryArchitectureV25.home(m,base,group.style,groupIndex*4+index)'],
            'MarinaDistrict.luau':['SecondaryArchitectureV25.marina(m,localBase,index)'],
        }
        for source,calls in expected.items():
            text=(S/source).read_text()
            for call in calls:
                with self.subTest(source=source, call=call):self.assertEqual(text.count(call),1)
        self.assertIn('KinV25Facade', (S/'SecondaryArchitectureV25.luau').read_text())
    def test_ornaments_avoid_gameplay_collision_and_use_profiles(self):
        src=(S/'SecondaryArchitectureV25.luau').read_text()
        kit=(S/'CrystalKit.luau').read_text()
        for role in ('hall','boutique','arcade','home','marina'):
            self.assertIn(f'function Architecture.{role}(',src)
        self.assertIn('CanCollide=false',kit)
        self.assertIn('CanTouch=false',kit)
        self.assertIn('CanQuery=false',kit)
        self.assertIn('KinOptionalDetail',src)
        self.assertIn('Kit.profile=="LITE"',src)
        self.assertIn('Kit.profile=="SHOWCASE"',src)
    def test_reused_mesh_or_native_fallback(self):
        code=(S/'ReusableMeshesV23.luau').read_text()
        keys=('opal_lattice','mineral_pediment','harbor_crest')
        manifest=json.loads((R/'config/meshes.json').read_text())
        for key in keys:
            self.assertIn('assetKey=="'+key+'"',code)
            self.assertIn(key,(S/'StudioAssetLibraryV24.luau').read_text())
            self.assertIn(key,manifest)
            self.assertIsNone(manifest[key])
    def test_obj_geometry_is_valid_and_bounded(self):
        for name in ('opal-lattice','mineral-pediment','harbor-crest'):
            lines=(R/'assets/meshes-v25'/(name+'.obj')).read_text().splitlines()
            positions=[tuple(map(float,row.split()[1:])) for row in lines if row.startswith('v ')]
            faces=[tuple(map(int,row.split()[1:])) for row in lines if row.startswith('f ')]
            self.assertGreater(len(faces),30)
            self.assertTrue(all(len(p)==3 and max(map(abs,p))<=.501 for p in positions))
            self.assertTrue(all(1<=k<=len(positions) for face in faces for k in face))
    def test_pbr_library_preserves_existing_appearance(self):
        src=(S/'MaterialLibraryV25.luau').read_text()
        for key in ('sarcelle_pierre','opale_massive','champagne_mineral','pierre_promenoir'):
            self.assertIn(key,src)
        self.assertIn('FindFirstChildOfClass("SurfaceAppearance")',src)
        self.assertIn('profile=="LITE"',src)
        self.assertIn('KinCityMaterialLibrary',src)
        self.assertIn('MaterialLibraryV25.apply(copy,assetKey,Kit.profile)',(S/'StudioAssetLibraryV24.luau').read_text())
        register=(R/'KinCity_Enregistrer_Materiau_Studio_v25.luau').read_text()
        self.assertIn('Selection:Get()',register)
        self.assertIn('source.ColorMap',register)
        self.assertNotIn('HttpService',register)
    def test_new_glazing_is_opaline(self):
        for name in ('CommunityBuildings.luau','PromenadeCommerce.luau','MarinaDistrict.luau'):
            self.assertIn('OpalGlazingV22.apply(', (S/name).read_text())
    def test_diagnostics_are_populated_at_build_completion(self):
        build=(S/'WorldBuilder.luau').read_text()
        diag=(S/'WorldBuildDiagnosticsV25.luau').read_text()
        self.assertEqual(build.count('WorldBuildDiagnosticsV25.capture(world,startClock,VisualConfig.profile)'),1)
        self.assertLess(build.index('WorldBuildDiagnosticsV25.capture('), build.index('world:SetAttribute("KinBuildState","Ready")'))
        for key in ('KinGeneratedParts','KinGeneratedLights','KinGeneratedPrompts','KinGeneratedMaterials','KinBuildSeconds'):
            self.assertIn(key,diag)
        self.assertIn('KinCityGenerated',(R/'KinCity_Diagnostic_Studio_v25.luau').read_text())
    def test_release_v25(self):
        manifest=json.loads((R/'build/release-manifest.json').read_text())
        self.assertEqual(manifest['version'],'26.0.0')
        for artifact in ('KinCity_Installation_Directe_v26.luau','KinCity_Enregistrer_Mesh_Studio_v25.luau',
                         'KinCity_Enregistrer_Materiau_Studio_v25.luau','KinCity_Diagnostic_Studio_v25.luau'):
            self.assertIn(artifact,manifest['artifacts'])
            self.assertTrue((R/artifact).is_file())
        self.assertIn('construction-v26.0.0-', (S/'WorldBuilder.luau').read_text())
    def test_no_kOA_services_added(self):
        for name in ('SecondaryArchitectureV25.luau','MaterialLibraryV25.luau','WorldBuildDiagnosticsV25.luau'):
            code=(S/name).read_text()
            for forbidden in ('HttpService','DataStoreService','OnServerEvent','PostAsync'):
                self.assertNotIn(forbidden,code)

if __name__=='__main__':unittest.main()
