"""V30.0.7 : typographie Garamond globale et fallback Bodoni."""
import unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'src'
SERVER=SRC/'server'
CLIENT=SRC/'client'
SHARED=SRC/'shared'

class TypographyV3006(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.factory=(SERVER/'Factory.luau').read_text(encoding='utf8')
        cls.typography=(SHARED/'Typography.luau').read_text(encoding='utf8')
        cls.server_sources='\n'.join(p.read_text(encoding='utf8') for p in SERVER.glob('*.luau'))
        cls.client_sources='\n'.join(p.read_text(encoding='utf8') for p in CLIENT.glob('*.luau'))
        cls.arcade=(SERVER/'StationArcades.luau').read_text(encoding='utf8')
        cls.artisan=(SERVER/'ArtisanStreets.luau').read_text(encoding='utf8')
        cls.commerce=(SERVER/'PromenadeCommerce.luau').read_text(encoding='utf8')
        cls.promenade=(SERVER/'PromenadeLife.luau').read_text(encoding='utf8')
        cls.facade=(SERVER/'FacadeGenerator.luau').read_text(encoding='utf8')

    def test_shared_typography_prefers_garamond_with_bodoni_fallback(self):
        for needle in ('resolve("Garamond"','resolve("Bodoni"','function Typography.body()','function Typography.display()','function Typography.fallback()'):
            self.assertIn(needle,self.typography)

    def test_factory_uses_shared_typography_and_readability_tuning(self):
        for needle in ('local Typography=require(Shared:WaitForChild("Typography"))','estimateLines','txt.Font = Typography.display()','UITextSizeConstraint','UIStroke','UIPadding','sg.PixelsPerStud = 60','txt.LineHeight = 1.0'):
            self.assertIn(needle,self.factory)
        self.assertIn('KinSignTypography',self.factory)
        self.assertIn('garamond-with-bodoni-fallback',self.factory)
        self.assertIn('boardHeight = math.max(requestedHeight + 0.85',self.factory)
        self.assertIn('position + forward * frontOffset',self.factory)
        self.assertIn('frontOffset = 0.46',self.factory)

    def test_no_legacy_gotham_in_runtime_sources_outside_fallback_module(self):
        self.assertNotIn('Enum.Font.Gotham',self.server_sources)
        self.assertNotIn('Enum.Font.Garamond',self.server_sources)
        self.assertIn('Typography.body()',self.server_sources)
        self.assertNotIn('Enum.Font.Gotham',self.client_sources)
        self.assertNotIn('Enum.Font.Garamond',self.client_sources)
        self.assertIn('Typography.body()',self.client_sources)
        self.assertNotIn('GothamBold',self.server_sources)
        self.assertNotIn('GothamBold',self.client_sources)

    def test_primary_storefronts_keep_raised_forward_signs(self):
        self.assertIn('CFrame.new(0,14.15,-10.85)',self.arcade)
        self.assertIn('18.8,3.45',self.arcade)
        self.assertIn('CFrame.new(0,13.65,-16.15)',self.artisan)
        self.assertIn('20.5,3.35',self.artisan)
        self.assertIn('CFrame.new(0,13.2,-13.65)',self.commerce)
        self.assertIn('18.8,3.25',self.commerce)
        self.assertIn('CFrame.new(0,12.5,-11.25)',self.promenade)
        self.assertIn('20.5,3.2',self.promenade)
        self.assertIn('math.min(h-2.1,14.1)',self.facade)
        self.assertIn('-d/2-1.95',self.facade)
        self.assertIn('math.min(w-10,42),3.8',self.facade)

if __name__=='__main__':
    unittest.main()
