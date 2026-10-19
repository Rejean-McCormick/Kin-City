#!/usr/bin/env python3
"""Cinq courts lits sonores originaux, en WAV mono (boucles facultatives Roblox).
Pure génération locale; aucun son sous licence et aucun accès réseau.
"""
from pathlib import Path
import math
import wave
import random
import struct
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'assets/audio'
RATE=22050
SECONDS=6
SAMPLES=RATE*SECONDS

def envelope(i):
    # Les 60 premières et dernières millisecondes convergent vers zéro.
    t=i/RATE
    return min(1.0,t/0.06,max(0.0,(SECONDS-t)/0.06))

def data(kind):
    rng=random.Random(19062026+len(kind))
    phase=0.0
    buffer=[]
    prev=0.0
    for i in range(SAMPLES):
        t=i/RATE
        r=rng.uniform(-1,1)
        prev=0.995*prev+0.005*r
        if kind=='archives':
            beat=0.025*math.sin(2*math.pi*87*t)+0.035*math.sin(2*math.pi*132*t)
            rustle=0.28*prev+0.009*r*(math.sin(2*math.pi*0.37*t)**2)
            sound=beat+rustle
        elif kind=='laboratory':
            sound=(0.09*math.sin(2*math.pi*110*t)+0.045*math.sin(2*math.pi*165*t)
                   +0.025*math.sin(2*math.pi*220*t+0.4*math.sin(2*math.pi*0.35*t))
                   +0.04*prev)
        elif kind=='harbor':
            ring=0.0
            for onset,freq in ((1.0,440),(3.9,550)):
                age=t-onset
                if age>=0:
                    ring+=0.18*math.exp(-age*2.2)*math.sin(2*math.pi*freq*age)
            sound=ring+0.07*prev+0.025*math.sin(2*math.pi*66*t)
        elif kind=='botanical':
            sound=0.12*prev+0.02*r+0.022*math.sin(2*math.pi*69*t)
        else:  # civic resonances
            bells=0.0
            for onset,freq in ((0.5,392),(2.4,523.25),(4.4,659.25)):
                age=t-onset
                if age>=0:
                    bells+=0.17*math.exp(-1.5*age)*(math.sin(2*math.pi*freq*age)+0.24*math.sin(2*math.pi*2.01*freq*age))
            sound=bells+0.02*prev
        value=max(-1.0,min(1.0,sound*envelope(i)))
        buffer.append(struct.pack('<h',int(value*32760)))
    return b''.join(buffer)

for key,filename in (
    ('archives','kin-city-archives.wav'),
    ('laboratory','kin-city-laboratoire.wav'),
    ('harbor','kin-city-port.wav'),
    ('botanical','kin-city-botanique.wav'),
    ('civic','kin-city-harmonie-civique.wav'),
):
    OUT.mkdir(parents=True,exist_ok=True)
    path=OUT/filename
    with wave.open(str(path),'wb') as f:
        f.setnchannels(1);f.setsampwidth(2);f.setframerate(RATE)
        f.writeframes(data(key))
    print(filename,path.stat().st_size)
