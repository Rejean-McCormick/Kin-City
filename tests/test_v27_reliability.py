"""Behavioral offline regressions; pure Lua store runs without Roblox services."""
import json
import sys
import tempfile
import unittest
from pathlib import Path
from shutil import copytree
from lupa import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from make_studio_installer import generate
from make_king_klown_installer import generate_avatar

class PendingTravelBehavior(unittest.TestCase):
    def setUp(self):
        self.lua=LuaRuntime(unpack_returned_tuples=True)
        module=self.lua.execute((ROOT/'src/server/PendingTravel.luau').read_text())
        self.store=module.new()
    def request(self,n): return self.lua.table_from({'id':n,'targetId':123})
    def test_duplicate_is_rejected_without_overwriting(self):
        self.assertTrue(self.store.begin('alice',self.request(1)))
        self.assertFalse(self.store.begin('alice',self.request(2)))
        self.assertEqual(self.store.get('alice')['id'],1)
    def test_stale_failure_keeps_new_request(self):
        self.store.begin('alice',self.request(1));self.store.take('alice',1)
        self.store.begin('alice',self.request(2))
        self.assertIsNone(self.store.take('alice',1))
        self.assertEqual(self.store.get('alice')['id'],2)
    def test_timeout_releases_only_matching_request(self):
        self.store.begin('alice',self.request(1))
        self.assertEqual(self.store.take('alice',1)['id'],1)
        self.assertTrue(self.store.begin('alice',self.request(2)))
    def test_players_are_isolated(self):
        self.store.begin('alice',self.request(1));self.store.begin('bob',self.request(2))
        self.store.clear('alice')
        self.assertIsNone(self.store.get('alice'))
        self.assertEqual(self.store.get('bob')['id'],2)
    def test_completion_is_idempotent(self):
        self.store.begin('alice',self.request(1));self.store.take('alice',1)
        self.assertIsNone(self.store.take('alice',1))

class InstallerRegression(unittest.TestCase):
    def test_local_fallback_stays_local_with_published_config(self):
        with tempfile.TemporaryDirectory() as td:
            root=Path(td)
            for folder in ('tools','schemas','catalog','config','src'): copytree(ROOT/folder,root/folder)
            ids=json.loads((root/'config/place_ids.json').read_text())
            (root/'config/place_ids.json').write_text(json.dumps({key:84000000+i for i,key in enumerate(ids)}))
            (root/'config/runtime.json').write_text('{"mode":"MULTI_PLACE"}')
            text=generate(root).read_text()
            self.assertIn('["mode"] = "LOCAL_UNIVERSE"',text)
            self.assertNotIn('["target_place_key"]',text)
    def test_avatar_embeds_exact_canonical_sources(self):
        text=generate_avatar(ROOT).read_text()
        for file in ('src/server/KingKlownAvatar.luau','src/client/KingKlownAura.luau'):
            self.assertIn((ROOT/file).read_text(),text)
        self.assertNotIn('WorldBuilder',text)
        first=text
        self.assertEqual(first,generate_avatar(ROOT).read_text())
