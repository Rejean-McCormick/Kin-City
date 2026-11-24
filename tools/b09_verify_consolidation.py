#!/usr/bin/env python3
"""B09 integrity verifier for consolidation candidate. Offline only, no Studio calls."""
import json,hashlib,sys
from pathlib import Path
from b09_contracts import baseline_report,validate_handoff
from b09_recipes import check as check_recipes
HERE=Path(__file__).resolve().parents[1]
CONSOL=HERE/'docs/B09/consolidation'
REF=HERE/'reference_KC34'
BASELINE_SHA='1fd3968977823a8814f54f766164c85e02cda3e370df984455f8c3f7db877c89'

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def check():
    problems=[];receipt=json.loads((CONSOL/'consolidation_receipt.json').read_text());ledger=json.loads((HERE/'docs/B09/branch_ledger.json').read_text())
    if receipt['releases']['runtime_active']!='KC35_SOURCE_ONLY' or not receipt['releases']['staging_candidate_only']:
        problems.append('Runtime release status incorrect')
    if receipt['releases'].get('published_multiplace')!='NOT_PERFORMED':problems.append('Publication staging claimed without evidence')
    if receipt['baseline_zip_sha256']!=BASELINE_SHA:problems.append('Wrong baseline ZIP SHA')
    archives=HERE/'inputs/branch_archives'
    for filename,expected in receipt['original_submission_sha256'].items():
        if 'B09' in filename:continue # B09 baseline extracted from this supplied archive, not copied as duplicate
        blob=archives/filename
        if not blob.is_file() or sha(blob)!=expected:problems.append('Branch input archive missing/tampered: '+filename)
    records=receipt['branches'];staged=receipt['staged_files']
    expected=set(('B01','B02','B03','B04','B05','B06','B07','B08','B09','B10'))
    if set(records)!=expected:problems.append('Missing branch in report')
    count={x:sum(v['branch']==x for v in staged) for x in expected}
    if count['B07']<6 or records['B07']['source_status']!='READY_FOR_REVIEW':problems.append('B07 finalization missing or incomplete')
    if len(staged)!=len(set(x['path'] for x in staged)):problems.append('Colliding contributed paths')
    for s in staged:
        rel=s['path'];source=HERE/rel
        if not rel.startswith('contrib/places/'+records[s['branch']]['place_key']+'/'):problems.append('Foreign branch namespace: '+rel)
        if not source.is_file() or sha(source)!=s['sha256']:problems.append('Staged file tampered: '+rel)
    for bid in expected-{'B09'}:
        original=CONSOL/'original_handoffs'/f'handoff_{bid}_AS_RECEIVED.json'
        d=json.loads(original.read_text())
        if d['branch_id']!=bid:problems.append('Mismatched receipt ID '+bid)
        if bid=='B08':
            if d['baseline']=='KC33' or ledger['branches'][bid]['status']=='ACCEPTED':problems.append('B08 V3 mismatch hidden')
            if not (HERE/'contrib/places/orgo_center/asset_plan_KC33.json').is_file():
                problems.append('B08 KC33 rebase evidence missing')
        else:
            if d['baseline_sha256']!=BASELINE_SHA:problems.append('Wrong source SHA '+bid)
            # A transformed file is recorded by its original and KC35 hashes.
            # Review historical handoffs but do not falsify their original bytes.
            result=validate_handoff(original,HERE,BASELINE_SHA,strict_patch_tree=False)
            overrides=receipt.get('kc35_overrides',{})
            result=[x for x in result if not any(
                x=='Empreinte du patch erronée: '+rel and xdata['current_sha256']==sha(HERE/rel)
                for rel,xdata in overrides.items())]
            if result:problems.append(bid+' fails handoff:'+str(result))
    for bid,row in ledger['branches'].items():
        if bid!='B09' and row.get('runtime_integrated') is not True:problems.append('Branch runtime wiring missing: '+bid)
        if bid!='B09' and row.get('studio_validated') is not False:problems.append('False Studio validation status: '+bid)
    try:
        baseline=baseline_report(HERE,REF)
        if baseline['status']!='PASS':problems+=baseline['failures']
    except Exception as exc:problems.append('Baseline report exception '+str(exc))
    problems+=check_recipes(HERE)
    return problems,len(staged)

if __name__=='__main__':
 errors,n=check()
 print(json.dumps({'status':'PASS' if not errors else 'FAIL','staged_files':n,'branches_with_sources':9,'branch_missing':None,'failures':errors,'runtime':'KC35_CODE_WIRED_STUDIO_NOT_TESTED'},ensure_ascii=False,indent=2))
 sys.exit(bool(errors))
