import json,math,unittest
from pathlib import Path
from collections import Counter
from lupa import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
class StoryBehavior(unittest.TestCase):
    def setUp(self):
        self.lua=LuaRuntime(unpack_returned_tuples=True)
        self.rules=self.lua.execute((ROOT/'src/server/LibraryJourneyRules.luau').read_text())
        self.state=self.rules.new()
    def test_story_requires_welcome(self):
        self.assertEqual(self.rules.visit(self.state,'memory'),'start_first')
        self.assertEqual(self.rules.count(self.state),0)
    def test_duplicate_fragment_does_not_count_twice(self):
        self.rules.visit(self.state,'welcome')
        self.rules.visit(self.state,'memory')
        self.assertEqual(self.rules.visit(self.state,'memory'),'repeat')
        self.assertEqual(self.rules.count(self.state),1)
    def test_cannot_finish_before_all_fragments(self):
        self.rules.visit(self.state,'welcome')
        self.rules.visit(self.state,'connection')
        self.assertEqual(self.rules.visit(self.state,'welcome'),'missing')
        self.assertFalse(self.state.finished)
    def test_fragments_can_be_read_in_any_order(self):
        self.rules.visit(self.state,'welcome')
        for fragment in ('imagination','memory','connection'):self.rules.visit(self.state,fragment)
        self.assertEqual(self.rules.target(self.state),'welcome')
        self.assertEqual(self.rules.visit(self.state,'welcome'),'complete')
        self.assertEqual(self.rules.target(self.state),'exit')
    def test_two_players_independent(self):
        other=self.rules.new();self.rules.visit(self.state,'welcome');self.rules.visit(self.state,'memory')
        self.assertEqual(self.rules.count(other),0)
        self.assertEqual(self.rules.target(other),'welcome')
    def test_invalid_actions_do_not_change_state(self):
        self.assertEqual(self.rules.visit(self.state,'grant_credits'),'invalid')
        self.assertEqual(self.rules.count(self.state),0)

class RouteBehavior(unittest.TestCase):
    def setUp(self):
        self.lua=LuaRuntime(unpack_returned_tuples=True)
        self.path=self.lua.execute((ROOT/'src/shared/JourneyPath.luau').read_text())
    def points(self,points):return self.lua.table_from([self.lua.table_from(p) for p in points])
    def test_off_path_projects_to_walkway(self):
        result=self.path.target(self.points([[0,0,0],[70,0,0],[70,0,30]]),25,20)
        self.assertEqual((result[1],result[3]),(25,0))
    def test_corner_not_skipped_from_far_away(self):
        result=self.path.target(self.points([[0,0,0],[70,0,0],[70,0,30]]),30,0)
        self.assertEqual((result[1],result[3]),(70,0))
    def test_cross_room_path_uses_portal_axis(self):
        points=self.path.roomRoute(-48,-8,self.lua.table_from([27,0,15]))
        self.assertEqual((points[2][1],points[2][3]),(-27,-8))
        self.assertEqual((points[3][1],points[3][3]),(-27,-18))
    def test_portal_exit_does_not_send_player_back(self):
        points=self.path.roomRoute(-27,-9,self.lua.table_from([27,0,15]))
        target=self.path.target(points,-27,-9)
        self.assertEqual((target[1],target[3]),(-27,-18))
    def test_same_room_direct_route(self):
        points=self.path.roomRoute(-27,15,self.lua.table_from([-32,0,32]))
        self.assertEqual(len(points),2)

class StoryPlacement(unittest.TestCase):
    def test_reuses_existing_furniture_and_door_ids(self):
        config=json.loads((ROOT/'config/library_journey.json').read_text())
        spatial=json.loads((ROOT/'catalog/spatial.json').read_text())
        library=next(p for p in spatial['places'] if p['place_key']=='library')
        furnishings={p['furnishing_id']:p for p in library['furnishings']}
        rooms={r['room_id']:r for r in library['rooms']}
        self.assertEqual(len({s['furnishing_id'] for s in config['stations']}),4)
        for station in config['stations']:
            furn=furnishings[station['furnishing_id']];room=rooms[furn['room_id']]
            for axis,half in ((0,1.2),(2,.8)):
                self.assertLessEqual(abs(furn['position_studs'][axis]-room['center_studs'][axis])+half,room['size_studs'][axis]/2)
            self.assertLess(7.5,room['size_studs'][1])
        doors=json.loads((ROOT/'catalog/doors.json').read_text())['doors']
        self.assertTrue(any(d['door_id']==config['entry_door_id'] for d in doors))
        self.assertTrue(any(d['door_id']==config['exit_door_id'] for d in doors))
    def test_mesh_closed_and_nondegenerate(self):
        vertices=[];faces=[]
        for line in (ROOT/'assets/kingklown-v7/kingklown-hair-v7.obj').read_text().splitlines():
            if line.startswith('v '):vertices.append(tuple(map(float,line.split()[1:])))
            if line.startswith('f '):faces.append(tuple(int(n)-1 for n in line.split()[1:]))
        edges=Counter()
        for a,b,c in faces:
            self.assertEqual(len({a,b,c}),3)
            u=[vertices[b][i]-vertices[a][i] for i in range(3)];v=[vertices[c][i]-vertices[a][i] for i in range(3)]
            cross=(u[1]*v[2]-u[2]*v[1],u[2]*v[0]-u[0]*v[2],u[0]*v[1]-u[1]*v[0])
            self.assertGreater(sum(n*n for n in cross),1e-16)
            for x,y in ((a,b),(b,c),(c,a)):edges[tuple(sorted((x,y)))]+=1
        self.assertTrue(all(n==2 for n in edges.values()))
        self.assertTrue(all(abs(n)<=.50000001 for v in vertices for n in v))
