# Kin City — Construction v16.0 : ailes des découvertes et façades emblématiques

## Travail effectivement codé

Cette version continue **la v15**, sans supprimer les quartiers, transports, habitats, galeries, observatoires, archipel, ferries, marinas ni autres mécanismes hérités.

### Huit ailes intérieures nouvelles

Un nouveau volume accessible physiquement est rattaché à l'atrium arrière de chaque institution :

- Hôtel de ville → Galerie de la Cité
- Tour EkoH → Atelier des Savoirs
- Bibliothèque → Grande Aile des Archives
- Campus → Galerie des Sciences
- Palais de justice → Espace des Équilibres
- Laboratoire d'innovation → Fabrique des Idées
- Musée Kreative → Galerie des Formes
- Centre Orgo → Atelier des Réseaux

Les ailes sont construites dans le repère local de l'intérieur. Chaque aile comporte un **passage traversable** depuis l'atrium original, une salle d'environ 92 × 83 studs, des murs vitrés, une verrière, **deux mezzanines**, deux escaliers de 26 marches, une passerelle reliant les niveaux, bancs utilisables, éclairages et terminal de capacité future.

Le générateur retire effectivement le mur arrière de l'atrium initial et le reconstruit avec une ouverture centrale. Ce n'est pas un couloir simplement dessiné sur une cloison solide.

### Seize nouvelles œuvres animables et huit commandes d'ambiance

Chaque aile possède deux sculptures thématiques pilotables avec `E`. Les huit institutions ont chacune un système d'éclairage de galerie. L'animation est **serveur**, déclenchée via `ProximityPromptService`, avec vérification de proximité et de la zone du joueur. Le progrès de visite est **en mémoire de session seulement** et ne crée ni score, ni vote, ni crédit EkoH.

Les huit terminaux métier ajoutés dans les ailes conservent un identifiant stable et le message **« Fonctionnalité à venir »**. Aucun service kOA n'est activé.

### Huit façades différenciées

Nouvelle couche de relief procédural sur les huit bâtiments principaux : trames de vitraux, colonnes monumentales, frises, rubans de pierre et motifs sculpturaux adaptés à l'institution (livres, système planétaire, équilibre, turbine, réseau, couleurs ou miniatures urbaines). Les ornements sont non-collidables afin de ne pas empêcher l'accès aux portes.

## Sources ajoutées

- `src/server/InstitutionDiscoveryWings.luau` — géométrie des huit nouvelles ailes, ouvertures, escaliers, mezzanines, expos et mobilier
- `src/server/InstitutionDiscoveryRuntime.luau` — contrôle des machines et lumières, actions locales
- `src/server/HeritageFacadesV16.luau` — signatures architecturales extérieures

## Sources modifiées

- `src/server/InteriorGenerator.luau` — invoque le constructeur d'aile
- `src/server/FacadeGenerator.luau` — applique le nouveau langage de façade
- `src/server/init.server.luau` — active le nouveau runtime serveur
- `src/server/WorldBuilder.luau` — révision `construction-v16.0.0`, force la reconstruction de la scène précédente
- `tools/make_studio_installer.py` — message de version et installateur autonome reconstruit

## Pour visiter la v16

1. Ouvrir une **copie** du projet dans Roblox Studio (mode **Édition**).
2. Copier tout `KinCity_Installer_CommandBar.luau` dans la Command Bar; l'exécuter, puis lancer **Play**.
3. Entrer dans l'une des huit institutions par sa porte; rejoindre le grand atrium situé derrière les premières salles.
4. Traverser l'ancienne paroi du fond, désormais ouverte, pour découvrir la grande galerie et ses mezzanines.
5. Utiliser `E` sur les deux commandes d'œuvre et sur la console de lumières. Les bornes réservées répondent « Fonctionnalité à venir ».

Il n'est **pas** nécessaire d'installer les v1–v15 : le dépôt et l'installateur sont cumulatifs. Le script remplace les objets situés dans les dossiers Kin City générés : ne pas y conserver de créations manuelles.

## État exact

- Génération du code Luau et de l'installateur : **faite**.
- Validation statique existante : **13 tests hors Roblox réussis**.
- Exécution dans Roblox Studio : **non effectuée ici**. La construction est conçue pour être jouable, mais son rendu et ses collisions ne sont pas certifiés en moteur.
- Publication de vrais `PlaceId` et navigation `MULTI_PLACE` : **non faites**.
- Finition 3D professionnelle, textures et performances mobiles : **toujours incomplètes**.

## Prochain gros travail de construction

Routines et animations R15 des habitants, mobilier architectural plus naturel, remplacement progressif des primitives par des modèles 3D soigneusement créés et archivés, chargement par zones pour rendre la ville volumineuse plus légère, finitions sonores une fois les trois fichiers audio importés dans Roblox. La version connectée à kOA reste **délibérément en dehors** de la livraison autonome actuelle.
