# Kin City — Construction v12.0 : gare centrale et places vivantes

## Constructions réelles ajoutées au dépôt

- **Gare centrale des Connexions** sur l'axe central, à `X=0, Z=114` : dalle, grande nef traversante de 84 × 70 studs, passages nord et sud ouverts sur 15 studs, verrière, colonnes, deux galeries latérales à l'étage, escaliers à 14 marches, pont surélevé, mobilier, comptoirs, présentoirs, luminaires et signalétique.
- **Six guichets** (`kin.intermodal.gate.01` à `.06`) dans la gare; chacun dessert le point d'embarquement d'un des six minibus déjà générés en v11. Ils sont des **transferts locaux instantanés**, pas des transports en cabine.
- **Douze bornes de retour** (`kin.intermodal.return.XX.start/finish`) implantées à proximité des deux terminus de chaque ligne. Téléportation locale vers l'accès sud de la gare; aucune connexion réseau.
- **Six agoras culturelles publiques**, autour du rayon de 425 studs : mini-scène, gradins, bancs, végétation, jeu de lumières et mobile cinétique. Toutes visitables librement.
- **Douze commandes physiques de places**, deux par agora (allumage et sculpture), gérées côté serveur avec contrôle de proximité et limiter de requêtes. Les futures bornes institutionnelles restent en stub.
- **Interface des correspondances**, accessible par `G` ou bouton tactile et présentant les six lignes; ajout de la gare et des six agoras à `M` et `N`.

## Nouveaux fichiers sources

- `src/shared/IntermodalNetwork.luau` — coordonnées communes au bâtiment, serveurs et clients
- `src/shared/CivicDestinations.luau` — noms et positions des six places
- `src/server/IntermodalHub.luau` — construction de la gare et des bornes
- `src/server/IntermodalTransfers.luau` — déplacements serveur des correspondances
- `src/server/CivicStages.luau` — construction des places et des installations
- `src/server/CivicStageRuntime.luau` — actions locales sur éclairage et sculpture
- `src/client/IntermodalPanel.luau` — panneaux des correspondances / bouton tactile

Fichiers intégrateurs modifiés : `CityGenerator`, `WorldBuilder`, `init.server`, `init.client`, `MapHud`, `RouteGuide`, `make_studio_installer.py`.

## Installation

1. Ouvrir une copie de Roblox Studio Baseplate, mode Édition.
2. Ouvrir `KinCity_Installer_CommandBar.luau`, tout copier, coller dans **Command Bar** et exécuter.
3. La scène `Workspace/KinCityGenerated` doit être créée en mode Édition; ensuite appuyer sur Play.
4. Depuis la place centrale, longer le chemin vers le palais de justice pour visiter la gare. Activer les guichets avec **E**. `G` ouvre le tableau des lignes; `M` ouvre la carte et `N` le guide.
5. Pour travailler dans Rojo, utiliser `default.project.json` et les modules sous `src/`.

## Limites et travail non fait

Les modèles sont construits avec les primitives natives Roblox. La gare et les nouvelles places ne disposent pas de maillages importés de qualité artistique finale. Aucun vrai billet, horaire de transport public, compte, vote, paiement ou fonction kOA n'a été simulé.

Le code Luau n'a pas été exécuté dans Roblox Studio par cet environnement. La qualité du rendu, les ouvertures de circulation, les collisions des escaliers et les transitions de correspondance doivent être essayées dans Studio. Les tests hors moteur ne remplacent pas cet essai.

**Livrable** : sources cumulatives v1–v12, générateurs, configuration, tests et installateur autonome réassemblé.
