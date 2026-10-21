"""V30.0.7 : dégagement des portes et disparition des blocs devant les entrées."""
import unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
SERVER=ROOT/'src/server'

class DoorClearanceV3007(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.world=(SERVER/'WorldBuilder.luau').read_text(encoding='utf8')
        cls.portals=(SERVER/'PlacePortalsV26.luau').read_text(encoding='utf8')
        cls.arch=(SERVER/'ArchitecturePlus.luau').read_text(encoding='utf8')

    def test_door_prompt_surface_is_nearly_invisible(self):
        for needle in (
            'Vector3.new(6.6,6.8,0.18)',
            'doorPart.Transparency=0.96',
            'doorPart.CanCollide=false',
            'doorPart.CanTouch=false',
            'doorPart.CanQuery=false',
            'doorPart.CastShadow=false',
            'doorPart:SetAttribute("KinDoorBoundary",true)',
        ):
            self.assertIn(needle, self.world)

    def test_place_portal_ornaments_leave_opening_clear(self):
        for needle in (
            'side*5.85',
            'Vector3.new(0.45,7.6,0.7)',
            'frame*CFrame.new(0,7.95,-0.72)',
            'tag,10.2,1.95',
            'PLACE DISTINCTE • À PUBLIER",8.6,0.95',
        ):
            self.assertIn(needle, self.portals)

    def test_central_pillars_are_skipped_for_main_institution_families(self):
        self.assertIn('local doorwayHalf=6.6', self.arch)
        self.assertIn('if math.abs(px)>doorwayHalf then', self.arch)
        self.assertIn('local doorwayHalf=6.8', self.arch)
        self.assertIn('if math.abs(x)>doorwayHalf then', self.arch)

if __name__=='__main__':
    unittest.main()
