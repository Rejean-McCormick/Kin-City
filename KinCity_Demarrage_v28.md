# Essayer la v28

## 1. King Klown dans votre ville actuelle

Arrêter Play. Ouvrir `KingKlown_v7.luau`, tout copier, coller dans la barre Commande et exécuter. Relancer Play.

Observer de face et de profil. Marcher, sauter et s'asseoir pour voir la cape. À l'arrêt, au sol et sans outil équipé, appuyer sur **G** (manette : clic du stick droit R3; tactile : bouton Magie). Une étincelle apparaît près de la main et les éclats de l'orbe se rapprochent. Recharge de 6 secondes. La marche, le saut, le siège ou un outil interrompent la pose.

Le costume reste réservé au créateur en expérience personnelle publiée. Pour une expérience de groupe, renseigner votre vrai UserId dans OWNER_USER_ID en tête du petit installateur, ou dans `config/king_klown.json` avant génération. Studio applique le costume aux joueurs de test par défaut. L'ancien OwnerUserId explicite est conservé si le nouveau reste à zéro.

## 2. Tester la bibliothèque seule

Dans une autre Place Studio, exécuter `KinCity_Installation_Place_library_v28.luau`, puis Play. Le guide se présente automatiquement.

1. Rejoindre le banc du hall et ouvrir le livre d'accueil.
2. Lire le fragment **Observer** au présentoir de la galerie.
3. Lire **Relier** au banc de la galerie.
4. Lire **Imaginer** à la table de lecture.
5. Revenir au livre d'accueil pour conclure le récit.
6. Suivre la direction de sortie.

Les trois fragments peuvent être découverts dans n'importe quel ordre. Le récit est individuel : un second joueur ne complète pas votre parcours. Une réapparition dans le même serveur conserve les fragments. Le compteur est un suivi de lecture local, sans récompense ni service kOA. Les textes sont défilables et se ferment avec le bouton, Échap ou B à la manette.

## 3. Essayer le parcours entier

L'installateur direct construit la **ville seule**. Son bouton PARCOURS BIBLIOTHÈQUE suit le chemin canonique vers la façade. Sans publication, la porte ne peut pas rejoindre la Place de la bibliothèque.

Pour tester l'aller-retour immédiatement, utiliser `KinCity_Installation_Univers_Local_v28.luau` dans une copie de test. Il contient la ville et tous les grands intérieurs dans une même Place, éloignés les uns des autres. Ce secours n'est pas l'architecture de publication recommandée.

Pour les Places séparées : créer les neuf Places dans la même expérience, configurer leurs véritables IDs, sélectionner MULTI_PLACE et régénérer avec `python tools/build_release.py`. Installer et publier chaque script dans la Place correspondante. Tester ensuite dans le client Roblox publié.

## 4. Import facultatif des cheveux

Importer `assets/kingklown-v7/kingklown-hair-v7.obj` sans rotation ni miroir. Sélectionner le MeshPart et exécuter `KingKlown_Enregistrer_Cheveux_v7.luau`. Le prochain personnage utilise le modèle enregistré. Répéter cet import dans les Places qui doivent l'utiliser. Sans import, les mèches natives restent disponibles.

## 5. Mesurer et vérifier

Le diagnostic `KinCity_Diagnostic_Performance_v28.luau` reste disponible : installer en Édition, lancer Play et marcher environ 25 secondes. Lire les mesures côté client dans Sortie. Comparer des trajets, appareils et qualités identiques.

Vérifier en priorité : chevelure et sourire de profil; cape sur un siège; absence de blocage des animations de marche; geste visible sur un second client; lecture sur mobile; franchissement des portails entre les salles; retour extérieur. Les repères au sol n'évitent pas dynamiquement les obstacles. Aucune amélioration FPS chiffrée n'est revendiquée.
