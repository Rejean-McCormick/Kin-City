"""KC33 static regression tests; does not pretend to run Roblox or Luau."""
import hashlib
import json
import tempfile
import unittest
from pathlib import Path
from build_staging_places import make,read_ids,PRODUCTION_ID
from art_deco_catalog import load_art_deco
from compile_plan import compile_plan
ROOT=Path(__file__).resolve().parents[1]

class UpgradeStatic(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.source=load_art_deco(ROOT)
        cls.records={a['asset_key']:a for a in cls.source['manifest']['assets']}
        cls.world=compile_plan(ROOT)
    def cost(self,keys):
        d={'triangles':0,'parts':0,'clones':0}
        for key in keys:
            a=self.records[key];d['triangles']+=a['triangles_mesh_definitions'];d['parts']+=a['primitives']+2;d['clones']+=1
        return d
    def test_plan_not_modified(self):
        self.assertEqual(self.world['canonical_sha256'],'5941cd6ecd89ea806cd5b815fcc128b1abef1cff77f77d670dbe01c7f487039a')
        self.assertEqual(len(self.world['places']),9)
        self.assertEqual(len(self.world['doors']),16)
        self.assertEqual(len(self.world['structures']),8)
    def test_all_canonical_place_ids_unset(self):
        data=json.loads((ROOT/'config/place_ids.json').read_text())
        self.assertEqual(len(data),9)
        self.assertTrue(all(v is None for v in data.values()))
        self.assertEqual(json.loads((ROOT/'config/runtime.json').read_text())['mode'],'LOCAL_UNIVERSE')
    def test_three_pavilion_sources_fit_quota(self):
        p=self.source['placements']['pavilion'];self.assertEqual(len(p['variants']),3)
        c=self.cost(p['variants'])
        for profile in self.source['config']['profiles'].values():
            for dimension,value in c.items():self.assertLessEqual(value,profile['pools']['pavilion'][dimension],dimension)
    def test_paving_and_street_furniture_quotas_separate(self):
        p=self.source['placements']['street']
        for profile in self.source['config']['profiles'].values():
            lamps=self.cost([p['lamp']['asset']]*(2*len(profile['lamp_steps'])))
            benches=self.cost([p['bench']['asset']]*(2*len(profile['bench_steps'])))
            street={k:lamps[k]+benches[k] for k in lamps}
            roads=self.cost([p['paving_cross' if n%2==0 else 'paving_straight']['asset'] for n in profile['road_steps']])
            for k in street:
                self.assertLessEqual(street[k],profile['pools']['street'][k],('street',k))
                self.assertLessEqual(roads[k],profile['pools']['paving'][k],('paving',k))
    def test_stair_skin_and_lobby_accent_leave_reservations(self):
        prior=json.loads((ROOT/'build/art-deco-zone-audit-V3-REFERENCE.json').read_text())
        stairs=self.cost([self.source['placements']['stair_skins']['default']]*2)
        mirror=self.cost([self.source['placements']['lobby_accent']['asset']])
        for label,profile in self.source['config']['profiles'].items():
            for interior in prior['profiles'][label]['interiors'].values():
                for metric in stairs:
                    self.assertLessEqual(interior['architecture'][metric]+stairs[metric],profile['pools']['architecture'][metric],(label,'stairs',metric))
                    self.assertLessEqual(interior['furniture'][metric]+mirror[metric],profile['pools']['interior'][metric],(label,'mirror',metric))
    def test_global_budget_sum(self):
        owners={'building':8,'pavilion':6,'interior':8,'architecture':8,'street':6,'paving':6,'environment':6}
        for profile in self.source['config']['profiles'].values():
            for metric in ('triangles','parts','clones'):
                self.assertEqual(profile[metric],sum(owners[k]*v[metric] for k,v in profile['pools'].items()))
    def test_six_sector_identifiers_preserved(self):
        text=(ROOT/'src/shared/HexagonalDistricts.luau').read_text()
        for key in ('keenkonnect','ethikos','kreative','uckk','ekole','konnected'):
            self.assertIn('key="'+key+'"',text)
        self.assertIn('0,0.74,0',(ROOT/'src/server/DistrictChromatics.luau').read_text())
    def test_runtime_has_staging_allowlist_and_safe_colliders(self):
        policy=(ROOT/'src/server/ArtDecoPolicy.luau').read_text()
        self.assertIn('config.test_place_ids or {}',policy)
        street=(ROOT/'src/server/ArtDecoProps.luau').read_text()
        self.assertIn('paving/',street)
        assets=(ROOT/'src/server/ArtDecoAssets.luau').read_text()
        self.assertIn('node.CanCollide=false',assets)
        self.assertIn('function Props.pavilion',street)
    def test_staging_generator_rejects_invalid_ids(self):
        ids={p['place_key']:8800011000+i for i,p in enumerate(self.world['places'])}
        with tempfile.TemporaryDirectory() as temp:
            source=Path(temp)/'ids.json'
            for wrong in ({**ids,'city':PRODUCTION_ID},{**ids,'city':ids['campus']},{**ids,'city':None},{'city':8800001}):
                source.write_text(json.dumps(wrong))
                with self.assertRaises(ValueError):read_ids(source,ROOT)
    def test_staging_installer_generation_on_synthetic_ids(self):
        ids={p['place_key']:8800011000+i for i,p in enumerate(self.world['places'])}
        with tempfile.TemporaryDirectory() as temp:
            work=Path(temp);file=work/'ids.json';file.write_text(json.dumps(ids))
            scripts=make(ROOT,file,work/'out')
            self.assertEqual(len(scripts),9)
            for key,id in ids.items():
                script=(work/'out'/f'INSTALLER_STAGING_{key.upper()}.luau').read_text()
                before=script.index('wipe(workspace,')
                self.assertLess(script.index(f'assert(game.PlaceId=={id}'),before)
                self.assertLess(script.index('KinArtDecoTestPlace'),before)
                self.assertIn('"MULTI_PLACE"',script)
                self.assertNotIn('assert(game.PlaceId==0',script)
                self.assertIn('table.find(artDecoTarget.test_place_ids',script)
                self.assertIn('"KinCityGenerated"',script)

if __name__=='__main__':unittest.main(verbosity=2)
