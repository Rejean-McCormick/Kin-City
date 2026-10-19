# Kin City — Livraison de construction v0.6.0

## Produit livré

Une extension **réelle du code de la ville autonome Roblox**, basée sur les sources v0.5.0. Aucun service externe, aucun compte kOA, aucun appel payant à une IA. Les huit grandes institutions, leurs portes, les ascenseurs, le guide et les stubs restent conservés.

## Cinq nouveaux modules Luau

| Source | Construction ajoutée | Interaction |
| --- | --- | --- |
| `src/server/WaterfrontDistrict.luau` | **12 quais publics** sur le lac, pontons piétons, pavillons, bancs, balises et structures de soutien | Borne de découverte stub sur chaque quai |
| `src/server/ArtisanStreets.luau` | **Ruelles artisanales** : bâtiments 24 × 24 studs, façades avec vitrines, comptoirs, rayons, sièges physiques, auvents, 6 familles d'activités. Jusqu'à 48 emplacements; ceux proches des chemins/bâtiments/parvis sont omis | Comptoir « Fonctionnalité à venir » |
| `src/server/InteractiveGardens.luau` | Jardins d'expérimentation avec sculptures, cristaux, lumières et mobiles cinétiques. Jusqu'à 20 emplacements; sélection géométrique évitant les grands axes | **Activation et désactivation locale réelle** |
| `src/server/LocalMechanisms.luau` | Service serveur qui commande les lumières et rotors des jardins ; interpolation des transitions | Interaction proche, contrôlée par le serveur, avec retour visuel et dialogue |
| `src/server/SpecializedRooms.luau` | **16 espaces spécialisés** dans les huit institutions : postes d'apprentissage, mini-collections, sièges et bornes | Sièges utilisables, futurs services stub |

**Nota :** les nombres de boutiques et de jardins effectivement construits dépendent des exclusions géométriques. Les douze quais et seize espaces spécialisés sont créés sans condition. Des boutiques, kiosques et panneaux sont des géométries Roblox natives, pas des assets externes.

## Raccordement

- `CityGenerator` invoque les nouveaux générateurs urbains après les systèmes v5.
- `InteriorGenerator` ajoute `SpecializedRooms` aux salles existantes.
- `init.server.luau` démarre `LocalMechanisms` en plus du routeur de stubs.
- `WorldBuilder` porte désormais la révision `construction-v6.0.0`, empêchant la réutilisation d'une ancienne scène v5 inchangée.
- La carte `M` comprend les douze directions du front de lac.

## Installation

1. Sauvegarder une copie du projet Roblox Studio.
2. Créer ou ouvrir un projet **Baseplate**.
3. Ouvrir `KinCity_Installer_CommandBar.luau` à la racine du dépôt et **coller tout le fichier dans la Command Bar en mode Édition**.
4. Exécuter la commande. Attendre que `Workspace/KinCityGenerated` soit présent.
5. Utiliser Play, puis `WASD`, `E`, `M`, `N`, `J`. Utiliser `E` devant un jardin cinétique pour allumer et éteindre son mécanisme.

L'installateur remplace les seuls conteneurs Kin City (`KinCityGenerated`, `KinCityShared`, `KinCityRuntime`, `KinCityUI`) : les éditions manuelles à l'intérieur ne sont pas conservées.

La version Rojo est conservée via `default.project.json`. Les modules doivent être synchronisés ou l'installateur régénéré après une modification.

## État de contrôle

Les tests Python du dépôt passent (génération déterministe, schémas, liens de manifestes, installateur autonome). **Aucune exécution effective dans Roblox Studio n'a pu être effectuée depuis cet environnement** : rendu visuel, collisions, fluidité et comportement des mécanismes demeurent à confirmer avec le client Roblox.

## Travaux restant pour la version totale

- Maillages, textures et animations à qualité artistique finale.
- Univers beaucoup plus étendu, mais partitionné suivant le budget de mémoire réel des appareils.
- Gestion des transports jouables à haute densité et amélioration des PNJ R15.
- Ajustement en Studio des conflits géométriques non déductibles des catalogues et affinage des lieux intérieurs.
- Importation des fichiers audio avec des asset IDs Roblox autorisés.
- Publication finale et expérience de navigation à grande échelle.
- Connexions kOA ultérieures : **pas dans cette livraison**.
