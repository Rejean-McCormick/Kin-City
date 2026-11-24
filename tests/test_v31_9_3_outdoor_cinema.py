"""Contrats de l'écran vidéo extérieur v31.9.3, sans lecture Roblox en local."""
from pathlib import Path
import re
import unittest

ROOT=Path(__file__).resolve().parents[1]
SERVER=(ROOT/'src/server/OutdoorCinema.luau').read_text(encoding='utf8')
CLIENT=(ROOT/'src/client/OutdoorCinemaClient.luau').read_text(encoding='utf8')
START_SERVER=(ROOT/'src/server/init.server.luau').read_text(encoding='utf8')
START_CLIENT=(ROOT/'src/client/init.client.luau').read_text(encoding='utf8')
PATCH_GEN=(ROOT/'tools/make_outdoor_cinema_patch.py').read_text(encoding='utf8')
INSTALL_GEN=(ROOT/'tools/make_universe_recovery_installer.py').read_text(encoding='utf8')

class OutdoorCinemaContract(unittest.TestCase):
    def test_requires_real_video_asset_id_no_fake(self):
        self.assertIn('DEFAULT_VIDEO_ID=0',SERVER)
        self.assertIn('KinVideoAssetId',SERVER)
        self.assertIn('rbxassetid://',SERVER)
        self.assertNotIn('youtube.com',SERVER)
        self.assertNotIn('http://',SERVER)
        self.assertNotIn('youtube.com',CLIENT)

    def test_one_screen_one_trigger(self):
        self.assertIn('MODEL_NAME="KinCityOutdoorCinema"',SERVER)
        self.assertIn('Vector3.new(24,13.5,0.55)',SERVER)
        self.assertIn('Vector3.new(10,0.32,8)',SERVER)
        self.assertIn('Name="Film"',SERVER)
        self.assertIn('Name="Projection"',SERVER)
        self.assertIn('KinVideoTriggerEnabled',SERVER)
        self.assertIn('video.Looped=false',SERVER)

    def test_server_validates_character_and_entry(self):
        self.assertIn('Players:GetPlayers()',SERVER)
        self.assertIn('FindFirstChildOfClass("Humanoid")',SERVER)
        self.assertIn('HumanoidRootPart',SERVER)
        self.assertIn('if entered and not inside[id]',SERVER)
        self.assertIn('KinVideoPlaybackStart',SERVER)
        self.assertIn('workspace:GetServerTimeNow()',SERVER)

    def test_client_plays_locally_without_playing_replication(self):
        self.assertIn('video:Play()',CLIENT)
        self.assertIn('video:Pause()',CLIENT)
        self.assertIn('video.IsLoaded',CLIENT)
        self.assertIn('video.TimePosition',CLIENT)
        self.assertIn('video.Ended:Connect',CLIENT)
        self.assertIn('GetAttributeChangedSignal("KinVideoPlaybackStart")',CLIENT)

    def test_startup_in_current_universe(self):
        self.assertIn('require(script.OutdoorCinema).start()',START_SERVER)
        self.assertIn('require(script.OutdoorCinemaClient).start()',START_CLIENT)
        self.assertIn('require(server:WaitForChild("OutdoorCinema")).ensure()',INSTALL_GEN)

    def test_patch_does_not_destroy_generated_city(self):
        self.assertIn('KinCityOutdoorCinemaRuntime',PATCH_GEN)
        self.assertIn('KinCityOutdoorCinemaClient',PATCH_GEN)
        self.assertIn('KinCityGenerated',PATCH_GEN)
        self.assertNotIn('builder.build()',PATCH_GEN)
        self.assertNotIn('KinCityGenerated:Destroy',PATCH_GEN)

if __name__=='__main__':unittest.main()
