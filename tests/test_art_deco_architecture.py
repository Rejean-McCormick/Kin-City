"""Execute the production architecture planners and reservation allocator outside Roblox."""
import copy,json,sys,unittest
from pathlib import Path
from lupa import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from compile_plan import compile_plan
from art_deco_catalog import load_art_deco

class ArchitectureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lua=LuaRuntime(unpack_returned_tuples=True)
        cls.layout=cls.lua.execute((ROOT/'src/server/ArtDecoLayout.luau').read_text())
        cls.rooms=cls.lua.execute((ROOT/'src/server/ArtDecoRooms.luau').read_text())
        cls.budget=cls.lua.execute((ROOT/'src/server/ArtDecoBudget.luau').read_text())
        cls.world=compile_plan(ROOT);cls.data=load_art_deco(ROOT)
    def table(self,data):return self.lua.table_from(data,recursive=True)
    def plans(self):
        for structure in self.world['structures']:
            recipe=self.data['placements']['buildings'][structure['building_id']]
            yield structure,self.layout.compile(*structure['footprint_studs'],structure['height_studs'],self.table(recipe))
    def test_all_eight_envelopes_fill_the_site_without_imports(self):
        self.assertEqual(len(list(self.plans())),8)
        for structure,plan in self.plans():
            floor=next(p for p in plan.parts.values() if p.name=='Floor')
            self.assertEqual(floor.size[1],structure['footprint_studs'][0])
            self.assertEqual(floor.size[3],structure['footprint_studs'][1])
            for p in plan.parts.values():
                self.assertGreater(min(p.size.values()),0,p.name)
                self.assertLessEqual(p.center[2]+p.size[2]/2,structure['height_studs']+1e-8,p.name)
                self.assertNotEqual(p.name,'BuildingCore')
    def test_public_approach_is_clear_for_a_player_capsule(self):
        for structure,plan in self.plans():
            self.assertGreaterEqual(plan.entry.width,8)
            for p in plan.parts.values():
                if not p.solid:continue
                # Swept AABB: player radius 2, height 8, crossing the front wall.
                overlaps_x=abs(p.center[1])<p.size[1]/2+2
                overlaps_y=p.center[2]+p.size[2]/2>.05 and p.center[2]-p.size[2]/2<8
                overlaps_z=abs(p.center[3]-plan.entry.z)<p.size[3]/2+4
                self.assertFalse(overlaps_x and overlaps_y and overlaps_z,(structure['building_id'],p.name))
    def test_eight_authored_shapes_and_sign_clearance(self):
        shapes=set()
        for structure,plan in self.plans():
            shapes.add(plan.shape)
            self.assertGreater(plan.sign.center[2]-plan.sign.height/2,plan.entry.height)
            self.assertGreater(plan.sign.width,16)
        self.assertEqual(len(shapes),8)
    def test_reservations_fit_every_global_budget(self):
        counts={'building':8,'street':6,'interior':8,'environment':6}
        for profile in self.data['config']['profiles'].values():
            for key in ('triangles','parts','clones'):
                self.assertLessEqual(sum(profile['pools'][pool][key]*n for pool,n in counts.items()),profile[key])
    def test_generation_order_cannot_starve_another_sector(self):
        limit={'triangles':8000,'parts':60,'clones':4}
        owners=['keenkonnect','ethikos','kreative','uckk','ekole','konnected']
        def allocate(order):
            budget=self.budget.new(self.table({owner:dict(limit) for owner in owners}));result={}
            for owner in order:
                accepted=0
                for _ in range(5):
                    receipt=budget.reserve(budget,owner,self.table({'triangles':2400,'parts':4,'clones':1}))
                    accepted+=receipt is not None
                result[owner]=accepted
            return result
        self.assertEqual(allocate(owners),allocate(list(reversed(owners))))
        self.assertEqual(set(allocate(owners).values()),{3})
    def test_real_allocator_boundaries_refund_and_invalid_owner(self):
        budget=self.budget.new(self.table({'building/a':{'triangles':10,'parts':4,'clones':1}}))
        cost=self.table({'triangles':10,'parts':4,'clones':1})
        self.assertIsNone(budget.reserve(budget,'unknown',cost))
        token=budget.reserve(budget,'building/a',cost)
        self.assertIsNotNone(token)
        self.assertIsNone(budget.reserve(budget,'building/a',cost))
        self.assertEqual(budget.stats(budget).triangles,10)
        self.assertTrue(budget.release(budget,token))
        self.assertFalse(budget.release(budget,token))
        self.assertEqual(budget.stats(budget).triangles,0)
        self.assertIsNotNone(budget.reserve(budget,'building/a',cost))
    def test_proposed_room_furniture_respects_routes_portals_and_canonical_objects(self):
        total=0
        for place in self.world['places']:
            if place['place_key']=='city':continue
            program=self.data['placements']['interior_programs'][place['place_key']]
            for index,room in enumerate(place['rooms'],1):
                slots=self.rooms.compile(self.table(room),self.table(place),self.table(program),index)
                for slot in slots.values():
                    total+=1
                    self.assertTrue(self.rooms.clear(slot,self.table(room),self.table(place)))
        self.assertGreater(total,0)
    def test_room_planner_rejects_a_portal_and_an_existing_furnishing(self):
        room={'room_id':'a','center_studs':[0,0,0],'size_studs':[60,16,60]}
        slot={'center':[16,0,16],'size':[8,5,8]}
        place={'portals':[],'furnishings':[]}
        self.assertTrue(self.rooms.clear(self.table(slot),self.table(room),self.table(place)))
        place['portals']=[{'from_room':'a','to_room':'b','center_studs':[16,0,16],'clear_width_studs':8}]
        self.assertFalse(self.rooms.clear(self.table(slot),self.table(room),self.table(place)))
        place['portals']=[];place['furnishings']=[{'position_studs':[16,0,16]}]
        self.assertFalse(self.rooms.clear(self.table(slot),self.table(room),self.table(place)))
    def test_pack_metadata_is_server_only(self):
        self.assertTrue((ROOT/'src/server/ArtDecoData.luau').exists())
        self.assertFalse((ROOT/'src/shared/ArtDecoData.luau').exists())
    def test_street_cadence_is_explicit_and_symmetric(self):
        for profile in self.data['config']['profiles'].values():
            lamps=2*len(profile['lamp_steps']);benches=2*len(profile['bench_steps'])
            self.assertLessEqual(lamps+benches,profile['pools']['street']['clones'])
            self.assertLessEqual(lamps*2400+benches*456,profile['pools']['street']['triangles'])
if __name__=='__main__':unittest.main()
