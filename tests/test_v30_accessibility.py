"""V30 offline contracts. Static checks only: no Roblox rendering or device execution."""
import hashlib
import json
import re
import unittest
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]


def text(rel):
    return (ROOT/rel).read_text(encoding='utf8')


class NavigationV30(unittest.TestCase):
    def test_canonical_navigation_and_building_ids_unchanged(self):
        hashes=json.loads(text('docs/v29_baseline_sha256.json'))
        for name, expected in hashes.items():
            with self.subTest(name=name):
                self.assertEqual(hashlib.sha256((ROOT/name).read_bytes()).hexdigest(), expected)
        plan=json.loads(text('build/world-plan.json'))
        self.assertEqual(len(plan['structures']), 8)
        self.assertEqual(len(plan['places']), 9)
        self.assertEqual(len(plan['pedestrian_paths']), 8)

    def test_route_projects_along_path_not_through_destination(self):
        guide=text('src/client/RouteGuide.luau')
        for token in ('after[i+1]+segmentLength', 'remaining=gap+(1-t)*math.sqrt(lengthSq)+after[i]',
                      'nextTarget=if gap>18 then projected', 'local remaining=routeRemaining or distance',
                      'Distance directe indicative', 'Distance sur le chemin'):
            self.assertIn(token, guide)
        self.assertNotIn('selected=sorted[1]', guide)

    def test_destinations_eight_main_first_filter_and_clear(self):
        guide=text('src/client/RouteGuide.luau')
        for token in ('for _,b in ipairs(Buildings)', 'mainIds[a.building_id]',
                      'search:GetPropertyChangedSignal("Text")', 'string.find(string.lower(caption)',
                      'clear.Activated:Connect(clearDestination)', 'filteredCount==0'):
            self.assertIn(token, guide)

    def test_optional_library_guide_respects_dismissal(self):
        guide=text('src/client/LibraryJourneyGuide.luau')
        for token in ('local dismissed=false', 'not dismissed and mode~="route"',
                      'dismissed=not enabled', 'dismissed=true', 'stations[id] or stations.welcome'):
            self.assertIn(token, guide)


class AccessibilityV30(unittest.TestCase):
    def test_menu_search_fits_small_screens_and_selects_controller_focus(self):
        menu=text('src/client/KinCityMenu.luau')
        for token in ('searchBox:GetPropertyChangedSignal("Text")', 'layout.AbsoluteContentSize.Y',
                      'GuiService.SelectedObject', 'if UIS:GetFocusedTextBox() then return end',
                      'Menu.closeTools()', 'ViewportSize', 'constraint.MinSize=Vector2.zero',
                      'Fermer l\'outil', 'GetPropertyChangedSignal("Visible")'):
            self.assertIn(token, menu)
        self.assertIn('local function showOnly(key)', menu)
        self.assertIn('if e.key~=key and e.window then e.window.Visible=false end', menu)

    def test_probe_local_no_network_and_interruptible(self):
        probe=text('src/client/LocalPerformanceProbeV29.luau')
        for token in ('local started=time()', 'lastDisplay>=0.4', 'if busy then',
                      'measurementConnection:Disconnect()', 'GetPropertyChangedSignal("Visible")',
                      'if not panel.Visible and busy', 'Temps/image p95', 'KinCityLocalQuality'):
            self.assertIn(token, probe)
        for forbidden in ('HttpService', 'FireServer', 'DataStoreService', 'TeleportService'):
            self.assertNotIn(forbidden, probe)


class BuildV30(unittest.TestCase):
    def test_separate_8_interiors_and_city_and_all_in_one(self):
        registry=json.loads(text('config/place_ids.json'))
        self.assertEqual(len(registry),9)
        for key in registry:
            rel=f'KinCity_Installation_Place_{key}_v30.luau'
            self.assertTrue((ROOT/rel).exists(), rel)
            payload=text(rel)
            self.assertIn('KinCityMenuV30', payload)
            self.assertIn('Rechercher une destination', payload)
            self.assertIn('local started=time()',payload)
        self.assertEqual((ROOT/'KinCity_Installation_Directe_v30.luau').read_bytes(),
                         (ROOT/'KinCity_Installation_Place_city_v30.luau').read_bytes())
        self.assertTrue((ROOT/'KinCity_Installation_Univers_Local_v30.luau').exists())
        self.assertEqual(json.loads(text('build/release-manifest.json'))['version'], '30.0.7')


if __name__=='__main__':
    unittest.main()
