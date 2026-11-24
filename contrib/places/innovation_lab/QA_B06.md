# B06 — Matrice de validation des six salles et des accès

Chaque case est initialement **NON TESTÉE DANS ROBLOX** et doit être remplie avec preuve à l'appui par l'équipe B06/B09.

| Contrôle | Test spécifique attendu | Statut initial |
|---|---|---|
| Accueil | Spawn `innovation_lab.lobby.spawn` dégagé, exit à z=-45 accessible | NON TESTÉ |
| Fabrication | Interaction `hall.desk_01` consultable, état « à venir » honnête | NON TESTÉ |
| Démonstration | Cartouche haut lisible; aucun panneau n'occulte les démonstrations | NON TESTÉ |
| Prototypage | Passage `gallery_to_west` de 8 studs non obstrué | NON TESTÉ |
| Galerie des inventions | Passage `chamber_to_east` de 8 studs non obstrué | NON TESTÉ |
| Hall de l'innovation | `gallery_to_rear` et `chamber_to_rear` praticables | NON TESTÉ |
| Accès hall → fabrication | `innovation_lab.portal.lobby.gallery` de 10 studs dégagé | NON TESTÉ |
| Accès hall → démonstration | `innovation_lab.portal.lobby.chamber` de 10 studs dégagé | NON TESTÉ |
| Porte d'entrée | Transition de la ville vers le bon `place_key` | NON TESTÉ |
| Porte de sortie | Retour exact `city.keenkonnect.innovation_lab.return_spawn` | NON TESTÉ |
| Profil LITE | 24 pièces overlay max, jeu fluide sur mobile modeste | 24 pièces calculées; FPS NON MESURÉS |
| Profil STANDARD | 33 pièces max, signalétique lisible | 33 pièces calculées; FPS NON MESURÉS |
| Profil SHOWCASE | 60 pièces max, pas d'occlusion du plafond | 60 pièces calculées; FPS NON MESURÉS |
| Accessibilité | Lisibilité des contrastes, navigation clavier/manette, avatars petits/grands | NON TESTÉ |
| Absence de modèles importés | Habillage natif montable même sans AssetLibrary (une fois l'adaptateur créé) | NON TESTÉ |
| Tests multijoueur | Plusieurs avatars, respawn, chargement de Place séparée | NON TESTÉ |

Le rapport de test doit contenir : build hash, PlaceId **de staging**, appareils, captures jour/nuit, journaux, temps de transition, FPS p50/p5 et coûts mémoire. Aucune approbation de publication n'est implicite.
