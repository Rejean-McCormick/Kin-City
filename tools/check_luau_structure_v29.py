#!/usr/bin/env python3
"""Conservative Luau lexical/paired-delimiter check; NOT a Luau parser.
The full grammar check remains tools/check_luau_syntax.py (tree-sitter-luau).
"""
from pathlib import Path
import re,sys
ROOT=Path(__file__).resolve().parents[1]

def check(text):
    i=0;stack=[];pair={')':'(',']':'[','}':'{'}
    while i<len(text):
        ch=text[i]
        if text.startswith('--',i):
            j=i+2
            opening=re.match(r'\[(=*)\[',text[j:])
            if opening:
                terminator=']'+opening.group(1)+']'
                e=text.find(terminator,j+len(opening.group(0)))
                if e<0:return 'Commentaire long non fermé'
                i=e+len(terminator);continue
            e=text.find('\n',i+2)
            i=len(text) if e<0 else e+1;continue
        opening=re.match(r'\[(=*)\[',text[i:]) if ch=='[' else None
        if opening:
            terminator=']'+opening.group(1)+']'
            e=text.find(terminator,i+len(opening.group(0)))
            if e<0:return 'Chaîne longue non fermée'
            i=e+len(terminator);continue
        if ch in '\'"`':
            quote=ch;j=i+1
            while j<len(text):
                if text[j]=='\\':j+=2;continue
                if text[j]==quote:break
                if text[j]=='\n' and quote!='`':return 'Saut de ligne brut dans une chaîne courte'
                j+=1
            if j>=len(text):return 'Chaîne courte non fermée'
            i=j+1;continue
        if ch in '([{':stack.append((ch,i))
        elif ch in ')]}':
            if not stack or stack[-1][0]!=pair[ch]:return f'Délimiteur incohérent {ch} à caractère {i}'
            stack.pop()
        i+=1
    if stack:return f'Délimiteur non fermé: {stack[-1]}'
    return None

def main():
    files=sorted((ROOT/'src').rglob('*.luau'))
    files+=sorted(ROOT.glob('*_v29.luau'))
    files += [ROOT/'KinCity_Installer_CommandBar.luau',ROOT/'KingKlown_v7.luau']
    errors=[]
    for f in files:
        e=check(f.read_text(encoding='utf8'))
        if e:errors.append(f'{f.relative_to(ROOT)}: {e}')
    print(f'Luau v29 scan LEXICAL/STRUCTURE uniquement : {len(files)} fichiers, {len(errors)} erreur(s)')
    for e in errors:print('ERREUR',e)
    print('Ce contrôle ne remplace PAS tree-sitter-luau ni la compilation dans Roblox Studio.')
    return bool(errors)

if __name__=='__main__':sys.exit(main())
