"""Regression: the creation menu must not depend on server RPC startup."""
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]

class EditorBootstrap(unittest.TestCase):
    def test_client_module_does_not_wait_for_rpc_at_top_level(self):
        src=(ROOT/'src/client/PlayerBuildClient.luau').read_text()
        self.assertNotIn('WaitForChild("KinCityBuildRPC")',src)
        self.assertIn('FindFirstChild("KinCityBuildRPC")',src)
        self.assertIn('Menu.register("build","CRÉATION • Éditer la ville"',src)
        self.assertIn('serveur en cours de chargement',src)

    def test_other_tools_unaffected_if_client_editor_fails(self):
        src=(ROOT/'src/client/init.client.luau').read_text()
        self.assertIn('task.spawn(function()',src)
        self.assertIn('require(script.PlayerBuildClient).start()',src)
        self.assertIn('Mode Création client non chargé',src)
        self.assertIn('require(script.MapHud).start()',src)

    def test_rpc_available_before_indexing(self):
        src=(ROOT/'src/server/PlayerBuildServer.luau').read_text()
        self.assertLess(src.index('(rpc :: RemoteFunction).OnServerInvoke=responder'),src.index('    index(world)',src.index('function Editor.start(')))
        self.assertIn('if not isLoaded then return errorReply("Chargement des retouches en cours")',src)

    def test_empty_menu_message_is_not_behind_buttons(self):
        src=(ROOT/'src/client/KinCityMenu.luau').read_text()
        self.assertIn('emptyLabel.LayoutOrder=0',src)
        self.assertIn('emptyLabel.Parent=items',src)
        self.assertNotIn('emptyLabel.Position=UDim2.fromOffset(6,82)',src)

if __name__=='__main__':unittest.main()
