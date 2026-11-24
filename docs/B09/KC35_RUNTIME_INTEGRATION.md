# KC35 — Intégration runtime des neuf contributions

**Statut : code relié et testé hors moteur ; NON certifié par Roblox Studio ni dans un client publié.**

## Architecture technique

`tools/b09_bundle_branches.py` transforme de façon déterministe les modules de `contrib/places/<place_key>` en quatorze `ModuleScript` Luau préfixés sous `src/server/`. Le préfixage des dépendances `script.Parent` évite les conflits de `SceneData` et conserve les originaux des branches. Le script `src/server/BranchRuntime.luau` est le **seul adaptateur** qui appelle ces modules ; ni `WorldBuilder.luau` ni `catalog/places.json`, ni `catalog/doors.json`, ni `PlayerTravel.luau` ne sont modifiés.

**Cycle Edit/Play** : le générateur d'installation exécute `WorldBuilder.build()` puis `BranchRuntime.apply(state)`. Au démarrage Play, `init.server.luau` exécute `WorldBuilder.build(true)` puis `BranchRuntime.apply(state)` avant l'enregistrement des prompts serveur. Chaque module doit être idempotent ; le décor B07 a été amendé pour éviter tout doublon à la relecture du monde.

**Codes cibles par Place :**

| Place | Branche | Constructeur appelé | Fournisseurs |
|---|---|---|---|
| `city_hall` | B01 | `CityHallScene.build(context)` | `B01CityHallSpec` |
| `ekoh_tower` | B02 | `B02EkohInterior.Build(context)` | Spécification intégrée |
| `library` | B03 | `LibraryScene.build(context)` | `LibrarySceneData` |
| `campus` | B04 | `CampusDecor.build(interior,origin,profile)` | Aucun |
| `justice_palace` | B05 | `PreviewBuilder.build(context)` | `SceneData` |
| `innovation_lab` | B06 | `KonstructScene.build(context)` | Aucun |
| `museum` | B07 | `MuseumScene.build(context)` | `MuseumSceneData` |
| `orgo_center` | B08 | `OrgoScene.build(context)` | `OrgoSceneData` rebasé KC33 |
| `city` | B10 | `Wayfinding.build(city,plan,districts,profile)` | `WorldPlan`, `HexagonalDistricts` |

**Contextes** : l'adaptateur fournit `place_key`, `placeKey`, `contracts_version=KC34-DOC-1.0`, `place_model`, `placeModel`, `interiorModel`, `model`, `parent`, `origin` et `profile`. L'autorisation `authorized=true` pour B03 est déclenchée uniquement par l'adaptateur serveur B09. En `LOCAL_UNIVERSE`, il traite la ville et les huit intérieurs. En `MULTI_PLACE`, il ne traite que la Place active résolue par `Spatial.currentPlace()`.

**Diagnostics** : `KinCityGenerated:GetAttribute("KinBranchRuntimeState")` vaut `Ready` ou `Partial`. Inspecter `KinBranchReadyCount`, `KinBranchExpected`, `KinBranchRuntimeErrors` et les attributs `KinBranchBxxStatus`. L'installateur Édition refuse de déclarer une réussite si une branche n'a pas été décorée. Le serveur Play avertit en cas d'erreur sans prétendre que le service fonctionnel est validé.

## Statut B08 (rebase)

Le `studio/B08_STUDIO_PREVIEW_LOCAL.luau` original V3 reste archivé et **n'est pas exécuté**. `scene_recipe_KC33.json` contient les six salles et 24 ornements avec les clés KC33 ; `asset_plan_KC33.json` met à jour les statuts d'assets selon le manifeste KC33. `OrgoSceneData.luau` et `OrgoScene.luau` implémentent la version serveur KC33 avec des objets natifs non collidables, sans importer les modèles commerciaux proposés dans le document de curation. Les 16 tests legacy B08 peuvent donc continuer à vérifier l'archive historique, mais la nouvelle implémentation doit être testée visuellement dans Studio.

## Exception produit B07 — PORTE BARRÉE

Le contrat `city.kreative.museum.entry` demeure dans `catalog/doors.json`, mais son usage public est **désactivé par choix du propriétaire** : ProximityPrompt désactivé et règle serveur complémentaire dans `PromptRouter`. Le modèle `KinCityMuseumLockdown` matérialise physiquement la fermeture. `KinCityOutdoorCinema` est déplacé vers la façade du musée et sa signalétique est harmonisée avec B10 (`MUSÉE — FERMÉ / BROADCAST YOUTUBE À PROXIMITÉ`). Les départs du musée vers la ville restent présents pour les administrateurs/testeurs accédant directement à la Place `museum`. **Cette configuration ne permet pas de revendiquer 16 portes accessibles publiquement** : 15 sont opérationnelles selon la conception canonique et une entrée est volontairement fermée tant que la décision n'est pas levée.

Un `VideoFrame` Roblox ne lit **pas** une URL de flux YouTube ; il nécessite une vidéo téléversée sur Roblox et autorisée. Le compteur `KinVideoAssetId=0` signifie qu'il n'existe pas de vidéo active. Le panneau de broadcast reste visible, et le message « VIDÉO À CONFIGURER » est affiché tant qu'aucun ID valide n'est renseigné. Aucune promesse de diffusion en direct fictive n'est faite. Documentation : https://create.roblox.com/docs/reference/engine/classes/VideoFrame .

## Rebuild local (seulement une copie Roblox Studio)

1. Ouvrir une copie **locale PlaceId 0** contenant les 121 modèles sous licence dans leur bibliothèque autorisée. **Sauvegarder d'abord le `.rbxl`.**
2. Arrêter Play, activer `Workspace.StreamingEnabled`, puis coller le contenu de `INSTALLER_KINCITY_KC35_LOCAL_9_BRANCHES.luau` dans la Command Bar. L'installateur remplace uniquement les ressources Kin City qu'il annonce ; il est destructif sur les anciennes ressources Kin City de la copie.
3. Vérifier `Workspace.KinCityGenerated.KinBranchRuntimeState == "Ready"`, `KinBranchReadyCount == 9`, `KinInteriorCount == 8`. Vérifier la barre devant le musée et l'écran de broadcast bien orienté, sans passage bloqué sur le trottoir public.
4. Jouer le parcours des 48 salles, des ascenseurs, des 6 secteurs. Les téléportations inter-Place ne se testent **pas** ici.
5. Pour un rollback, restaurer la copie Studio enregistrée ou utiliser le ZIP antérieur KC34 ; ne pas exécuter de désinstallation improvisée en production.

## Rebuild staging (après neuf vrais PlaceIds privés)

1. Créer les neuf Places **dans le même univers privé de staging** ; conserver les sauvegardes et importer les 121 modèles autorisés dans chaque Place.
2. Remplir une copie de `config/place_ids_staging.TEMPLATE.json` avec les neuf IDs réels (aucun ID production).
3. Générer les neuf installateurs :

```bash
python tools/build_staging_kc35.py --ids config/place_ids_staging.json --out build/KC35-STAGING-PLACE-INSTALLERS
```

4. Vérifier manuellement que les neuf IDs appartiennent au même univers et que celui-ci est privé ; l'outil vérifie la structure, pas les permissions de ton compte Roblox.
5. Exécuter chaque installateur **dans sa Place précise**, Play arrêté, avec `KinArtDecoTestPlace=true` et `StreamingEnabled`.
6. Tester dans le **client Roblox publié sur staging** les sept entrées de musées autres que B07, les huit sorties, les arrêts et erreurs de téléportation, la Place musée en accès direct administrateur et la cohérence du retour.

## Limites et performance

Le raccordement à `WorldBuilder` ne met pas automatiquement à jour les métriques de budget Art déco calculées à la fin de la construction canonique. Les nouvelles décorations sont des objets natifs sans mesh commercial. Leur coût réel en instances, rendu, mémoire et FPS doit être profilé sur appareil mobile. Un statut `Ready` signifie que les fonctions de décoration ont été appelées sans erreur et non que le jeu est validé visuellement ou publiable.
