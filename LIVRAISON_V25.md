# Kin City — Livraison de construction v25.0

## Décision : finition des quartiers existants, pas de nouvelle expansion

Dépôt cumulatif v1–v25; **WORLD_STUB** conservé, sans requête kOA, IA payante, DataStore ni PlaceId inventé. Architecture : vert sarcelle `#1E6864`, opale `#C5F4F0` et métal champagne.

### Architecture des bâtiments secondaires (57 éléments réinterprétés)

Le module `src/server/SecondaryArchitectureV25.luau` est appelé par les générateurs d'origine :

| Famille | Effectif prévu par les catalogues | Détails ajoutés |
|---|---:|---|
| Halles marchandes | 6 | Fronton de nef, corniches, pilastres, emblème opalin, épis de toiture |
| Maisons communautaires | 6 | Fronton plus calme, corniches et prismes, silhouette de toiture distincte |
| Boutiques de promenade | 9 | Frontons obliques, résilles de vitrine, claveaux de toiture |
| Ateliers de gare | 8 | Nervures de marquise, jetons opalins et trame des lanterneaux |
| Maisons habitées | 24 | Frontons résidentiels, gemmes et variantes de faîtage |
| Ateliers maritimes | 4 | Traverse de port, emblème d'amarrage, sculpture de vigie |
| **Total** | **57** | Détails statiques et non bloquants |

Les ensembles v25 sont regroupés sous `Architecture de quartier v25`, identifiés par `KinV25Facade` et leur rôle. Le code supprime une ancienne décoration v25 du même modèle avant de la régénérer. Il ne déplace pas les ouvertures, marches, téléporteurs, prompts ou transports.

**Attention :** les 57 sont les éléments **ciblés par les générateurs**, pas un décompte d'Instances réellement constaté dans Studio. Le rendu des nouveaux accessoires doit y être contrôlé.

### Onze modèles 3D originaux facultatifs

Trois OBJ ajoutés dans `assets/meshes-v25/` :

- `opal-lattice.obj` : résille de vitrine.
- `mineral-pediment.obj` : fronton minéral à double nervure.
- `harbor-crest.obj` : emblème maritime.

Ils complètent les 8 modèles des v23–v24. `ReusableMeshesV23` conserve une variante native sans import. `StudioAssetLibraryV24` accepte maintenant onze clés. Pour utiliser les vrais modèles, importer et enregistrer les MeshParts dans `ServerStorage.KinCityAssetLibrary` avec `KinCity_Enregistrer_Mesh_Studio_v25.luau`.

### PBR Studio sans identifiants fictifs

Nouveau `MaterialLibraryV25.luau` : lit uniquement les quatre `SurfaceAppearance` facultatifs rangés dans `ServerStorage.KinCityMaterialLibrary` sous les noms `sarcelle_pierre`, `opale_massive`, `champagne_mineral` et `pierre_promenoir`. Une finition ne s'applique qu'à un MeshPart importé, seulement si celui-ci n'a pas déjà de `SurfaceAppearance`, et pas dans le profil de construction `LITE`.

`KinCity_Enregistrer_Materiau_Studio_v25.luau` enregistre un `SurfaceAppearance` configuré et sélectionné dans Studio. Le ZIP contient déjà les cartes de texture originales v23, mais leur **téléversement Roblox reste manuel**. Aucun AssetId n'est inventé. La géométrie native ne devient pas soudainement un mesh PBR.

### Transparences et profils visuels

Les vitrages répétitifs des 12 bâtiments communautaires, des 9 boutiques et des 4 ateliers maritimes utilisent désormais `OpalGlazingV22` : opale majoritairement opaque, verre héros limité aux configurations prévues, pièces décoratives sans collision, touche, requête ni ombre.

`SecondaryArchitectureV25` réduit ses détails en `LITE`, autorise quelques textures géométriques supplémentaires en `SHOWCASE` et ne crée **aucune nouvelle source de lumière dynamique**.

### Diagnostic Studio

`WorldBuildDiagnosticsV25.luau` effectue une seule lecture des Instances générées à la fin du build et inscrit sur `Workspace.KinCityGenerated` : temps de génération, nombres de BaseParts, MeshParts, sièges, lumières, prompts, finitions PBR et détails facultatifs. Les nombres apparaissent dans Output à l'installation.

`KinCity_Diagnostic_Studio_v25.luau` permet de relire ces mesures ainsi que l'état `Workspace.StreamingEnabled` et le nombre d'assets enregistrés. Ce diagnostic n'est pas un FPS, un microprofil CPU, ni un résultat de test mobile.

## Installation

1. Coller le contenu intégral de `KinCity_Installation_Directe_v25.luau` dans la **Command Bar**, en mode Édition, sur une copie du projet.
2. Exécuter pour reconstruire directement la ville. **Pas de transaction ni de rollback**, suivant la décision produit.
3. Lancer **Play** pour les activités et les transports.
4. Facultatif : enregistrer les OBJ et `SurfaceAppearance` importés dans Studio, puis régénérer avec le même installateur.

Les importations ne sont pas nécessaires pour le fonctionnement natif.

## Construction, vérifications et limites

- Commande unique : `python tools/build_release.py` (OBJ v24/v25, données et scripts partagés, installateur, empreintes).
- Suite : `python -m unittest discover -s tests -q` — **61 tests hors moteur réussis** au moment de la livraison.
- Le ZIP et son installateur ont été assemblés avec les sources cumulatives; des empreintes sont consignées dans `build/release-manifest.json`.
- **Non exécuté dans Roblox Studio** ici : les collisions, le style des meshes importés, les matériaux PBR, la fluidité, le streaming et les parcours multijoueur ne sont donc pas certifiés.

## Reste à construire

Finition de la végétation et des infrastructures secondaires hors de cette passe, animations R15 avec assets et locomotion raffinés, simplification des couches de géométrie coûteuses **après mesure en Studio**, import manuel des sons et textures déjà produits, publication Roblox si décidée ultérieurement.
