#!/usr/bin/env python3
"""Contrôle limité d'un handoff IA Kin City. Ne remplace pas le QA moteur."""
import json,sys
from pathlib import Path
BASE=Path(__file__).resolve().parents[1]
valid={'city_hall','ekoh_tower','library','campus','justice_palace','innovation_lab','museum','orgo_center','city','integration'}
def check(f):
 d=json.loads(Path(f).read_text(encoding='utf8'))
 mandatory=('schema_version','branch_id','place_key','baseline','contracts_version','changed_files','contract_changes','tests_executed','tests_not_executed','risk','rollback','status','change_class')
 missing=[k for k in mandatory if k not in d]
 if missing:raise ValueError('Champs manquants : '+', '.join(missing))
 if d['schema_version']!='kincity.handoff/1.0':raise ValueError('Version du schéma incorrecte')
 if d['place_key'] not in valid:raise ValueError('Place non canonique')
 keys=['city_hall','ekoh_tower','library','campus','justice_palace','innovation_lab','museum','orgo_center','integration','city']
 expected='B'+str(keys.index(d['place_key'])+1).zfill(2)
 if d['branch_id']!=expected:raise ValueError(f'Branche {d["branch_id"]} incohérente; attendu {expected}')
 if d['change_class'] not in ('LOCAL','SHARED','BREAKING'):raise ValueError('Type de changement inconnu')
 for field in ['changed_files','contract_changes','tests_executed','tests_not_executed','risk']:
  if not isinstance(d[field],list):raise ValueError(field+' doit être une liste')
 if not isinstance(d['rollback'],str) or not d['rollback'].strip():raise ValueError('Rollback obligatoire')
 if d['status'] not in ('WORK_IN_PROGRESS','READY_FOR_REVIEW','ACCEPTED','CHANGES_REQUESTED','BLOCKED'):raise ValueError('Statut invalide')
 if d['change_class'] in ('SHARED','BREAKING') and not d.get('needs_approval'):
  raise ValueError('Un changement commun ou de rupture exige needs_approval')
 if any(isinstance(t,dict) and t.get('result')=='PASS' and not t.get('evidence') for t in d['tests_executed']):
  raise ValueError('PASS sans preuve explicite')
 print('HANDOFF STRUCTUREL VALIDE; tests et runtime non vérifiés',d['branch_id'],d['place_key'])
if __name__=='__main__':
 try:check(sys.argv[1])
 except (ValueError,KeyError,IndexError,json.JSONDecodeError) as e:
  print('ÉCHEC HANDOFF:',e,file=sys.stderr);sys.exit(1)
