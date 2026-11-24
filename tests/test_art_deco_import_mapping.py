"""Exercise the generated resolver against the actual Studio import report."""
import json
import unittest
from pathlib import Path
from lupa import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]


class ImportMappingTests(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.records = json.loads((ROOT / 'catalog/art_deco_studio_imports.json').read_text())['records']
        expected = {a['asset_key']: a['source_name'] for a in json.loads(
            (ROOT / 'catalog/art_deco_assets.json').read_text())['assets']}
        self.lua.globals().expected = self.lua.table_from(expected)
        self.lua.globals().config = self.lua.table_from({'library_name': 'KinCityArtDecoLibrary'})
        self.node = self.lua.eval('''function(name, class)
            return {Name=name, IsA=function(self, wanted) return class==wanted end, GetAttribute=function() return nil end}
        end''')
        self.root = self.lua.eval('''function(nodes, children)
            return {GetDescendants=function() return nodes end,
                GetFullName=function() return "Fixture" end,
                FindFirstChild=function(self,name) return children[name] end}
        end''')
        self.nodes = [self.node(n['name'], n['class']) for r in self.records for n in r['nodes']]
        code = (ROOT / 'studio/PrepareArtDecoLibrary.luau').read_text()
        self.resolver = code[code.index('local function keyFor'):code.index('-- Validate the entire selection')]

    def surface(self, nodes, children=None):
        return self.root(self.lua.table_from(nodes), self.lua.table_from(children or {}))

    def resolve(self, workspace_nodes, storage_children=None):
        # The empty historical folder must not hide Workspace.AD_Assets wrappers.
        self.lua.globals().workspace = self.surface(workspace_nodes, {
            'KinCityArtDecoImports': self.surface([])})
        self.lua.globals().storage = self.surface([], storage_children)
        return self.lua.execute(self.resolver + '\nreturn sources')

    def test_all_121_wrappers_resolve_despite_empty_import_folder(self):
        self.assertEqual(len(list(self.resolve(self.nodes).keys())), 121)

    def test_archived_originals_resolve_on_rerun(self):
        self.assertEqual(len(list(self.resolve([], {
            'KC_ARTDECO_V32_SOURCES': self.surface(self.nodes)}).keys())), 121)

    def test_existing_library_resolves_if_no_originals_remain(self):
        self.assertEqual(len(list(self.resolve([], {
            'KinCityArtDecoLibrary': self.surface(self.nodes)}).keys())), 121)

    def test_reinstallation_ignores_existing_generated_street_models(self):
        generated=self.node('KinCityGenerated','Folder')
        nodes=[]
        for _ in range(3):
            lamp=self.node('KC32__AD_Ext_Streetlamp','Model')
            lamp.Parent=generated;nodes.append(lamp)
        self.assertEqual(len(list(self.resolve(nodes, {
            'KC_ARTDECO_V32_SOURCES': self.surface(self.nodes)}).keys())),121)

    def test_duplicate_named_asset_is_rejected(self):
        with self.assertRaisesRegex(Exception, 'Ambiguous imported model'):
            self.resolve(self.nodes + [self.node('AD_Ext_Bench.001', 'Model')])

    def test_partial_workspace_import_does_not_mix_with_old_library(self):
        with self.assertRaisesRegex(Exception, 'Missing imported sources'):
            self.resolve([self.node('AD_Ext_Bench.001', 'Model')], {
                'KinCityArtDecoLibrary': self.surface(self.nodes)})

    def test_observed_mesh_ids_are_complete(self):
        meshes = [n for r in self.records for n in r['nodes'] if n['class'] == 'MeshPart']
        self.assertEqual(len(meshes), 463)
        self.assertEqual(len({n['meshId'] for n in meshes}), 463)
        for mesh in meshes:
            self.assertRegex(mesh['meshId'], r'^rbxassetid://[1-9]\d*$')
