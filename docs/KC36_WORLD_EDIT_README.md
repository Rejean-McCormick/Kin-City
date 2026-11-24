# KC36 WORLD EDIT V1 — édition visuelle ville + intérieurs

Remplace les modules `InteriorEditorV36` (serveur) et `InteriorEditorClientV36` (client), sans modifier les deux moteurs `PlayerBuildServer`/`WorldBuilder` ni le menu `KinCityMenu`.

Fonctions : sélection clic (modèle entier ou pièce précise), translation 0,5 stud, rotation, duplication (Model ou BasePart), effacement réversible, Annuler/Rétablir, journal DataStore `KinCity_WorldEditorV36_v1` par Place. Propriétaire seul, serveur valide distance et cible. Ancien DataStore d'atelier intérieur `KinCity_InteriorEditorV36_v1` reste intact mais **n'est pas migré** ; si l'utilisateur avait déjà enregistré des éditions dans l'ancien atelier, prévoir une migration avant de publier.

Protégés : composants marqués `KinDoorId`, `KinAnchorId`, `KinInteractionId`, `KinLiftId`, `KinShuttleId`, `KinTransitId`, `KinSpawnId`, `KinProtectEdit`, ainsi que scripts, prompts, PNJ, spawns, portes et zones techniques. Les visuels individuels des bâtiments sont éditables via **MODE : PIÈCE PRÉCISE** si aucune ancre technique ne les protège. `Terrain` Roblox n'est pas éditable par cette version : nécessite pinceau terrain distinct. Un groupe contenant un mécanisme technique ne peut pas être effacé d'un seul coup, mais ses pièces purement visuelles peuvent être sélectionnées individuellement.

**Attention :** la copie de meubles et la suppression de murs peuvent être destructives pour l'apparence. Faire une sauvegarde de la Place, tester dans Studio et ne pas publier avant validation. Les modifications faites en Studio sans API Service DataStore ne persistent pas ; ne pas activer API Studio sur une Place de production pour tester. Les modifications du nouvel éditeur sont séparées de l'ancien éditeur externe ; ne pas éditer le même objet avec les deux outils.

Pour installer : ouvrir la Place principale `72097868581669` dans Studio, arrêter Play, coller `KC36_INSTALL_EDITEUR_MONDE_COMPLET_RS.luau` dans Command Bar, vérifier `PASS KC36 WORLD EDIT V1`, Ctrl+S, Play. Tester arbre -> objet entier -> déplacer -> dupliquer -> effacer -> annuler. Tester mur d'institution -> mode pièce précise. Conserver le backup dans ServerStorage pour retour arrière.

Le moteur et l'interface ont été contrôlés statiquement, mais **pas exécutés dans Roblox Studio** dans cet environnement. Le script Command Bar effectue une validation de chargement Luau du nouveau moteur avant de remplacer les sources.
