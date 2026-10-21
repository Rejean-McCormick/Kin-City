"""Original swept hair sculpture. No downloads, no Roblox asset IDs."""
from pathlib import Path
import math,json
ROOT=Path(__file__).resolve().parents[1]
def generate(root=ROOT):
    out=root/'assets/kingklown-v7';out.mkdir(parents=True,exist_ok=True)
    vertices=[];faces=[]
    def vertex(p):vertices.append(p);return len(vertices)
    def tube(centers,radii):
        rings=[]
        for center,(rx,rz) in zip(centers,radii):
            rings.append([vertex((center[0]+rx*math.cos(k*2*math.pi/12),center[1],center[2]+rz*math.sin(k*2*math.pi/12))) for k in range(12)])
        for a,b in zip(rings,rings[1:]):
            for k in range(12):
                j=(k+1)%12
                faces.extend([(a[k],b[k],b[j]),(a[k],b[j],a[j])])
        bottom=vertex(centers[0]);top=vertex(centers[-1])
        for k in range(12):
            j=(k+1)%12;faces.extend([(bottom,rings[0][k],rings[0][j]),(top,rings[-1][j],rings[-1][k])])
    # Crown-less scalp cap with a swept asymmetrical silhouette.
    tube([(0,.34,.12),(0,.51,.12),(0,.68,.12)],[(.72,.48),(.88,.61),(.60,.44)])
    locks=[(-.60,.60,-.32,-.28,.55,-.22),(-.30,.70,-.36,-.12,.72,-.16),(.03,.70,-.35,.30,.60,-.18),(.38,.60,-.28,.42,.34,-.16),(-.60,.54,.28,-.30,.42,.21),(.12,.61,.40,.28,.53,.25),(.60,.40,.20,.20,.20,.23)]
    for x,y,z,dx,dy,dz in locks:
        centers=[];radii=[]
        for j in range(9):
            t=j/8;centers.append((x+dx*t*t,y+dy*t,z+dz*t*t))
            radii.append((.23*(1-.97*t),.18*(1-.97*t)))
        tube(centers,radii)
    bounds=[(min(v[a] for v in vertices),max(v[a] for v in vertices)) for a in range(3)]
    center=[(lo+hi)/2 for lo,hi in bounds];size=[hi-lo for lo,hi in bounds]
    normalized=[tuple((v[a]-center[a])/size[a] for a in range(3)) for v in vertices]
    lines=['# King Klown v7 - original geometry, normalized bounds','o KingKlownHair','s 1']
    lines += ['v %.8f %.8f %.8f'%v for v in normalized]
    lines += ['f %d %d %d'%f for f in faces]
    (out/'kingklown-hair-v7.obj').write_text('\n'.join(lines)+'\n')
    (out/'geometry.json').write_text(json.dumps({'center':center,'size':size,'vertices':len(vertices),'triangles':len(faces)},indent=2)+'\n')
    return center,size
if __name__=='__main__':print(generate())
