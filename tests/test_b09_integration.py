"""B09 contract gate: positive and adversarial checks, no Roblox runtime."""
import copy,hashlib,json,sys,tempfile,unittest
from pathlib import Path

REPO=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(REPO/'tools'))
import b09_contracts as gate
import b09_recipes

BASELINE_SHA='1fd3968977823a8814f54f766164c85e02cda3e370df984455f8c3f7db877c89'
REFERENCE=REPO/'reference_KC34'

class Contracts(unittest.TestCase):
    def test_01_baseline_immutable_and_logical_plan(self):
        # Baseline files are unchanged in B09; new tools/contrib are separate.
        report=gate.baseline_report(REPO,REFERENCE)
        self.assertEqual(report['status'],'PASS',report['failures'])
        self.assertEqual(report['locked_files_verified'],23)
        self.assertEqual(report['counts']['doors'],16)
        self.assertEqual(report['counts']['anchors'],49)
        self.assertEqual(report['compiled_plan_sha256'],'5941cd6ecd89ea806cd5b815fcc128b1abef1cff77f77d670dbe01c7f487039a')
    def test_02_extended_bounds_are_detected(self):
        observed=gate.effective_room_bounds(REPO)
        self.assertEqual(len(observed),8)
        for x in observed.values():
            self.assertFalse(x['catalog_covers_runtime'])
            self.assertEqual(x['actual_aabb_xz'],[-105.0,105.0,-46.0,104.0])
            self.assertEqual(x['suggested_centered_size_xz'],[230,228])
    def test_03_contribution_contracts(self):
        self.assertEqual(b09_recipes.check(REPO),[])
    def test_04_path_guards_reject_traversal(self):
        for s in ['../file','/tmp/file','a/../../file','C:/windows','x\\other']:
            with self.subTest(s=s),self.assertRaises(ValueError):gate.relative_path(s)
    def test_05_reciprocal_door_mutation_detected(self):
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp);(root/'catalog').mkdir()
            doors=json.loads((REPO/'catalog/doors.json').read_text())
            doors['doors'][0]['return_door_id']='not.there'
            (root/'catalog/doors.json').write_text(json.dumps(doors))
            # Instead of copying the entire repo, exercise the door reciprocity branch
            # through a temporary copy with hardlinks to unmodified catalogs.
            for name in ['places','spatial','art_deco_contexts','districts']:
                (root/f'catalog/{name}.json').symlink_to(REPO/f'catalog/{name}.json')
            (root/'src/shared').mkdir(parents=True)
            (root/'src/shared/HexagonalDistricts.luau').symlink_to(REPO/'src/shared/HexagonalDistricts.luau')
            errors,_=gate.count_lock(root)
            self.assertTrue(any('non réciproque' in msg for msg in errors))

class Handoffs(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.path=Path(self.temp.name)
        (self.path/'contrib/places/library').mkdir(parents=True)
        self.rel='contrib/places/library/recipe.json'
        file=self.path/self.rel
        file.write_text('{"modified":true}\n')
        self.handoff={'schema_version':'kincity.handoff/1.0','branch_id':'B03','place_key':'library',
          'baseline':'KC33','baseline_sha256':BASELINE_SHA,'contracts_version':'KC34-DOC-1.0',
          'change_class':'LOCAL','changed_files':[{'path':self.rel,'sha256':gate.digest(file)}],
          'contract_changes':[],'tests_executed':[{'name':'test_recipe','result':'PASS','evidence':'log/test_recipe.txt'}],
          'tests_not_executed':['Roblox Studio','published teleport'], 'rollback':'Supprimer contribution B03 de la candidate',
          'risk':['Visuel non validé'], 'status':'READY_FOR_REVIEW','needs_approval':[]}
        self.handoff_path=self.path/'handoff.json'
    def validate(self,mutator=None):
        d=copy.deepcopy(self.handoff)
        if mutator:mutator(d)
        self.handoff_path.write_text(json.dumps(d))
        return gate.validate_handoff(self.handoff_path,self.path,BASELINE_SHA)
    def test_06_valid_local_handoff(self):self.assertEqual(self.validate(),[])
    def test_07_wrong_branch_or_place_rejected(self):
        self.assertTrue(any('Branche/Place' in x for x in self.validate(lambda d:d.update(branch_id='B04'))))
    def test_08_wrong_baseline_hash_rejected(self):
        self.assertTrue(any('Empreinte' in x for x in self.validate(lambda d:d.update(baseline_sha256='0'*64))))
    def test_09_tampered_file_rejected(self):
        self.assertTrue(any('Empreinte du patch' in x for x in self.validate(lambda d:d['changed_files'][0].update(sha256='0'*64))))
    def test_10_out_of_scope_rejected(self):
        p=self.path/'contrib/places/campus';p.mkdir(parents=True)
        f=p/'bad.json';f.write_text('{}')
        self.assertTrue(any('Hors périmètre' in x for x in self.validate(lambda d:d['changed_files'][0].update(path='contrib/places/campus/bad.json',sha256=gate.digest(f)))))
    def test_11_missing_test_evidence_rejected(self):
        self.assertTrue(any('PASS sans preuve' in x for x in self.validate(lambda d:d['tests_executed'][0].update(evidence=''))))
    def test_12_shared_changed_unapproved_rejected(self):
        (self.path/'catalog').mkdir()
        f=self.path/'catalog/doors.json';f.write_text('{}')
        errs=self.validate(lambda d:d['changed_files'][0].update(path='catalog/doors.json',sha256=gate.digest(f)))
        self.assertTrue(any('Hors périmètre' in x for x in errs))
        self.assertTrue(any('partagé classé LOCAL' in x for x in errs))
    def test_13_unilateral_accepted_rejected(self):
        self.assertTrue(any('réservé' in x for x in self.validate(lambda d:d.update(status='ACCEPTED'))))
    def test_14_empty_handoff_rejected(self):
        self.assertTrue(any('vide' in x for x in self.validate(lambda d:d.update(changed_files=[]))))
    def test_15_shared_requires_rfc(self):
        errs=self.validate(lambda d:d.update(change_class='SHARED', needs_approval=['B09']))
        self.assertTrue(any('RFC' in x for x in errs))
    def test_16_breaking_requires_adr(self):
        errs=self.validate(lambda d:d.update(change_class='BREAKING',needs_approval=['B09'],rfc_id='RFC-001'))
        self.assertTrue(any('ADR' in x for x in errs))

if __name__=='__main__':unittest.main()

# Kept separate from the 16 primary tests to avoid re-generating large installers
# each time the handoff validation runs.
class StagingGuards(unittest.TestCase):
    def test_17_invalid_ids_prohibited(self):
        import build_staging_places as st
        with tempfile.TemporaryDirectory() as tmp:
            f=Path(tmp)/'ids.json'
            original={k:800000000+i for i,k in enumerate(gate.KEYS)}
            for mutation in ('production','duplicate','bool'):
                ids=original.copy()
                if mutation=='production':ids['city']=st.PRODUCTION_ID
                elif mutation=='duplicate':ids['city']=ids['city_hall']
                else:ids['city']=True
                f.write_text(json.dumps(ids))
                with self.subTest(mutation=mutation),self.assertRaises(ValueError):st.read_ids(f,REPO)
    def test_18_staging_production_consistency(self):
        import b09_staging_audit as audit
        with tempfile.TemporaryDirectory() as tmp:
            ids={k:850000000+i for i,k in enumerate(gate.KEYS)}
            f=Path(tmp)/'ids.json';f.write_text(json.dumps(ids))
            self.assertEqual(audit.audit_ids(f,REPO),ids)

class PatchIntegrity(unittest.TestCase):
    def test_19_hidden_file_in_patch_refused(self):
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp);f=root/'contrib/places/library/recipe.json'
            f.parent.mkdir(parents=True);f.write_text('{}')
            extra=root/'contrib/places/library/secret.luau';extra.write_text('-- hidden')
            handoff={'schema_version':'kincity.handoff/1.0','branch_id':'B03','place_key':'library',
                     'baseline':'KC33','baseline_sha256':BASELINE_SHA,'contracts_version':'KC34-DOC-1.0',
                     'change_class':'LOCAL','changed_files':[{'path':f.relative_to(root).as_posix(),'sha256':gate.digest(f)}],
                     'contract_changes':[],'tests_executed':[{'name':'t','result':'PASS','evidence':'log'}],
                     'tests_not_executed':[],'rollback':'revert','risk':['non runtime'],'status':'READY_FOR_REVIEW'}
            h=root/'handoff.json';h.write_text(json.dumps(handoff))
            errs=gate.validate_handoff(h,root,BASELINE_SHA,strict_patch_tree=True)
            self.assertTrue(any('dissimulé' in m for m in errs))

class RecipeSchema(unittest.TestCase):
    def test_20_nine_manifests_validate_json_schema(self):
        from jsonschema import Draft202012Validator
        schema=json.loads((REPO/'schemas/place_recipe.schema.json').read_text())
        Draft202012Validator.check_schema(schema)
        for key in gate.KEYS:
            recipe=json.loads((REPO/'contrib/places'/key/'recipe.json').read_text())
            with self.subTest(place_key=key):
                Draft202012Validator(schema).validate(recipe)
