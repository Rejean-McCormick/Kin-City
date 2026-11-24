"""Source-derived offline acceptance. Studio rendering and R15 API require separate Play QA."""
import json, math, unittest
from pathlib import Path
repo = Path(__file__).resolve().parent.parent
root=repo/'src/server' if (repo/'src/server').exists() else Path(__file__).parent
structures=json.loads((repo/'catalog/spatial.json').read_text(encoding='utf-8'))['structures']
sectors=[(0,-1),(.866025403784,-.5),(.866025403784,.5),(0,1),(-.866025403784,.5),(-.866025403784,-.5)]
radii={'stylized':[105,185,275,370],'r15':[145,235,335]}
def blocked(x,z,pad):
    for b in structures:
        dx=x-b['center_studs'][0]; dz=z-b['center_studs'][2]
        a=math.radians(b['yaw_degrees'])
        lx=math.cos(a)*dx-math.sin(a)*dz
        lz=math.sin(a)*dx+math.cos(a)*dz
        if abs(lx)<b['footprint_studs'][0]/2+pad and abs(lz)<b['footprint_studs'][1]/2+pad:return True
    return False

def generate():
    records=[]
    for kind,levels in radii.items():
        for index in range(1,len(levels)*6+1):
            sector_index=(index-1)%6
            tier=(index-1)//6
            ax,az=sectors[sector_index]
            r0=levels[tier]
            offorder=([0,1,2,3] if (index+tier)%2==0 else [1,0,3,2])
            site=None
            for d in [0]+[v for n in range(9,352,9) for v in (n,-n)]:
                r=r0+d
                if not 88<=r<=417:continue
                for j in offorder:
                    lateral=(-4,4,-6.5,6.5)[j]
                    x,z=r*ax-az*lateral,r*az+ax*lateral
                    if any(math.dist((x,z),(p['x'],p['z']))<17 for p in records):continue
                    if any(blocked(x+ax*step,z+az*step,8) for step in (-15,0,15)):continue
                    site={'type':kind,'index':index,'sector':sector_index+1,'x':x,'z':z,'radius':r,'lateral':lateral,'axis':(ax,az)}
                    break
                if site:break
            if not site:raise ValueError(f"No valid site {kind} index {index}")
            records.append(site)
    return records

class PopulationV36Tests(unittest.TestCase):
    def test_exact_counts(self):
        data=generate()
        self.assertEqual(len(data),42)
        self.assertEqual(sum(p['type']=='stylized' for p in data),24)
        self.assertEqual(sum(p['type']=='r15' for p in data),18)
    def test_even_6_districts(self):
        data=generate()
        self.assertEqual([sum(p['sector']==i for p in data) for i in range(1,7)],[7]*6)
    def test_nonoverlap(self):
        data=generate()
        self.assertTrue(all(math.dist((a['x'],a['z']),(b['x'],b['z']))>=16.999 for idx,a in enumerate(data) for b in data[idx+1:]))
    def test_in_road_and_not_building(self):
        for p in generate():
            self.assertTrue(88<=p['radius']<=417)
            self.assertLessEqual(abs(p['lateral']),6.5)
            for delta in (-15,0,15):
                x=p['x']+p['axis'][0]*delta
                z=p['z']+p['axis'][1]*delta
                self.assertFalse(blocked(x,z,8),(p['type'],p['index'],delta))
    def test_source_wiring(self):
        files={f.name:f.read_text(encoding='utf8') for f in root.glob('*.luau')}
        self.assertIn('Citizens.make(city)',files['CityGenerator.luau'])
        self.assertIn('function Citizens.start(world)',files['Citizens.luau'])
        self.assertIn('local folder=Citizens.make(city)',files['Citizens.luau'])
        self.assertIn('Population.site("stylized",i)',files['Citizens.luau'])
        self.assertIn('Population.site("r15",index)',files['NativeR15Citizens.luau'])
        self.assertIn('PathfindingService:CreatePath',files['NativeR15Citizens.luau'])
        self.assertIn('KinNPCPopulationRevision',files['Citizens.luau'])
        self.assertNotIn('for i=1,14 do',files['NativeR15Citizens.luau'])
        self.assertIn('if collidesStructure(p.X,p.Z,8)', files['CityPopulationV36.luau'])

if __name__=='__main__':unittest.main(verbosity=2)
