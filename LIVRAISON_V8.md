# Kin City — Construction v0.8.0 : l’archipel habité

## Périmètre réellement codé

La version v8 continue **sans repartir de zéro** du dépôt v7 et conserve l'ensemble des huit grandes institutions, leurs intérieurs et les lieux des versions précédentes.

### Six nouvelles îles publiques

Un nouveau groupe `Workspace/KinCityGenerated/Ville/Archipel des six îles` est généré dans le *Place* de la ville. Le lac environnant est agrandi de **1 220 à 1 800 studs de diamètre** pour accueillir les îles au rayon 700 studs. Les six îles reposent sur des plateformes terrestres, avec arbres, trois pavillons ouverts par île, sièges Roblox utilisables, éclairages, signalétique et installations spécialisées :

| Île | Installation interactive locale |
|---|---|
| Île des Jardins suspendus | Jardin lumineux avec 24 fleurs |
| Île des Arts vivants | Sculpture d’art lumineuse |
| Île des Énergies | Roue à aubes d'énergie mécanique |
| Île de l’Observatoire | Orbe solaire et planètes |
| Île des Histoires | Volumes monumentaux |
| Île des Rencontres | Anneau de rencontre lumineux |

Les expériences physiques changent de luminosité ou de disposition via des prompts `E`, autorisés côté serveur. Les kiosques « service futur » **ne simulent jamais une connexion métier** : ils passent par le routeur stub et répondent « Fonctionnalité à venir ».

### Six longues passerelles piétonnes

Chaque île est reliée à l'île principale par **224 studs de promenade surélevée** avec rampes de montée et descente, garde-corps, éclairage et segments physiques. Il est possible de rejoindre les îles à pied, sans téléportation. L'axe suit les quais publics impairs de la version v6 (angles de 7,5°, 67,5°, 127,5°, etc.).

### Six traversées jouables en ferry

`IslandFerries.luau` construit **12 embarcadères** avec leurs bornes : un côté ville, un côté île pour chacune des six traversées. En mode Play, `E` à la borne crée un bateau, embarque le joueur et réalise un déplacement physique serveur sur le lac, avec arrivée et débarquement automatique. Le joueur peut retourner sur le continent. La cabine et le joueur sont déplacés ensemble ; un système de nettoyage gère les morts et déconnexions.

Les traversées suivent le bord des passerelles, décalées latéralement pour éviter les collisions visuelles avec leurs piliers.

### Cartographie, carnet et itinéraires

- La carte `M` a désormais **deux échelles** : « Ville » et « Archipel » ; les six îles sont visibles.
- Le guide `N` répertorie les six nouveaux lieux et conseille les passerelles ou le ferry.
- Le HUD de voyage utilisé par les tramways présente également le trajet des ferries.
- Le nouveau carnet affiche **0–6 îles découvertes**. L'activation d'une installation attribue une découverte à la session du visiteur. Aucune donnée kOA n'est lue ou modifiée ; rien n'est persisté entre sessions.

## Nouveaux modules

- `src/shared/IslandDestinations.luau` — géographie canonique commune aux systèmes.
- `src/server/OuterIslands.luau` — générateur de la terre, des pavillons, des ponts et des installations.
- `src/server/IslandFerries.luau` — navettes maritimes jouables et embarcadères.
- `src/server/IslandExperiences.luau` — événements d'activation d'objets et carnet par joueur.
- `src/client/IslandPassportHud.luau` — progression locale de l'archipel.

Modules précédents enrichis : `CityGenerator`, `WorldBuilder`, `init.server`, `init.client`, `MapHud`, `RouteGuide`, `TramRideHud`. Nouvelle révision de fabrication : `construction-v8.0.0`.

## Installer en mode Édition

1. Ouvrir Roblox Studio, faire une copie de son projet ou ouvrir une nouvelle `Baseplate`.
2. Ouvrir `KinCity_Installer_CommandBar.luau` et copier **tout** son contenu dans la Command Bar de Studio en mode **Édition**.
3. Exécuter une fois. L'installateur doit générer la ville, le lac agrandi et les six îles dans Workspace.
4. Lancer Play. Rejoindre un des six quais impairs et activer une borne `Ferry` ; visiter l'île et activer son installation pour remplir le carnet. Utiliser `M` et `N` pour trouver les lieux.

**Attention :** l'installation directe remplace les conteneurs générés (`KinCityGenerated`, `KinCityShared`, etc.). Sauvegarder une copie avant de réinstaller.

## Ce qui reste ouvert

Ce dépôt ne comporte **aucune session Roblox Studio réellement exécutée** depuis cet environnement. Le code, les modèles et les traversées sont implémentés, mais les collisions, rampes, proportions, transport de personnages et performances n'ont pas été confirmés dans le moteur. Les assets 3D sculptés, les textures spécifiques finales, l'audio importé et les animations avancées nécessitent encore du travail. Les futures connexions kOA restent désactivées selon la décision initiale.
