#!/usr/bin/env python3
"""Quatre matériaux tileables originaux (Color/Normal/Roughness) pour Roblox.
Pas de banque d'images ni téléchargement. Les Maps exigent un import Studio pour PBR.
"""
from pathlib import Path
from PIL import Image, ImageDraw
import numpy as np

OUT=Path(__file__).resolve().parents[1]/'assets/materials-v23'
OUT.mkdir(parents=True,exist_ok=True)
N=512
rng=np.random.default_rng(23102026)
y,x=np.mgrid[0:N,0:N].astype(np.float64)
a=x*2*np.pi/N;b=y*2*np.pi/N

def periodic_noise(seed):
    r=np.random.default_rng(seed)
    h=np.zeros((N,N),np.float64)
    for octave in (1,2,3,5,8,13,21):
        p1=r.random()*2*np.pi;p2=r.random()*2*np.pi
        h+=(np.sin(a*octave+p1)*np.cos(b*octave+p2)+
             0.32*np.sin((a+b)*octave+p2)) / (octave**0.9)
    h/=2.2
    h=np.clip(h,-1,1)
    return h

specs={
  'sarcelle-pierre': {'rgb':(30,104,100),'variation':(13,19,16),'rough':165,'normal':.18},
  'opale-massive': {'rgb':(197,244,240),'variation':(23,14,11),'rough':105,'normal':.13},
  'champagne-mineral': {'rgb':(229,215,175),'variation':(17,14,10),'rough':94,'normal':.09},
  'pierre-promenoir': {'rgb':(173,186,171),'variation':(15,17,14),'rough':176,'normal':.20},
}
for i,(name,spec) in enumerate(specs.items()):
    noise=periodic_noise(800+i)
    grains=periodic_noise(990+i)
    veins=np.sin((a*4+b*2)+2.0*noise)
    height=0.62*noise+0.24*grains+0.10*veins
    col=np.zeros((N,N,3),np.float64)
    for c in range(3):
        col[:,:,c]=spec['rgb'][c]+spec['variation'][c]*(height+0.15*veins)
    col=np.uint8(np.clip(col,0,255))
    Image.fromarray(col,'RGB').save(OUT/(name+'-color.png'),optimize=True)
    rr=spec['rough']+18*noise+8*grains
    rough=np.uint8(np.clip(rr,0,255))
    Image.fromarray(rough,'L').save(OUT/(name+'-roughness.png'),optimize=True)
    # Dérivées périodiques: bord sans couture artificielle.
    ddx=(np.roll(height,-1,1)-np.roll(height,1,1))*.5*spec['normal']*N*.38
    ddy=(np.roll(height,-1,0)-np.roll(height,1,0))*.5*spec['normal']*N*.38
    nx,ny,nz=-ddx,-ddy,np.ones_like(ddx)
    length=np.sqrt(nx*nx+ny*ny+nz*nz)
    nm=np.stack(((nx/length+1)*127.5,(ny/length+1)*127.5,(nz/length+1)*127.5),2)
    Image.fromarray(np.uint8(np.clip(nm,0,255)),'RGB').save(OUT/(name+'-normal.png'),optimize=True)
    print('3 maps',name)

# Planche couleur consultable localement; ce n'est PAS une capture Roblox.
canvas=Image.new('RGB',(1056,1056),(245,247,244))
draw=ImageDraw.Draw(canvas)
for i,name in enumerate(specs):
    thumb=Image.open(OUT/(name+'-color.png')).convert('RGB')
    col=i%2;row=i//2
    xx=12+col*526;yy=12+row*526
    canvas.paste(thumb,(xx,yy))
    draw.rectangle((xx,yy+482,xx+511,yy+511),fill=(15,44,43))
    draw.text((xx+12,yy+489),name,fill=(242,250,247))
canvas.save(OUT/'palette-apercu.png',optimize=True)
(OUT/'README.md').write_text('''# Matériaux v23 — textures originales et périodiques\n\nQuatre ensembles de maps 512 × 512 créés par algorithme local, sans assets tiers. Chaque matériau comprend `color`, `normal` et `roughness`. La planche `palette-apercu.png` montre uniquement les textures générées, pas un résultat dans Roblox.\n\nImportation **optionnelle** dans Roblox Studio > Material Manager / MaterialVariant. Réutiliser sur les structures, ne pas produire une variante par instance. Les générateurs Kin City livrés restent fonctionnels avec les matériaux natifs; l'import PBR n'est pas automatisé faute d'AssetIds publiés.\n''',encoding='utf8')
