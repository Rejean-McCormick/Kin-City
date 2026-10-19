# Contrats des manifestes et schémas

## Convention

Les schémas inclus dans `schemas/` sont des **contrats Kin City proposés** en JSON Schema draft 2020-12. Ils ne prétendent pas décrire des contrats officiels Roblox ou kOA. Chaque document porte `schema_version`, stable et explicite. Par défaut, les champs inconnus sont refusés (`additionalProperties: false`) dans les objets critiques ; toute extension doit être versionnée.

## Catalogues

| Fichier | Entité principale | Schéma |
|---|---|---|
| `catalog/city.json` | `city_id`, `central_place`, géométrie, districts | `schemas/city.schema.json` |
| `catalog/districts.json` | collection de quartiers | `schemas/districts.schema.json` |
| `catalog/buildings.json` | collection de bâtiments et gabarits | `schemas/buildings.schema.json` |
| `catalog/places.json` | Place symbolique → ID Roblox, ancrages | `schemas/places.schema.json` |
| `catalog/doors.json` | portes de navigation source/destination | `schemas/doors.schema.json` |
| `catalog/capabilities.json` | capacités métier futures et état | `schemas/capabilities.schema.json` |
| `catalog/interactions.json` | ancrages et objets interactifs | `schemas/interactions.schema.json` |
| `catalog/messages.fr.json` | dictionnaire clé→texte | `schemas/messages.schema.json` |

## Identifiants et références

Format recommandé `[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+`. Tous les IDs doivent être uniques dans leur famille et immuables. `place_key`, `building_id`, `district_id`, `capability_id`, `interaction_id`, `door_id` sont des références documentaires ; le `place_id` numérique Roblox est un identifiant de déploiement qui peut rester nul avant publication.

## Exemple d'interaction

```json
{
  "schema_version": "kincity.interaction/1.0",
  "interaction_id": "ethikos.justice_palace.terminal_01",
  "building_id": "ethikos.justice_palace",
  "anchor_id": "hall.terminal_01",
  "capability_id": "ethikos.consultation.list",
  "provider_mode": "stub",
  "prompt_label_key": "prompt.consult",
  "display_title_key": "title.consultations",
  "display_message_key": "ui.coming_soon"
}
```

## Relations transversales

La validation JSON Schema ne prouve pas que des IDs pointent vers des objets existants dans *d'autres fichiers*. Le script `tools/validate_catalog.py` vérifie les relations logiques. L'implantation Roblox devra ensuite vérifier la présence physique de l'ancrage identifié. Une interaction manifestée sans ancrage dans un Place publié doit bloquer la qualification.

## Changements

Ajouter un champ optionnel rétrocompatible peut être mineur ; changer le sens d'un ID, déplacer une autorité, rendre optionnel un contrôle de sécurité, transformer une interface locale en écriture distante est majeur et soumis à ADR.
