# 03 — Le sol, la pelouse blanche clignotante et les couches de surface

## 1. Symptôme observé et statut de certitude

Le joueur voit sur sa Place KC35 une grande zone blanchâtre/triangulaire et une partie de la pelouse qui **clignote blanc quand la caméra bouge**. Le *z-fighting* entre surfaces proches/coplanaires est une **hypothèse prioritaire**, pas une preuve. Les autres hypothèses à tester sont : import GLB avec face en conflit, face triangulée mal orientée, surface du `Baseplate` ancienne, dalle de sentier très large, terrain réel sous un Part, et LOD/streaming/transparence.

**Ne pas conclure « le problème vient de deux meshes »** sans le chemin d'Instance. Le bon prochain geste est une capture d'identification en Play et un examen des éléments sous le curseur (voir protocole ci-dessous).

## 2. Observations vérifiées dans les fichiers KC35

- `CityGenerator.luau` produit une **île circulaire** de rayon ~495 studs, cylindre horizontal `Size=(2,990,990)`, `CFrame=(0,-1,0)` : sommet nominal Y=0 ; produit également une pièce « Lac périphérique » plus basse.
- `GroundCompatibility.luau` **archive seulement** un `Baseplate` très précis (bloc, taille, orientation, sommet voisin de Y=0), plutôt que d'effacer arbitrairement tout le Terrain.
- `CityGenerator.streetTiles` émet des « Chemin unifié » : `Size.Y=0.24`, `Position.Y=0.09`, face supérieure ~Y=0.21.
- `KoaliUrbanism.avenue` émet 19 « Dalle piétonne » par axe : `Size.Y=0.35`, centre ~Y=0.36, sommet ~Y=0.535.
- Le même générateur ajoute le pavage GLB `ArtDecoProps.street(..., "paving_straight/cross", ...)` en face visible ~Y=0.535, par dessus le sol natif.
- Des parvis sont ajoutés ultérieurement par `InstitutionForecourts`, ce qui ajoute une troisième famille de revêtements.

Ces empilements rendent un conflit **plausible**. Ils ne prouvent pas l'origine exacte de la forme blanche photographiée.

## 3. Décision d'architecture recommandée : un titulaire par cellule surfacique

Créer un `SurfaceOwnershipMap` calculé, non un collage d'instances issues de modules indépendants.

| Couche métier | Propriétaire unique | Peut être visible ? | Collision physique ? |
|---|---|---|---|
| `FOUNDATION_GROUND` | `TerrainPlanner` | oui hors masques | un support explicite |
| `ROAD_CORE` | `RoadSurfaceBuilder` | oui | oui sur une surface exacte |
| `SIDEWALK` | `WalkwayBuilder` | oui | oui si utilisable |
| `CROSSING` | `JunctionBuilder` | oui, **remplace** la route locale | une seule |
| `PLOT_BASE` | `PlotSurfaceBuilder` | oui hors bâtiments | selon parvis |
| `PLAZA` | `CivicPlazaBuilder` | oui, remplace la pelouse | oui |
| `BUILDING_FOOTPRINT` | `SiteFoundationBuilder` | visible seulement si intentionnel | oui |
| `DECO_OVERLAY` | `VisualDetailBuilder` | selon budget, mesh seul | **jamais collision indépendante** |

Une cellule peut contenir décor + sol porteur, mais une **seule face opaque dominante** au niveau de la marche. Quand deux motifs doivent être adjacents, utiliser un découpage polygonal en surfaces sans recouvrement, pas deux pavés sur le même plan. Élévation très légère comme correctif local = exceptionnel, jamais le mécanisme principal.

## 4. Règles de géométrie et matériaux

- Autorité 2D : polygones de recouvrement exclusifs. Autorité 3D : surface du sol dérivée du type de zone (`groundHeight(x,z)`) ; définir séparément `visualTopY` et `walkableTopY`.
- Quand une voie traverse une pelouse : découper le masque pelouse **avant** génération. On ne pose pas une route opaque sur un fond opaque coplanaire.
- Quand un parvis rejoint une avenue : polygoniser une zone d'interface, transition contrôlée par un seul `JunctionBuilder`.
- Interdire les triangles gigantesques issus de l'import pour remplacer des cellules carrées à hauteur du joueur ; vérifier normals, pivots, bounding box, `DoubleSided` et matériaux.
- Toute surface visible d'une largeur excessive doit être **marquée comme majeure** et documentée ; éviter qu'un accessoire/mesh de pavage couvre une avenue entière par un import mal orienté.
- Différencier les catégories `Part.Grass`, `Terrain.Grass`, `MeshPart` sans présumer qu'elles partagent les mêmes propriétés ni LOD.

## 5. Protocole de diagnostic Studio (sans suppression)

1. Sauvegarder `KinCity_35_AVANT_AUDIT_SOL.rbxl`; Play arrêté : sélectionner la zone blanche, examiner `GetFullName`, `ClassName`, `Size`, `CFrame`, `Material`, `Transparency`, `MeshId`, `CanCollide`, `CastShadow`, `Attributes`. Noter screenshot et coordonnées.
2. Si la sélection directe est impossible : passer la caméra à l'angle suspect, relever la zone, utiliser temporairement un script diagnostic **lecture seule** qui échantillonne des rayons (origine caméra, `Workspace:Raycast`, `RaycastParams`); répéter avec 1–2 degrés de variation. Une raycast donne la première collision, **pas nécessairement** la surface visuelle clignotante.
3. En mode Édition **sur une copie de la Place**, masquer un groupe à la fois : `KinCityGenerated.Ville.Île circulaire`, puis `Sentiers piétons`, puis l'avenue incriminée, puis les `KinArtDecoAsset` de pavage. Photographier une image par test et annuler le masquage. Ne pas intervenir dans la bibliothèque du Package.
4. Répéter immobile, en mouvement, qualité basse et élevée, streaming activé ; noter si le clignotement dépend du chargement/angle.
5. Si deux surfaces opaques se disputent le même plan : enregistrer les chemins des **deux** instances, leurs sommets et leurs propriétaires de module. Émettre une RFC de suppression de doublon géométrique, non un patch de transparence aveugle.

## 6. Portes de qualité

**P0 bloquant :** aucune zone blanche géante ni scintillement reproductible dans les trajets majeurs ; aucun patch masquant le problème sur un seul appareil. **Preuve :** capture et courte vidéo depuis la même trajectoire dans V30, KC35 et le nouveau plan. Aucun résultat avant exécution Studio ne doit être qualifié de « corrigé ».
