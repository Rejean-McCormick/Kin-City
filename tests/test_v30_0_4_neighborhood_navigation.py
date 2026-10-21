"""Tests de géométrie et contrats NPC offline; pas de simulation de PathfindingService."""
import math
import re
import unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
S=ROOT/'src/server'

class NeighborhoodNavigationV3004(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.nav=(S/'NeighborhoodNPCNavigation.luau').read_text(encoding='utf8')
        cls.cit=(S/'Citizens.luau').read_text(encoding='utf8')
        cls.r15=(S/'NativeR15Citizens.luau').read_text(encoding='utf8')
        cls.res=(S/'ResidentialResidents.luau').read_text(encoding='utf8')
        cls.groups=(ROOT/'src/shared/ResidentialDestinations.luau').read_text(encoding='utf8')

    def test_npcs_reuse_canonical_six_quarters(self):
        self.assertIn('ResidentialDestinations',self.nav)
        self.assertIn('Groups[(index-1)%#Groups+1]',self.nav)
        for npc in (self.cit,self.r15):
            self.assertIn('Nav.quarter(',npc)
            self.assertIn('KinResidenceQuarter',npc)
        self.assertIn('Nav.stop(quarter,index,1)',self.res)
        self.assertIn('for index=1,12 do',self.res)
        self.assertIn('for i=1,36 do',self.cit)
        self.assertIn('for i=1,14 do',self.r15)

    def test_waypoints_are_away_from_kiosk_and_houses(self):
        pairs=re.findall(r'\{(-?\d+),(-?\d+),"[^"\n]+"\}',self.nav)
        self.assertGreaterEqual(len(pairs),12)
        for sx,sz in pairs:
            x,z=int(sx),int(sz)
            self.assertTrue(abs(x)<=65 and -95<=z<=55)
            # Shared neighborhood kiosk has footprint +-8.5, add 1.5 studs.
            self.assertFalse(abs(x)<10 and abs(z)<10, (x,z))
            # Each home is 23 x 25, its footprint centered at +-29.
            for hx in (-29,29):
                for hz in (-29,29):
                    self.assertFalse(abs(x-hx)<14 and abs(z-hz)<15,(x,z,hx,hz))

    def test_path_refuses_failing_or_out_of_neighborhood_routes(self):
        for keyword in ('PathfindingService:CreatePath','path:ComputeAsync',
                        'Enum.PathStatus.Success','Enum.PathWaypointAction.Jump',
                        'Nav.within(quarter,waypoint.Position)','if traveled>190 then return nil',
                        'AgentCanJump=false','AgentRadius=2.5'):
            self.assertIn(keyword,self.nav)
        self.assertIn('function Nav.walkHumanoid(',self.nav)
        self.assertIn('humanoid:MoveTo(targetPosition)',self.nav)
        self.assertNotIn('humanoid:MoveTo(destination)',self.nav)
        self.assertIn('path.Blocked:Connect',self.nav)

    def test_procedural_collisions_checked_before_movement(self):
        self.assertIn('workspace:Blockcast(',self.nav)
        self.assertIn('params.RespectCanCollide=true',self.nav)
        self.assertIn('Nav.blockedAhead(model,position,',self.cit)
        self.assertIn('Nav.within(quarter,nextPosition)',self.cit)
        self.assertIn('retryAt=now+2.0',self.cit)
        self.assertNotIn('radius*math.cos(theta)',self.cit)

    def test_multiple_routes_and_stops_not_perpetual_circles(self):
        routes=re.search(r'local ROUTES=\{(.*?)\n\}',self.nav,re.S).group(1)
        self.assertGreaterEqual(routes.count('    {'),6)
        self.assertIn('Promenade du boulevard',self.nav)
        self.assertIn('Terrasse commune',self.nav)
        self.assertIn('task.wait(2.0)',self.r15)
        self.assertIn('task.wait(2.0)',self.res)
        self.assertIn('Presence.near',self.cit)
        self.assertIn('Presence.near',self.r15)
        self.assertIn('Presence.near',self.res)

    def test_no_network_or_broken_interaction_ids(self):
        for source in (self.nav,self.cit,self.r15,self.res):
            self.assertNotIn('HttpService',source)
            self.assertNotIn('TeleportService',source)
        self.assertIn('"citizen.%03d.dialogue"',self.cit)
        self.assertIn('"city.r15.%02d.dialogue"',self.r15)
        self.assertIn('"kin.resident.%02d.future"',self.res)

if __name__=='__main__':unittest.main()
