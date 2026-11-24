"""Regression for the gallery menu client crash observed in Studio v31."""
from pathlib import Path
import re
import unittest
ROOT = Path(__file__).resolve().parents[1]

class GalleryMenuHotfixTests(unittest.TestCase):
    def test_gallery_is_created_before_it_is_registered(self):
        s=(ROOT/'src/client/GalleryJournalV22.luau').read_text(encoding='utf8')
        create=s.index('window=Instance.new("Frame")')
        parent=s.index('listing.Parent=scroll')
        register=s.index('require(script.Parent.KinCityMenu).register("gallery"')
        self.assertLess(create,parent)
        self.assertLess(parent,register)
        self.assertEqual(s.count('KinCityMenu).register("gallery"'),1)

    def test_menu_rejects_invalid_window_with_clear_error(self):
        s=(ROOT/'src/client/KinCityMenu.luau').read_text(encoding='utf8')
        reg=s[s.index('function Menu.register('):s.index('function Menu.registerAction(')]
        self.assertIn('typeof(window)=="Instance" and window:IsA("GuiObject")',reg)
        self.assertLess(reg.index('typeof(window)'),reg.index('window:GetPropertyChangedSignal("Visible")'))

    def test_no_other_active_ui_registers_before_window_creation(self):
        # All other active registered windows should be constructed before register.
        for filename in ('MapHud','RouteGuide','ExplorationJournal','LocalPerformanceProbeV29', 'LibraryJourneyGuide'):
            s=(ROOT/'src/client'/f'{filename}.luau').read_text(encoding='utf8')
            match=re.search(r'\.register\([^\n]*',s)
            self.assertIsNotNone(match,filename)
            self.assertIn('Instance.new("Frame")',s[:match.start()],filename)

if __name__=='__main__':unittest.main()
