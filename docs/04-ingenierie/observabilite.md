# Observabilité et preuves de fonctionnement

## Objectif

Savoir si les citoyens peuvent réellement naviguer, entrer, revenir, ouvrir et fermer des objets, et si les scènes sont performantes. Les tests automatisés et signaux techniques doivent permettre de constater un échec avant qu'il ne devienne un incident public.

## Événements suggérés

| Événement | Champs minimaux et non sensibles |
|---|---|
| `session_enter` | place_key, build_rev, device_class |
| `door_requested` | door_id, source/destination keys, trace_id |
| `door_completed` | door_id, succès/échec, durée |
| `interaction_opened` | interaction_id, capability_id, provider_mode |
| `interaction_closed` | interaction_id, durée d'affichage |
| `scene_loaded` | place_key, build_rev, temps, warnings |
| `scene_error` | error_code, place_key, build_rev, trace_id |

**Ne pas inclure** de données personnelles non nécessaires ni de noms/documents kOA. En `WORLD_STUB`, aucune télémétrie n'est envoyée à un serveur kOA.

## Indicateurs de qualification

Taux de franchissement réussi des portes, pourcentage de retours fonctionnels, interactions ayant affiché « Fonctionnalité à venir », messages UI manquants, erreurs de chargement, FPS et mémoire par appareil, nombre d'interactions orphelines, taux de collision invalide.

## Niveaux de preuve

`P0` déclaration non testée, `P1` validation schéma/catalogue, `P2` test local Studio, `P3` essai client Roblox publié, `P4` essai multi-appareils/charge/reprise, `P5` exploitation publique vérifiée. Aucune catégorie inférieure ne doit être utilisée pour revendiquer une catégorie supérieure.

## Diagnostics

Chaque erreur retourne un code stable (pas seulement un texte localisé). Documenter le lien entre `build_rev`, `catalog_rev`, `place_id`, `door_id` et le journal. Garder un rapport reproductible plutôt que des impressions subjectives (« ça a l'air de marcher »).
