"""Offline contract checks for the owner-supplied v27 fallback and v30 full-universe installer."""
import re
import sys
import unittest
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from make_universe_recovery_installer import compact_luau, OUTPUT

class RecoveryInstallerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.source=OUTPUT.read_text(encoding='utf8')

    def test_legacy_geom_fallback_embedded(self):
        s=self.source
        self.assertIn('"CityGeneratorLegacyV27"',s)
        self.assertIn('"InteriorGeneratorLegacyV27"',s)
        self.assertIn('KinGeneratorFallbacks',s)
        self.assertIn('MONDE PRÊT',s)

    def test_full_universe_mode_and_all_eight_institutions(self):
        s=self.source
        self.assertIn('["mode"] = "LOCAL_UNIVERSE"',s)
        self.assertIn('local expected={"campus","city_hall","ekoh_tower","innovation_lab","justice_palace","library","museum","orgo_center"}',s)
        self.assertIn('KinCityGenerated',s)
        self.assertIn('FindFirstChild("Ville")',s)
        self.assertIn('Bâtiments visitables',s)

    def test_v30_modules_embedded_exactly_once(self):
        source=self.source
        names=re.findall(r'source\((shared|server|client),"([A-Za-z0-9_]+)",',source)
        self.assertEqual(len(names),len(set(names)))
        server={p.stem for p in (ROOT/'src/server').glob('*.luau') if p.name!='init.server.luau'}
        client={p.stem for p in (ROOT/'src/client').glob('*.luau') if p.name!='init.client.luau'}
        shared={p.stem for p in (ROOT/'src/shared').glob('*.luau')}
        self.assertEqual(set(names),{("server",x) for x in server}|{("client",x) for x in client}|{("shared",x) for x in shared})
        self.assertIn('local city=world:FindFirstChild("Ville")',source)
        self.assertIn('world:GetAttribute("KinBuildState")=="Ready"',source)

    def test_compact_shorter_than_working_v27_without_runtime_payload_loss(self):
        old=Path('/mnt/data/KinCity_Installation_Directe_v27(3).luau')
        if old.exists():
            self.assertLess(OUTPUT.stat().st_size,old.stat().st_size)
        self.assertIn('local server=Instance.new("Script")',self.source)
        self.assertIn('server.Source=',self.source)
        self.assertIn('client.Source=',self.source)

    def test_every_embedded_source_matches_local_source(self):
        pat=re.compile(r'source\((shared|server|client),"([A-Za-z0-9_]+)",(\[(=*)\[\n)(.*?)\n\]\4\]\)\n',re.S)
        extracted={(p,n):payload for p,n,_,__,payload in pat.findall(self.source)}
        self.assertEqual(len(extracted),len(re.findall(r'^source\(',self.source,re.M)))
        for parent in ('shared','server','client'):
            for file in (ROOT/'src'/parent).glob('*.luau'):
                if file.name in ('init.server.luau','init.client.luau') or file.stem=='RuntimeConfig':
                    continue
                expected=compact_luau(file.read_text(encoding='utf8')).rstrip('\n')
                self.assertEqual(extracted[(parent,file.stem)].rstrip("\n"),expected,msg=file.name)

if __name__=='__main__':unittest.main()
