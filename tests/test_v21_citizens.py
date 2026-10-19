"""Contrats hors moteur v21 : habitants et acoustique, sans prétendre simuler Roblox."""
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
SERVER=ROOT/'src/server'
CLIENT=ROOT/'src/client'

class CitizenV21(unittest.TestCase):
    def test_r15_tagging_and_shared_activity(self):
        for module in ['NativeR15Citizens.luau','ResidentialResidents.luau']:
            s=(SERVER/module).read_text()
            self.assertIn('CollectionService:AddTag(model,"KinCityAnimatedNPC")',s)
            self.assertIn('KinNPCMotion',s)
            self.assertIn('CitizenProps.attach(model,role,',s)
        self.assertNotIn('joint.C0=',(SERVER/'NativeR15Citizens.luau').read_text())
    def test_nearby_client_animation_is_streaming_compatible(self):
        a=(CLIENT/'CitizenAnimationV21.luau').read_text()
        for required in ['RunService.PreSimulation','AnimationConstraint','Motor6D','KinCityAnimatedNPC',
                         'GetInstanceAddedSignal','GetInstanceRemovedSignal','MAX_DISTANCE','UPDATE_HZ',
                         'KinNPCMotion','joint.Transform','model.Parent']:
            self.assertIn(required,a)
        self.assertIn('CitizenAnimationV21).start()', (CLIENT/'init.client.luau').read_text())
        self.assertNotIn('HttpService',a)
    def test_accessories_are_welded_lightweight_without_external_assets(self):
        a=(SERVER/'CitizenPropsV21.luau').read_text()
        for required in ['WeldConstraint','Massless=true','CanCollide=false','CanTouch=false','CanQuery=false',
                         'Color3.fromRGB(30,104,100)','RightHand']:
            self.assertIn(required,a)
        self.assertNotIn('HttpService',a)
        self.assertNotIn('InsertService',a)
    def test_audio_keeps_user_upload_optional(self):
        s=(SERVER/'Soundscape.luau').read_text()
        self.assertIn('if not Config.enabled then return end',s)
        self.assertIn('Plan.structures',s)
        self.assertIn('Residential',s)
        for text in ['Config.wind_sound_id','Config.chimes_sound_id','Config.water_sound_id']:
            self.assertIn(text,s)
        self.assertNotIn('HttpService',s)
    def test_v21_release(self):
        release=(ROOT/'tools/build_release.py').read_text()
        assert 'KinCity_Installation_Directe_v26.luau' in release
        assert '26.0.0' in release
        self.assertIn('construction-v26.0.0-',(SERVER/'WorldBuilder.luau').read_text())
if __name__=='__main__':unittest.main()
