#!/usr/bin/env python3
"""Modèles OBJ originaux à facettes, centrés et normalisés à une unité.
Importation manuelle dans Roblox requise pour les utiliser comme FileMesh;
la ville fonctionne sans eux grâce aux primitives natives.
"""
from pathlib import Path
from math import cos, sin, pi
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'assets/meshes-v23'
OUT.mkdir(parents=True,exist_ok=True)

class Mesh:
    def __init__(self,name):
        self.name=name;self.v=[];self.f=[]
    def vertex(self,x,y,z):
        self.v.append((x,y,z));return len(self.v)
    def triangle(self,a,b,c):self.f.append((a,b,c))
    def quad(self,a,b,c,d):self.triangle(a,b,c);self.triangle(a,c,d)
    def rings(self,rings,n=10):
        prev=None
        for ry,radx,radz,phase in rings:
            current=[self.vertex(cos(2*pi*i/n+phase)*radx,ry,sin(2*pi*i/n+phase)*radz) for i in range(n)]
            if prev:
                for i in range(n):
                    j=(i+1)%n
                    self.quad(prev[i],prev[j],current[j],current[i])
            else:
                bottom=self.vertex(0,ry,0)
                for i in range(n):self.triangle(bottom,current[(i+1)%n],current[i])
            prev=current
        if prev:
            top=self.vertex(0,rings[-1][0],0)
            for i in range(n):self.triangle(top,prev[i],prev[(i+1)%n])
    def bar(self,p0,p1,width,depth):
        # Extrusion x-y: an orthogonal rectangular tube with constant z thickness.
        x0,y0=p0;x1,y1=p1
        dx,dy=x1-x0,y1-y0
        norm=(dx*dx+dy*dy)**0.5 or 1
        nx,ny=-dy/norm*width/2,dx/norm*width/2
        points=[(x0-nx,y0-ny,-depth/2),(x0+nx,y0+ny,-depth/2),(x1+nx,y1+ny,-depth/2),(x1-nx,y1-ny,-depth/2),
                (x0-nx,y0-ny,depth/2),(x0+nx,y0+ny,depth/2),(x1+nx,y1+ny,depth/2),(x1-nx,y1-ny,depth/2)]
        ids=[self.vertex(*pt) for pt in points]
        for a,b,c,d in ((0,1,2,3),(4,7,6,5),(0,4,5,1),(1,5,6,2),(2,6,7,3),(3,7,4,0)):
            self.quad(ids[a],ids[b],ids[c],ids[d])
    def write(self):
        path=OUT/(self.name+'.obj')
        with path.open('w') as out:
            out.write(f'# Kin City / original procedural mesh / {self.name}\n')
            out.write('mtllib kincity-crystal.mtl\nusemtl OpaleMinerale\n')
            for x,y,z in self.v:out.write(f'v {x:.7f} {y:.7f} {z:.7f}\n')
            for a,b,c in self.f:out.write(f'f {a} {b} {c}\n')
        print(path.name,len(self.v),'vertices',len(self.f),'triangles')

column=Mesh('mineral-column')
column.rings([(-.5,.22,.22,0),(-.46,.28,.28,0),(-.39,.24,.24,.07),(-.10,.20,.20,0),(.14,.23,.23,.07),(.37,.20,.20,0),(.45,.29,.29,0),(.5,.29,.29,0)],10)
column.write()
spire=Mesh('opal-spire')
spire.rings([(-.5,.34,.34,0),(-.42,.4,.4,0),(-.20,.29,.29,.1),(.16,.34,.34,0),(.33,.23,.23,.1),(.48,.025,.025,0)],8)
spire.write()
rosette=Mesh('crystal-rosette')
# Radial faceted relief with 10 petals; x/y plane, depth is z.
for i in range(10):
    a=2*pi*i/10
    side=0.12
    center=rosette.vertex(.14*cos(a),.14*sin(a),-.08)
    lo=rosette.vertex(.38*cos(a-side),.38*sin(a-side),-.05)
    peak=rosette.vertex(.5*cos(a),.5*sin(a),.09)
    hi=rosette.vertex(.38*cos(a+side),.38*sin(a+side),-.05)
    rosette.triangle(center,lo,peak);rosette.triangle(center,peak,hi)
    rosette.triangle(lo,hi,peak)
    rosette.triangle(center,hi,lo)  # fermer l'arrière du pétale
rosette.rings([(-.15,.11,.11,0),(.15,.13,.13,0)],10) # ornamental central axis
rosette.write()
arch=Mesh('opal-arch')
pts=[]
# Arch from left foot to right foot: quarter-circle blend with vertical pillars.
pts.append((-.42,-.5));pts.append((-.42,-.12))
for k in range(1,15):
    a=pi-k*pi/14
    pts.append((.42*cos(a),-.12+.55*sin(a)))
pts.append((.42,-.5))
for a,b in zip(pts,pts[1:]):arch.bar(a,b,0.10,0.22)
arch.write()
lamp=Mesh('opal-chandelier')
lamp.rings([(-.12,.36,.36,0),(-.04,.46,.46,0),(.1,.4,.4,.03),(.18,.17,.17,0)],12)
for i in range(8):
    a=i*pi/4
    x,z=cos(a)*.31,sin(a)*.31
    # Hanging prism at each ring node.
    idx=[]
    for height,r in ((-.48,.02),(-.38,.08),(-.18,.08)):
        idx.append([lamp.vertex(x+cos(j*pi/2)*r,height,z+sin(j*pi/2)*r) for j in range(4)])
    for m in range(2):
        for j in range(4):lamp.quad(idx[m][j],idx[m][(j+1)%4],idx[m+1][(j+1)%4],idx[m+1][j])
    lamp.quad(idx[0][0],idx[0][3],idx[0][2],idx[0][1])
    lamp.quad(idx[2][0],idx[2][1],idx[2][2],idx[2][3])
lamp.write()
(OUT/'kincity-crystal.mtl').write_text('''# Palette originale Kin City\nnewmtl OpaleMinerale\nKa 0.14 0.29 0.28\nKd 0.77 0.94 0.90\nKs 0.18 0.24 0.23\nNs 48.0\nd 1.0\n''')
(OUT/'README.md').write_text('''# Kit de cinq meshes de Kin City v23\n\nFichiers OBJ + matériau MTL produits localement, originaux, sans asset tiers. Unités normalisées; Roblox fixe la taille par code. Importer les OBJ dans Roblox Studio/Creator Hub, obtenir les IDs utilisables avec SpecialMesh, puis remplir `config/meshes.json` et régénérer l'installateur. Les champs `null` déclenchent des volumes natifs Roblox : l'installateur reste autonome sans import. Les meshes ne contiennent ni rig, ni collision; ils sont uniquement décoratifs.\n\n- `mineral-column.obj` : pilier cannelé et facetté\n- `opal-spire.obj` : pointe de cristal\n- `crystal-rosette.obj` : relief radial\n- `opal-arch.obj` : arche minérale\n- `opal-chandelier.obj` : luminaire facetté\n''',encoding='utf8')
