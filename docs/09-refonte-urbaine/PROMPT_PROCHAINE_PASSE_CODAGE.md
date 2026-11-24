# Prompt de travail — KC37, après approbation documentaire KC36

Tu travailles sur le projet Kin City / Koali. **NE MODIFIE PAS IMMÉDIATEMENT LA VILLE VISIBLE.** Pars de `KinCity_KC35_INTEGRATION_9_BRANCHES_COMPLET.zip` et du paquet documentaire `KinCity_KC36_DOCUMENTATION_URBANISME_COMPLET.zip`.

**Objectif :** implémenter dans une **nouvelle copie locale** le contrat de refonte KC36 en mode *greybox*, avant de retoucher matériaux et façades.

1. Lire `09-refonte-urbaine/00_LIRE_EN_PREMIER.md` et les chapitres 01–08 ; distinguer `DÉCIDÉ`, `PROPOSÉ`, `À_QUALIFIER`.
2. Charger les 8 structures et les 6 avenues du plan KC35. Reproduire les **6 conflits** de `preuves/KC35_CHEVAUCHEMENTS_VOIRIE.json` avec un test d'intersection polygonale.
3. Proposer au propriétaire **au moins deux alternatives** de placement pour les trois cas majeurs — bibliothèque, Hôtel de ville, musée — sans appliquer une coordonnée arbitraire.
4. Construire `RoadNetwork`, `SpatialReservations`, `PlotInventory`, `ApprovedSiteAssignments` et un prévalidateur `0 illegal collisions` ; aucun constructeur ne doit placer directement un bâtiment canonique sans site approuvé.
5. Prévoir `SurfaceOwnershipMap` et le diagnostic Studio de la pelouse blanche, sans déclarer une cause non observée.
6. Ne jamais recréer les panneaux de B10 : aucun `BillboardGui` géographique, aucune référence publique « 10 H », textes physiques et lisibles.
7. Préserver **tous les IDs** : 16 portes, 49 ancres, 8 identités institutionnelles, 9 Places logiques, 9 contributions B01–B08+B10 ; B09 intégration distincte.
8. Conserver `ServerStorage.KinCityArtDecoLibrary`, sa version et son `PackageLink` (121 modèles, 463 MeshParts validés dans la Place actuelle), sans édition du Package source dans les consommateurs.
9. B07 reste fermée (porte barrée et écran de broadcast près du musée). La vidéo réelle nécessite un asset Roblox autorisé : ne pas promettre un direct YouTube.
10. Comparer V30 et KC35 à caméra identique, et publier une matrice : fonctionnalités et style V30 à conserver, nouveautés KC35 souhaitables, objets à supprimer.
11. Livrer test géométrique reproductible, rapports avant/après, captures Studio à faire, RFC des déplacements, plan de migration et rollback ; ne pas publier de Roblox Place automatiquement.

**Priorité de sortie :** PR/patch documentaire d'abord, puis gris de validation. Si les coordonnées de nouvelles parcelles ne sont pas approuvées, ne pas générer de scène finie faussement certifiée.
