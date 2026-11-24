"""Static checks for the B07 locked-door + YouTube broadcast integration."""
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
BARRIER=(ROOT/'src/server/MuseumBroadcastBarrier.luau').read_text(encoding='utf8')
INIT=(ROOT/'src/server/init.server.luau').read_text(encoding='utf8')

class B07BroadcastIntegration(unittest.TestCase):
    def test_barrier_targets_canonical_museum_entry_only(self):
        self.assertIn('TARGET_DOOR_ID="city.kreative.museum.entry"',BARRIER)
        self.assertIn('KinMuseumDoorBlocked',BARRIER)
        self.assertIn('child.Enabled=false',BARRIER)
        self.assertIn('child.ActionText="Fermé"',BARRIER)
    def test_broadcast_screen_is_repositioned_and_labeled(self):
        self.assertIn('SCREEN_NAME="KinCityOutdoorCinema"',BARRIER)
        self.assertIn('KinVideoChannel","YouTube - contenu via asset Roblox autorise"',BARRIER)
        self.assertIn('BROADCAST YOUTUBE',BARRIER)
        self.assertIn('PORTE BARRÉE',BARRIER)
        self.assertIn('cinema:PivotTo',BARRIER)
    def test_runtime_starts_in_server_boot(self):
        self.assertIn('require(script.MuseumBroadcastBarrier).start()',INIT)
        self.assertIn('require(script.OutdoorCinema).start()',INIT)

if __name__=='__main__':
    unittest.main()
