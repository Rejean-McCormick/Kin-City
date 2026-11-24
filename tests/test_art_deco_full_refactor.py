"""Behavioral checks of the production planners, streamed zones and source quotas."""
import json
import sys
import unittest
from pathlib import Path
from lupa import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from art_deco_scene_audit import audit
from compile_plan import compile_plan
from art_deco_catalog import load_art_deco

class FullRefactorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lua=LuaRuntime(unpack_returned_tuples=True)
        cls.lua.execute('table.clone=function(t) local r={} for k,v in pairs(t) do r[k]=v end return r end')
        cls.layout=cls.lua.execute((ROOT/'src/server/ArtDecoLayout.luau').read_text())
        cls.surfaces=cls.lua.execute((ROOT/'src/server/ArtDecoSurfacePlan.luau').read_text())
        cls.wings=cls.lua.execute((ROOT/'src/server/InteriorWings.luau').read_text())
        cls.data=load_art_deco(ROOT);cls.world=compile_plan(ROOT)
        cls.records={a['asset_key']:a for a in cls.data['manifest']['assets']}
    def table(self,value):return self.lua.table_from(value,recursive=True)
    def places(self):
        for p in self.world['places']:
            if p['place_key']!='city':yield self.wings.expand(self.table(p))
    def slots(self,place):
        program=self.data['placements']['interior_programs'][place.place_key]
        for index,room in place.rooms.items():
            yield room,self.surfaces.room(room,place,self.table(program),index,
                self.table(self.data['placements']['surfaces']),self.table(self.data['config']['profiles']['STANDARD']))
    def test_static_light_selection_obeys_distance_and_quality_caps(self):
        policy=self.lua.execute((ROOT/'src/shared/ArtDecoLightPolicy.luau').read_text())
        for quality,cap in [('LITE',8),('STANDARD',16),('SHOWCASE',24)]:
            candidates=self.table([{'distance':float(i*i)} for i in range(30,0,-1)])
            self.assertEqual(policy.select(candidates,quality),cap)
            selected=[r.distance for r in candidates.values() if r.selected]
            self.assertEqual(selected,[float(i*i) for i in range(1,cap+1)])
        far=self.table([{'distance':1000000.0}])
        self.assertEqual(policy.select(far,'STANDARD'),0)

    def test_eight_street_facades_are_full_building_meshes(self):
        for s in self.world['structures']:
            recipe=self.data['placements']['buildings'][s['building_id']]
            plan=self.layout.compile(*s['footprint_studs'],s['height_studs'],self.table(recipe))
            self.assertEqual(len(list(plan.primary_shells.values())),2)
            width=sum(slot.size[1] for slot in plan.primary_shells.values())
            self.assertGreater(width,s['footprint_studs'][0]*.55)
            for slot in plan.primary_shells.values():
                self.assertEqual(self.records[slot.asset]['category'],'Exterior__Buildings')
                self.assertGreaterEqual(abs(slot.center[1])-slot.size[1]/2,plan.entry.width/2+3.9)
                self.assertLessEqual(abs(slot.center[1])+slot.size[1]/2,plan.width/2+.01)
            for part in plan.primary_parts.values():
                self.assertLessEqual(part.center[2]+part.size[2]/2,s['height_studs'])
                if part.name=='ConnectingCanopy':self.assertGreater(part.center[2]-part.size[2]/2,plan.entry.height+3)
    def test_primary_colliders_match_visible_wings_and_leave_portal_clear(self):
        for s in self.world['structures']:
            plan=self.layout.compile(*s['footprint_studs'],s['height_studs'],self.table(self.data['placements']['buildings'][s['building_id']]))
            colliders=[p for p in plan.primary_parts.values() if p.invisible]
            for shell,collider in zip(plan.primary_shells.values(),colliders):
                self.assertEqual(list(shell.size.values()),list(collider.size.values()))
                self.assertEqual(shell.center[1],collider.center[1])
                self.assertEqual(shell.center[3],collider.center[3])
                self.assertGreater(abs(collider.center[1])-collider.size[1]/2,4)
    def test_all_48_existing_rooms_receive_structural_surfaces(self):
        count=0
        for place in self.places():
            self.assertEqual(len(list(place.rooms.values())),6)
            for room,slots in self.slots(place):
                count+=1;kinds={s.kind for s in slots.values()}
                self.assertTrue({'wall','floor'}<=kinds,room.room_id)
                self.assertGreater(len(list(slots.values())),8)
                for slot in slots.values():
                    self.assertGreater(min(slot.size.values()),0)
                    if slot.kind=='floor':
                        self.assertLessEqual(abs(slot.center[1]-room.center_studs[1])+slot.size[1]/2,room.size_studs[1]/2-2)
                        self.assertLessEqual(abs(slot.center[3]-room.center_studs[3])+slot.size[3]/2,room.size_studs[3]/2-2)
        self.assertEqual(count,48)
    def test_wall_panels_do_not_cover_existing_portal_openings(self):
        for place in self.places():
            for room,slots in self.slots(place):
                for slot in slots.values():
                    if slot.kind!='wall':continue
                    horizontal=slot.yaw in (0,180)
                    for portal in place.portals.values():
                        if portal.from_room!=room.room_id and portal.to_room!=room.room_id:continue
                        c=portal.center_studs
                        perp=3 if horizontal else 1;axis=1 if horizontal else 3
                        if abs(slot.center[perp]-c[perp])<3:
                            self.assertGreaterEqual(abs(slot.center[axis]-c[axis])-slot.size[1]/2,portal.clear_width_studs/2+.9)
    def test_traversable_portals_use_columns_not_closed_door_models(self):
        assets=self.table(self.data['placements']['surfaces'])
        for place in self.places():
            slots=self.surfaces.portals(place,assets)
            frames=[s for s in slots.values() if s.kind=='portal']
            self.assertEqual(len(frames),2*len(list(place.portals.values())))
            self.assertTrue(all(s.asset=='AD_Arc_Column_Round_10' for s in frames))
            self.assertEqual(sum(s.kind=='exit' for s in slots.values()),1)
    def test_mezzanine_mesh_floor_aligns_with_existing_walkable_floor(self):
        slots=self.surfaces.upper(self.table(self.data['placements']['surfaces']))
        source=self.records['AD_Arc_Mezzanine_Rail_Blue']['source_bounds']
        for slot in slots.values():
            scale=min(slot.size[i+1]/source[i] for i in range(3))
            self.assertAlmostEqual(slot.center[2]+.62*scale,18.02)
            self.assertGreaterEqual(abs(slot.center[1])-12/2,19)
    def test_every_planned_structural_clone_fits_each_profile_without_starvation(self):
        report=audit(ROOT)
        for name,profile in report['profiles'].items():
            self.assertEqual(len(profile['interiors']),8)
            self.assertEqual(profile['city']['pavilions']['clones'],18)
    def test_owner_reservations_cover_all_zone_categories(self):
        counts={'building':8,'pavilion':6,'architecture':8,'street':6,'paving':6,'interior':8,'environment':6}
        for profile in self.data['config']['profiles'].values():
            for dimension in ['triangles','parts','clones']:
                self.assertEqual(sum(n*profile['pools'][pool][dimension] for pool,n in counts.items()),profile[dimension])
    def test_original_institution_origins_are_far_from_city_and_each_other(self):
        origins=json.loads((ROOT/'config/interior_origins.json').read_text())
        self.assertEqual(len(origins),8)
        for key,pos in origins.items():
            self.assertGreater(sum(v*v for v in pos)**.5,1000,key)
            for other,other_pos in origins.items():
                if other!=key:self.assertGreater(sum((a-b)**2 for a,b in zip(pos,other_pos))**.5,1000)

if __name__=='__main__':unittest.main()
