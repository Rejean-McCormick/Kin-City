"""Static B10 city QA against the canonical files in the supplied V3 archive.

Studio, LOD/GPU/teleport and KC33 integration are deliberately not claimed.
"""
from pathlib import Path
import unittest, json, re, math, hashlib, os

CITY=Path(__file__).resolve().parents[1]
V3=Path(os.environ.get('KINCITY_SOURCE_PATH','/mnt/data/b10_work/KinCity_ArtDeco_V3/source/Kin-City'))
# If the entire patch is moved next to source/Kin-City, allow tests to use that source.
if not (V3/'build/world-plan.json').is_file():
    raise RuntimeError('B10 tests need -- see README: copy a full KC33 or V3 source folder and set KINCITY_SOURCE_PATH')

W=json.loads((V3/'build/world-plan.json').read_text())
DOORS=json.loads((V3/'catalog/doors.json').read_text())['doors']
STUDS=json.loads((CITY/'design.json').read_text())
LUA=(CITY/'Wayfinding.luau').read_text()
PREVIEW=(CITY/'preview/B10_APERCU_LOCAL_COMMAND_BAR.luau').read_text()
PALETTE=(V3/'src/shared/HexagonalDistricts.luau').read_text()
SECTIONS=[('keenkonnect',0.,-1.),('ethikos',.866025403784,-.5),('kreative',.866025403784,.5),('uckk',0.,1.),('ekole',-.866025403784,.5),('konnected',-.866025403784,-.5)]
ANCHORS={a['anchor_id']:a for p in W['places'] if p['place_key']=='city' for a in p['anchors']}
ARRIVALS=[d for d in DOORS if d['source_place_key']=='city']


def pos_ok(x,z):
    if not 75 < math.hypot(x,z) < 438:return False
    for b in W['structures']:
        dx=x-b['center_studs'][0];dz=z-b['center_studs'][2]
        theta=math.radians(b['yaw_degrees'])
        lx=math.cos(theta)*dx-math.sin(theta)*dz
        lz=math.sin(theta)*dx+math.cos(theta)*dz
        if abs(lx)<b['footprint_studs'][0]/2+10 and abs(lz)<b['footprint_studs'][1]/2+10:return False
    for d in ARRIVALS:
        for anchor_id in (d['source_anchor_id'],f"city.{d['building_id']}.return_spawn"):
            a=ANCHORS[anchor_id]['position_studs']
            if math.hypot(x-a[0],z-a[2])<12:return False
    return True


def markers(level):
    selection=[];skipped=[]
    for key,x,z in SECTIONS:
        for i,r in enumerate(STUDS['avenues']['radii_studs'][:level]):
            side=(-z,x)
            choices=[(x*r+side[0]*35*s,z*r+side[1]*35*s) for s in (1,-1)]
            safe=[xy for xy in choices if pos_ok(*xy)]
            if safe:selection.append((key,i,safe[0]))
            else:skipped.append((key,i))
    return selection,skipped

class CityContracts(unittest.TestCase):
    def test_01_six_sectors_exact_palette(self):
        self.assertEqual(len(SECTIONS),6)
        for name,rgb in STUDS['sector_colors'].items():
            key=next(k for k in SECTIONS if k[0]==name)
            rgba=tuple(int(rgb[j:j+2],16) for j in (1,3,5))
            found=re.search(r'key="'+re.escape(name)+r'".*?color=Color3\.fromRGB\((\d+),(\d+),(\d+)\)',PALETTE,re.S)
            self.assertTrue(found, name)
            self.assertEqual(tuple(map(int,found.groups())),rgba)
    def test_02_eight_entry_anchors_preserved(self):
        self.assertEqual(len(ARRIVALS),8)
        self.assertEqual(len([d for d in DOORS if d['destination_place_key']=='city']),8)
        for d in ARRIVALS:
            self.assertIn(d['source_anchor_id'],ANCHORS)
            self.assertIn(f"city.{d['building_id']}.return_spawn",ANCHORS)
    def test_03_path_count_unchanged(self):
        self.assertEqual(len(W['pedestrian_paths']),8)
        self.assertEqual(len(W['structures']),8)
    def test_04_lite_has_all_six_distinct_sectors(self):
        m,skip=markers(1)
        self.assertEqual({k for k,i,xy in m},{s[0] for s in SECTIONS})
        self.assertEqual(skip,[])
    def test_05_standard_finds_safe_positions(self):
        m,sk=markers(2)
        self.assertEqual(len(m),12)
        self.assertEqual(sk,[])
    def test_06_showcase_finds_safe_positions(self):
        m,sk=markers(3)
        self.assertEqual(len(m),18)
        self.assertEqual(sk,[])
    def test_07_signs_do_not_collide(self):
        for statement in ('object.CanCollide = false','object.CanTouch = false','object.CanQuery = false','object.CastShadow = false'):
            self.assertIn(statement,LUA)
    def test_08_preview_is_studio_local_only(self):
        for required in ('RunService:IsStudio()','not RunService:IsRunning()','game.PlaceId==0','KinBuildState','KinRoutingMode','LOCAL_UNIVERSE'):
            self.assertIn(required,PREVIEW)
    def test_09_no_portal_or_teleport_changes(self):
        for forbidden in ('TeleportService','TeleportAsync',':PivotTo(','.CanCollide = true','Game:Shutdown','workspace:ClearAllChildren'):
            self.assertNotIn(forbidden,LUA)
    def test_10_idempotent_existing_folder(self):
        self.assertIn('KinB10Revision',LUA)
        self.assertIn('if previous and previous:GetAttribute',LUA)
        self.assertIn('if previous then previous:Destroy() end',LUA)
    def test_11_profile_names_and_limits(self):
        self.assertEqual(STUDS['avenues']['quality_levels'],{'LITE':1,'STANDARD':2,'SHOWCASE':3})
        for n in ('LITE','STANDARD','SHOWCASE'):self.assertIn('"'+n+'"',LUA)
    def test_12_legacy_id_not_renamed(self):
        self.assertIn('city.konnected.university.entry',{d['door_id'] for d in DOORS})
    def test_13_world_compilation_hash(self):
        self.assertEqual(W['canonical_sha256'],'5941cd6ecd89ea806cd5b815fcc128b1abef1cff77f77d670dbe01c7f487039a')
    def test_14_decorator_contains_no_external_assets(self):
        self.assertNotIn('MeshPart',LUA)
        self.assertNotIn('InsertService',LUA)
        self.assertNotIn('HttpService',LUA)
    def test_15_no_decoration_or_audio_touches_to_rooms(self):
        for forbidden in ('InteriorWings','InteriorGenerator','RoomGenerator','SoundService','GetPlaceId'):
            self.assertNotIn(forbidden,LUA)
    def test_16_preview_embeds_exact_module(self):
        source='\n'.join(LUA.splitlines()[1:])
        self.assertIn(source,PREVIEW)
    def test_17_build_manifest_conformant(self):
        j=json.loads((CITY/'recipe.json').read_text())
        self.assertEqual(j['place_key'],'city')
        self.assertEqual(j['owner_branch'],'B10')
        self.assertEqual(j['requires_contracts_version'],'KC34-DOC-1.0')
        self.assertEqual(j['implementation_status'],'INTEGRATION_PROPOSED')

if __name__=='__main__':unittest.main(verbosity=2)
