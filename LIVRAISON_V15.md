# Kin City — Construction v15.0 : les pavillons du ciel

**Statut : code produit et intégré. Non exécuté dans Roblox Studio.** Livrable cumulatif couvrant v1 à v15. Aucune connexion à kOA, aucune IA payante, aucun système de points/votes fictif.

## Nouveaux espaces réellement construits dans le code

- **Huit quatrièmes niveaux**, un dans chacune des grandes institutions (`city_hall`, `ekoh_tower`, `library`, `campus`, `justice_palace`, `innovation_lab`, `museum`, `orgo_center`). Chaque nouveau niveau prend la forme d'un **pavillon du ciel** situé au-dessus du toit-jardin préexistant. Il possède une dalle surélevée, des piliers, garde-corps, verrière translucide, signalétique et sièges utilisables.
- **Seize stations à démonstration cinétique** (deux par institution). Chaque installation utilise un modèle 3D procédural thématique, créé avec des pièces Roblox natives : ville miniature, livres en suspension, système orbital, balance mécanique, turbine, sculpture d'art, constellation, réseau de connexions.
- **Seize commandes locales de démonstration**, qui déclenchent des animations côté serveur, avec délai anti-double-activation. Les pièces de la machine pivotent autour d'un axe, sans déplacer l'utilisateur ni le bâtiment.
- **Huit commandes d'éclairage** du pavillon; l'activation change les projecteurs, leur matériau et les lumières `PointLight`.
- **Seize consoles d'ascenseur** pour les trajets toit → pavillon du ciel → toit, au moyen du `PlayerTravel.tryLift` déjà existant. Les déplacements sont des changements d'étage physiques à l'intérieur du même intérieur.
- **Huit consoles réservées aux fonctions futures**, identifiées par `KinStubInteractionId` / `KinStubCapabilityId`, avec la réponse existante « Fonctionnalité à venir ». Elles sont distinctes des mécanismes physiques locaux.
- **Carnet des observatoires** accessible par `P` ou bouton tactile. Il suit les **16 stations distinctes** découvertes pendant la session. Un joueur qui active de nouveau la même station ne gagne pas une nouvelle découverte. Il n'y a ni récompenses ni persistance kOA.

## Parcours pour visiter les quatre niveaux

1. Depuis la ville, franchir la porte d'une institution (`E`).
2. Dans l'atrium, utiliser l'ascenseur vers le niveau des galeries ou emprunter les escaliers.
3. Dans les galeries, prendre l'ascenseur vers le **toit-jardin**.
4. Sur le toit, repérer la console **« Monter au pavillon »**, proche de X=12, Z=82 dans les coordonnées locales.
5. Au quatrième niveau, activer les deux stations (`E`), essayer la lumière et ouvrir le carnet (`P`).
6. Utiliser **« Revenir au toit »** pour redescendre, puis revenir par les ascenseurs/escaliers jusqu'à la porte de sortie.

Le moteur utilise les **mêmes huit Places logiques et les mêmes IDs de portes** que précédemment. Aucun `PlaceId` fictif n'a été créé; mode `LOCAL_UNIVERSE` activé par défaut. Les vrais `PlaceId` seront nécessaires pour `MULTI_PLACE`.

## Fichiers ajoutés

- `src/server/SkyPavilions.luau` : construction complète de la scène de quatrième niveau (architecture et objets spéciaux).
- `src/server/SkyPavilionRuntime.luau` : serveur des mécanismes, éclairages et découvertes.
- `src/client/SkyTourHud.luau` : carnet de visite à la touche `P` et bouton tactile.

## Fichiers modifiés

- `src/server/InteriorGenerator.luau` : génère les pavillons après l'architecture verticale.
- `src/server/WorldBuilder.luau` : version de scène `construction-v15.0.0` (nécessite la reconstruction).
- `src/server/init.server.luau` et `src/client/init.client.luau` : initialisation des deux nouveaux systèmes.
- `tools/make_studio_installer.py` : message de fin et version actualisés.
- `README.md`, `STATUT.md`, `CHANGELOG.md` et `PROCHAIN_TRAVAIL.md` : suivi de construction.

## Installation

Ouvrir une copie du projet Roblox Studio et exécuter **tout le contenu** de `KinCity_Installer_CommandBar.luau` dans la Command Bar **en mode édition**. Le script doit remplacer les sous-dossiers gérés par Kin City et générer immédiatement la scène. Lancer Play ensuite. Le fichier racine séparé `KinCity_Installation_Directe_v15.luau` est une copie exacte de l'installateur.

## Limites explicites

- **Aucune exécution Roblox Studio réalisée dans cet environnement** : visuels, ascenseurs et interactions réelles demeurent non confirmés sur le client.
- Les nouveaux observatoires sont des modèles 3D **procéduraux en Parts natives**, pas des maillages sculptés ni des textures artisanales importées.
- Le monde cumulatif v15 est vaste et la stratégie de streaming/LOD et les appareils mobiles restent des chantiers ouverts.
- Les sons originaux livrés en v4 nécessitent encore leurs identifiants d'assets Roblox.
- L'intégration kOA reste volontairement hors périmètre de cette livraison.
