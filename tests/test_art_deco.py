"""Behavioral policy, catalog mutations, syntax and snapshot continuity; no Studio claims."""
import copy, hashlib, json, re, shutil, sys, tempfile, unittest
from pathlib import Path
from lupa import LuaRuntime
from tree_sitter import Language, Parser
import tree_sitter_luau
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from art_deco_catalog import load_art_deco
from export_roblox import export, build_fingerprint
from compile_plan import compile_plan
from make_universe_recovery_installer import generate

class ArtDecoTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data=load_art_deco(ROOT)
        cls.lua=LuaRuntime(unpack_returned_tuples=True)
        cls.policy=cls.lua.execute((ROOT/'src/server/ArtDecoPolicy.luau').read_text())
    def table(self,value): return self.lua.table_from(value,recursive=True)
    def test_inventory_and_used_materials(self):
        m=self.data['manifest']; assets=m['assets']
        self.assertEqual(len(assets),121)
        self.assertEqual(sum(x['triangles_mesh_definitions'] for x in assets),522275)
        self.assertEqual(sum('KC32_ACCENT' in x['used_material_roles'] for x in assets),56)
        self.assertEqual({x['category'] for x in assets},set(m['categories']))
        self.assertTrue(all(a['roblox_asset_id'] is None for a in assets))
    def test_exact_sector_accents(self):
        code=(ROOT/'src/shared/HexagonalDistricts.luau').read_text()
        colors={key:tuple(map(int,rgb.split(','))) for key,rgb in re.findall(r'key="([a-z]+)"[^}]*?color=Color3.fromRGB\(([^)]+)\)',code)}
        self.assertEqual(colors,{'keenkonnect':(208,191,134),'ethikos':(169,124,79),'kreative':(203,128,157),'uckk':(117,142,166),'ekole':(229,234,231),'konnected':(188,103,76)})
        self.assertIn('SignTheme.palettes[section.key].accent=section.color',(ROOT/'src/shared/SignTheme.luau').read_text())
    def test_target_policy(self):
        c=copy.deepcopy(self.data['config']); c['test_place_id']=123
        c=self.table(c)
        for place,marked,expected in [(72097868581669,True,False),(123,True,True),(123,False,False),(456,True,False),(0,True,True),(0,False,False)]:
            self.assertEqual(self.policy.isTestTarget(place,marked,c),expected)
        c.allow_local_test=False
        self.assertFalse(self.policy.isTestTarget(0,True,c))
        c.test_place_id=72097868581669
        self.assertFalse(self.policy.isTestTarget(72097868581669,True,c))
    def test_budget_boundary_and_each_dimension(self):
        used={'triangles':10,'parts':2,'clones':1}; limit={'triangles':20,'parts':4,'clones':2}
        cost={'triangles':10,'parts':2,'clones':1}
        self.assertTrue(self.policy.canSpend(self.table(used),self.table(cost),self.table(limit)))
        for dimension in limit:
            excessive=dict(cost); excessive[dimension]+=1
            self.assertFalse(self.policy.canSpend(self.table(used),self.table(excessive),self.table(limit)))
    def test_uniform_fit_preserves_envelope(self):
        size={'X':10,'Y':20,'Z':8}; box={'X':6,'Y':15,'Z':3}
        scale=self.policy.fitScale(self.table(size),self.table(box))
        self.assertAlmostEqual(scale,.375)
        for axis in size:self.assertLessEqual(size[axis]*scale,box[axis])
        size['Y']=0
        self.assertAlmostEqual(self.policy.fitScale(self.table(size),self.table(box)),.375)
        self.assertIsNone(self.policy.fitScale(self.table({'X':0,'Y':0,'Z':0}),self.table(box)))
    def test_snapshot_contracts_unchanged(self):
        fixture=json.loads((ROOT/'tests/fixtures/art_deco_invariants.json').read_text())
        for path,expected in fixture['unchanged'].items():
            self.assertEqual(hashlib.sha256((ROOT/path).read_bytes()).hexdigest(),expected,path)
        self.assertEqual(compile_plan(ROOT)['canonical_sha256'],fixture['canonical_plan_sha256'])
    def test_palette_changes_affect_build_identity(self):
        with tempfile.TemporaryDirectory() as d:
            root=Path(d); (root/'src/shared').mkdir(parents=True)
            p=root/'src/shared/HexagonalDistricts.luau';p.write_text('first')
            first=build_fingerprint(root,'plan')['sha256'];p.write_text('second')
            self.assertNotEqual(first,build_fingerprint(root,'plan')['sha256'])
    def test_catalog_rejects_invalid_recipes_and_target(self):
        with tempfile.TemporaryDirectory() as d:
            root=Path(d)
            for folder in ('catalog','config'):shutil.copytree(ROOT/folder,root/folder)
            path=root/'catalog/art_deco_placements.json';data=json.loads(path.read_text())
            data['street']['bench']['asset']='missing';path.write_text(json.dumps(data))
            with self.assertRaisesRegex(ValueError,'unknown prop'):load_art_deco(root)
            shutil.copyfile(ROOT/'catalog/art_deco_placements.json',path)
            path=root/'config/art_deco.json';data=json.loads(path.read_text());data['test_place_id']=72097868581669;path.write_text(json.dumps(data))
            with self.assertRaisesRegex(ValueError,'invalid test PlaceId'):load_art_deco(root)
    def test_installer_guards_precede_first_wipe_and_preserve_library(self):
        code=(ROOT/'installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau').read_text()
        first_wipe=code.index('wipe(workspace,')
        self.assertLess(code.index('game.PlaceId~=artDecoTarget.production_place_id'),first_wipe)
        self.assertLess(code.index('KinArtDecoTestPlace'),first_wipe)
        self.assertLess(code.index('PlaceId de test non configure'),first_wipe)
        self.assertNotIn('wipe(game:GetService("ServerStorage")',code)
        self.assertNotIn('PublishPlace',code)
    def test_release_is_reproducible_and_respects_root(self):
        with tempfile.TemporaryDirectory() as d:
            root=Path(d)
            for folder in ('catalog','config','schemas','src'):shutil.copytree(ROOT/folder,root/folder)
            first=generate(root);self.assertTrue(first.is_relative_to(root));a=first.read_bytes()
            generate(root);self.assertEqual(a,first.read_bytes())
    def test_all_runtime_installer_and_studio_syntax(self):
        parser=Parser(Language(tree_sitter_luau.language()))
        for p in list((ROOT/'src').rglob('*.luau'))+list((ROOT/'installer').glob('*.luau'))+list((ROOT/'studio').glob('*.luau')):
            self.assertFalse(parser.parse(p.read_bytes()).root_node.has_error,str(p))
if __name__=='__main__':unittest.main()
