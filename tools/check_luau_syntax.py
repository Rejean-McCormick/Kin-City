"""Luau syntax parser, not Roblox execution or type analysis."""
from pathlib import Path
from tree_sitter import Language,Parser
import tree_sitter_luau
ROOT=Path(__file__).resolve().parents[1]
parser=Parser(Language(tree_sitter_luau.language()))
files=list((ROOT/'src').rglob('*.luau'))+list(ROOT.glob('*v29.luau'))+[ROOT/'KingKlown_v7.luau']
errors=[]
for path in files:
    tree=parser.parse(path.read_bytes())
    if tree.root_node.has_error:
        errors.append(str(path.relative_to(ROOT)))
print(f'{len(files)} fichiers Luau analysés; {len(errors)} erreurs de syntaxe : {errors}')
raise SystemExit(bool(errors))
