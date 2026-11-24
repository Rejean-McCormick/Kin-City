# Kin City — B02 / Observatoire EkoH · première contribution

**Version :** `B02-EKOH-ATLAS-1.0.0` · 26 octobre 2026  
**Périmètre :** `ekoh_tower` uniquement. **Branche intégratrice :** B09.  
**État :** code Luau généré et vérifié hors moteur; **NON FUSIONNÉ DANS KC33/B09**, **NON CHARGÉ DANS ROBLOX**, **NON PUBLIÉ**.

## Pourquoi cette première livraison

Donner à B09 un premier cas concret, réversible et testable de contribution propre à une Place, sans bifurquer `WorldBuilder`, `PlayerTravel`, `InteriorGenerator`, les 16 portes, `catalog/spatial.json`, ni la palette des six secteurs. Le seul effet prévu en jeu est un habillage additif EkoH non interactif après génération des six salles.

## Pièces réelles

- `scene.json` — **source** de six pièces, six panneaux, contrats de portes et zones protégées, titres et trois profils.
- `B02EkohInterior.template.luau` — moteur de décor indépendant, non auto-exécuté.
- `B02EkohInterior.luau` — **module Roblox Luau compilé** depuis le JSON; expose `Build(context)`.
- `tools/build_b02.py` — régénération déterministe sans réseau.
- `tools/validate_b02.py` — préflight spatial et identité canoniques, 6/6 panneaux, collisions et budgets.
- `tests/test_b02.py` — 20 tests positifs/négatifs dont un test de reproductibilité.
- `fixtures/canonical_v3_snapshot.json` — preuve extraite du ZIP V3 original. **Attention : la source KC33/B09 n'était pas accessible dans la présente session**.
- `recipe.json` — manifeste strict de branche B09 (`INTEGRATION_PROPOSED`, non chargé par le moteur).

## Les six salles

| Salle | Identifiant | Décor livré | Intention |
|---|---|---|---|
| Accueil | `ekoh_tower.lobby` | Atlas du savoir | Orienter sans obstruer spawn/sortie |
| Galerie des contributions | `ekoh_tower.gallery` | Panneau Contributions | Présentation sans fausses distinctions |
| Salle d'observation | `ekoh_tower.chamber` | Panneau Observation | Constellation pédagogique annoncée comme artistique |
| Observatoire EkoH | `ekoh_tower.west_wing` | Panneau Observatoire | Exploration des concepts |
| Galerie du mérite | `ekoh_tower.east_wing` | Panneau Mérite | Encouragement symbolique sans faux palmarès |
| Forum de la connaissance | `ekoh_tower.rear_atrium` | Panneau Forum | Inviter à la circulation et à l'échange |

Tous les panneaux sont à plus de 7 studs au-dessus du sol, sans collision (`CanCollide/CanTouch/CanQuery=false`), et placés dans leurs pièces sans intersecter les rectangles de protection des 2 portes, 3 ancres et 6 passages du plan. Aucun nouveau `ProximityPrompt` n'est créé.

## Identifiants invariants

- Bâtiment : `central.ekoh_tower` ; Place : `ekoh_tower` ; secteur : `central`.
- Aller : `city.central.ekoh_tower.entry` → `ekoh_tower.lobby.spawn`.
- Retour : `ekoh_tower.exit` → `city.central.ekoh_tower.return_spawn`.
- Interaction inchangée : `central.ekoh_tower.display_01` / `tower.panel_01`, `provider_mode=stub`.
- **Aucune septième couleur** : couleur transversale `#1E6864` avec bronze `#CCA667` et opale `#E5EAE7`. Les six accents périphériques sont inchangés.

## Budgets décoratifs théoriques (PAS des mesures FPS)

| Profil | Panneaux | Instances Part supplémentaires | SurfaceGui | MeshPart importées |
|---|---:|---:|---:|---:|
| LITE | 6 | 6 | 6 | 0 |
| STANDARD | 6 | 24 | 6 | 0 |
| SHOWCASE | 6 | 42 | 6 | 0 |

Chaque panneau affiche deux TextLabels. Ces coûts représentent uniquement la contribution B02, sans sous-estimer les coûts du monde KC33. Aucune lumière dynamique et aucun asset externe ou mesh commercial.

## Procédure d'intégration B09 — requiert une vraie revue

1. Faire comparer `fixtures/canonical_v3_snapshot.json` et `scene.json` aux `catalog/places.json`, `doors.json`, `spatial.json`, `build/world-plan.json` **de KC33**, et à la révision intégrée de `InteriorWings`.
2. Exécuter les 20 tests puis l'outil B09 de validation du handoff et les tests négatifs. Le ZIP KC33 de référence doit être vérifié par SHA-256.
3. Installer `B02EkohInterior.luau` en tant que `ModuleScript` serveur dans **une copie privée** Studio. Ajouter une intégration partagée via RFC-B09, **après** `InteriorGenerator.make` et avant la fin du build contrôlé, uniquement pour la Place `ekoh_tower`.
4. Appel cible, à faire par B09 :

```luau
local Decorator=require(ServerScriptService.KinCityRuntime.B02EkohInterior)
local instance,summary=Decorator.Build({
    place_key="ekoh_tower",
    model=interiorModel,           -- Model créé par InteriorGenerator.make
    origin=Spatial.origin("ekoh_tower"),
    profile="LITE",               -- ou STANDARD / SHOWCASE
})
```

5. En `MULTI_PLACE`, passer l'origine **locale réellement calculée par Spatial.origin** (ne pas injecter `[3900,0,1800]` arbitrairement). Ne pas désactiver les ascenseurs/portails ni remplacer les prompts métier.
6. Tester visuellement les six salles, la lisibilité des SurfaceGui et l'absence d'occlusion des passages dans Roblox Studio et sur mobile, puis un aller-retour dans le client Roblox **publié staging**.
7. Pour rollback, supprimer **uniquement** le dossier `KinB02_EkoH_Atlas` du Model ou retirer l'appel B09; aucune donnée externe n'est stockée.

**Module idempotent :** un deuxième appel avec même révision/profil retourne `ALREADY_BUILT` sans créer de Parts. Une demande de nouveau profil doit passer par reconstruction explicite du monde; le module refuse de remplacer silencieusement ses objets.

## Important pour B09

Le dossier `contrib/places/ekoh_tower/` est le seul ensemble de chemins soumis. L'outil B09 doit recevoir `handoff_B02.json` et le ZIP `patch_B02` avec les `sha256` calculés. Le code B02 **n'est pas** connecté au runtime, et sa compatibilité avec le package KC33/B09 final reste une **condition de revue non satisfaite** jusqu'à transmission de ces archives dans la conversation.
