#!/usr/bin/env python3
"""Trois meshes OBJ originaux, low-poly, centrés et normalisés [-0.5,0.5]."""
from pathlib import Path
from math import pi,cos,sin
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'assets/meshes-v25'
OUT.mkdir(parents=True,exist_ok=True)
class Shape:
    def __init__(self,name):self.name=name;self.vertices=[];self.faces=[]
    def point(self,p):self.vertices.append(tuple(p));return len(self.vertices)
    def tri(self,a,b,c):self.faces.append((a,b,c))
    def quad(self,a,b,c,d):self.tri(a,b,c);self.tri(a,c,d)
    def bar(self,p0,p1,thickness=0.05,depth=.13):
        x,y=p0;X,Y=p1
        vx,vy=X-x,Y-y
        l=max((vx*vx+vy*vy)**.5,1e-6)
        nx=-vy/l*thickness/2;ny=vx/l*thickness/2
        corners=[(x-nx,y-ny,-depth/2),(x+nx,y+ny,-depth/2),(X+nx,Y+ny,-depth/2),(X-nx,Y-ny,-depth/2),
                 (x-nx,y-ny,depth/2),(x+nx,y+ny,depth/2),(X+nx,Y+ny,depth/2),(X-nx,Y-ny,depth/2)]
        vs=[self.point(c) for c in corners]
        for a,b,c,d in ((0,3,2,1),(4,5,6,7),(0,1,5,4),(1,2,6,5),(2,3,7,6),(3,0,4,7)):
            self.quad(vs[a],vs[b],vs[c],vs[d])
    def write(self):
        path=OUT/(self.name+'.obj')
        with path.open('w',encoding='utf8') as f:
            f.write(f'# Original Kin City v25 - {self.name} - normalized geometry\n')
            f.write('mtllib kincity-v25.mtl\nusemtl OpaleMinérale\n')
            for x,y,z in self.vertices:f.write(f'v {x:.7f} {y:.7f} {z:.7f}\n')
            for a,b,c in self.faces:f.write(f'f {a} {b} {c}\n')
        print(self.name,len(self.vertices),'vertices',len(self.faces),'triangles')

lattice=Shape('opal-lattice')
for x in (-.46,.46):lattice.bar((x,-.46),(x,.46),.055,.15)
for y in (-.46,.46):lattice.bar((-.46,y),(.46,y),.055,.15)
for x in (-.23,0,.23):lattice.bar((x,-.46),(x,.46),.031,.09)
for y in (-.23,0,.23):lattice.bar((-.46,y),(.46,y),.031,.09)
lattice.write()

pediment=Shape('mineral-pediment')
# Triangular pediment with layered bars and opaline ridge, suitable for façades.
for p,q,w in [((-.44,-.35),(0,.42),.10),((0,.42),(.44,-.35),.10),((-.44,-.35),(.44,-.35),.10),
               ((-.38,-.26),(0,.27),.05),((0,.27),(.38,-.26),.05),((-.38,-.26),(.38,-.26),.05)]:
    pediment.bar(p,q,w,.18)
pediment.write()

harbor=Shape('harbor-crest')
# Stylized mooring symbol: strong silhouette, no glass, no physical collision.
harbor.bar((0,-.43),(0,.43),.10,.17)
harbor.bar((-.28,.27),(.28,.27),.08,.17)
for n in range(12):
    a=pi+(pi*n/11)
    b=pi+(pi*(n+1)/11)
    harbor.bar((cos(a)*.34,sin(a)*.33-.06),(cos(b)*.34,sin(b)*.33-.06),.09,.16)
for x in (-.33,.33):harbor.bar((x,-.06),(x,-.26),.09,.17)
harbor.write()

(OUT/'kincity-v25.mtl').write_text('''# Palette de travail. SurfaceAppearance finale importée séparément dans Studio.
newmtl OpaleMinérale
Ka 0.12 0.26 0.25
Kd 0.77 0.94 0.90
Ks 0.20 0.30 0.28
Ns 54.0
d 1.0
''',encoding='utf8')
(OUT/'README.md').write_text('''# Trois nouveaux meshes Kin City v25

- `opal-lattice.obj` : résille opaline pour vitrines et lanternes
- `mineral-pediment.obj` : fronton minéral à double nervure
- `harbor-crest.obj` : relief des ateliers maritimes

Les OBJ sont originaux, low-poly, centrés, normalisés sur une unité et facultatifs.
Importer comme MeshPart dans Roblox Studio, puis enregistrer avec le script
`KinCity_Enregistrer_Mesh_Studio_v25.luau`. Les générateurs proposent une
forme native lorsque les MeshParts ne sont pas importés.
''',encoding='utf8')
