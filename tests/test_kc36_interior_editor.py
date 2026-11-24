from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
SERVER=(ROOT/'src/server/InteriorEditorV36.luau').read_text(encoding='utf-8')
CLIENT=(ROOT/'src/client/InteriorEditorClientV36.luau').read_text(encoding='utf-8')
LEGACY=(ROOT/'src/server/PlayerBuildServer.luau').read_text(encoding='utf-8')
class InteriorEditorContracts(unittest.TestCase):
    def test_whitelist_and_model_level(self):
        for token in ['KinFurnishingId','KinAssetId','prop.bench','prop.table','prop.planter','prop.bookshelf','Model','model:GetBoundingBox()','model:Clone()']:
            self.assertIn(token,SERVER)
    def test_protection_and_server_authority(self):
        for token in ['KinDoorId','KinAnchorId','KinStubInteractionId','ProximityPrompt','Humanoid','KinZone','owner(player)','MAX_REACH','positionOk','furnitureClear']:
            self.assertIn(token,SERVER)
        self.assertNotIn('OnClientInvoke=',SERVER)
        self.assertIn('OnServerInvoke=handle',SERVER)
    def test_persistence_is_separate(self):
        self.assertIn('KinCity_InteriorEditorV36_v1',SERVER)
        self.assertIn('DataStoreService',SERVER)
        self.assertIn('store:SetAsync',SERVER)
        self.assertIn('store:GetAsync',SERVER)
        self.assertIn('BindToClose',SERVER)
    def test_undo_and_duplicate_and_delete(self):
        for token in ['verb=="duplicate"','verb=="delete"','verb=="undo"','verb=="redo"','doAction(action,verb=="undo")','copy%04d']:
            self.assertIn(token,SERVER)
        self.assertIn('Confirmer : appuie encore sur EFFACER',CLIENT)
    def test_old_editor_doesnt_edit_interiors(self):
        self.assertIn('p:IsDescendantOf(interiorRoot) then return true',LEGACY)
    def test_boot(self):
        self.assertIn('require(script.InteriorEditorV36).start(state.world)',(ROOT/'src/server/init.server.luau').read_text())
        self.assertIn('require(script.InteriorEditorClientV36).start()', (ROOT/'src/client/init.client.luau').read_text())
if __name__=='__main__':unittest.main()
