# Art Deco v3 — refonte de la ville et des intérieurs séparés

## État de référence

Travail sur la branche locale `refactor/art-deco-contextual`, à partir du snapshot
fourni. Le HEAD GitHub distant n'a pas pu être vérifié. Aucun dépôt distant ni
aucune Place publiée n'ont été modifiés. La Place de production reste exclue.

Le relevé Studio de l'utilisateur identifie exactement 121 sources et 463 MeshParts
avec des MeshId distincts. La précédente installation avait réellement placé
349 MeshParts, mais la majeure partie des bâtiments restait procédurale. Cette
version remplace les volumes extérieurs dominants et habille l'architecture des
intérieurs séparés, en utilisant les mêmes imports déjà présents dans Studio.

## Architecture de chargement conservée

Le mode fourni est `LOCAL_UNIVERSE`. La ville et les huit intérieurs existent
côté serveur dans une seule Place de test. Les intérieurs sont à leurs origines
éloignées d'origine ; les portes appellent le déplacement du joueur et la demande
de streaming vers la destination. Ce mode local ne crée pas huit nouvelles Places
publiées et ne transforme pas les intérieurs en pièces physiquement contenues dans
les façades de la ville. La bibliothèque complète reste dans ServerStorage.

`catalog/spatial.json`, `catalog/places.json`, `catalog/doors.json`,
`config/interior_origins.json`, `config/runtime.json`, `Spatial`, `PlayerTravel`
et `InteriorWings` conservent leurs données et comportements de référence.

## Intégration

| Ensemble | Réalisation |
| --- | --- |
| Huit institutions extérieures | Deux grands modules de bâtiment du pack, collisions ajustées à ces volumes, passage central dégagé, couronnement propre à l'institution et pancarte originale |
| 18 pavillons des secteurs | Bâtiments Cinema du pack, orientés et dimensionnés dans les terrains existants ; bornes et prompts conservés |
| 48 salles existantes | Panneaux muraux, fenêtres, sols à motifs ou parquet, colonnes ; substrat natif continu et ouvertures conservés |
| Connexions entre salles | Colonnes du pack autour des ouvertures ; aucune porte fermée dans les passages traversables |
| Sorties interactives | Modèle de porte du pack autour des ancres de sortie existantes |
| Galeries hautes | Revêtements de mezzanine au niveau existant ; escaliers, sols de marche et ascenseurs conservés |
| Mobilier | Comptoirs, assises, banquettes, tables basses, végétation, luminaires et objets d'exposition en contexte ; identifiants fonctionnels conservés |

Les six couleurs de secteur proviennent toujours de HexagonalDistricts. Les rôles
CORPS, BRONZE, VITRAGE et LUMIERE ont une palette structurelle commune ; ACCENT
prend la couleur du secteur. Les textures et variations de couleurs de vertex
restent dans les meshes. Leur rendu effectif doit être inspecté dans Studio.

## Fichiers d'intégration

- `ArtDecoLayout` et `ArtDecoBuildings` : composition des enveloppes extérieures.
- `ArtDecoSurfacePlan` : planificateur pur de surfaces, passages et galeries.
- `ArtDecoSurfaces` : rendu des surfaces dans le repère de chaque intérieur.
- `ArtDecoInteriors` et `PropGenerator` : mobilier et hôtes d'interaction.
- `ArtDecoProps` et `KoaliUrbanism` : pavillons et mobilier urbain.
- `ArtDecoAssets` et `ArtDecoBudget` : clones, palette, collisions décoratives,
  réservations par propriétaire, restauration du budget et remboursement.
- `ArtDecoLightLOD` et `ArtDecoLightPolicy` : sélection locale de lumières statiques.
- `PrepareArtDecoLibrary` : résolution des vrais imports, exclusion des copies
  générées, archivage privé et conservation d'une bibliothèque précédente.

## Optimisation et limites

Les clones sont ancrés. Les surfaces décoratives ne participent pas aux collisions,
aux contacts ni aux requêtes de gameplay. Les collisions nécessaires proviennent
des sols, enveloppes et hôtes dédiés. Les meshes utilisent RenderFidelity.Automatic ;
les ombres de meshes sont réservées au profil SHOWCASE. Le LOD local existant peut
masquer les revêtements décoratifs éloignés sans retirer le sol praticable.

Les lumières architecturales statiques sont sélectionnées localement par proximité :
8 en LITE, 16 en STANDARD, 24 en SHOWCASE. Les lumières d'expositions pilotées par
les mécanismes gardent leur propriétaire ; ces plafonds ne désignent donc pas le
total de toutes les lumières possibles de la scène. Aucun son n'est modifié.

Les budgets sont séparés entre bâtiments, pavillons, surfaces intérieures,
mobilier, éclairage urbain et végétation. `build/art-deco-zone-audit.json` contient
les estimations exécutant les mêmes planificateurs que le rendu. Les réservations
globales couvrent la géométrie résidente des neuf zones, pas une seule image mobile.

Les bâtiments importés et pavillons représentent 299 350 triangles source, avant
le mobilier urbain et la géométrie native conservée. Les surfaces d'un intérieur
représentent environ 33 500 à 39 000 triangles source suivant le profil, auxquels
s'ajoutent le mobilier et les mécanismes existants. Ces valeurs ne mesurent ni le
coût GPU, ni la mémoire, ni un nombre d'images par seconde. Les mécanismes, étages
et collections fonctionnelles historiques conservent de la géométrie native ;
l'installateur ne prétend pas supprimer toutes les pièces générées par l'IA.

## Migration, reproduction et retour arrière

1. Ouvrir la Place locale contenant les imports déjà réalisés, hors Play.
2. Exécuter en entier le script assemblé fourni à la racine du ZIP.
3. Vérifier les lignes de contrôle : 8 façades, 18 pavillons, 48 salles.
4. Lancer Play et contrôler les transitions aller/retour, ascenseurs, interactions,
   musique et rendu sur un appareil mobile réel avant d'envisager une publication.

Les 121 sources restent en privé dans ServerStorage.KC_ARTDECO_V32_SOURCES. Les
clones préparés sont dans KinCityArtDecoLibrary. Une bibliothèque préparée précédente
est conservée ; les copies supplémentaires créées par nos propres installations
sont nettoyées pour éviter une accumulation illimitée.

Pour revenir au code précédent, utiliser le commit local `0951066` et son
installateur officiel sur la même Place locale. Les originaux archivés restent
réutilisables. Une sauvegarde de la Place permet aussi de revenir à son état visuel.
Aucune action ne doit publier la Place de production sans accord de l'utilisateur.

## Licence et validation

Le ZIP de livraison contient les sources du projet et les références d'assets,
aucune redistribution du pack commercial en bibliothèque publique. Les fichiers
3D et leurs droits restent soumis à la licence du pack acheté. L'installateur
n'upload aucun nouvel asset et ne publie aucune Place.

Les tests hors Studio vérifient les proportions, quotas, passages, 48 salles,
mezzanines, sélection des lumières, réinstallation et invariants fonctionnels.
Les contrôles Studio sont inclus et exécutés par le script sur la Place de test.
L'auteur de cette livraison n'a pas exécuté cette version dans Roblox Studio :
rendu, performance mobile, audio effectif et parcours restent à confirmer là-bas.
