#!/usr/bin/env python3
"""Création déterministe de 3 OBJ centrés, normalisés [-0.5,0.5].
Sans téléchargement, Blender, modèle tiers ni besoin d'IA. Exécuter depuis le dépôt.
"""
from pathlib import Path
from math import cos,sin,pi
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'assets/meshes-v24'
OUT.mkdir(parents=True,exist_ok=True)
class Solid:
    def __init__(self,name):self.name=name;self.vertices=[];self.faces=[]
    def v(self,p):self.vertices.append(tuple(p));return len(self.vertices)
    def face(self,*ids):
        for i in range(1,len(ids)-1):self.faces.append((ids[0],ids[i],ids[i+1]))
    def ring(self,y,rx,rz,n=8):
        return [self.v((rx*cos(i*2*pi/n),y,rz*sin(i*2*pi/n))) for i in range(n)]
    def bridge(self,a,b):
        for i in range(len(a)):
            j=(i+1)%len(a)
            self.face(a[i],a[j],b[j],b[i])
    def cuboid(self,x0,x1,y0,y1,z0,z1):
        v=[self.v(x) for x in ((x0,y0,z0),(x1,y0,z0),(x1,y1,z0),(x0,y1,z0),
                                (x0,y0,z1),(x1,y0,z1),(x1,y1,z1),(x0,y1,z1))]
        for a,b,c,d in ((0,3,2,1),(4,5,6,7),(0,1,5,4),(1,2,6,5),(2,3,7,6),(3,0,4,7)):
            self.face(v[a],v[b],v[c],v[d])
    def write(self):
        p=OUT/(self.name+'.obj')
        with p.open('w',encoding='utf-8') as f:
            f.write(f'# Kin City original procedural art — {self.name} — normalized geometry\n')
            f.write('mtllib kincity-v24.mtl\nusemtl SarcelleCristal\n')
            for v in self.vertices:f.write('v %.7f %.7f %.7f\n'%v)
            for face in self.faces:f.write('f %d %d %d\n'%face)
        print(p.name,len(self.vertices),'vertices',len(self.faces),'triangles')

# Corniche minérale: dais octogonal taillé, fermé en dessous et sommet facetté.
a=Solid('crystal-canopy')
r0=a.ring(-.42,.46,.44)
r1=a.ring(.0,.50,.48)
r2=a.ring(.37,.28,.27)
a.bridge(r0,r1);a.bridge(r1,r2)
center0=a.v((0,-.45,0));center1=a.v((0,.5,0))
for i in range(8):
 a.face(center0,r0[(i+1)%8],r0[i]);a.face(center1,r2[i],r2[(i+1)%8])
a.write()

# Bac de pierre avec lèvre ouverte et épaisseur réelle.
b=Solid('mineral-planter')
outer0=b.ring(-.5,.34,.34)
outer1=b.ring(.39,.47,.47)
inner1=b.ring(.39,.30,.30)
inner0=b.ring(-.24,.26,.26)
b.bridge(outer0,outer1)
b.bridge(outer1,inner1)
b.bridge(inner1,inner0)
center=b.v((0,-.3,0))
for i in range(8):
 b.face(center,inner0[i],inner0[(i+1)%8]);b.face(center,outer0[(i+1)%8],outer0[i])
b.write()

# Pupitre monobloc incliné, pied ancré et partie d'affichage facettée.
c=Solid('opal-console')
c.cuboid(-.20,.20,-.5,.17,-.22,.22)
c.cuboid(-.32,.32,-.5,-.40,-.28,.28)
# Plateau incliné à huit coins, section d'épaisseur constante
verts=[(-.45,.20,-.35),(.45,.20,-.35),(.45,.34,.32),(-.45,.34,.32),
       (-.45,.12,-.35),(.45,.12,-.35),(.45,.26,.32),(-.45,.26,.32)]
v=[c.v(x) for x in verts]
for f in ((0,1,2,3),(4,7,6,5),(0,4,5,1),(1,5,6,2),(2,6,7,3),(3,7,4,0)):
 c.face(*[v[i] for i in f])
c.write()
(OUT/'kincity-v24.mtl').write_text('''# Matériau indicatif; couleur définitive réglée dans Studio\nnewmtl SarcelleCristal\nKa 0.12 0.27 0.26\nKd 0.12 0.41 0.39\nKs 0.28 0.37 0.34\nNs 56.0\nd 1.0\n''')
(OUT/'README.md').write_text('''# Trois pièces architecturales originales — Kin City v24\n\nOBJ centrés, normalisés et conçus pour la mise à l'échelle via `MeshPart.Size`.\n- `crystal-canopy.obj` : couronnement octogonal facetté\n- `mineral-planter.obj` : bac minéral ouvert\n- `opal-console.obj` : pupitre opalin incliné\n\nExporter/importer ces OBJ via **Roblox Studio > Import**, puis enregistrer leur MeshPart dans `ServerStorage.KinCityAssetLibrary` avec `KinCity_Enregistrer_Mesh_Studio_v24.luau`. Aucun identifiant n'est fourni ou inventé.\nSans import, le code crée une sculpture équivalente à partir de primitives natives.\n''',encoding='utf8')
