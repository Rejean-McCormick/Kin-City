# Kin City — 121 GLB retrouvés / Installation centrale sans Blender

## Résultat vérifié

`deco.zip` contient trois ensembles de 121 GLB : `_ETAPE_1_GLB_ORIGINAUX`, `IMPORTER_121_GLB` et `MODELES`. **Ne pas importer les trois !**

Les 121 fichiers `IMPORTER_121_GLB/KC32__*.glb` correspondent **exactement** aux 121 noms attendus dans `INSTALLER_KINCITY_KC35_LOCAL_9_BRANCHES.luau`. Les en-têtes GLB sont valides (glTF 2.0), chacun contient maillages et noeuds. Contrôle logiciel : pas une qualification visuelle Studio.

## Chemin sur le PC

`C:\mycode\Kin_City\Blender\KinCity_ArtDeco_V3_2_Sortie\IMPORTER_121_GLB`

Tu peux conserver les fichiers à cet emplacement. Ne renomme pas les `KC32__*.glb`.

## Procédure — Place nouvelle et vide, sauvegardée en RBXL, non publiée

1. Ouvrir la **nouvelle Place**, arrêter Play. Sauvegarder un `.rbxl` local avant manipulation. Activer `Workspace.StreamingEnabled`.
2. Dans Studio : `Fichier > Importer` (ou `File > Import`). Naviguer vers `IMPORTER_121_GLB`, sélectionner **tous les 121 GLB** (Ctrl+A) et les ajouter à la file d'importation. **Ne pas importer** les deux autres dossiers. Choisir le propriétaire du même compte/groupe que la future expérience.
3. Préférences d'import : `Add to Workspace = ON`, `Upload to Roblox = ON`, `Merge Meshes = OFF`, `Ignore Vertex Colors = OFF`, `Import as Package = OFF` pour les fichiers individuels. Utiliser un même préréglage pour les 121. Lancer Import. Examiner les erreurs éventuelles. Chaque modèle importé doit contenir des `MeshPart` avec des `MeshId` Roblox non nuls ; la présence des GLB locaux ne suffit pas.
4. Dans **Affichage > Barre de commandes** (`Command Bar`), exécuter **tout** `AUDITER_IMPORTS_ARTDECO_121.luau`. Vérifier `PASS 121/121` dans `Output`.
5. Toujours en **édition** et dans une Place **locale non publiée** (`game.PlaceId == 0`), exécuter **tout** `INSTALLER_KINCITY_KC35_CENTRAL_SAFE.luau`. C'est KC35 complet avec préservation d'une bibliothèque centrale valide déjà installée. Il crée `ServerStorage/KinCityArtDecoLibrary` et `Workspace/KinCityGenerated`.
6. Vérifier 121 modèles dans `ServerStorage/KinCityArtDecoLibrary` et sauvegarder le RBXL.
7. **Après** l'installation réussie, clic droit sur `ServerStorage/KinCityArtDecoLibrary` > **Convert to Package** ; choisir le bon créateur (compte/groupe). Vérifier que `PackageLink` apparaît. Sauvegarder. Conserver aussi les 121 GLB et le `.rbxl` en sauvegarde.
8. Dans chaque autre Place : insérer le package depuis Toolbox > Inventory > My Packages (ou les packages du groupe), le déplacer dans **ServerStorage**, vérifier le nom `KinCityArtDecoLibrary` et ne pas détacher son `PackageLink`. Les futures mises à jour passent par **Publish to Package** et **Update All**. Publier séparément les Places lorsque prêtes.

## Protection de la bibliothèque centrale

Le nouvel installateur `CENTRAL_SAFE` valide la bibliothèque centrale **avant** de lancer la construction. Si `ServerStorage/KinCityArtDecoLibrary` est complète, il la garde telle quelle et n'écrit pas d'attributs dans le package (préserve le `PackageLink`). Si elle est incomplète, il s'arrête au lieu de la remplacer silencieusement.

**Attention** : l'installateur local KC35 reste réservé à `PlaceId = 0`, hors production. Pour une Place publiée/staging, utiliser un processus de déploiement de test adapté, pas contourner cette sécurité. L'import et la publication nécessitent Roblox Studio et des droits appropriés. **Aucun import ni package Roblox n'a été réalisé par ChatGPT.**

## Licence

Certains modèles proviennent d'un pack commercial. Ne pas redistribuer les GLB ; conserver la licence et éviter de rendre le package public si les conditions n'autorisent pas cette diffusion.
