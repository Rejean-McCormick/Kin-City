# 04 — L'orchestrateur urbain : remplacer les générateurs indépendants

## 1. Problème d'organisation dans KC35

Actuellement `WorldBuilder` délègue une grande construction à `CityGenerator` et aux intérieurs, puis `BranchRuntime` ajoute les contributions ; plusieurs modules (`KoaliUrbanism`, parvis, pavillons, mobilier, signalétique, scènes spécifiques) possèdent leurs propres règles locales de réservation. Ils ne partagent **pas** un inventaire exhaustif d'occupation, de surplomb et de surfaces visibles. La construction produit un monde « qui tient debout », mais elle ne peut pas démontrer une composition urbaine cohérente.

Le changement structurel est : **un plan d'occupation unique est calculé et validé AVANT que la moindre Part soit créée**. Les générateurs sont des exécutants d'un plan immuable ; ils ne choisissent plus où les objets majeurs apparaissent.

## 2. Architecture cible proposée

```text
Source-of-Truth
  CityDefinition + Districts + RoadNetwork + PlotInventory + BuildingRegistry
  + Anchors + PlaceContracts + AssetPackageManifest
               │
               ▼
     01 UrbanPlanCompiler (déterministe)
         - parcelles, voies, circulations, niveaux
         - calcul de polygones orientés et réservations
         - assignation façade ↔ parcelle ↔ parvis
         - connexité piétonne et graphes de portes
               │
               ▼
     02 SpatialValidator (strict, fail-fast)
         - intersections/clearances
         - surfaces uniques, top Y et z-fighting candidats
         - visibilité, sorties, budgets, cohérence IDs
               │
       ApprovedPlan.json (révision figée)
               │
               ▼
     03 StagedSceneBuilder
         A. Terrain + rivages + masques
         B. Sols de rues, trottoirs et carrefours
         C. Fondations, parvis et connexions piétonnes
         D. Volumes et façades institutionnelles
         E. Intérieurs (dans les Places ciblées)
         F. Mobilerie, lumière, jardins, panneaux physiques
         G. Ancres, portes, interactions, politique d'accès
         H. Contributions B01–B10, uniquement dans les slots
               │
               ▼
     04 SceneVerifier + snapshots + Play QA
         - diff des instances/transformations
         - scripts de navigation, screenshots, performance
         - staging uniquement après revue
```

## 3. Propriétaires de géométrie (une seule autorité par fonction)

| Domaine | Autorité de planification | Propriétaire de construction | Modules historiques à adapter |
|---|---|---|---|
| Île/eau/terrain | `TerrainPlan` | `TerrainBuilder` | `CityGenerator`, `GroundCompatibility`, `ScenicCoast` |
| Routes / axes / anneaux | `StreetGraph` + reservations | `RoadBuilder` | `KoaliUrbanism`, `CityGenerator.streetTiles` |
| Carrefour / liaison | `JunctionPlan` | `JunctionBuilder` | routes et pavage de plusieurs modules |
| Parcelles et parvis | `SitePlanner` | `SiteFoundationBuilder` | `InstitutionForecourts`, institutions |
| Façades | `BuildingPlacement` | `FacadeGenerator` | `ArtDecoBuildings` ; pas de nouvelle origine |
| Signalétique | `SignageSchedule` | `SignEngine` + `Factory.sign` | `Wayfinding` B10, façades, bornes |
| Nature | `LandscapePlan` | `LandscapeBuilder` | plantations aléatoires et réservations locales |
| Intérieurs | `InteriorRoomPlan` | `InteriorGenerator` | `InteriorWings`, décor des branches |
| Portes et prompts | `DoorContract` | `DoorBinder` | `WorldBuilder`, `PromptRouter`, `PlayerTravel` |
| Assets | `AssetResolver` | `ArtDecoAssets` | `KinCityArtDecoLibrary`, clones de décor |

Les noms ci-dessus sont **des composants cibles proposés**, pas des classes déjà présentes. Les scripts historiques doivent être migrés progressivement et protégés par tests de diff. Un nom de composant ne remplace pas une implémentation.

## 4. Système de réservation multi-échelle

Un seul registre `SpatialReservations` est utilisé pour chaque zone :

- `hard_exclusion` : voie publique, issue, murs interdits, rives, emprise d'institution ; la demande est rejetée.
- `required_interface` : parvis/entrée, liaison pédestre, dégagement d'un panneau ; l'actif doit toucher cet espace de façon contractuelle.
- `soft_constraint` : vue/ambiance, préférences végétales, matériaux ; on peut scorer/déplacer avec décision.
- `overlap_exemption` : pont, tunnel, auvent hors sol, marquise ; nécessite `vertical_clearance`, preuve et décision explicites.

Chacune a un `owner`, une source de données, un polygone (ou OBB), une élévation, une révision et une preuve. **Aucune fonction de branche ne réserve secrètement des parcelles au runtime.**

## 5. Protocole de contribution des dix branches

- **B09** : autorité de compilation, validation géométrique, merge et migrations.
- **B10** : composition des six secteurs, réseau public, alignements, vues et supports physiques ; **ne redéfinit pas une porte B01–B08**.
- **B01–B08** : identité propre, contenus et mobilier intérieur, propositions de parvis et façade **dans des slots approuvés** ; ne choisissent pas un emplacement absolu en ville.
- **B07** : accès musée fermé, écran de broadcast voisin, sans transmission YouTube native présumée et sans obstruction de chemin.
- **Package central Art déco** : copie versionnée en `ServerStorage.KinCityArtDecoLibrary`. Aucun générateur n'édite un enfant du Package. Des instances sont clonées comme éléments de scène avec provenance/asset ID, pas modifiées in situ.

Chaque branche livre un `PlacementRequest` avec `place_key`, `slot_id`, `clearance`, `visual_budget`, `source_revision`, `rollback`, `acceptance_images`, et **n'écrit aucune coordonnée monde absolue dans son code de décor**.

## 6. Déterminisme, diff et rollback

L'IR doit porter un `plan_sha256`. Deux builds même seed/contrats/Package version donnent le même placement logique, quel que soit l'ordre d'import des branches. Les changements générés sont comparés par `stable_instance_id`, rôle, emplacement, taille, matériau et asset source. Un nouveau générateur crée sa scène dans une zone temporaire, exécute une **prévalidation**, puis remplace son ancien groupe **uniquement** si les contrôles ont réussi. Les objets sous `ServerStorage.KinCityArtDecoLibrary` sont exclus de tous les scripts de nettoyage ou `wipe`.

En cas d'erreur : conserver le monde précédent et produire une trace exploitable, plutôt que construire une ville partiellement renouvelée et annoncer « READY ».

## 7. Décision d'exécution recommandée

Avant d'écrire une nouvelle ligne de façade ou de mobilier, livrer d'abord l'outil de **planification en mode tête-bêche/greybox** : deux rectangles et des routes suffisent à démontrer la résolution des collisions. Après son acceptation, brancher progressivement les générateurs de surfaces et les décorations. Cela évite de dépenser du temps de production artistique sur un plan instable.
