"""Compatibilité : la passe typographique v30.0.7 conserve les objectifs de v30.0.5."""
import unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
S=ROOT/'src/server'
SHARED=ROOT/'src/shared'

class SignageCompatibility(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.factory=(S/'Factory.luau').read_text(encoding='utf8')
        cls.typography=(SHARED/'Typography.luau').read_text(encoding='utf8')
        cls.facade=(S/'FacadeGenerator.luau').read_text(encoding='utf8')

    def test_serif_typography_remains(self):
        self.assertIn('resolve("Garamond"',self.typography)
        self.assertIn('resolve("Bodoni"',self.typography)
        self.assertIn('txt.Font = Typography.display()',self.factory)
        self.assertIn('KinSignTypography',self.factory)
        self.assertIn('garamond-with-bodoni-fallback',self.factory)

    def test_readability_guardrails_remain(self):
        for needle in ('UITextSizeConstraint','UIStroke','UIPadding','boardHeight = math.max(requestedHeight + 0.85','frontOffset = 0.46'):
            self.assertIn(needle,self.factory)
        self.assertIn('math.min(w-10,42),3.8',self.facade)

if __name__=='__main__':
    unittest.main()
