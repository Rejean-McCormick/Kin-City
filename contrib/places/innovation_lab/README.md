# B06 — Atelier Konstruct : livraison intérieure 0.1.0

**Place :** `innovation_lab` • **building_id :** `keenkonnect.innovation_lab` • **District :** keenKonnect • **Contrat cible :** `KC34-DOC-1.0`.

## Intention artistique

Un atelier de conception et de fabrication inscrit dans le vocabulaire Art déco de Kin City : motifs horizontaux en bronze/champagne, cartouches géométriques, repères sarcelle, lumière maîtrisée, six espaces différenciés. **L'objectif de la présente passe est un habillage d'identité lisible et léger**, pas une simulation de machines ou une fonctionnalité Koali réelle.

Palette intangible : accent `#D0BF86` (champagne) de keenKonnect et sarcelle structurant `#1E6864`. Les autres matériaux peuvent employer bronze foncé et graphite neutres. Il ne faut ni recolorer les six sections globales, ni modifier l'extérieur de la façade (B10).

## Les six salles

| Salle (ID canonique) | Fonction visitable | Signature B06 |
|---|---|---|
| `innovation_lab.lobby` | Accueil projets et orientation | Deux frises et un panneau de bienvenue |
| `innovation_lab.gallery` | Atelier de fabrication | Bandeaux hauts, sans déplacer le bureau `hall.desk_01` |
| `innovation_lab.chamber` | Salle de démonstration | Frises et cartouche de présentation |
| `innovation_lab.west_wing` | Atelier de prototypage | Frises techniques sans collisions |
| `innovation_lab.east_wing` | Galerie des inventions | Cadres suspendus et repères |
| `innovation_lab.rear_atrium` | Hall de l'innovation | Composition symétrique de bandeaux et cartouche |

Les salles supplémentaires `west_wing`, `east_wing`, `rear_atrium` proviennent du générateur partagé `InteriorWings`, qui doit rester inchangé. Les quatre passages d'extension et les deux passages depuis le hall sont protégés dans `room_layout.json`.

## Contrats B09/B10 préservés

- Entrée : `city.keenkonnect.innovation_lab.entry` → `innovation_lab.lobby.spawn`.
- Sortie : `innovation_lab.exit` → `city.keenkonnect.innovation_lab.return_spawn`.
- Point d'interaction : `hall.desk_01` et `keenkonnect.innovation_lab.desk_01` restent exactement inchangés, en **mode stub** (capacité `keenkonnect.projects.browse`).
- Toutes les nouvelles IDs sont sous `innovation_lab.decor.*`; **aucun nouvel `anchor_id` canonique**, aucune remise à zéro des fichiers communs.

## Structure livrée

`room_layout.json` contient le plan de six salles, les portes/passage protégés, la légende et 24 ornements natifs non-collidables. `build_scene.py` le compile en module Luau `KonstructScene.luau`, qui propose `plan(profile)` et `build(context)`. `recipe.json` respecte le schéma de contribution B09 mais reste **INTEGRATION_PROPOSED** : son tableau `decorations` est intentionnellement vide, car les objets B06 sont fixés relativement à des **room_id**, non à des anchors publiés. B09 doit créer un adaptateur sûr avant d'alimenter son runtime.

### Contrat proposé du module Luau

```luau
local output = KonstructScene.build({
    placeKey = "innovation_lab",
    profile = "STANDARD",
    parent = targetRoomVisualFolder,
    origin = actualInteriorOrigin,
})
```

`origin` doit provenir de l'environnement actif (mode local déporté ou Place publiée), **jamais être hardcodé**. Le parent est celui de la scène intérieure géré par B09. La construction est idempotente lorsque la même version/profil est déjà montée. Un overlay de version différente exige un rollback manuel : aucun `:Destroy()` silencieux. Les éléments sont `Anchored=true`, `CanCollide=false`, `CanTouch=false`, `CanQuery=false` et ne créent ni scripts distants ni RemoteEvents.

Le module ne prétend pas contrôler les nouveaux budgets partagés `ArtDecoBudget`; son plan compte 24 pièces LITE, 33 STANDARD et 60 SHOWCASE, sans MeshParts ni import commercial. **Le total réel de la Place doit néanmoins être mesuré dans Studio** par B09 et B06.

## Tests

Lancer localement : `python contrib/places/innovation_lab/test_b06.py` en fournissant l'archive `BASE_KINCITY_V3_ORIGINAL.zip` au niveau de la racine du présent paquet. Les dix tests comparent l'identité, les pièces, les six portails, les deux portes réciproques, le stub, les coordonnées, les plafonds de pièces et la génération identique du module.

Ce sont des tests **hors Roblox**. Aucune téléportation, aucun rendu de signalétique et aucune collision observée en jeu ne sont validés. En particulier, le sens d'affichage des panneaux `SurfaceGui` doit être vérifié à l'éditeur.

## Dépendance et passation à B09

1. Appliquer exclusivement le dossier `patch_B06/contrib/places/innovation_lab/` sur une copie à jour de KC34-B09.
2. Rejouer les tests, inspecter le manifeste `handoff_B06.json` et ses SHA-256.
3. Créer une RFC B09 pour le loader des recettes et le placement dans le bon parent selon `place_key`; ne pas patcher `WorldBuilder` directement depuis B06.
4. Installer la Place **de staging**, inspecter les six salles, les connecteurs, les cartouches, les niveaux de détail, et documenter les photographies et FPS. Tous les états KOALI restent stub.
5. Après ces preuves, B09 pourra déclarer la recette intégrée. Avant cela, B06 est **prête pour revue**, pas publiée.
