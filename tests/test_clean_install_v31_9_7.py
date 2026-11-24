"""Clean repo and wipe installer invariants, static only (not Roblox execution)."""
import unittest,re,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
INSTALLER=ROOT/'installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau'
class CleanInstall(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.code=INSTALLER.read_text('utf-8')
        cls.builder=(ROOT/'tools/make_universe_recovery_installer.py').read_text('utf-8')
    def test_single_official_installer(self):
        self.assertEqual([p.name for p in (ROOT/'installer').glob('*INSTALLATION_TOTALE*.luau')],['KinCity_INSTALLATION_TOTALE_v31_9_7.luau'])
        self.assertFalse(list(ROOT.glob('*.luau')))
    def test_no_historical_deliverables_in_root(self):
        self.assertFalse(list(ROOT.glob('INSTALLATION_V*.md')))
        self.assertFalse((ROOT/'archives').exists())
    def test_guard_play(self):
        self.assertIn('assert(not game:GetService("RunService"):IsRunning()',self.code)
    def test_wipe_core_instances_before_regeneration(self):
        for name in ('KinCityGenerated','KinCityOutdoorCinema','KinCityShared','KinCityReply','KinCityBuildRPC','KinCityTricksterCast','KinCityRuntime','KinCityKingKlownAvatar','KinCityUI','KinCityAtmosphere'):
            self.assertIn(name,self.code)
        self.assertLess(self.code.find('wipe(workspace,'),self.code.find('source(shared,'))
    def test_no_old_asset_id_merge(self):
        self.assertNotIn('preservedMusicSource',self.code)
        self.assertIn('128763700452308',self.code)
        self.assertIn('113300141047037',self.code)
    def test_expected_module_count(self):
        # 29 shared + 125 server (minus init) + 32 client (minus init)
        self.assertEqual(self.code.count('source(shared,'),len(list((ROOT/'src/shared').glob('*.luau'))))
    def test_world_and_interiors_verified(self):
        self.assertIn('world:GetAttribute("KinBuildState")=="Ready"',self.code)
        for name in ['campus','city_hall','ekoh_tower','innovation_lab','justice_palace','library','museum','orgo_center']:
            self.assertIn(name,self.code)
    def test_branding_and_player(self):
        self.assertIn('OuterRule',self.code)
        self.assertIn('KinCityMusicPlayerV31_9_6',self.code)
        self.assertIn('MUSIQUE',self.code)
    def test_media_count(self):
        inv=json.loads((ROOT/'catalog/music_inventory_current.json').read_text('utf-8'))
        self.assertEqual(inv['summary']['total_mp3'],49)
        ids=re.findall(r'\["(kin_track_[a-f0-9]+)"\]\s*=\s*(\d+)',(ROOT/'src/shared/MusicAssetIds.luau').read_text('utf8'))
        self.assertEqual(len(ids),49)
        self.assertEqual(sum(int(x)>0 for _,x in ids),48)
    def test_single_place_mode(self):
        self.assertIn('LOCAL_UNIVERSE',self.code)
        self.assertIn('server.Enabled=true;client.Enabled=true',self.code)
if __name__=='__main__':unittest.main()
