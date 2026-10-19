# Kin City — Construction v0.10.0 : quartiers habités et ferries collectifs

## Construction livrée

La v10 est une **continuation directe de la v9**. Toutes les grandes institutions, les intérieurs, les jardins, les commerces, les marinas, les îles, les ferries et les haltes précédents sont conservés. Les fonctionnalités de kOA sont toujours inactives (`WORLD_STUB`) et les postes métier continuent d'afficher « Fonctionnalité à venir ».

### Six îlots résidentiels

Le générateur `src/server/ResidentialQuarters.luau` construit **six quartiers habités**, définis par le registre commun `src/shared/ResidentialDestinations.luau` :

1. Les Terrasses du Nord;
2. Les Maisons des Savoirs;
3. Les Cours des Arts;
4. Le Clos des Promenades;
5. Le Village Coopératif;
6. Le Quartier de la Lumière.

Chaque îlot est relié au cœur de la ville par son **boulevard piéton radial** avec éclairage et un chemin vers la place commune. Chaque îlot comporte **quatre maisons en dur**, donc **24 maisons au total**, et **48 niveaux d'habitation**, plus sa propre place commune. Chaque maison possède une entrée sans collision, un rez-de-chaussée meublé, un escalier de 14 marches et une galerie au deuxième niveau. Elle comporte des fenêtres, un auvent, une toiture végétalisée, des espaces d'étude, des chaises Roblox et une borne de service futur. Les places accueillent une table commune, des plantations, un kiosque, des luminaires et un tableau des futurs services.

Chaque boulevard possède quatre stations lumineuses de chaque côté; ses lampadaires et les lanternes du kiosque appartiennent au même groupe de quartier.

Le bouton de contrôle des lanternes de chaque place **allume et éteint réellement** ses lumières à l'échelle du serveur. Ce n'est pas un service kOA. Les postes futurs demeurent des stubs.

Pour éviter de faire pousser des arbres à travers les nouvelles habitations, `CityGenerator` interroge maintenant `ResidentialQuarters.isReserved` au moment de placer la végétation procédurale.

### Douze nouveaux habitants R15

`src/server/ResidentialResidents.luau` fait apparaître en mode Play jusqu'à **douze personnages Roblox R15** supplémentaires, répartis dans les six quartiers. Ils se promènent autour de leur place commune. Leurs interactions de dialogue sont des stubs. L'échec de création d'un personnage ne bloque pas la construction de la ville.

### Ferries collectifs, six personnes par bateau

`src/server/IslandFerries.luau` a été refait pour transporter **jusqu'à six joueurs sur le même bateau** :

- embarquement via les douze bornes déjà en place (six départs et six retours);
- fenêtre de regroupement de **7 secondes**, départ anticipé lorsque les six places sont occupées;
- un seul bateau animé par groupe, avec six emplacements passagers fixes;
- navigation synchronisée par le serveur et débarquement individualisé;
- plusieurs groupes peuvent être en traversée sur une même ligne;
- restauration de la vitesse et de l'état des personnages à la fin, après déconnexion ou à la destruction du monde;
- interface client indiquant le nombre de passagers, le compte à rebours et la progression de la traversée;
- aucun paiement, aucun service externe, aucun suivi individuel permanent.

**Important :** il s'agit d'un système de transport collectif par placement synchronisé de personnages, et non d'un bateau Roblox à propulsion physique ou à conduite libre. Les sièges visibles servent de repères; la position des avatars est pilotée côté serveur.

J'ai corrigé le registre des lignes : les six itinéraires sont accessibles dès le chargement du module, même lorsque Roblox reprend la scène de l'éditeur sans réexécuter la génération.

### Carte et guide

Les six quartiers et leurs boulevards radiaux sont construits dans la ville et les six quartiers sont ajoutés aux marqueurs de la carte `M` et aux destinations du guide `N`. Les marinas et les destinations antérieures restent présentes. Le panneau de ferry collectif apparaît pendant les voyages et fonctionne avec l'affichage Roblox standard, sans raccourci réservé au clavier.

## Fichiers majeurs créés

| Fichier | Rôle |
| --- | --- |
| `src/shared/ResidentialDestinations.luau` | Six coordonnées et identifiants de quartier |
| `src/server/ResidentialQuarters.luau` | Construction de 24 maisons, des espaces publics et des 48 niveaux |
| `src/server/ResidentialLife.luau` | Interactions locales d'éclairage |
| `src/server/ResidentialResidents.luau` | Jusqu'à 12 PNJ R15 à proximité des places |
| `src/server/IslandFerries.luau` | Transport partagé remplaçant les anciens ferries individuels |
| `src/client/FerryGroupHud.luau` | Information d'embarquement et de trajet |
| `src/server/CityGenerator.luau` | Assemblage des quartiers, réserve de plantation |
| `src/server/WorldBuilder.luau` | Révision de construction v10 |
| `src/server/init.server.luau` | Initialisation des nouveaux systèmes |
| `src/client/MapHud.luau`, `RouteGuide.luau`, `init.client.luau` | Carte, guide, interface ferry |

## Installation immédiate

1. **Dupliquer** son projet Roblox Studio actuel : une réinstallation remplace les dossiers générés par Kin City.
2. Télécharger `KinCity_Installation_Directe_v10.luau` (également dans le ZIP sous `KinCity_Installer_CommandBar.luau`).
3. Ouvrir Roblox Studio > View > Command Bar en mode Édition.
4. Copier-coller le contenu intégral de l'installateur, puis exécuter la commande.
5. Une ville doit être construite dans l'éditeur, sans appuyer sur Play. Pour charger les PNJ et essayer les ferries collectifs, lancer ensuite **Play**.
6. Touche `M` : carte; `N` : guide des lieux; `E` : interactions; l'interface de ferry apparaît automatiquement après embarquement.

Pour éditer le code de façon modulaire, utiliser le `default.project.json` fourni avec Rojo. Le script direct peut être regénéré avec `python tools/make_studio_installer.py`.

## Ce qui n'est pas encore achevé

- **Exécution dans Roblox Studio : non réalisée dans cet environnement.** Les scripts et les trajectoires ne sont pas certifiés par un test dans le moteur. Les avatars, collisions, marches et embarquements devront être essayés dans un projet Roblox publié ou en mode Play approprié.
- Les maisons sont des constructions natives Roblox conçues avec des primitives. Les textures PBR, les meshes complexes et l'habillage artistique de qualité finale restent à fabriquer.
- Les PNJ R15 utilisent un déplacement simple, sans système complet de circulation, mémoire, interactions de groupe ou pathfinding évolué.
- Les ferries ne sont pas pilotables librement : l'animation et le placement sont contrôlés par le serveur pour rendre la traversée de groupe prévisible.
- La carte présente une direction et une estimation de distance, pas de navigation piétonne recalculée dynamiquement pour les nouveaux quartiers.
- La densité d'objets a augmenté. Les budgets PC/mobile et multijoueur restent à mesurer dans le moteur.
- Aucune connexion kOA, identité, vote, crédit EkoH ou écriture dans un service métier n'est incluse, conformément au périmètre demandé.

## Construction recommandée pour la continuation v11

Priorité au contenu : bâtiments de quartier plus spécialisés (hôpitaux communautaires fictifs, ateliers, marchés couverts, centres d'apprentissage), animations de PNJ plus riches, transport terrestre partagé, ressources artistiques importables, scènes intérieures distinctives. Préserver les six quartiers, les 24 maisons et les ferries collectifs tels que définis ici.
