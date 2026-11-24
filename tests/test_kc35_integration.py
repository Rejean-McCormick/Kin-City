"""KC35 offline regression for runtime wiring, manifest hashes and scope safety."""
import hashlib,json,sys,tempfile,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from b09_bundle_branches import SOURCES,generate as bundle
from b09_staging_audit import self_test
from b09_contracts import baseline_report
from build_staging_kc35 import NEEDLE,REPLACE

class KC35Runtime(unittest.TestCase):
    def test_01_all_nine_branch_constructs_bound(self):
        source=(ROOT/'src/server/BranchRuntime.luau').read_text()
        for name in ['B01CityHallScene','B02EkohInterior','B03LibraryScene','B04CampusDecor',
                     'B05KorumPreview','B06KonstructScene','B07MuseumScene','B08OrgoScene','B10Wayfinding']:
            self.assertIn('script.Parent.'+name,source)
        self.assertIn('KinBranchRuntimeState',source)
        self.assertIn('KinBranchReadyCount',source)
        self.assertIn('KinBuildState',source)
    def test_02_bootstrap_after_world_builder(self):
        code=(ROOT/'src/server/init.server.luau').read_text()
        self.assertLess(code.index('WorldBuilder.build(true)'),code.index('BranchRuntime).apply(state)'))
        self.assertLess(code.index('BranchRuntime).apply(state)'),code.index('PlayerTravel.setup'))
    def test_03_every_bundle_is_reproducible(self):
        before={name:hashlib.sha256((ROOT/'src/server'/(name+'.luau')).read_bytes()).hexdigest() for name in SOURCES}
        bundle(ROOT)
        after={name:hashlib.sha256((ROOT/'src/server'/(name+'.luau')).read_bytes()).hexdigest() for name in SOURCES}
        self.assertEqual(before,after)
    def test_04_real_installer_contains_all_dependencies(self):
        text=(ROOT/'installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau').read_text()
        for name in list(SOURCES)+['BranchRuntime','MuseumBroadcastBarrier']:
            self.assertIn('source(server,"'+name+'",',text)
        self.assertIn('require(server:WaitForChild("BranchRuntime")).apply(state)',text)
        self.assertIn('require(server:WaitForChild("MuseumBroadcastBarrier")).start()',text)
    def test_05_staging_editor_adapter_present(self):
        self.assertIn('BranchRuntime',REPLACE)
        self.assertIn('WorldBuilder',NEEDLE)
    def test_06_staging_synthetic_ids_regression(self):
        self.assertEqual(self_test(ROOT),[])
    def test_07_no_mutation_to_23_frozen_files(self):
        report=baseline_report(ROOT,ROOT/'reference_KC34')
        self.assertEqual(report['status'],'PASS',report['failures'])
        self.assertEqual(report['locked_files_verified'],23)
    def test_08_b08_rebased_and_old_preview_archived(self):
        d=json.loads((ROOT/'contrib/places/orgo_center/scene_recipe_KC33.json').read_text())
        self.assertEqual(d['source_baseline'],'KC33')
        self.assertEqual(len(d['rooms']),6)
        self.assertEqual(len(d['decorations']),24)
        self.assertTrue((ROOT/'contrib/places/orgo_center/studio/B08_STUDIO_PREVIEW_LOCAL.luau').is_file())
        self.assertIn('B08_OrgoDecor_KC33',(ROOT/'contrib/places/orgo_center/OrgoScene.luau').read_text())
    def test_09_b08_asset_status_reconciled(self):
        contexts={x['asset_key']:x['status'] for x in json.loads((ROOT/'catalog/art_deco_contexts.json').read_text())['assets']}
        plan=json.loads((ROOT/'contrib/places/orgo_center/asset_plan_KC33.json').read_text())
        self.assertTrue(all(x['kc33_manifest_status']==contexts[x['asset_key']] for x in plan['items']))
    def test_10_b07_locked_server_side_and_noncolliding_decoration(self):
        code=(ROOT/'src/server/PromptRouter.luau').read_text()
        self.assertIn('record.data.door_id=="city.kreative.museum.entry"',code)
        barrier=(ROOT/'src/server/MuseumBroadcastBarrier.luau').read_text()
        self.assertIn('child.Enabled=false',barrier)
        self.assertIn('cinema:PivotTo',barrier)
        self.assertIn('KinVideoAssetId',barrier)
        self.assertIn('BROADCAST YOUTUBE',barrier)
        source=(ROOT/'contrib/places/museum/MuseumScene.luau').read_text()
        self.assertIn('KinB07Revision',source)
        self.assertIn('Enum.Material.SmoothPlastic,false',source)
    def test_11_no_made_up_place_ids(self):
        d=json.loads((ROOT/'config/place_ids.json').read_text())
        self.assertEqual(len(d),9)
        self.assertTrue(all(x is None for x in d.values()))
    def test_12_single_place_and_staging_guard(self):
        local=(ROOT/'tools/build_imported_test_installer.py').read_text()
        self.assertIn('assert(game.PlaceId==0',local)
        staging=(ROOT/'tools/build_staging_kc35.py').read_text()
        self.assertIn('read_ids(ids,root)',staging)
        self.assertIn('MuseumBroadcastBarrier',staging)

if __name__=='__main__':unittest.main(verbosity=2)
