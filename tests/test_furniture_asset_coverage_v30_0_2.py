"""Regression for the Studio log's prop.desk failure in innovation_lab."""
import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

class FurnitureCoverageV3002(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.props = (ROOT / 'src/server/PropGenerator.luau').read_text(encoding='utf-8')
        cls.builder = (ROOT / 'src/server/WorldBuilder.luau').read_text(encoding='utf-8')
        cls.plan = json.loads((ROOT / 'build/world-plan.json').read_text(encoding='utf-8'))

    def test_every_furnishing_has_a_registered_generator(self):
        registered = set(re.findall(r'\["(prop\.[a-z_]+)"\]\s*=\s*true', self.props))
        used = {f['asset_id'] for p in self.plan['places'] for f in p.get('furnishings', [])}
        self.assertTrue(used, 'no furnishings were checked')
        self.assertFalse(used-registered, f'Unsupported furniture: {used-registered}')

    def test_registered_generators_have_real_build_branches(self):
        registered = set(re.findall(r'\["(prop\.[a-z_]+)"\]\s*=\s*true', self.props))
        implemented = set(re.findall(r'asset\s*==\s*"(prop\.[a-z_]+)"', self.props))
        self.assertEqual(registered, implemented, 'Registry and construction branches diverge')

    def test_specific_failed_desk_remains_interactive_and_solid(self):
        lab = next(p for p in self.plan['places'] if p['place_key']=='innovation_lab')
        desk = next(f for f in lab['furnishings'] if f['asset_id']=='prop.desk')
        self.assertEqual(desk['anchor_id'],'hall.desk_01')
        self.assertEqual(desk['furnishing_id'],'innovation_lab.interactive.01')
        self.assertEqual(desk['collision_policy'],'solid')
        self.assertIn('root = piece(model,"DeskTop"', self.props)
        self.assertIn('model:SetAttribute("KinAnchorId",item.anchor_id)', self.props)
        self.assertIn('model.PrimaryPart = root', self.props)

    def test_world_builder_preflights_before_deleting_existing_world(self):
        self.assertLess(self.builder.index('PropGenerator.supports(furn.asset_id)'),
                        self.builder.index('if old then old:Destroy() end'))
        self.assertIn('construction-v30.0.7-door-clearance-pass-',self.builder)

    def test_all_eight_institution_canonical_ids_still_present(self):
        keys={p['place_key'] for p in self.plan['places'] if p['place_key']!='city'}
        self.assertEqual(keys,{'campus','city_hall','ekoh_tower','innovation_lab',
                               'justice_palace','library','museum','orgo_center'})

if __name__=='__main__':
    unittest.main()
