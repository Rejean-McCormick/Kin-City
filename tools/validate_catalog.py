#!/usr/bin/env python3
"""Validation de la documentation et des catalogues Kin City.

Ne compile ni ne publie de jeu Roblox. Ne contacte aucun serveur.
Compatible Python 3.10+ ; vérification JSON Schema complète optionnelle si
le paquet jsonschema est installé.
"""
from __future__ import annotations
import json, re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLLECTIONS = ['city','districts','buildings','places','doors','capabilities','interactions','messages']
FILENAME = lambda k: 'messages.fr' if k == 'messages' else k
errors = []
warnings = []

def fail(msg): errors.append(msg)
def warn(msg): warnings.append(msg)
def load(path):
    try: return json.loads(path.read_text(encoding='utf-8'))
    except Exception as e:
        fail(f'{path.relative_to(ROOT)}: JSON invalide : {e}')
        return {}

data = {n:load(ROOT/'catalog'/(FILENAME(n)+'.json')) for n in COLLECTIONS}

try:
    from jsonschema import Draft202012Validator
except ImportError:
    warn('Paquet jsonschema absent : validation de type complète non exécutée.')
else:
    for name,obj in data.items():
        schema=load(ROOT/'schemas'/(name+'.schema.json'))
        try: Draft202012Validator.check_schema(schema)
        except Exception as e: fail(f'Schéma {name} invalide : {e}')
        validator = Draft202012Validator(schema)
        for error in sorted(validator.iter_errors(obj),key=lambda e:list(map(str,e.absolute_path))):
            fail(f'{name} JSON Schema, {list(error.absolute_path)}: {error.message}')

for name, obj in data.items():
    if obj.get('schema_version') != f'kincity.{name}/1.0':
        fail(f'{name}: schema_version inattendue')


def indexed(name, plural, idfield):
    out={}
    for item in data.get(name,{}).get(plural,[]):
        key=item.get(idfield)
        if not key or key in out: fail(f'{name}: ID absent ou dupliqué {key!r}')
        out[key]=item
    return out

districts=indexed('districts','districts','district_id')
buildings=indexed('buildings','buildings','building_id')
places=indexed('places','places','place_key')
doors=indexed('doors','doors','door_id')
capabilities=indexed('capabilities','capabilities','capability_id')
interactions=indexed('interactions','interactions','interaction_id')
messages=data.get('messages',{}).get('messages',{})

for did in data['city'].get('district_ids',[]):
    if did not in districts: fail(f'city: district_id introuvable {did}')
if data['city'].get('start_place_key') not in places: fail('city: start_place_key introuvable')

for id,b in buildings.items():
    if b.get('district_id') not in districts: fail(f'{id}: district absent')
    if b.get('interior_place_key') not in places: fail(f'{id}: Place intérieur absent')
    for prop in ('entry_door_id','exit_door_id'):
        if b.get(prop) not in doors: fail(f'{id}: {prop} non défini')

for id,door in doors.items():
    if door.get('building_id') not in buildings: fail(f'{id}: bâtiment inconnu')
    source=places.get(door.get('source_place_key'))
    target=places.get(door.get('destination_place_key'))
    if not source or not target: fail(f'{id}: Place de départ/destination inconnu')
    else:
        if door.get('source_anchor_id') not in source.get('anchors',[]): fail(f'{id}: ancre source absente')
        if door.get('destination_anchor_id') not in target.get('anchors',[]): fail(f'{id}: ancre destination absente')
    if door.get('return_door_id') not in doors: fail(f'{id}: porte retour absente')
    elif doors[door['return_door_id']].get('return_door_id') != id: fail(f'{id}: appariement retour non symétrique')
    if door.get('is_operational_required') is not True: fail(f'{id}: une porte ne peut être un stub')

for id,cap in capabilities.items():
    if cap.get('provider_mode')!='stub': fail(f'{id}: fournisseur kOA interdit en WORLD_STUB')
    if cap.get('state')!='planned': fail(f'{id}: capacité non planifiée')
    if cap.get('message_key') not in messages: fail(f'{id}: message_key introuvable')

for id,inter in interactions.items():
    if inter.get('building_id') not in buildings: fail(f'{id}: bâtiment absent')
    elif inter.get('place_key')!=buildings[inter['building_id']].get('interior_place_key'):
        fail(f'{id}: mauvaise Place d’intérieur')
    place=places.get(inter.get('place_key'))
    if place and inter.get('anchor_id') not in place.get('anchors',[]):fail(f'{id}: ancre absente')
    if inter.get('capability_id') not in capabilities:fail(f'{id}: capacité absente')
    if inter.get('provider_mode')!='stub':fail(f'{id}: doit rester stub')
    for key in ('prompt_label_key','display_title_key','display_message_key'):
        if inter.get(key) not in messages:fail(f'{id}: message inconnu {inter.get(key)}')
    if inter.get('display_message_key')!='ui.coming_soon':fail(f'{id}: message stub incorrect')

for key,place in places.items():
    if place.get('place_id') is None:
        warn(f'Place {key}: PlaceId non publié (normal pour le dossier documentaire ; bloquant pour publication).')
    if place.get('publication_state')=='unpublished' and place.get('place_id') is not None:
        fail(f'{key}: PlaceId réel défini mais état unpublished incohérent')

# Contrôle statique des liens Markdown locaux; pas de réseau.
LINK = re.compile(r'(?<!\!)\[[^\]]+\]\(([^)]+)\)')
for doc in ROOT.rglob('*.md'):
    text=doc.read_text(encoding='utf-8')
    for target in LINK.findall(text):
        target=target.strip().split(' #')[0]
        if target.startswith(('https://','http://','mailto:','#')):continue
        dest=(doc.parent/target.split('#')[0]).resolve()
        if not dest.exists():fail(f'{doc.relative_to(ROOT)}: lien local manquant {target}')

print(f'Kin City — {len(buildings)} bâtiments, {len(places)} Places, {len(doors)} portes, '
      f'{len(interactions)} interactions, {len(capabilities)} capacités.')
print(f'Erreurs : {len(errors)} ; avertissements : {len(warnings)}')
for w in warnings:print('[INFO]',w)
for e in errors:print('[ERREUR]',e)
print('VALIDATION DOCUMENTAIRE :', 'ÉCHEC' if errors else 'OK')
sys.exit(1 if errors else 0)
