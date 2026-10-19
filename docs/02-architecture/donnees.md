# Données, référentiels et gestion des identifiants

## Source de vérité locale

En mode autonome, le catalogue Git des lieux et objets est la source de vérité **de la topologie 3D**, pas des données kOA. Les entrées du catalogue sont versionnées, testables et publiques. Aucune table d'utilisateurs, de votes ou de crédits n'est nécessaire.

## Entités

| Entité | Identifiant | Relations |
|---|---|---|
| City | `city_id` | Districts, hub, seed, plan |
| District | `district_id` | Bâtiments, style, repère |
| Building | `building_id` | District, portes, capacités prévues |
| Door | `door_id` | Source Place/anchor, destination Place/anchor |
| Interaction | `interaction_id` | Building, anchor, capability |
| Capability | `capability_id` | Owner documentaire, état et fournisseur |
| Asset | `asset_id` | Licence, révision, provenance |
| Place | `place_key` | `place_id` Roblox après publication, type |
| Localization | message key | Traductions, repli explicite |

## Durée de vie des IDs

Création → active → déprécié → archivé. Un ID n'est jamais réassigné à un objet différent. Les modifications physiques de coordonnées ne changent pas un ID. Toute transformation d'une entrée en plusieurs entrées documente le mapping ancien→nouveau ; garder les portes et ancres de retour compatibles tant que des joueurs les utilisent.

## Liens vers des instances Roblox

Lors du build, le compilateur attribue des attributs (`KinCityInteractionId`, `KinCityDoorId`) à des Instances marquées par un tag `KinCityInteractive` ou `KinCityDoor`. Les noms d'Instances peuvent changer et ne sont pas des clés canoniques.

## Validation croisée

Chaque interaction pointe vers un bâtiment existant et une capacité existante ; chaque bâtiment vers un district, des portes et un Place ; chaque porte vers une source et destination/anchor ; chaque `message_key` vers le catalogue de localisation. Références circulaires de navigation sont autorisées, mais aucune destination pendante n'est acceptée dans la qualification de publication.
