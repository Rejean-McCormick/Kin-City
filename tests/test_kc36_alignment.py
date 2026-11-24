"""KC36 alignment: source invariants. Runtime geometry must still be QA'd in Studio."""
from pathlib import Path
import unittest,re,json
ROOT=Path(__file__).resolve().parents[1]

def read(path):return (ROOT/path).read_text(encoding='utf8')
class KC36Alignment(unittest.TestCase):
    def test_01_floor_above_island(self):
        layout=read('src/server/ArtDecoLayout.luau')
        self.assertIn('SITE_FLOOR_TOP_STUDS=0.32',layout)
        self.assertIn('Layout.SITE_FLOOR_TOP_STUDS-Layout.SITE_FLOOR_THICKNESS_STUDS/2',layout)
        city=read('src/server/CityGenerator.luau')
        self.assertIn('CFrame.new(0,-1,0)',city) # Island disk: upper face at Y=0
        building=read('src/server/ArtDecoBuildings.luau')
        self.assertIn('KinGroundAuthority',''.join([building]))
        self.assertIn('institution-foundation',building)
        self.assertIn('KinGroundOwner',building)
    def test_02_single_avenue_ground_authority(self):
        u=read('src/server/KoaliUrbanism.luau')
        self.assertIn('native-avenue-slabs',u)
        self.assertIn('KinPavingMeshOverlay",false',u)
        self.assertNotIn('ArtDecoProps.street(road,kind,frame,s.key)',u)
        self.assertIn('Avenue ',u)
    def test_03_ekoh_has_no_central_post(self):
        h=read('src/server/EkohHalo.luau')
        self.assertNotIn('"Fil vertical du halo"',h)
        self.assertIn('Colonne latérale du portique',h)
        self.assertIn('KinSignSupportRevision',h)
        self.assertIn('CFrame.new(p)*CFrame.Angles(0,yaw,0)',h)
        self.assertIn('post.Shape=Enum.PartType.Cylinder',h)
        self.assertIn('doubleSided=true',h)
    def test_04_b10_physical_and_historical_preserved(self):
        b=read('src/server/B10WayfindingKC36.luau')
        self.assertNotIn('Instance.new("BillboardGui")',b)
        self.assertNotIn('"SECTEUR  •  "',b)
        self.assertIn('Instance.new("SurfaceGui")',b)
        self.assertIn('KinB10AvenueMarkers",0',b)
        self.assertIn('KinB10EntranceMarkers",#doors',b)
        self.assertIn('B10WayfindingKC36',read('src/server/BranchRuntime.luau'))
        self.assertIn('billboard(',read('contrib/places/city/Wayfinding.luau')) # archived original immutable
    def test_05_command_bar_transaction_and_limits(self):
        script=read('studio/KC36_INSTALL_ALIGNEMENT_COMMAND_BAR.luau')
        self.assertLess(len(script),100000)
        for token in ['KC36AlignmentBackup','oldWorld.Parent=backup',
                      'oldWorld.Parent=workspace','result.created==9','KinCityArtDecoLibrary',
                      'PackageLink','originals==121','KinGroundTop',
                      'B10 contient une pancarte flottante','proposedShared.Parent=Replicated','oldShared.Parent=backup','identity.Source=']:
            self.assertIn(token,script)
    def test_06_locked_contracts(self):
        import sys
        sys.path.insert(0,str(ROOT/'tools'))
        from b09_contracts import frozen_snapshot
        errors,n=frozen_snapshot(ROOT,ROOT/'reference_KC34')
        self.assertEqual(n,23)
        self.assertEqual(errors,[])
    def test_07_original_branch_inputs(self):
        receipt=json.loads(read('docs/B09/consolidation/consolidation_receipt.json'))
        self.assertEqual(len(receipt['staged_files']),83)
        self.assertTrue((ROOT/'inputs/branch_archives/KinCity_B10_KC34_Premiere_Passe.zip').exists())

if __name__=='__main__':unittest.main()
