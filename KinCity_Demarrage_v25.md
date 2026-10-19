# Kin City v25 — Démarrage pratique

## Installation directe, aucune importation obligatoire

1. Ouvrir Roblox Studio sur une copie de votre expérience, en mode **Édition**.
2. Ouvrir **View > Command Bar**.
3. Ouvrir `KinCity_Installation_Directe_v25.luau`, sélectionner tout et coller dans la Command Bar.
4. Exécuter. La ville est générée immédiatement avec les formes natives; le script installe aussi le code pour les actions en mode Play.
5. Lancer **Play** pour explorer Kin City, ses portes et activités.

L'installateur est **cumulatif** : ne pas coller ceux des versions précédentes. Il remplace directement la scène et les scripts; pas de mécanisme de retour arrière. `ServerStorage.KinCityAssetLibrary` et `ServerStorage.KinCityMaterialLibrary` sont conservés.

## Option : vraies pièces 3D

1. Importer un `.obj` d'`assets/meshes-v23`, `assets/meshes-v24` ou `assets/meshes-v25` via Roblox Studio.
2. Sélectionner son `MeshPart`.
3. Ouvrir `KinCity_Enregistrer_Mesh_Studio_v25.luau` et donner à `KIN_KEY` l'une des 11 clés figurant dans `config/meshes.json`.
4. Coller la commande dans la Command Bar et exécuter.
5. Réinstaller la v25 : le MeshPart importé sera réutilisé dans les constructions concernées.

## Option : matériaux PBR sur MeshPart

1. Importer les cartes de `assets/materials-v23/` dans Roblox et configurer un `SurfaceAppearance` avec au minimum son `ColorMap`, plus les cartes normale et rugosité si disponibles.
2. Nommer cet objet `sarcelle_pierre`, `opale_massive`, `champagne_mineral` ou `pierre_promenoir`.
3. Le sélectionner et exécuter `KinCity_Enregistrer_Materiau_Studio_v25.luau` dans la Command Bar.
4. Régénérer la v25. Les matériaux sont utilisés uniquement pour les MeshParts concernés en `STANDARD` ou `SHOWCASE`, sans modifier les pièces natives.

## Voir les mesures de construction

Après installation, afficher **View > Output** pour le résumé. On peut aussi exécuter `KinCity_Diagnostic_Studio_v25.luau`. Les chiffres comptent les Instances générées **dans Studio**; ils ne mesurent ni les FPS ni la consommation sur téléphone.

## État de l'univers

- Signature artistique : **#1E6864 + cristal opalin**.
- Activités locales, portes et transports : code prévu dans la livraison cumulative.
- Fonctions kOA : **WORLD_STUB**, libellé « Fonctionnalité à venir », aucune requête externe.
- Import audio, permissions des assets Roblox, rendu et performance mobile : à vérifier dans Studio et sur appareils cibles.
