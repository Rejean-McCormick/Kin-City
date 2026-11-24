from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
MENU=(ROOT/'src/client/KinCityMenu.luau').read_text(encoding='utf8')
CLIENT=(ROOT/'src/client/InteriorEditorClientV36.luau').read_text(encoding='utf8')
INSTALL=(ROOT/'installer/KC36_CORRIGER_INTERFACE_ATELIER_RS.luau').read_text(encoding='utf8')

class AtelierUIV2(unittest.TestCase):
    def test_native_layout_opt_in_and_legacy(self):
        self.assertIn('KinUseNativeWindowLayout', MENU)
        self.assertIn('KinUseNativeWindowLayout', CLIENT)
        self.assertIn('normalWidth=math.max(window.Size.X.Offset,240)', MENU)
        self.assertIn('if window:GetAttribute("KinUseNativeWindowLayout")~=true then', MENU)
    def test_reader_friendly_controls(self):
        for s in ['DUPLIQUER','EFFACER','ANNULER','RÉTABLIR','SÉLECTION : ACTIVER','SÉLECTION : ACTIVE','MONTER','DESCENDRE']:
            self.assertIn(s, CLIENT)
        self.assertIn('b.TextSize=15', CLIENT)
        self.assertIn('scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y', CLIENT)
        self.assertNotIn('TextScaled=true', CLIENT)
        self.assertIn('Confirmer : appuie encore sur EFFACER', CLIENT)
    def test_mobile_and_independent_panel(self):
        for s in ['ViewportSize','math.min(448','math.min(770','insidePanel(screen)','ScreenPointToRay']:
            self.assertIn(s, CLIENT)
        self.assertIn('KC36AtelierUILayoutBackup_v2', INSTALL)
        self.assertLess(len(INSTALL),100000)
    def test_security_not_changed(self):
        old=(ROOT/'src/server/InteriorEditorV36.luau').read_text(encoding='utf8')
        self.assertIn('OnServerInvoke=handle',old)
        self.assertIn('owner(player)',old)
if __name__=='__main__': unittest.main()
