import unittest
import sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from make_studio_installer import generate

class StudioInstallerTest(unittest.TestCase):
    def test_installer_is_self_contained_and_reproducible(self):
        path=generate(ROOT)
        first=path.read_bytes()
        generate(ROOT)
        self.assertEqual(first,path.read_bytes())
        text=first.decode('utf8')
        self.assertIn('require(server:WaitForChild("WorldBuilder")).build()',text)
        self.assertIn('server.Enabled = true',text)
        self.assertIn('client.Enabled = true',text)
        for name in ('WorldPlan','PropGenerator','InteriorGenerator','PlayerTravel','Hud'):
            self.assertIn('"'+name+'"',text)
        self.assertNotIn('HttpService',text)

if __name__=='__main__': unittest.main()
