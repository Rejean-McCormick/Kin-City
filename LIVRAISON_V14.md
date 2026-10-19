# Kin City — Construction v14.0

**Statut réel : code produit et intégré; exécution Roblox Studio non effectuée.**

## Nouveautés fabriquées

1. **Galeries de la gare** : huit boutiques-ateliers indépendantes en dur, positionnées à l'est et à l'ouest de la gare. Portes ouvertes, devantures, vitrines latérales, rayonnages détaillés, tables, sièges Roblox, plantes, enseignes, éclairage et collections originales. Chaque atelier dispose d'une exposition physique que les joueurs peuvent faire tourner avec `E`. Registre canonique partagé `UrbanV14Destinations.arcades`.
2. **Six ateliers publics de manipulation** : structures couvertes avec trois pupitres distincts, machine cinétique centrale, voyants, mobilier et panneaux. Les interactions `E` suivent les étapes **Assembler → Calibrer → Animer**. Plusieurs joueurs peuvent contribuer au même atelier; aucune présence multijoueur n'est obligatoire. État serveur collectif, délai de 48 secondes entre étapes, animation de 6 secondes puis réinitialisation. Registre `UrbanV14Destinations.workshops`.
3. **Interface des ateliers** : nouveau panneau `K` avec bouton tactile, état des trois étapes et messages de progression reçus du serveur.
4. **Vie résidentielle** : modification des douze résidents R15 existants pour afficher une activité quotidienne locale (« Lecture », « Jardin partagé », « Rencontre », etc.) et marquer des pauses, selon l'heure virtuelle. Aucun téléchargement ou avatar externe supplémentaire requis par cette fonctionnalité.
5. **Orientation** : nouvelles destinations sur la carte `M` et dans le guide `N`. Les jardins aléatoires respectent les emprises des huit boutiques et six ateliers. Les identifiants sont permanents.

## Fichiers créés

- `src/shared/UrbanV14Destinations.luau` : registre spatial des nouveaux lieux.
- `src/server/StationArcades.luau` : construction des galeries et des ateliers marchands.
- `src/server/PublicWorkshops.luau` : six machines et consoles pédagogiques.
- `src/server/UrbanV14Runtime.luau` : interactions et animations autorisées côté serveur.
- `src/client/WorkshopHud.luau` : interface clavier/tactile.
- `tools/extend_v14.py` et `tools/enhance_residents_v14.py` : opérations d'intégration conservées comme trace de construction (à usage de développement, sans nécessité d'exécution dans Studio).

## Fichiers existants modifiés

`CityGenerator.luau`, `WorldBuilder.luau`, `init.server.luau`, `ResidentialResidents.luau`, `MapHud.luau`, `RouteGuide.luau`, `init.client.luau`, `make_studio_installer.py` et documentation principale.

## Installation

Le ZIP contient tout le projet cumulatif, sans avoir besoin de récupérer séparément les v1–v13. Pour construire immédiatement dans un projet Roblox Studio :

1. Sauvegarder et dupliquer le projet courant ou créer **Baseplate**.
2. Ouvrir `KinCity_Installation_Directe_v14.luau` (ou `KinCity_Installer_CommandBar.luau` dans le dépôt).
3. Copier le texte entier dans la **Command Bar en mode Édition** et l'exécuter. La scène doit apparaître directement dans `Workspace/KinCityGenerated`.
4. Lancer **Play**. Rejoindre la gare centrale (autour de X=0, Z=114) et ses galeries aux coordonnées X=±64, Z=85–148, ou les nouvelles machines à côté des six agoras périphériques.
5. `E` = interaction; `K` = ateliers; `M` = carte; `N` = destinations; `G` = correspondances; `J` = exploration.

Pour un développement itératif avec Rojo, utiliser `default.project.json` et les sources du dossier `src/`. Pour réassembler l'installateur après modification : `python tools/make_studio_installer.py`.

## Conventions maintenues

- **Mode WORLD_STUB** : aucun compte kOA, aucune IA payante, aucun appel HTTP, aucun vote, point EkoH ou achat inventé.
- Les terminaux métier disposent d'IDs et répondent **« Fonctionnalité à venir »**. Les mécanismes purement physiques sont utilisables localement.
- La ville existante, les institutions, les portes, les quais, marinas, ferries, quartiers, transports et agoras sont préservés dans le dépôt cumulatif.
- La scène générée est recalculée en édition lors de l'installation de v14; ne pas laisser de décor créé à la main à l'intérieur de `KinCityGenerated`.

## Ce qui reste

La **v14 n'est pas la version artistique finale**, et aucun test dans Roblox Studio n'a été effectué dans cet environnement. Il reste à corriger, au besoin, les collisions et les navigations en jeu, à remplacer/compléter les assets primitifs par des modèles 3D élaborés, à enrichir la simulation urbaine des PNJ et à ajuster les performances sur mobile et en multijoueur. Les `PlaceId` pour de véritables intérieurs publiés sont encore absents; le mode local fonctionnel est conservé comme configuration de base. Les sons importés nécessitent leurs identifiants Roblox.

## Vérifications hors moteur

13 tests Python existants réussis. Script d'installation autonome produit par `tools/make_studio_installer.py`. Ces contrôles n'impliquent **aucune preuve d'exécution de Roblox Studio**.
