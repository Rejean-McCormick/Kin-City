"""B09 consolidation contracts and provenance; requires no Studio/Roblox."""
import json,sys,unittest
from pathlib import Path
HERE=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(HERE/'tools'))
import b09_verify_consolidation as verify
import b09_contracts as gate

class Consolidation(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.receipt=json.loads((HERE/'docs/B09/consolidation/consolidation_receipt.json').read_text())
        cls.registry=json.loads((HERE/'contrib/SCENE_REGISTRY_KC34.json').read_text())
    def test_01_exact_contribution_counts(self):
        self.assertEqual(len(self.receipt['staged_files']),83)
        self.assertEqual({s['branch'] for s in self.receipt['staged_files']}, {'B01','B02','B03','B04','B05','B06','B07','B08','B10'})
    def test_02_canonical_sources_unchanged(self):
        errors,n=gate.frozen_snapshot(HERE,HERE/'reference_KC34')
        self.assertEqual(errors,[])
        self.assertEqual(n,23)
    def test_03_provenance_all_staged_source_hashes(self):
        errors,n=verify.check()
        self.assertEqual(n,83)
        self.assertEqual(errors,[])
    def test_04_b07_received_and_registered(self):
        self.assertEqual(self.receipt['branches']['B07']['source_status'],'READY_FOR_REVIEW')
        row=next(x for x in self.registry['entries'] if x['branch_id']=='B07')
        self.assertEqual(row['status'],'WIRED_KC35_NOT_STUDIO_VALIDATED')
        self.assertEqual(row['module_path'],'contrib/places/museum/MuseumScene.luau')
    def test_05_b08_rebase_unapproved(self):
        b=self.receipt['branches']['B08']
        self.assertEqual(b['source_baseline'],'V3_ORIGINAL')
        self.assertEqual(b['integration_status'],'REBASED_KC33_AND_KC35_RUNTIME_WIRED_PENDING_STUDIO')
    def test_06_b06_old_source_dependency_disclosed(self):
        self.assertIn('B06_TESTS_REFERENCE_EMBEDDED_V3_ORIGINAL_NOT_KC33',self.receipt['branches']['B06']['issues'])
    def test_07_runtime_loader_wired_not_studio_approved(self):
        self.assertTrue(self.registry['runtime_loader_enabled'])
        self.assertTrue(all(e['runtime_enabled'] for e in self.registry['entries']))
        self.assertEqual(self.registry['studio_validation'],'NOT_PERFORMED')
    def test_08_all_provided_modules_exist(self):
        for e in self.registry['entries']:
            if e['module_path'] is not None:
                self.assertTrue((HERE/e['module_path']).is_file(),e['branch_id'])
    def test_09_heterogeneous_signatures_block_direct_calls(self):
        sigs={e['entrypoint'] for e in self.registry['entries'] if e['entrypoint']}
        self.assertGreaterEqual(len(sigs),7)
    def test_10_nine_places_and_ten_branches(self):
        self.assertEqual(len(self.registry['entries']),9)
        self.assertEqual(len(set(x['place_key'] for x in self.registry['entries'])),9)
        self.assertEqual(set(x['branch_id'] for x in self.registry['entries']),set('B%02d'%i for i in range(1,9))|{'B10'})

if __name__=='__main__':unittest.main()
