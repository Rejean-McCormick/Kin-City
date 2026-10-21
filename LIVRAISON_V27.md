# Livraison v27 — fiabilité, effets locaux et King Klown v6

Base : ZIP v26 et installateur KingKlown_v5_CORRIGE fournis dans cette conversation. La ville et les huit institutions sont conservées. Aucun nouveau quartier, aucune API kOA, aucun AssetId ou PlaceId inventé.

## Modifications livrées

| Domaine | Modification | Portée et limite |
|---|---|---|
| Visage | Coque ellipsoïdale complète masquant la tête native, deux yeux et sourire adouci en segments arrondis | Pas de plaque; expressions faciales dynamiques natives masquées. Rendu à vérifier dans Studio. |
| Cheveux | Mise à l'échelle selon la tête | Géométrie procédurale conservée; pas de mesh importé. |
| Apparence | Attente du corps complet, traitement de l'apparence tardive, annulation des tâches obsolètes, nettoyage des connexions | Remplace le suivi ObjectValue qui pouvait enregistrer un succès avant équipement réel. |
| Aura | Une sphère et un émetteur locaux par costume visible; pas de Highlight | Aucun ForceField ni PointLight créé. Les scintillements restent attachés à l'orbe. |
| Budget d'aura | 2/4/6 particules par seconde en léger/normal/détail; portée 55/110 studs; masquage en première personne | Valeurs configurées, pas un gain GPU mesuré. |
| PNJ | 12 Hz et portée 80 studs en léger, 24 Hz et portée 155/190 en normal/détail | Ne modifie pas les animations de locomotion du joueur. |
| Décor | Comparaisons de distances au carré pour le LOD existant | Évite deux racines carrées par objet évalué; pas de mesure FPS. |
| Institutions | Ambiance pilotée par KinZone, mise à jour par événement | Corrige l'usage des anciennes coordonnées d'intérieurs éloignés. |
| Voyages | Réservation maintenue après TeleportAsync, échec corrélé par requestId, libération après échec/départ/respawn/délai | Délai de récupération 30 s, aucune relance automatique. Test client publié encore requis. |
| Apparition | Même attente du corps pour joueurs déjà présents et nouveaux personnages; demande de streaming à destination | Vérification physique dans Roblox encore nécessaire. |
| Installation | Blocage en Play, costume intégré aux neuf scènes, attribution explicite récupérée de l'ancien script | Les IDs de compte doivent être réels; expérience de groupe à configurer. |
| Secours local | L'installateur local reste LOCAL_UNIVERSE même sous configuration MULTI_PLACE | Le fichier générique est explicitement documenté comme secours tout-en-un. |
| Mesure | Diagnostic de 20 s de temps d'image après 5 s d'attente | Mesure locale à lancer; aucune télémétrie. |

## Fichiers principaux

- `src/server/KingKlownAvatar.luau`, `src/client/KingKlownAura.luau`, `config/king_klown.json` : sources canoniques du personnage et des effets.
- `src/server/PlayerTravel.luau`, `src/server/PendingTravel.luau`, `src/client/TravelTransition.luau` : sessions de téléportation et information du joueur.
- `src/client/LocalVisualDirectorV22.luau`, `src/client/CitizenAnimationV21.luau`, `src/client/CrystalDetailLOD.luau` : ambiance et budgets locaux.
- `src/server/init.server.luau`, `src/client/init.client.luau` : branchement des nouveaux modules.
- `tools/make_king_klown_installer.py`, `tools/make_studio_installer.py`, `tools/build_release.py`, `tools/export_roblox.py` : génération des livrables et configuration.
- `tests/test_v27_reliability.py` : cinq régressions comportementales du registre de requêtes Lua, secours local et identité des sources du costume.
- `tools/check_luau_syntax.py`, `KinCity_Diagnostic_Performance_v27.luau` : vérification syntaxique et mesure à exécuter dans Studio.
- Tests historiques : attentes de version actualisées; copie temporaire du test de release placée hors du dépôt pour éviter une copie récursive en environnement restreint.
- Les installateurs v26 historiques sont archivés; les fichiers v27 sont régénérés.

## Vérifications réalisées

- `python tools/validate_catalog.py` : zéro erreur; neuf avertissements correspondant aux PlaceIds non publiés.
- `python tools/validate_spatial.py` : zéro erreur.
- `python tools/build_release.py` : neuf installateurs distincts, ville directe, secours local et costume autonome produits.
- `python -m unittest discover -s tests -q` : **78 tests réussis**, dernière exécution 19,168 secondes dans l'environnement de travail.
- `python tools/check_luau_syntax.py` : **168 fichiers Luau analysés**, zéro erreur syntaxique. Ce contrôle n'est ni une analyse de types complète ni une exécution du moteur Roblox.
- Empreintes du manifeste et intégrité ZIP vérifiées lors du conditionnement.

Les dépendances de test sont dans `requirements-dev.txt`. Les tests utilisent Python, un analyseur syntaxique Luau et Lua pour le registre pur PendingTravel; ils n'émulent pas le moteur Roblox.

## À qualifier dans Roblox

Visage de face/profil, échelle de tête R6/R15, apparition tardive, respawn, deux clients, aura en première personne, costumes dans les véhicules, transitions et collisions. Puis les neuf scènes publiées et leurs allers-retours. Les PlaceIds sont toujours non renseignés. La v27 ne prétend pas avoir importé les modèles/PBR ni refait artistiquement les bâtiments ou leurs activités.

L'utilisateur avait confirmé la promenade v26. Aucun test Studio v27 ni gain de FPS n'a été mesuré dans cette session.

Référence officielle consultée : https://create.roblox.com/docs/projects/teleport — erreurs asynchrones et nécessité de tester les passages dans le client Roblox publié.
