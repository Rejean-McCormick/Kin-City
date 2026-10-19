from __future__ import annotations
import json, sys, unittest, copy
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from validate_spatial import validate,load
from compile_plan import compile_plan,nav_path,is_blocked
ROOT=Path(__file__).resolve().parents[1]

class MemoryCatalog:
    def __init__(self,original):self.docs={key:load(original,key) for key in ['spatial','assets','style_guide','buildings','places','doors','interactions','city']}
    def patch(self):
        # use mocks to target load without touching tracked repository
        import unittest.mock as mock
        from validate_spatial import load as _load
        saved=self.docs
        def fetch(root,name):return copy.deepcopy(saved[name]) if name in saved else _load(root,name)
        return mock.patch('validate_spatial.load',side_effect=fetch)

class TestStaticWorld(unittest.TestCase):
    def test_world_passes(self):self.assertEqual([],validate(ROOT))
    def test_nonexistent_facade_rejected(self):
        data=MemoryCatalog(ROOT);data.docs['buildings']['buildings'][0]['exterior_template']='fictional.geometry.not_present_anywhere'
        with data.patch():
            errs=validate(ROOT)
        self.assertTrue(any('asset template introuvable' in e for e in errs),errs)
    def test_spatial_anchor_out_of_city_rejected(self):
        data=MemoryCatalog(ROOT)
        anchor=next(a for a in data.docs['spatial']['places'][0]['anchors'] if a['anchor_id']=='city.central.spawn')
        anchor['position_studs']=[9999,3,0]
        with data.patch():
            errs=validate(ROOT)
        self.assertTrue(any('ancre hors ville' in e for e in errs),errs)
    def test_missing_interaction_object_rejected(self):
        data=MemoryCatalog(ROOT)
        library=next(p for p in data.docs['spatial']['places'] if p['place_key']=='library')
        library['furnishings']=[f for f in library['furnishings'] if 'anchor_id' not in f]
        with data.patch():
            errs=validate(ROOT)
        self.assertTrue(any('aucun objet meuble' in e for e in errs),errs)
    def test_plan_is_repeatable(self):
        a=compile_plan(ROOT);b=compile_plan(ROOT)
        self.assertEqual(a['canonical_sha256'],b['canonical_sha256'])
        self.assertEqual(8,len(a['pedestrian_paths']))
        for path in a['pedestrian_paths']:
            self.assertTrue(path['path_xyz_studs'])
    def test_plan_paths_do_not_cross_footprints_on_grid(self):
        plan=compile_plan(ROOT)
        for walkway in plan['pedestrian_paths']:
            route=walkway['path_xyz_studs']
            for a,b in zip(route,route[1:]):
                dist=max(abs(a[0]-b[0]),abs(a[2]-b[2]))
                for i in range(int(dist/10)+1):
                    t=0 if dist==0 else min(1,10*i/dist)
                    x=a[0]*(1-t)+b[0]*t;z=a[2]*(1-t)+b[2]*t
                    self.assertFalse(is_blocked(x,z,plan['structures']),walkway['building_id'])
if __name__=='__main__':unittest.main()
