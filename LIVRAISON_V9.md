# Kin City — Construction v0.9.0 : marinas, maisons insulaires et sentiers

## Périmètre de cette livraison

Cette version **continue les mêmes catalogues et scripts** de la v0.8.0. Elle ne remplace pas les institutions, le tramway, les ferries, les ponts et les environnements déjà construits. Elle ne connecte aucun service kOA et ne fait aucun appel HTTP / IA.

### Construction nouvelle

| Zone | Nouveaux objets construits par les générateurs | Comment visiter |
| --- | --- | --- |
| **Marina des Découvertes**, **Port des Artisans** | 2 grands quais sur pilotis, 4 ateliers couverts avec mobilier et passages réels, 2 phares, 2 grues et des promenades | À pied depuis le littoral, ou par le guide `N` |
| **6 îles de l'archipel** | 6 nouvelles maisons avec **12 salles** aménagées (2 par île), terrasses de toit, escaliers extérieurs à 16 marches, collections thématiques | Depuis les ponts ou ferries v8; traverser la nouvelle passerelle latérale de chaque maison |
| **6 boucles paysagères** | 6 circuits de marche, 24 haltes avec bornes et 6 nouveaux points d'observation | Sur le sentier de ronde de chaque île |

### Activités réellement locales

- Les phares sont allumables et éteignables avec `E` ; le faisceau lumineux tourne par mises à jour côté serveur.
- Les grues pivotent grâce à un mouvement physique visuel (TweenService, pièces ancrées).
- Les deux marinas ont une borne qui ajoute une découverte au carnet pour la session.
- Dans chaque maison insulaire, les deux salles possèdent une console qui fait varier l'apparence de collections d'objets 3D.
- Les 24 haltes de randonnée déclenchent un progrès individuel, sans monnaie, compte externe, classement ni stockage permanent.
- Un panneau « CARNET DES VOYAGES » affiche les marinas, les salles et les haltes découvertes. Il fonctionne également sur écran tactile.
- Les bureaux et terminaux de services kOA restent explicitement des **stubs** qui affichent « Fonctionnalité à venir ».

### Implantation et préservation des créations existantes

- Les deux marinas sont placées à **22,5°** et **202,5°**, entre les axes des quais et îles précédents, sur la côte autour du rayon 480 studs.
- Chaque maison insulaire est installée sur un **plateau annexe sur pilotis**, accessible par une passerelle, afin de ne pas recouvrir les anciens kiosques ouverts.
- Les boucles de randonnée prennent une position autour du rayon 37 studs à l'intérieur du relief insulaire.
- Les nouvelles destinations des marinas sont présentes dans les données géographiques partagées, la carte `M` et le guide `N`.

### Nouveau code

- `src/shared/MarinaDestinations.luau` — localisations communes des deux ports.
- `src/server/MarinaDistrict.luau` — architecture complète des marinas.
- `src/server/IslandAnnexes.luau` — architecture et décors uniques des six maisons insulaires.
- `src/server/IslandFootpaths.luau` — boucles et 24 haltes de randonnée.
- `src/server/HarborAndTrailsRuntime.luau` — action des phares, grues et collections et carnet local, côté serveur.
- `src/client/ArchipelagoProgressHud.luau` — interface discrète, souris/tactile.
- Mise à jour de `CityGenerator`, `WorldBuilder`, `init.server`, `init.client`, `MapHud`, `RouteGuide` et de l'installateur autonome.

### Installation

1. **Faire une copie** du projet avant d'installer.
2. Ouvrir `KinCity_Installation_Directe_v9.luau` ou le fichier `KinCity_Installer_CommandBar.luau` de ce dépôt.
3. Copier le script entier dans **View > Command Bar** de Roblox Studio **en mode Édition**.
4. Exécuter pour mettre à jour les objets générés de Kin City et installer les scripts.
5. Lancer `Play` ; `M` = carte, `N` = guide, `E` = interactions, **CARNET DES VOYAGES** = progression locale.
6. Visiter l'une des deux marinas, puis l'archipel.

La réinstallation **détruit et remplace** les objets gérés par Kin City (`KinCityGenerated`, `KinCityShared`, `KinCityRuntime` et `KinCityUI`). Éviter de conserver des créations personnelles dans ces conteneurs.

### État et limites

- Le générateur de source et l'installateur autonome sont livrés, sans API payante ni connexion kOA.
- Les tests Python hors moteur passent, mais **Roblox Studio n'a pas été exécuté ici** ; les escaliers, les collisions et le rendu des grandes scènes doivent être vérifiés sur place.
- Les intérieurs sont créés avec des primitives natives Roblox, pas des mesh/assets artistiques de qualité AAA ; les matériaux/éclairages pourront être raffinés.
- L'archipel existant comporte déjà plusieurs éléments autour du sol de l'île; de petites retouches de passages et de végétation peuvent être nécessaires après inspection dans Studio.
- La progresssion des promenades est volontairement locale à la session. Aucun compte ou récompense kOA n'est inventé.

### Construction encore à effectuer

1. Marina avec plusieurs passagers, véhicules maritimes libres et pontons d'amarrage réellement interactifs.
2. Un ensemble de textures/mesh/animations 3D professionnelles et une bibliothèque d'assets autorisés.
3. Extension de la variété de quartiers urbains, bâtiments intérieurs davantage scénarisés et interactions locales supplémentaires.
4. PNJ R15 plus avancés, comportement en groupe, flux de déplacement et ambiance sonore importée.
5. Réglages PC, téléphone, tablette et multijoueur dans Roblox Studio/client publié.
6. Publication des *Places* si la stratégie `MULTI_PLACE` est activée ultérieurement.
7. Connexions kOA : **hors périmètre** tant que la ville autonome n'est pas achevée.
