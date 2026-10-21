# Kin City v30.0.4 — parcours de quartiers

**Installateur recommandé :** `KinCity_Installation_Univers_Complet_v30.0.4.luau` (ville + 8 institutions dans une seule Place Roblox Studio). Éteindre **Play**, sauvegarder une copie `.rbxl`, coller le fichier complet dans la Command Bar, puis exécuter. Attendre le message `KIN CITY : MONDE PRÊT` dans Sortie. L'installation remplace `Workspace.KinCityGenerated` ainsi que les scripts associés; les retouches manuelles à l'intérieur sont remplacées.

## Changements

- Les 36 citoyens géométriques, 14 PNJ R15 et 12 résidents ont des itinéraires variés rattachés à l'un des six quartiers (`ResidentialDestinations`).
- Le module partagé `NeighborhoodNPCNavigation` place les haltes sur les axes des cours et des allées, en dehors des empreintes théoriques du kiosque et des maisons; les routes comprennent des sorties courtes sur le boulevard et des pauses.
- Calcul d'itinéraire par `PathfindingService` avec rayon et hauteur d'agent, détection des obstacles et interdiction des détours hors quartier ou des sauts. Aucun déplacement direct de secours qui traverse un objet. Les citoyens ancrés effectuent en plus un `Blockcast` avant chaque déplacement; si un objet bloque, ils restent en place et retentent ultérieurement.
- Aucun changement aux identifiants des bâtiments, portes, interactions ni aux 8 institutions; l'éclairage intérieur à 65 % de la v30.0.3 demeure.

## Limites et vérifications dans Studio

La navigation hors moteur n'est **pas** un test du navmesh Roblox. Dans Studio, vérifier que les haltes sont sur des sols navigables, que les PNJ ne restent pas immobilisés en groupe et que les détours sont praticables autour des jardins, kiosques et maisons. Les objets mobiles ou les collisions dont la forme diverge du rendu peuvent nécessiter un ajustement de `STOPS` dans `NeighborhoodNPCNavigation.luau`.

Si le calcul échoue ou qu'un obstacle bloque le chemin, le PNJ s'arrête plutôt que d'avancer à travers la géométrie. Aucun service externe, asset ID ou PlaceId inventé.

## Validation hors Roblox

- `python tools/validate_catalog.py`
- `python tools/validate_spatial.py`
- `python tools/validate_v28_journey.py`
- `python -m unittest discover -s tests -v`
- `python tools/check_luau_structure_v29.py`

Le contrôle structurel ne remplace pas un parseur Luau ni la simulation du moteur Roblox.
