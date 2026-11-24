#!/usr/bin/env python3
"""Review an external handoff and append its OFFLINE gate result to a fresh ledger.
Does not merge source files, approve runtime, or publish Roblox Places.
"""
import argparse,hashlib,json,sys
from datetime import datetime,timezone
from pathlib import Path
from b09_contracts import digest,validate_handoff,OWNERS

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    for arg in ('handoff','patch','ledger','baseline-zip','out'):
        ap.add_argument('--'+arg,type=Path,required=True)
    a=ap.parse_args()
    ledger=json.loads(a.ledger.read_text(encoding='utf-8'))
    d=json.loads(a.handoff.read_text(encoding='utf-8'))
    issues=validate_handoff(a.handoff,a.patch,digest(a.baseline_zip),strict_patch_tree=True)
    branch=d.get('branch_id')
    if branch not in OWNERS:issues.append('Branch ID inconnu')
    result='CHANGES_REQUESTED' if issues else 'BLOCKED'
    # Successful offline intake remains BLOCKED until B09 reviews proof in Roblox.
    if branch in OWNERS:
        ledger['branches'][branch]['status']=result
        ledger['branches'][branch]['reason']=' | '.join(issues) if issues else 'Garde offline PASS; en attente de revue B09 et tests Roblox applicables'
        ledger['branches'][branch]['result_sha256']=digest(a.handoff)
    ledger['intake_history'].append({'branch':branch,'received_utc':datetime.now(timezone.utc).isoformat(),
        'handoff_sha256':digest(a.handoff),'offline_result':'FAIL' if issues else 'PASS',
        'issues':issues})
    if a.out.resolve()==a.ledger.resolve():ap.error('--out doit être un fichier NOUVEAU, jamais le ledger source')
    a.out.parent.mkdir(parents=True,exist_ok=True)
    a.out.write_text(json.dumps(ledger,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    print(json.dumps({'branch':branch,'offline_result':'FAIL' if issues else 'PASS',
          'ledger_status':result,'issues':issues,'out':str(a.out)},ensure_ascii=False))
    return 1 if issues else 0
if __name__=='__main__':sys.exit(main())
