# Correctif sol et arrivée — v28.0.1

Le gazon de l'île est à Y=0. Le générateur conservait les socles externes : une Baseplate affleurant ce plan pouvait provoquer un conflit de profondeur. GroundCompatibility met uniquement une grande Baseplate plate, ancrée, affleurante et couvrant le centre dans ServerStorage.KinCityOriginalGround. Aucun Terrain ni construction personnalisée n'est effacé. Sans capture Studio, cette cause reste une hypothèse pour le clignotement signalé.

L'ancre city.central.spawn passe de (0,3,0) à (0,3,-16), yaw 0. Empreinte du SpawnLocation : 12 × 12, centre (0,0.8,-16). Zone centrale sans panneaux directionnels : centres à au moins 40 studs, largeur 19. Enseigne Bienvenue déplacée à (0,7,30), largeur 28, hauteur 5, yaw 0. La caméra initiale recule de 16 studs et monte de 7 studs relativement au point visé. Les chemins sont recompilés depuis la même ancre. Les IDs restent identiques.

Installation : arrêter Play, ouvrir KinCity_Installation_Directe_v28.luau et coller son contenu dans la Command Bar pour la ville seule. Pour le mode historique avec tous les intérieurs dans la même Place, utiliser KinCity_Installation_Univers_Local_v28.luau. Ce correctif conserve les noms v28 des installateurs. La génération remplace KinCityGenerated, donc les retouches manuelles de ce dossier sont à préserver avant installation.

Contrôle Studio à faire : Play puis respawn, avatar visible sans panneau devant la caméra; marcher et tourner la caméra au-dessus du gazon; contrôler le bord de l'île. Si le gazon clignote encore, fournir une courte vidéo et la zone concernée pour identifier les surfaces restantes. Aucun rendu Roblox ni téléportation publiée n'a été testé ici.

Vérification locale : python tools/build_release.py ; python tools/validate_catalog.py ; python tools/validate_spatial.py ; python -m unittest discover -s tests -q ; python tools/check_luau_syntax.py.
