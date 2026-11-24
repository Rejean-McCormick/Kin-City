#!/usr/bin/env python3
"""KC34 B09 offline contract verifier and cross-branch submission gate.

Never publishes, changes a PlaceId, or writes to a Roblox asset. Stdlib-only.
See docs/B09-INTEGRATION.md for commands and explicitly untested criteria.
"""
from __future__ import annotations
import argparse
import csv
import hashlib
import json
import re
import sys
from pathlib import Path, PurePosixPath

KEYS = ('city', 'city_hall', 'ekoh_tower', 'library', 'campus', 'justice_palace', 'innovation_lab', 'museum', 'orgo_center')
OWNERS = {'B01':'city_hall','B02':'ekoh_tower','B03':'library','B04':'campus',
          'B05':'justice_palace','B06':'innovation_lab','B07':'museum','B08':'orgo_center',
          'B09':'integration','B10':'city'}
SHARED_PREFIXES = ('catalog/','config/','src/shared/','schemas/','installer/','studio/','tools/',
                   'src/server/','src/client/','build/','.github/')
CONTRACT = 'KC34-DOC-1.0'

def load(path):return json.loads(Path(path).read_text(encoding='utf-8'))
def digest(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def canonical_hash(obj):return hashlib.sha256(json.dumps(obj,sort_keys=True,ensure_ascii=False,separators=(',',':')).encode()).hexdigest()

def relative_path(value):
    if not isinstance(value,str) or not value or '\\' in value or '\x00' in value:
        raise ValueError(f'Chemin non canonique: {value!r}')
    p=PurePosixPath(value)
    if p.is_absolute() or '..' in p.parts or '.' in p.parts or str(p)!=value or ':' in value:
        raise ValueError(f'Chemin dangereux/non normalisé: {value!r}')
    return value

def folder_safe(root,rel):
    relative_path(rel)
    root=root.resolve();file=(root/rel).resolve()
    if not file.is_relative_to(root):raise ValueError('Chemin qui sort de la contribution : '+rel)
    return file

def frozen_snapshot(repo,reference):
    wanted=load(reference/'contrats/empreintes_kc33.json')['sha256']
    errs=[]
    for rel,expect in wanted.items():
        p=repo/rel
        if not p.is_file():errs.append(f'Fichier de contrat absent: {rel}')
        elif digest(p)!=expect:errs.append(f'Contrat modifié sans migration approuvée: {rel}')
    return errs,len(wanted)

def count_lock(repo):
    issues=[];stat={}
    def assert_count(name,actual,expected):
        stat[name]=actual
        if actual!=expected:issues.append(f'{name}: attendu {expected}, obtenu {actual}')
    p=load(repo/'catalog/places.json')['places']; keys=[e['place_key'] for e in p]
    assert_count('places',len(p),9)
    if set(keys)!=set(KEYS) or len(set(keys))!=9:issues.append('place_keys non canoniques / dupliquées')
    if any(e.get('place_id') is not None for e in p):issues.append('Baseline KC33 devrait garder les PlaceIds nuls')
    doors=load(repo/'catalog/doors.json')['doors']; assert_count('doors',len(doors),16)
    dd={d['door_id']:d for d in doors}
    if len(dd)!=len(doors):issues.append('door_id dupliqué')
    for d in doors:
        if d['source_place_key'] not in KEYS or d['destination_place_key'] not in KEYS:
            issues.append('door destination inconnue: '+d['door_id'])
        r=dd.get(d.get('return_door_id'))
        if r is None or r.get('return_door_id')!=d['door_id'] or r.get('source_place_key')!=d['destination_place_key'] or r.get('destination_place_key')!=d['source_place_key']:
            issues.append('door non réciproque: '+d['door_id'])
    spatial=load(repo/'catalog/spatial.json')['places']
    assert_count('anchors',sum(len(e['anchors']) for e in spatial),49)
    assert_count('canonical_rooms',sum(len(e['rooms']) for e in spatial),24)
    assert_count('interiors',sum(e['place_key']!='city' for e in spatial),8)
    contexts=load(repo/'catalog/art_deco_contexts.json')['assets']
    assert_count('art_deco_total',len(contexts),121)
    assert_count('art_deco_configured',sum(e['status']=='configured' for e in contexts),41)
    stats=load(repo/'catalog/districts.json')['districts']
    assert_count('outer_districts',sum(e.get('ring')==1 for e in stats),6)
    expected_palette={'keenkonnect':(208,191,134),'ethikos':(169,124,79),'kreative':(203,128,157),
        'uckk':(117,142,166),'ekole':(229,234,231),'konnected':(188,103,76)}
    luau=(repo/'src/shared/HexagonalDistricts.luau').read_text(encoding='utf-8')
    for key,rgb in expected_palette.items():
        pattern=r'\{key="'+re.escape(key)+r'"[^\n]*\n\s*color=Color3\.fromRGB\((\d+),(\d+),(\d+)\)'
        found=re.search(pattern,luau)
        if not found or tuple(map(int,found.groups()))!=rgb:issues.append('Couleur canonique changée: '+key)
    # These are declared/compiled geometry counts, not a Studio visual assertion.
    return issues,stat

def plan_integrity(repo):
    """Run compiler imported from its native path; no changes to repo/build."""
    import importlib.util
    tool=repo/'tools/compile_plan.py'
    old=list(sys.path)
    sys.path.insert(0,str(tool.parent))
    try:
        spec=importlib.util.spec_from_file_location('kc_b09_compile_plan',tool)
        module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
        fresh=module.compile_plan(repo)
    finally:sys.path[:]=old
    saved=load(repo/'build/world-plan.json')
    if canonical_hash({k:v for k,v in fresh.items() if k!='canonical_sha256'})!=fresh['canonical_sha256']:
        raise ValueError('SHA du plan fraîchement compilé inconsistant')
    if fresh!=saved:raise ValueError('Le plan recompilé diffère de build/world-plan.json')
    if fresh['canonical_sha256']!='5941cd6ecd89ea806cd5b815fcc128b1abef1cff77f77d670dbe01c7f487039a':
        raise ValueError('SHA de référence logique KC33 changé')
    return fresh['canonical_sha256']

def effective_room_bounds(repo,margin=10):
    """Compute observed KC33 runtime extension envelope; do not modify catalog.

    Expansion coordinates are read from InteriorWings.luau (constant literal room geometry).
    A future nonconstant recipe requires a new runtime-source audit.
    """
    code=(repo/'src/server/InteriorWings.luau').read_text(encoding='utf8')
    items=re.findall(r'room_id=key\.\."\.(?:west_wing|east_wing|rear_atrium)"[^\n]*?center_studs=\{([^}]+)\},size_studs=\{([^}]+)\}',code)
    if len(items)!=3:raise ValueError('Extensions de salle non reconnues; audit géométrique manuel obligatoire')
    extra=[]
    for center,size in items:
        xyz=[float(v.strip()) for v in center.split(',')]
        whd=[float(v.strip()) for v in size.split(',')]
        if len(xyz)!=3 or len(whd)!=3:raise ValueError('Dimensions non reconnues')
        extra.append((xyz,whd))
    places=load(repo/'catalog/spatial.json')['places']
    out={}
    for place in places:
        if place['place_key']=='city':continue
        rooms=[(r['center_studs'],r['size_studs']) for r in place['rooms']]+extra
        lo_x=min(c[0]-s[0]/2 for c,s in rooms);hi_x=max(c[0]+s[0]/2 for c,s in rooms)
        lo_z=min(c[2]-s[2]/2 for c,s in rooms);hi_z=max(c[2]+s[2]/2 for c,s in rooms)
        envelope=[round(lo_x,3),round(hi_x,3),round(lo_z,3),round(hi_z,3)]
        b=place['bounds']['size_studs']
        out[place['place_key']]={'catalog_size':b,'actual_aabb_xz':envelope,
            'actual_extent_xz':[hi_x-lo_x,hi_z-lo_z],
            'suggested_centered_size_xz':[int(2*max(abs(lo_x),abs(hi_x))+2*margin),int(2*max(abs(lo_z),abs(hi_z))+2*margin)],
            'catalog_covers_runtime':lo_x>=-b[0]/2 and hi_x<=b[0]/2 and lo_z>=-b[1]/2 and hi_z<=b[1]/2}
    return out

def baseline_report(repo,reference,zip_path=None):
    errors,n=frozen_snapshot(repo,reference)
    count_err,stats=count_lock(repo);errors+=count_err
    plan=None
    try:plan=plan_integrity(repo)
    except Exception as exc:errors.append('Plan non reproductible: '+str(exc))
    bounds=effective_room_bounds(repo)
    # Difference between declared and expanded rooms is an architecture ISSUE, not
    # a failure of the immutable KC33 snapshot used to start branches.
    return {'status':'PASS' if not errors else 'FAIL','contracts_version':CONTRACT,
        'zip_sha256':digest(zip_path) if zip_path else None,'locked_files_verified':n,
        'compiled_plan_sha256':plan,'counts':stats,'unresolved_runtime_bounds':bounds,
        'failures':errors,'runtime_tests':'NOT_RUN','publication':'NOT_RUN'}

def validate_handoff(handoff_path,repo,baseline_sha,strict=True,strict_patch_tree=False):
    d=load(handoff_path);issues=[]
    mandatory=('schema_version','branch_id','place_key','baseline','contracts_version','change_class',
               'changed_files','contract_changes','tests_executed','tests_not_executed','rollback','status')
    for f in mandatory:
        if f not in d:issues.append('Champ obligatoire manquant: '+f)
    if issues:return issues
    branch=d['branch_id']
    if d['schema_version']!='kincity.handoff/1.0':issues.append('Schéma incompatible')
    if branch not in OWNERS or OWNERS.get(branch)!=d['place_key']:issues.append('Branche/Place incohérente')
    if d['baseline']!='KC33':issues.append('Baseline non KC33')
    if d['contracts_version']!=CONTRACT:issues.append('Version de contrat différente')
    if strict and d.get('baseline_sha256')!=baseline_sha:issues.append('Empreinte ZIP KC33 manquante ou fausse')
    if d['change_class'] not in ('LOCAL','SHARED','BREAKING'):issues.append('Classification inconnue')
    if d['status'] not in ('WORK_IN_PROGRESS','READY_FOR_REVIEW','ACCEPTED','CHANGES_REQUESTED','BLOCKED'):issues.append('Statut invalide')
    if not isinstance(d['changed_files'],list):issues.append('changed_files doit être une liste')
    elif len(d['changed_files'])!=len({json.dumps(x,sort_keys=True) for x in d['changed_files']}):issues.append('Fichier modifié dupliqué')
    if not d.get('rollback') or not isinstance(d['rollback'],str) or d['rollback'].strip()=='A_COMPLETER':issues.append('Rollback absent')
    for field in ('contract_changes','tests_executed','tests_not_executed'):
        if not isinstance(d[field],list):issues.append(field+' doit être une liste')
    is_shared=False
    for ent in d['changed_files'] if isinstance(d['changed_files'],list) else []:
        if not isinstance(ent,dict) or set(('path','sha256'))-set(ent):issues.append('changed_files: {path, sha256} requis');continue
        try:
            rel=relative_path(ent['path']);file=folder_safe(repo,rel)
            if not file.is_file():issues.append('Fichier de patch inexistant: '+rel)
            elif ent['sha256']!=digest(file):issues.append('Empreinte du patch erronée: '+rel)
            if rel.startswith(SHARED_PREFIXES):is_shared=True
            if branch not in ('B09','B10'):
                allowed='contrib/places/'+d['place_key']+'/'
                if not rel.startswith(allowed):issues.append('Hors périmètre de la branche '+branch+': '+rel)
            if branch=='B10' and not rel.startswith('contrib/places/city/'):
                issues.append('B10 doit remettre par contrib/places/city ou demander un RFC B09: '+rel)
        except ValueError as exc:issues.append(str(exc))
    if strict_patch_tree and isinstance(d['changed_files'],list):
        declared={v['path'] for v in d['changed_files'] if isinstance(v,dict) and isinstance(v.get('path'),str)}
        observed={p.relative_to(repo).as_posix() for p in repo.rglob('*') if p.is_file()
            and '__pycache__' not in p.parts and p.name not in ('handoff.json','.DS_Store')}
        if observed!=declared:
            extra=sorted(observed-declared);missing=sorted(declared-observed)
            if extra:issues.append('Fichier(s) dissimulé(s) dans patch: '+', '.join(extra[:8]))
            if missing:issues.append('Fichier(s) déclaré(s) absent(s) du patch: '+', '.join(missing[:8]))
    if d['change_class']=='LOCAL' and is_shared:issues.append('Fichier partagé classé LOCAL')
    if d['change_class'] in ('SHARED','BREAKING') or is_shared:
        if not d.get('needs_approval') or not d.get('rfc_id'):
            issues.append('Changement transverse sans approbation/RFC')
        if d['change_class']=='BREAKING' and not d.get('adr_id'):issues.append('BREAKING exige ADR')
    for t in d['tests_executed'] if isinstance(d['tests_executed'],list) else []:
        if not isinstance(t,dict) or not t.get('name') or t.get('result') not in ('PASS','FAIL'):
            issues.append('Test exécuté doit être {name,result,evidence}');continue
        if t['result']=='PASS' and not t.get('evidence'):issues.append('PASS sans preuve')
    if d['status']=='ACCEPTED' and branch!='B09':issues.append('ACCEPTED réservé à la décision de B09')
    if strict and d['status']=='READY_FOR_REVIEW' and not d['changed_files']:issues.append('Handoff vide prêt pour revue')
    if d['status'] in ('READY_FOR_REVIEW','ACCEPTED') and not d['tests_executed']:issues.append('Aucune preuve de test')
    if strict and (not isinstance(d.get('risk'),list) or not d['risk']):issues.append('Risque non documenté')
    return issues

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--repo',required=True,type=Path)
    parser.add_argument('--reference',required=True,type=Path)
    parser.add_argument('--baseline-zip',type=Path)
    parser.add_argument('--handoff',type=Path)
    parser.add_argument('--patch',type=Path,help='Racine des SEULS fichiers du handoff')
    parser.add_argument('--strict-patch-tree',action='store_true',help='Refuser les fichiers non déclarés dans --patch')
    parser.add_argument('--out',type=Path)
    args=parser.parse_args()
    if args.handoff:
        if not args.baseline_zip:parser.error('--baseline-zip obligatoire pour un handoff')
        problems=validate_handoff(args.handoff,args.patch or args.repo,digest(args.baseline_zip),strict_patch_tree=args.strict_patch_tree)
        report={'status':'PASS' if not problems else 'FAIL','failures':problems,'handoff':str(args.handoff)}
    else:report=baseline_report(args.repo,args.reference,args.baseline_zip)
    message=json.dumps(report,ensure_ascii=False,indent=2,sort_keys=True)
    if args.out:args.out.parent.mkdir(parents=True,exist_ok=True);args.out.write_text(message+'\n',encoding='utf8')
    print(message)
    return 1 if report['status']=='FAIL' else 0
if __name__=='__main__':sys.exit(main())
