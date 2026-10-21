# Kin City v27 — démarrage

## Tester King Klown sans reconstruire la ville

1. Arrêter Play dans Studio.
2. Ouvrir `KingKlown_v6.luau` dans un éditeur de texte et tout copier.
3. Coller dans la barre Commande et exécuter.
4. Lancer Play. Vérifier le visage de face et de profil, marcher, sauter, s'asseoir, puis réinitialiser le personnage.
5. Rapprocher la caméra : l'orbe disparaît en première personne et revient à distance. Le bouton CRISTAL de la ville v27 règle aussi les effets.

L'installateur remplace le script King Klown précédent. Il ne reconstruit pas la ville. Il conserve son OwnerUserId explicite si le nouvel identifiant reste à zéro. En expérience de groupe, renseigner votre vrai UserId au début du fichier. En Studio, tous les joueurs de test sont autorisés par défaut; le dépôt permet de désactiver cela avec `studioPreview=false`.

## Installer toute la passe

Enregistrer d'abord une copie de votre Place si vous avez modifié manuellement les constructions. Exécuter `KinCity_Installation_Directe_v27.luau` en Édition. Ce script reconstruit KinCityGenerated et inclut King Klown; il n'est pas nécessaire d'exécuter ensuite le petit installateur.

Tester les transports et les interactions existantes. Les huit intérieurs gardent leurs propres installateurs. Commencer par `KinCity_Installation_Place_library_v27.luau` dans une autre Place. Les portes entre scènes séparées restent indisponibles tant que les vrais IDs ne sont pas configurés.

## Relier les Places publiées

Créer les neuf Places dans la même expérience, inscrire les vrais IDs dans `config/place_ids.json`, passer `config/runtime.json` à `MULTI_PLACE`, puis lancer `python tools/build_release.py`. Réinstaller et republier chaque scène correspondante. Tester les passages dans le client Roblox publié, aller et retour, puis après réapparition. Le mode de secours local reste local même lorsque la configuration de publication est active.

## Mesurer

Installer `KinCity_Diagnostic_Performance_v27.luau` en Édition, lancer Play, puis marcher pendant environ 25 secondes. Lire la Sortie côté client : FPS moyen, temps d'image médian/p95, mémoire et objets effectivement chargés. Refaire le même trajet avec la même qualité pour comparer. Retirer `StarterPlayerScripts.KinCityPerformanceProbe` pour désactiver le diagnostic aux prochains démarrages.

## Limites

Aucun rendu v27, aucune téléportation publiée ni gain de FPS n'a été mesuré ici. La tête personnalisée masque la tête d'origine mais conserve ses joints; elle ne conserve pas les expressions faciales dynamiques de l'avatar Roblox. Le sourire et la chevelure restent procéduraux, sans mesh importé. Les animations de locomotion du joueur restent celles de Roblox; seules les animations procédurales des PNJ changent de budget selon la qualité.
