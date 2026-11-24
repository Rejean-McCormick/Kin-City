# KC36 — Répartition architecturale des PNJ (B10 / B09)

## Symptôme confirmé

KC35 / première migration KC36 : `CityGenerator.make` n'appelle plus `Citizens.make`, et `Citizens.start` ne crée pas le dossier manquant. Seulement 14 R15 sont démarrés ; leur `NeighborhoodNPCNavigation` cible les anciens îlots `ResidentialDestinations` (rayon 352) que l'urbanisme v31 ne construit plus. Les PNJ qui existent se retrouvent concentrés vers ces anciennes coordonnées.

## Décision KC36

- **24 citoyens stylisés** (quatre par secteur) et **18 R15 ciblés** (trois par secteur) ; **42 emplacements**, 7 dans chacun des six secteurs.
- Le planificateur `src/server/CityPopulationV36.luau` utilise les six directions de `HexagonalDistricts` et les emprises réelles des huit bâtiments dans `WorldPlan.structures`.
- Avenues natives, rayons 88 à 417, décalage latéral intérieur de 4 à 6,5 studs. Chaque emplacement et son trajet de ±12 studs sont vérifiés contre les emprises des bâtiments + marge de 8 studs. La distance entre points d'apparition est au minimum de 17 studs.
- Les PNJ procéduraux sont générés par `Citizens.make`, que `CityGenerator` invoque pour les futures reconstructions. `Citizens.start` reconstitue également la population pour les mondes KC35 déjà générés (réhydratation), donc pas de reconstruction intégrale requise.
- Les R15 sont créés côté serveur par l'API Roblox ; **le nombre réellement chargé peut être inférieur à 18 si le service échoue**. Les déplacements utilisent `PathfindingService`, interdiction de traverser une façade en mode secours ; pause hors proximité joueur.
- Les 12 `ResidentialResidents` hérités ne sont pas activés : ils dépendent des îlots résidentiels désactivés. Pas de surpopulation arbitraire.
- Aucun impact sur les portes B01–B08, B09, les neuf Place recipes, B07 ou `ServerStorage.KinCityArtDecoLibrary`.

## Mise à jour du dépôt et déploiement Studio

Décompresser `KinCityV36_KC36_POPULATION_UPDATE.zip` dans `C:\mycode\Kin_City\KinCityV36` (en remplaçant seulement les quatre sources et en ajoutant documentation, outil et tests). Les sources du dépôt ne modifient **pas automatiquement** le fichier `.rbxl`.

Dans RS `KinCity_36_DEV.rbxl` : Play arrêté, sauvegarde `AVANT_POPULATION`, puis coller `tools/studio/KC36_INSTALL_POPULATION_RS.luau` dans la Command Bar. Le script vérifie 42 emplacements, sauvegarde les sources précédentes dans `ServerStorage.KC36PopulationSourceBackup_v1`, installe quatre modules et ne touche pas à la scène existante. `Ctrl+S`, puis Play : le serveur génère les 24 citoyens stylisés et demande jusqu'à 18 R15. Vérifier les logs `KC36 POPULATION`, l'absence de messages rouges, ainsi que l'apparition dans les six avenues.

## Qualification

`tests/test_kc36_population_geometry.py` : 5 tests source/géométrie (décomptes, densité équilibrée, séparation, réservations, raccordement à la génération). Ce sont des tests hors Studio, pas des preuves de déplacement ou de FPS Roblox. Vérifications Studio complémentaires requises : collisions avec mobilier réel, pathfinding, visibilité sous StreamingEnabled, position verticale, performance mobile et interactions de dialogue.
