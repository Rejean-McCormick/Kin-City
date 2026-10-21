"""Séparation effective du monde en neuf installateurs offline, sans Roblox Studio.
Ces tests vérifient les frontières et manifestes, pas une téléportation publiée.
"""
from pathlib import Path
import sys
import json
import re
import unittest
import tempfile
import shutil

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from make_studio_installer import generate
from export_roblox import export

KEYS=['city','city_hall','ekoh_tower','library','campus','justice_palace','innovation_lab','museum','orgo_center']
class SplitPlaceContracts(unittest.TestCase):
    def test_nine_independent_installers(self):
        manifest=json.loads((ROOT/'build/release-manifest.json').read_text())
        self.assertEqual(manifest['version'],'30.0.7')
        self.assertEqual(set(manifest['place_installers']),set(KEYS))
        for key in KEYS:
            name=manifest['place_installers'][key]
            path=ROOT/name
            self.assertTrue(path.is_file())
            script=path.read_text()
            self.assertIn('SPLIT_PREVIEW',script)
            # Each installer specifies only its own target; the other Places are
            # declared in global door catalog but not as this runtime target.
            self.assertIn('["target_place_key"] = "'+key+'"',script)
            self.assertIn('require(server:WaitForChild("WorldBuilder")).build()',script)
    def test_fallback_legacy_local_is_still_available(self):
        main=(ROOT/'KinCity_Installation_Directe_v30.luau').read_bytes()
        city=(ROOT/'KinCity_Installation_Place_city_v30.luau').read_bytes()
        self.assertEqual(main,city)
        local=(ROOT/'KinCity_Installation_Univers_Local_v30.luau').read_text()
        self.assertIn('LOCAL_UNIVERSE',local)
        self.assertNotIn('["target_place_key"]',local)
    def test_split_generates_only_place_content(self):
        world=(ROOT/'src/server/WorldBuilder.luau').read_text()
        self.assertIn('active=="city"',world)
        self.assertIn('place.place_key==active',world)
        self.assertIn('KinActivePlace',world)
        self.assertIn('KinSeparatedWorld',world)
        self.assertIn('PlacePortalsV26.decorate(',world)
        self.assertIn('KinCanonicalDoorCount',world)
        init=(ROOT/'src/server/init.server.luau').read_text()
        self.assertIn('state.currentPlace=="city"',init)
        self.assertLess(init.index('if state.mode=="LOCAL_UNIVERSE" or state.currentPlace=="city" then'),init.index('Citizens.start(state.world)'))
    def test_teleport_stays_disabled_without_published_ids(self):
        player=(ROOT/'src/server/PlayerTravel.luau').read_text()
        self.assertIn('Spatial.mode()=="SPLIT_PREVIEW"',player)
        self.assertIn('TeleportService:TeleportAsync(',player)
        self.assertIn('TravelSession.finish(player,token)',player)
        runtime=json.loads((ROOT/'config/runtime.json').read_text())
        self.assertEqual(runtime['mode'],'LOCAL_UNIVERSE')
        ids=json.loads((ROOT/'config/place_ids.json').read_text())
        self.assertEqual(set(ids),set(KEYS))
        self.assertTrue(all(v is None for v in ids.values()))
    def test_published_generation_is_guarded(self):
        with self.assertRaisesRegex(ValueError,'published PlaceIds'):
            generate(ROOT,place_key='library',preview=False)
        with self.assertRaisesRegex(ValueError,'Unknown place_key'):
            generate(ROOT,place_key='does-not-exist')
    def test_each_place_has_return_door_and_spawn(self):
        plan=json.loads((ROOT/'build/world-plan.json').read_text())
        doors=plan['doors'];places={p['place_key']:p for p in plan['places']}
        for key in KEYS[1:]:
            entry=[d for d in doors if d['source_place_key']=='city' and d['destination_place_key']==key]
            exit=[d for d in doors if d['source_place_key']==key and d['destination_place_key']=='city']
            self.assertEqual(len(entry),1,key)
            self.assertEqual(len(exit),1,key)
            self.assertEqual(entry[0]['return_door_id'],exit[0]['door_id'])
            self.assertIn(entry[0]['destination_anchor_id'],{a['anchor_id'] for a in places[key]['anchors'] if a['role']=='spawn'})
    def test_published_generation_with_fixture_ids_only(self):
        # Synthetic positive test in a disposable tree. NEVER exported to release.
        with tempfile.TemporaryDirectory() as td:
            target=Path(td)/'fixture'
            target.mkdir()
            for folder in ('tools','schemas','catalog','config','src'):
                shutil.copytree(ROOT/folder,target/folder)
            ids={key:84000000+i for i,key in enumerate(KEYS)}
            (target/'config/place_ids.json').write_text(json.dumps(ids))
            cfg=json.loads((target/'config/runtime.json').read_text())
            cfg['mode']='MULTI_PLACE'
            (target/'config/runtime.json').write_text(json.dumps(cfg))
            installer=generate(target,place_key='library',preview=False)
            text=installer.read_text()
            self.assertIn('["mode"] = "MULTI_PLACE"',text)
            self.assertIn('["target_place_key"] = "library"',text)
            self.assertIn('["library"] = 84000003',text)
            self.assertNotIn('["mode"] = "SPLIT_PREVIEW"',text)

    def test_zone_manifest_disjoint_and_consistent(self):
        payload=json.loads((ROOT/'build/place-package-plan.json').read_text())
        self.assertEqual({p['place_key'] for p in payload['packages']},set(KEYS))
        self.assertEqual(sum(p['canonical_doors'] for p in payload['packages']),16)
        for package in payload['packages']:
            if package['place_key']=='city':
                self.assertTrue(package['generates_city'])
                self.assertFalse(package['generates_institution_interior'])
            else:
                self.assertFalse(package['generates_city'])
                self.assertTrue(package['generates_institution_interior'])
        self.assertFalse(payload['preview_has_interplace_teleportation'])

    def test_city_ui_not_forced_on_interiors(self):
        ui=(ROOT/'src/client/init.client.luau').read_text()
        self.assertIn('if isCity then',ui)
        self.assertIn('require(script.PlaceIdentityHudV26).start()',ui)
        self.assertIn('require(script.MapHud).start()',ui)
        self.assertIn('require(script.GalleryJournalV22).start()',ui)
    def test_portal_decoration_is_local_and_nonblocking(self):
        code=(ROOT/'src/server/PlacePortalsV26.luau').read_text()
        for key in ('CanCollide=false','CanTouch=false','CanQuery=false','KinPortalBoundary','PLACE DISTINCTE'):
            self.assertIn(key,code)

if __name__=='__main__': unittest.main()
