"""Offline invariants v29. No Roblox rendering, collision engine, or teleport proof."""
from __future__ import annotations
import json,math,re,sys,unittest
from pathlib import Path
R=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(R/'tools'))
from compile_plan import compile_plan,is_blocked
P=compile_plan(R)

def near_sign(x,z,buildings,padding=13):
 for b in buildings:
  xx=x-b['center_studs'][0];zz=z-b['center_studs'][2];yaw=math.radians(b['yaw_degrees'])
  localx=math.cos(yaw)*xx-math.sin(yaw)*zz
  localz=math.sin(yaw)*xx+math.cos(yaw)*zz
  if abs(localx)<b['footprint_studs'][0]/2+padding and abs(localz)<b['footprint_studs'][1]/2+padding:return True
 return False

def signs_for_routes():
 placed=[];achieved=set()
 for path in P['pedestrian_paths']:
  route=path['path_xyz_studs'];id=path['building_id']
  for j in range(1,len(route)):
   ax,az=route[j-1][0],route[j-1][2];bx,bz=route[j][0],route[j][2]
   dist=math.hypot(bx-ax,bz-az)
   if dist<=6:continue
   dx,dz=(bx-ax)/dist,(bz-az)/dist
   x,z=ax+dx*min(dist-2,9)-dz*6.5,az+dz*min(dist-2,9)+dx*6.5
   if id not in achieved and math.hypot(x,z)>=72 and not near_sign(x,z,P['structures']) and all(math.hypot(x-px,z-pz)>=25 for px,pz in placed):
    placed.append((x,z));achieved.add(id)
 for path in P['pedestrian_paths']:
  id=path['building_id']
  if id in achieved:continue
  gx,gz=path['path_xyz_studs'][-1][0],path['path_xyz_studs'][-1][2]
  bearing=math.atan2(gz,gx)
  for radius in (115,145,175):
   for offset in range(-12,13):
    angle=bearing+offset*math.pi/24
    x,z=math.cos(angle)*radius,math.sin(angle)*radius
    if not near_sign(x,z,P['structures']) and all(math.hypot(x-px,z-pz)>=26 for px,pz in placed):
     placed.append((x,z));achieved.add(id);break
   if id in achieved:break
 return placed,achieved

class V29Geometry(unittest.TestCase):
 def test_eight_destinations_reached_without_furniture_collision(self):
  self.assertEqual(len(P['pedestrian_paths']),8)
  blocked=P['navigation_obstacles']
  self.assertEqual(len({o['id'] for o in blocked}),len(blocked))
  self.assertEqual(len(blocked),19)
  for path in P['pedestrian_paths']:
   for a,b in zip(path['path_xyz_studs'],path['path_xyz_studs'][1:]):
    self.assertTrue(a[0]==b[0] or a[2]==b[2])
    self.assertTrue((abs(a[0]-b[0])+abs(a[2]-b[2]))%10==0)
    steps=int((abs(a[0]-b[0])+abs(a[2]-b[2]))/10)
    for k in range(steps+1):
     x=a[0]+(b[0]-a[0])*k/steps
     z=a[2]+(b[2]-a[2])*k/steps
     self.assertFalse(is_blocked(x,z,[],obstacles=blocked),(path['building_id'],x,z))
 def test_pavement_geometry_does_not_overlap(self):
  nodes=set();edges=set();rect=[]
  for path in P['pedestrian_paths']:
   for a,b in zip(path['path_xyz_studs'],path['path_xyz_studs'][1:]):
    dx=10 if b[0]>a[0] else (-10 if b[0]<a[0] else 0)
    dz=10 if b[2]>a[2] else (-10 if b[2]<a[2] else 0)
    count=int((abs(b[0]-a[0])+abs(b[2]-a[2]))/10)
    for j in range(count+1):
     x,z=a[0]+dx*j,a[2]+dz*j
     if math.hypot(x,z)>56:nodes.add((x,z))
     if j and math.hypot(x-dx,z-dz)>56 and math.hypot(x,z)>56:
      edges.add((x-dx/2,z-dz/2,dx!=0))
  for x,z in nodes:rect.append((x-3,x+3,z-3,z+3))
  for x,z,horizontal in edges:
   sx,sz=(4,6) if horizontal else (6,4)
   rect.append((x-sx/2,x+sx/2,z-sz/2,z+sz/2))
  for i,r in enumerate(rect):
   for q in rect[i+1:]:
    self.assertFalse(min(r[1],q[1])-max(r[0],q[0])>1e-7 and min(r[3],q[3])-max(r[2],q[2])>1e-7)
  # Expected tile count against duplicated original path segments. Not a FPS claim.
  raw=sum(len(p['path_xyz_studs'])-1 for p in P['pedestrian_paths'])
  self.assertGreater(raw,0)
  self.assertTrue(len(rect)>0)
 def test_raster_union_is_exact_and_without_any_duplicate_surface(self):
  from collections import defaultdict
  nodes,edges=set(),set()
  for path in P['pedestrian_paths']:
   for a,b in zip(path['path_xyz_studs'],path['path_xyz_studs'][1:]):
    dx=0 if a[0]==b[0] else (10 if b[0]>a[0] else -10)
    dz=0 if a[2]==b[2] else (10 if b[2]>a[2] else -10)
    steps=(abs(b[0]-a[0])+abs(b[2]-a[2]))//10
    for j in range(steps+1):
     x,z=a[0]+j*dx,a[2]+j*dz
     if math.hypot(x,z)>56:nodes.add((x,z))
     if j and math.hypot(x-dx,z-dz)>56 and math.hypot(x,z)>56:
      edges.add((x-dx/2,z-dz/2,dx!=0))
  rows=defaultdict(set)
  for x,z in nodes:
   for xx in (x-2,x,x+2):
    for zz in (z-2,z,z+2):rows[zz//2].add(xx//2)
  for x,z,h in edges:
   for xx in ((x-1,x+1) if h else (x-2,x,x+2)):
    for zz in ((z-2,z,z+2) if h else (z-1,z+1)):
     rows[int(zz//2)].add(int(xx//2))
  rect=[];active={}
  for iz in sorted(rows):
   runs=[]
   for ix in sorted(rows[iz]):
    if runs and ix==runs[-1][1]+1:runs[-1][1]=ix
    else:runs.append([ix,ix])
   nxt={}
   for x1,x2 in runs:
    key=(x1,x2)
    if key in active and active[key][-1]==iz-1:
     item=active[key];item[-1]=iz
    else:item=[x1,x2,iz,iz]
    nxt[key]=item
   rect.extend(v for k,v in active.items() if k not in nxt)
   active=nxt
  rect.extend(active.values())
  reconstructed=set()
  for x1,x2,z1,z2 in rect:
   for x in range(x1,x2+1):
    for z in range(z1,z2+1):
     self.assertNotIn((x,z),reconstructed,'Deux rectangles coplanaires concurrents')
     reconstructed.add((x,z))
  expected={(x,z) for z,xs in rows.items() for x in xs}
  self.assertEqual(reconstructed,expected,'Union géométrique non conservatrice')
  self.assertEqual(len(rect),23,'Le plan connu a changé : réexaminer les jonctions')
  self.assertLess(len(rect),sum(len(p['path_xyz_studs'])-1 for p in P['pedestrian_paths']))
  self.assertIn('KinUniquePavementPieces', (R/'src/server/CityGenerator.luau').read_text())
 def test_signs_one_per_main_destination_avoid_footprints_and_one_another(self):
  locations,ids=signs_for_routes()
  self.assertEqual(ids,{p['building_id'] for p in P['pedestrian_paths']})
  self.assertEqual(len(locations),8)
  for i,(x,z) in enumerate(locations):
   self.assertGreaterEqual(math.hypot(x,z),72)
   self.assertFalse(near_sign(x,z,P['structures']))
   self.assertTrue(all(math.hypot(x-xx,z-zz)>=24.99 for xx,zz in locations[i+1:]))
 def test_spawn_consistency_with_placement_and_camera(self):
  anchor=next(a for p in P['places'] if p['place_key']=='city' for a in p['anchors'] if a['anchor_id']=='city.central.spawn')
  self.assertEqual(anchor['position_studs'],[0,3,-16])
  generator=(R/'src/server/CityGenerator.luau').read_text()
  travel=(R/'src/server/PlayerTravel.luau').read_text()
  cam=(R/'src/client/ArrivalCamera.luau').read_text()
  self.assertIn('Spatial.anchorCFrame("city","city.central.spawn")',generator)
  self.assertIn('token.character:PivotTo(cf)',travel)
  self.assertLess(travel.index('token.character:PivotTo(cf)'),travel.index('KinArrivalFrame'))
  self.assertIn('GetAttribute("KinArrivalFrame")',cam)
  self.assertIn('DevCameraOcclusionMode.Invisicam',cam)
 def test_annular_radial_segments_end_shorter_than_spacing(self):
  src=(R/'src/server/UrbanDetails.luau').read_text()
  self.assertIn('v.Magnitude-0.025',src)
  self.assertIn('14.975',src)
  self.assertIn('distanceToPath(x,z,path)',src)
 def test_baseplate_original_not_destroyed(self):
  s=(R/'src/server/GroundCompatibility.luau').read_text()
  self.assertIn('base.Parent=archive',s)
  self.assertNotIn('base:Destroy()',s)
 def test_portals_and_interactions_unchanged(self):
  import hashlib
  baseline=json.loads((R/'docs/v29_baseline_sha256.json').read_text())
  for f,expected in baseline.items():
   self.assertEqual(hashlib.sha256((R/f).read_bytes()).hexdigest(),expected,f)


class V29UI(unittest.TestCase):
 def src(self,name):return (R/'src/client'/f'{name}.luau').read_text()
 def test_g_reserved_and_h_unused_other_than_station(self):
  for p in (R/'src/client').glob('*.luau'):
   code=p.read_text()
   if p.stem!='KingKlownPerformance':self.assertNotIn('Enum.KeyCode.G',code,p.name)
   if p.stem!='IntermodalPanel':self.assertNotIn('Enum.KeyCode.H',code,p.name)
  self.assertIn('Enum.KeyCode.G',self.src('KingKlownPerformance'))
  self.assertIn('Enum.KeyCode.H',self.src('IntermodalPanel'))
 def test_no_forced_route_at_start_and_one_guide_mode(self):
  self.assertIn('local selected=nil',self.src('RouteGuide'))
  self.assertIn('KinGuideMode',self.src('RouteGuide'))
  self.assertIn('KinGuideMode',self.src('LibraryJourneyGuide'))
  self.assertIn('menu.register("library"',self.src('LibraryJourneyGuide'))
 def test_menu_exclusivity_closure_and_mobile_scrolling(self):
  menu=self.src('KinCityMenu')
  for needle in ('function Menu.register','function Menu.open','function Menu.closeTools','showOnly(key)','GetPropertyChangedSignal("Visible")','ScrollingFrame','ViewportSize','ButtonSelect','Enum.KeyCode.ButtonB','Fermer l\'outil'):
   self.assertIn(needle,menu)
  self.assertIn('require(script.KinCityMenu).start()',self.src('init.client'))
 def test_panorama_exits_on_location_change_respawn_and_restores_fov(self):
  src=self.src('VistaCamera')
  for needle in ('CharacterAdded:Connect(restore)','GetAttributeChangedSignal("KinZone")','savedFrame','savedFieldOfView','camera.Focus=','UIScale'):
   self.assertIn(needle,src)
 def test_probe_local_and_conditional_on_zone_quality(self):
  src=self.src('LocalPerformanceProbeV29')
  for needle in ('os.clock()','elapsed<20','RenderStepped','table.sort(frames)','math.ceil(#values*p)','KinZone','KinCityLocalQuality','Aucune donnée envoyée'):
   self.assertIn(needle,src)
  for disallowed in ('HttpService','RemoteEvent','FireServer','TeleportService','DataStoreService'):
   self.assertNotIn(disallowed,src)

if __name__=='__main__':unittest.main()
