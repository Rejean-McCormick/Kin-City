"""Map all 121 supplied assets to explicit configuration references, or library only."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def generate(root=ROOT):
    manifest=json.loads((root/'catalog/art_deco_assets.json').read_text())
    placements=json.loads((root/'catalog/art_deco_placements.json').read_text())
    contexts={a['asset_key']:[] for a in manifest['assets']}
    def walk(value,path):
        if isinstance(value,dict):
            for key,child in value.items():walk(child,path+[key])
        elif isinstance(value,list):
            for index,child in enumerate(value):walk(child,path+[str(index)])
        elif isinstance(value,str) and value in contexts:contexts[value].append('.'.join(path))
    walk(placements,[])
    result={'scope':'Configuration references, including fallback recipes; actual placements are verified in Studio.',
            'asset_count':121,'assets':[{'asset_key':key,'status':'configured' if paths else 'library_only',
                'configuration_references':paths} for key,paths in sorted(contexts.items())]}
    path=root/'catalog/art_deco_contexts.json';path.write_text(json.dumps(result,indent=2)+'\n')
    return path
if __name__=='__main__':print(generate())
