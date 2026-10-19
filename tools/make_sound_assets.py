#!/usr/bin/env python3
"""Original CC0-style/generated Foley for Kin City. PCM WAV, no downloaded/licensed assets.
Files require normal Roblox Studio audio upload before use; no external AI service.
"""
from pathlib import Path
import math, random, struct, wave

ROOT=Path(__file__).resolve().parents[1]/'assets'/'audio'
ROOT.mkdir(parents=True,exist_ok=True)
FS=16000

def clip(name,seconds,fn):
    out=ROOT/name
    rnd=random.Random(716)
    with wave.open(str(out),'wb') as wav:
        wav.setframerate(FS)
        wav.setnchannels(1)
        wav.setsampwidth(2)
        block=[]
        last=0.0
        for n in range(round(seconds*FS)):
            t=n/FS
            s,last=fn(t,n,last,rnd)
            # Soft fade at both ends of loops.
            fade=min(1.0,n/(FS*.2),(seconds*FS-n)/(FS*.2))
            block.append(struct.pack('<h',int(32767*max(-0.96,min(0.96,s*max(0,fade))))))
            if len(block)==8000:
                wav.writeframesraw(b''.join(block));block=[]
        if block:wav.writeframesraw(b''.join(block))
    print(out.name,round(out.stat().st_size/1024),'KiB')

def wind(t,n,prev,rnd):
    smooth=prev*0.994+rnd.uniform(-1,1)*0.006
    return (0.38*smooth+0.07*math.sin(2*math.pi*.09*t)+0.045*math.sin(2*math.pi*.17*t)),smooth

def water(t,n,prev,rnd):
    smooth=prev*0.68+rnd.uniform(-1,1)*0.32
    foam=0.12*math.sin(2*math.pi*(55+7*math.sin(t*0.7))*t)
    return (0.21*smooth+foam*math.sin(t*3.1)**2),smooth

def bells(t,n,prev,rnd):
    # Nine soft tintinnabulations, intended as UI feedback, not protected music.
    notes=[392.0,523.25,659.25,783.99,659.25,523.25,392.0]
    idx=min(len(notes)-1,int(t/0.42))
    phase=t-idx*.42
    env=math.exp(-phase*7) if phase>=0 else 0
    tone=notes[idx]
    s=0.26*env*(math.sin(2*math.pi*tone*phase)+0.23*math.sin(2*math.pi*tone*2.02*phase))
    return s,prev

if __name__=='__main__':
    clip('kin-city-wind-loop.wav',8.0,wind)
    clip('kin-city-water-loop.wav',7.0,water)
    clip('kin-city-chimes.wav',3.1,bells)
