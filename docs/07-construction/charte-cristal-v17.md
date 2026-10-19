# Direction artistique v17 : #1E6864 et cristal opalin

La signature de Kin City est le **sarcelle minéral profond** `#1E6864`, allié à un cristal opalin `#C5F4F0` et des filets champagne `#E5D7AF`. Les bâtiments sont chaleureux et lisibles; le cristal n'envahit jamais les voies ou les écrans.

## Hiérarchie visuelle

1. Les structures utilisent `#1E6864` (poutres, encadrements, soubassements, colonnes, signalétique) et les pierres adoucies du `catalog/style_guide.json`.
2. Les façades institutionnelles ajoutent des arêtes minérales, des frontons radiaux et une couronne de cristal. Chaque institution garde son accent thématique dans `catalog/crystal_theme.json`.
3. Les intérieurs utilisent des prismes muraux, des rosaces et un mandala au sol. Les salles ne se changent pas toutes en verrières.
4. La place centrale et la couronne des quartiers répètent les pylônes, motifs et cristaux, formant le langage commun de la ville.

## Production sans asset tiers

`CrystalKit.luau` produit des cristaux au moyen de quelques Parts et WedgeParts Roblox. Les parties opaques sont Slate; chaque cristal a une inclusion Neon limitée. Seuls les cristaux `hero` ajoutent UNE mince facette Glass, légèrement transparente. L'éclairage ponctuel n'est placé que sur le monument central, pas sur chaque élément.

La génération est déterministe et passe par `CrystalFacades`, `CrystalInteriors` et `CrystalPublic`. Les objets portent `KinArtTheme=sarcelle-cristal-v17` pour rester reconnaissables lors des futures refontes. **Ces éléments sont des ornements non-collidables** : portes, ascenseurs, consoles et tracés conservent leurs comportements.

## Profils de richesse visuelle

Le fichier `config/visual.json` permet de choisir `LITE`, `STANDARD` (par défaut) ou `SHOWCASE`. Regénérer l’installateur après modification. Le monde change de révision lorsque le profil change et ne réutilise pas l’ancienne scène. LITE conserve le sarcelle et les cristaux, mais réduit les facettes et supprime le verre des héros. Cette sélection est un paramètre de **construction** pour l’ensemble de la scène, pas une détection automatique des performances de chaque joueur.

## Finition ultérieure

L'identité est active maintenant. Les assets optimisés en MeshPart, la texture PBR et les détails supplémentaires sont prévus pour une itération future; le modèle de données et la couleur de marque resteront stables. Tout ajout devra conserver la lisibilité en mode mobile et éviter la superposition de multiples couches de verre.

## Exécution et limites

Le code est conçu pour Roblox Studio, mais sa qualité visuelle et ses performances ne peuvent être confirmées sans exécuter Studio. Aucun asset payant, requête HTTP ou accès à kOA n'est nécessaire.
