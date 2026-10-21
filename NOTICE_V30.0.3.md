# Kin City v30.0.3 — PNJ plus naturels et intérieurs moins éblouissants

## Installer l'univers entier (recommandé pour ton projet)

**Fichier :** `KinCity_Installation_Univers_Complet_v30.0.3.luau`.

1. Dans Roblox Studio, **arrêter Play** et enregistrer la Place au format `.rbxl` comme sauvegarde.
2. Afficher la **Command Bar**, ouvrir le `.luau` dans un éditeur et **coller son contenu entier**.
3. Exécuter **une seule fois**, attendre `KIN CITY : MONDE PRÊT` et le message de succès.
4. Dans Explorer, vérifier `Workspace.KinCityGenerated.Ville` et `Workspace.KinCityGenerated["Bâtiments visitables"]` (huit intérieurs). Ensuite démarrer Play.

L'installateur est **tout-en-un et autonome** : ville + huit institutions dans une seule Place. Il reconstruit `KinCityGenerated`, donc les éventuelles retouches manuelles dans ce dossier sont remplacées. Les portes se déplacent localement entre les institutions en aperçu ; elles ne constituent pas des téléportations entre Places publiées.

## Changements cumulés v30.0.3

- **36 citoyens géométriques** : direction calculée sur la tangente à leur promenade au lieu d'un angle de Tween, déplacement à vitesse à peu près constante, gestes de bras et jambes autour des articulations, chaussures animées avec les jambes, pauses ponctuelles et suspension loin des joueurs. Tenues affinées, badges, ceintures, visages plus lisibles.
- **26 PNJ Roblox R15 prévus** (14 citoyens et 12 résidents, sous réserve de la création des modèles par Roblox) : `Humanoid.AutoRotate`, vérification du résultat `MoveToFinished`, cibles à hauteur du rig, coiffures, insignes et chaussures natifs soudés sans collisions.
- **Lumière des huit institutions** : luminosité de chaque `PointLight`, `SpotLight` et `SurfaceLight` portée à **65 % de sa valeur initiale**, sans modifier le ciel, la lumière du jour ou les lampes extérieures. Facteur enregistré sous `KinInteriorLightingFactor=0.65` sur chaque modèle. Le même traitement s'applique au générateur de secours et à la régénération sélective d'un intérieur. La lumière globale Roblox et l'aspect des matériaux Neon ne sont pas diminués par cette opération : la luminosité perçue ne diminue donc pas nécessairement d'exactement 35 %.
- **Préservés** : ville, huit institutions, King Klown, bibliothèque, portes, interactions et identifiants métier, direction artistique sarcelle `#1E6864` / opale `#C5F4F0`. Aucun AssetId/PlaceId artificiel.

## Vérifications

- `python tools/validate_catalog.py`
- `python tools/validate_spatial.py`
- `python tools/validate_v28_journey.py`
- `python -m unittest discover -s tests -v`
- `python tools/check_luau_structure_v29.py`
- `python tools/build_release.py` et `python tools/make_universe_recovery_installer.py`

Les tests sont des contrôles hors moteur : **aucune animation, performance, collision ni lumière en jeu n'a été mesurée dans Roblox Studio dans cet environnement**. Le parseur Luau complet n'est pas installé ; les trois suites qui dépendent de `lupa` ne peuvent pas démarrer. Après installation, regarder les PNJ de profil/en face et vérifier les intérieurs de jour et de nuit.

## Dépannage

Si Roblox indique une erreur, afficher **View / Sortie (Output)** et relever la **première ligne rouge**. Le message `The command exceeds the size limit ... saved commands` concerne l'historique Command Bar et non l'exécution.
