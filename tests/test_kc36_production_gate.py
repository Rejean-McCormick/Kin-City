"""Régression du contrat studio / production : ne pas ouvrir les installateurs de test."""
import unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
class ProductionPolicySourceTests(unittest.TestCase):
    def test_contract_is_split(self):
        p=(ROOT/'src/server/ArtDecoPolicy.luau').read_text(encoding='utf8')
        self.assertIn('function Policy.isTestTarget',p)
        self.assertIn('if placeId==config.production_place_id then return false end',p)
        self.assertIn('function Policy.isRuntimeTarget',p)
        self.assertIn('if type(published)=="number" and published>0 and placeId==published then',p)
        self.assertIn('return Policy.isTestTarget(placeId,marked,config)',p)
    def test_asset_boot_and_clone_use_runtime_gate(self):
        source=(ROOT/'src/server/ArtDecoAssets.luau').read_text(encoding='utf8')
        self.assertEqual(source.count('Policy.isRuntimeTarget('),2)
        self.assertNotIn('Policy.isTestTarget(',source)
        self.assertIn('KinSourceCount',source)
        self.assertIn('PackageLink',source)
    def test_world_and_routing_remain_unchanged(self):
        source=(ROOT/'src/server/WorldBuilder.luau').read_text(encoding='utf8')
        self.assertIn('ArtDecoAssets.checkTarget()',source)
        self.assertIn('if reuseExisting and old then',source)
        route=(ROOT/'src/server/PromptRouter.luau').read_text(encoding='utf8')
        self.assertIn('PlayerTravel.tryDoor',route)
        player=(ROOT/'src/server/PlayerTravel.luau').read_text(encoding='utf8')
        self.assertIn('player:SetAttribute("KinZone",place)',player)
if __name__=='__main__': unittest.main()
