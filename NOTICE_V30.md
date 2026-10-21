# Kin City v30 — installation rapide

**Version cumulative** : la v30 part du ZIP v29 joint et conserve la ville, les huit institutions, les catalogues et King Klown v7. Aucune v30 préexistante n'est supposée.

Dans **Roblox Studio, mode Édition, Play arrêté**, ouvrir **View > Command Bar**, coller et exécuter **tout le contenu d'un seul installateur** :

- **Ville principale** : `KinCity_Installation_Directe_v30.luau` (identique à `KinCity_Installation_Place_city_v30.luau`). **Recommandé pour l'extérieur**.
- **Huit institutions séparées** : chaque Place reçoit son `KinCity_Installation_Place_<clé>_v30.luau` : `city_hall`, `ekoh_tower`, `campus`, `justice_palace`, `innovation_lab`, `library`, `museum`, `orgo_center`.
- **Tout-en-un local** : `KinCity_Installation_Univers_Local_v30.luau` (même code que `KinCity_Installer_CommandBar.luau`), pour l'aperçu dans une Place ; ce n'est pas une publication multi-Places.

**Attention** : relancer l'installateur **reconstruit `Workspace.KinCityGenerated`** et remplace toutes les retouches manuelles conservées *à l'intérieur de ce dossier*. Sauvegarder/copier la Place avant réinstallation. Les autres constructions et terrains personnalisés ne sont pas destinés à être supprimés. La compatibilité Baseplate de v28.0.1 et les chemins v29 restent présents.

## Nouveautés v30

- **Menu ☰ KIN CITY** : rechercher un outil; une fenêtre à la fois, ✕ et Échap/B pour fermer; défilement et dimensionnement sur petit écran; sélection initiale adaptée à la manette (Select ouvre le menu).
- **Destinations N** : recherche locale, huit institutions en tête, bouton explicite pour effacer la destination. Quand le trajet calculé v29 existe, la distance annoncée suit le parcours plutôt qu'une ligne droite. Pour les destinations secondaires sans tracé, la distance reste directe et indiquée comme telle. Le guide ne garantit pas une avoidance dynamique des autres joueurs.
- **Bibliothèque** : première visite facultative. Masquer volontairement le guide n'entraîne pas sa réactivation lors d'un prochain événement de zone de la même session; il reste réactivable depuis le menu.
- **Panorama** : sortie au retrait du personnage, cadrage de retour plus cohérent si le lieu a changé et respect d'une autre caméra déjà en mode Scriptable.
- **Mesure FPS** : 20 secondes sur l'horloge locale Roblox, rafraîchissement de texte limité, annulation par seconde pression ou fermeture; FPS moyen, médiane et p95, avertissement quand zone/qualité changent. **Aucune transmission externe** et aucun gain FPS affirmé.

Touches conservées : **G** magie de King Klown, **H** gare, **M** carte, **N** lieux, **J** carnet, **T** galeries, **K** ateliers, **P** ciel et **V** qualité; manette **R3** magie et **Select** menu.

**Portes** : en aperçu de Places séparées non publiées, les portes inter-Places ne peuvent pas téléporter. Seuls les véritables PlaceIds publiés dans `config/place_ids.json` et `MULTI_PLACE` permettent de construire un jeu multi-Places publié; aucun ID n'a été inventé.

**Limites** : aucune exécution dans le moteur Roblox Studio/client lors de cette livraison. Pour les détails des contrôles hors moteur et fichiers modifiés, voir `LIVRAISON_V30.md`.
