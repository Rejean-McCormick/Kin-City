# Contribution B07 — museum

Contribution B07 pour la **Galerie Konservation** (`museum`). Cette livraison remplace le stub initial et documente les **six salles** de référence ainsi que la politique d'accès demandée pour la consolidation finale :

- **la porte extérieure du musée reste barrée** côté ville ;
- **un écran de broadcast YouTube** est placé juste à proximité, bien visible ;
- le module d'intérieur reste **prévu mais non chargé automatiquement** tant que l'adaptateur commun B09 n'est pas activé.

## Salles prises en charge

1. `museum.lobby` — Accueil expositions
2. `museum.gallery` — Galerie permanente
3. `museum.chamber` — Galerie temporaire
4. `museum.west_wing` — Archives du patrimoine
5. `museum.east_wing` — Galerie des créations
6. `museum.rear_atrium` — Atrium artistique

## Fichiers

- `MuseumSceneData.luau` : plan des six salles, politique d'accès et offsets de broadcast.
- `MuseumScene.luau` : module Luau d'entrée `MuseumScene.build(context)`.
- `recipe.json` : manifeste B09.
- `tests/test_b07.py` : vérifications hors moteur.

## Limites

Le code de contribution B07 ne modifie ni les contrats canoniques, ni les portes partagées, ni la façade B10. Le verrouillage visuel de la porte et le repositionnement de l'écran extérieur sont assurés par un module d'intégration B09 (`src/server/MuseumBroadcastBarrier.luau`).

Le lecteur Roblox VideoFrame **ne peut pas lire une URL YouTube directement**. Sans AssetId vidéo Roblox autorisé, le grand écran affiche un message de configuration (jamais un faux direct).
