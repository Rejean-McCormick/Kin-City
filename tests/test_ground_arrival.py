"""Regression: leave custom ground alone and remove only the overlapping starter slab."""
import unittest,json
from pathlib import Path
from lupa import LuaRuntime
ROOT=Path(__file__).resolve().parents[1]
class GroundArrivalTests(unittest.TestCase):
 def scene(self,top=0,tilted=False,child=False):
  lua=LuaRuntime(unpack_returned_tuples=True)
  lua.execute('''
Vector3={yAxis={}}; storage={}; function storage:FindFirstChild() return self.archive end
workspace={}; Instance={new=function() return {} end}; game={GetService=function() return storage end}
base={Name="Baseplate",Anchored=true,Shape="Block",Size={X=512,Y=20,Z=512},Position={Y=-10},Parent=workspace}
Enum={PartType={Block="Block"}}; base.CFrame={UpVector={Dot=function() return 1 end},PointToObjectSpace=function() return {X=0,Z=0} end}
function base:IsA(kind) return kind=="Part" end
function base:GetDescendants() return {} end
function workspace:FindFirstChild() if base.Parent==self then return base end end
print=function() end
''')
  lua.globals().base.Position.Y=top-10
  if tilted:lua.execute('base.CFrame.UpVector.Dot=function() return 0.5 end')
  if child:lua.execute('base.GetDescendants=function() return {{IsA=function() return true end}} end')
  module=lua.execute((ROOT/'src/server/GroundCompatibility.luau').read_text());module.prepare()
  return lua,module
 def test_overlapping_base_archived_intact_and_idempotent(self):
  lua,m=self.scene();self.assertTrue(lua.eval('base.Parent~=workspace'));self.assertEqual(lua.eval('base.Parent.Name'),'KinCityOriginalGround');m.prepare();self.assertEqual(lua.eval('base.Position.Y'),-10)
 def test_low_ground_retained(self):
  lua,_=self.scene(-5);self.assertTrue(lua.eval('base.Parent==workspace'))
 def test_tilted_ground_retained(self):
  lua,_=self.scene(tilted=True);self.assertTrue(lua.eval('base.Parent==workspace'))
 def test_custom_children_retained(self):
  lua,_=self.scene(child=True);self.assertTrue(lua.eval('base.Parent==workspace'))
 def test_spawn_catalog_and_plan_agree(self):
  def anchor(data):
   city=next(p for p in data['places'] if p['place_key']=='city');return next(a for a in city['anchors'] if a['anchor_id']=='city.central.spawn')
  source=anchor(json.loads((ROOT/'catalog/spatial.json').read_text()));compiled=anchor(json.loads((ROOT/'build/world-plan.json').read_text()))
  self.assertEqual(source,compiled);self.assertEqual(source['position_studs'],[0,3,-16])
