#!/usr/bin/env python3
"""Replay eight branch offline suites with original archived test layouts.

Runs user-contributed code. Audit archived test scripts before use. DOES NOT run Studio.
B06 intentionally uses its V3 original snapshot: the result must NEVER be treated
as KC33 compatibility evidence until a separate KC33 test is authored.
"""
from pathlib import Path,PurePosixPath
import argparse,json,os,subprocess,sys,tempfile,zipfile
ROOT=Path(__file__).resolve().parents[1]
BUNDLE=ROOT
ARCH=BUNDLE/'inputs/branch_archives'
F={
 'B01':'KinCity_B01_KC34_Complet.zip',
 'B02':'KinCity_B02_Ekoh_Contribution_Initiale.zip',
 'B03':'KinCity_B03_KC34_Grande_Bibliotheque.zip',
 'B04':'KinCity_B04_Campus_UCKK_Contribution.zip',
 'B05':'KinCity_B05_AgoraKorum_KC34_Contribution.zip',
 'B06':'KinCity_B06_Atelier_Konstruct_Patch.zip',
 'B08':'KinCity_B08_Maison_Orgo_Branche.zip',
 'B10':'KinCity_B10_KC34_Premiere_Passe.zip',
}

def safe_extract(z,folder):
    for info in z.infolist():
        p=PurePosixPath(info.filename)
        if p.is_absolute() or '..' in p.parts or '\\' in info.filename:
            raise ValueError('Unsafe archived file path '+info.filename)
        if info.is_dir():continue
        out=folder/info.filename
        out.parent.mkdir(parents=True,exist_ok=True)
        out.write_bytes(z.read(info.filename))

def replay(out,only=None):
    out=Path(out);out.mkdir(parents=True,exist_ok=True)
    results={}
    with tempfile.TemporaryDirectory(prefix='kincity-b09-tests-') as tmp:
        tmp=Path(tmp)
        for branch in (only or F):
            arch=ARCH/F[branch]
            if not arch.is_file():raise FileNotFoundError('Missing original branch archive: '+str(arch))
            inner=tmp/branch
            with zipfile.ZipFile(arch) as zipf:safe_extract(zipf,inner)
            root=ROOT/'contrib/places'
            paths={
              'B01':root/'city_hall/tests',
              'B02':root/'ekoh_tower/tests',
              'B03':inner/'KinCity_B03_KC34/tests',
              'B04':root/'campus/tests',
              'B05':root/'justice_palace/tests',
              'B06':inner/'KinCity_B06_Atelier_Konstruct/contrib/places/innovation_lab',
              'B08':inner/'KinCity_B08/contrib/places/orgo_center/tests',
              'B10':root/'city/tests',
            }
            prefix={
              'B01':'test*.py','B02':'test*.py','B03':'test*.py','B04':'test*.py','B05':'test*.py',
              'B06':'test_b06.py','B08':'test*.py','B10':'test*.py',
            }
            overrides={
              'B03':{'KINCITY_BASELINE_ROOT':str(ROOT)},
              'B05':{'KINCITY_ORIGINAL':str(ROOT)},
              'B08':{'KINCITY_BASE_ROOT':str(ROOT)},
              'B10':{'KINCITY_SOURCE_PATH':str(ROOT)},
            }
            cmd=[sys.executable,'-m','unittest','discover','-s',str(paths[branch]),'-p',prefix[branch],'-v']
            p=subprocess.run(cmd,env={**os.environ,**overrides.get(branch,{})},cwd=ROOT,
                stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,timeout=90)
            log=out/f'{branch}_replay.log';log.write_text(p.stdout,encoding='utf8')
            short=[v for v in p.stdout.splitlines() if v.startswith('Ran ') or v.startswith('OK') or v.startswith('FAILED')]
            results[branch]={'exit_code':p.returncode,'summary':short,'log':log.name,
                'baseline_used':'V3 ORIGINAL EMBEDDED, NOT KC33' if branch=='B06' else 'KC33','studio':'NOT_TESTED'}
            print(branch,'PASS' if p.returncode==0 else 'FAIL','; '.join(short))
    (out/'replay_summary.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    return int(any(v['exit_code']!=0 for v in results.values()))

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--out',type=Path,required=True)
    ap.add_argument('--only',choices=tuple(F))
    x=ap.parse_args()
    sys.exit(replay(x.out,[x.only] if x.only else None))
