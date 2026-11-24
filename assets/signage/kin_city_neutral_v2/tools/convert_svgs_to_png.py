#!/usr/bin/env python3
"""Kin City SVG → PNG (conversion par lot, taille et teinte configurables).

Prérequis: python -m pip install -r tools/requirements.txt
Exemple: python tools/convert_svgs_to_png.py --scale 2 --color '#1E6864'
"""
import argparse
import re
from pathlib import Path


def main():
    ap = argparse.ArgumentParser(description='Convertir les SVG Kin City en PNG.')
    ap.add_argument('--scale', type=int, default=1, choices=[1, 2, 4], help='Échelle de sortie')
    ap.add_argument('--color', type=str, default=None, help='Teinte hex, ex: #1E6864 (blanc par défaut)')
    ap.add_argument('--input-dir', type=Path, default=Path(__file__).resolve().parents[1] / 'svg')
    ap.add_argument('--output-dir', type=Path, default=Path(__file__).resolve().parents[1] / 'png')
    args = ap.parse_args()
    try:
        import cairosvg
    except ImportError as exc:
        raise SystemExit('CairoSVG requis : python -m pip install -r tools/requirements.txt') from exc
    if args.color and not re.fullmatch(r'#[0-9a-fA-F]{6}', args.color):
        ap.error('Couleur attendue : #RRGGBB')
    args.output_dir.mkdir(parents=True, exist_ok=True)
    count=0
    for src in sorted(args.input_dir.glob('*.svg')):
        svg=src.read_text(encoding='utf-8')
        if args.color:
            svg=re.sub(r'#FFFFFF|#1E6864', args.color.upper(), svg, flags=re.IGNORECASE)
        dest=args.output_dir / (src.stem+'.png')
        cairosvg.svg2png(bytestring=svg.encode('utf-8'),write_to=str(dest),scale=args.scale)
        print(f'{src.name} → {dest.name}')
        count+=1
    if not count:
        raise SystemExit(f'Aucun SVG dans {args.input_dir}')
    print(f'{count} fichiers convertis.')

if __name__=='__main__': main()
