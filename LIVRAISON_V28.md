# Kin City v28 — personnage et parcours de bibliothèque

## Livré

Base cumulative : archive v27 fournie par l'utilisateur. Ville extérieure, huit institutions et identifiants canoniques conservés. Aucun service kOA ni identifiant Roblox fictif.

### King Klown v7

- Sept mèches courbes asymétriques, frange en virgule et calotte sombre; suppression de la disposition radiale de pointes.
- Veste adoucie, deux boutons et cape courte à deux pans. Suppression de la baguette fixe pour libérer la main.
- Clignements, légère inclinaison de tête et mouvement de cape. Les gestes s'ajoutent aux transformations du rig après l'Animator; l'offset précédent est retiré avant la prochaine animation pour éviter son accumulation. Motor6D et AnimationConstraint sont reconnus pour les joints du corps.
- Geste magique de 2,4 secondes, déclenchable par G, R3 ou bouton tactile. Le serveur valide le joueur autorisé, le personnage vivant, le sol, l'absence d'outil et de siège, l'arrêt et un délai de six secondes. Le client ne choisit ni position ni cible. Un timestamp synchronise les effets des clients; les transformations visuelles restent locales.
- Trois éclats orbitaux et traînées courtes. Un seul éclat en qualité légère; l'orbe et ses effets restent masqués en première personne. Les éclats se rassemblent près de la main pendant le geste.
- Chevelure OBJ originale facultative : 808 sommets, 1 584 triangles. Normalisation, triangles non dégénérés et fermeture des composantes vérifiés hors moteur. Le modèle est inclus mais n'a pas été importé dans Roblox.

### Le livre sans dernière page

Quatre stations réutilisent le mobilier canonique de la bibliothèque : accueil sur le banc du hall, Observer au présentoir, Relier au banc de la galerie et Imaginer à la table de lecture. Après les trois fragments, le retour au livre d'accueil conclut le récit.

L'ordre des fragments est libre. Les lectures répétées ne sont pas comptées deux fois. L'accueil est nécessaire et la conclusion exige les trois fragments. État individuel conservé durant la session serveur et après respawn; pas de DataStore ni de récompense. Les interactions sont validées côté serveur par zone, vie, distance, origine de l'invite et fréquence.

Les livres sont de petites sculptures natives sans collision, sur le mobilier existant. Leur placement, leur référence d'asset et leurs enveloppes de salle sont vérifiés. Aucun grand espace ni bâtiment n'est ajouté.

### Guidage et lecture

Le guide suit le chemin piéton canonique depuis la place centrale vers la bibliothèque. Dans les salles, il rejoint l'axe du portail avant de franchir la cloison. Il indique la prochaine station, puis la sortie. Le retour par la porte de la bibliothèque active le guidage vers la place centrale.

Les dix repères maximum sont locaux, sans collision ni source lumineuse. La qualité légère en utilise cinq. C'est un guidage géométrique et non un pathfinding dynamique : les obstacles ajoutés manuellement ne sont pas détectés.

Le panneau de récit est défilable, dimensionné selon l'écran et fermable au bouton, à Échap ou à B. Il remplace le petit dialogue générique pour ces textes afin d'éviter leur troncature.

## Principales sources

- `src/server/KingKlownAvatar.luau`, `src/client/KingKlownPerformance.luau`, `src/client/KingKlownAura.luau`.
- `src/server/LibraryJourneyRules.luau`, `LibraryJourneyRuntime.luau`, `LibraryJourneyArt.luau`.
- `src/shared/JourneyPath.luau`, `src/client/LibraryJourneyGuide.luau`, `LibraryStoryPanel.luau`.
- `config/library_journey.json`, `catalog/assets.json` et module partagé généré `LibraryJourney.luau`.
- `tools/generate_v28_meshes.py`, `tools/validate_v28_journey.py`, `tests/test_v28_journey.py`.
- Initialisation, HUD, déplacement joueur, générateurs d'installateurs et version de build actualisés. Les anciens installateurs v27 sont archivés.

## Vérification

Commandes de reproduction dans README.md et dépendances dans requirements-dev.txt.

- Catalogue : zéro erreur; neuf avertissements de PlaceIds non publiés.
- Validation spatiale : zéro erreur.
- Contrats de parcours : mobilier, enveloppes, portes et référence d'asset valides.
- Suite Python/Lua hors moteur : **91 tests réussis**, dernière exécution 7,497 secondes dans cet environnement.
- Analyseur syntaxique : **176 fichiers Luau vérifiés**, zéro erreur syntaxique. Il ne remplace pas une analyse de types ni le moteur Roblox.
- Tests supplémentaires : ordre des fragments, répétitions, conclusion prématurée, indépendance des joueurs, action inconnue, projection sur un sentier, virage, axe de portail et absence de retour en arrière au seuil. Contrôle géométrique du mesh et des placements.
- Neuf installateurs de Places, secours local, ville directe et costume autonome régénérés. Empreintes et intégrité ZIP vérifiées au conditionnement.

## Limites réelles

Aucun rendu Studio v28, test de rig réel, test tactile/manette réel, mesure FPS ou passage entre Places publiées n'a été effectué ici. Les interactions ajoutées et les vêtements peuvent encore nécessiter des ajustements à partir de captures. Les animations de locomotion standard sont conservées; il ne s'agit pas d'un pack d'animations importées. La tête native reste masquée par la coque arrondie v27 : ses expressions dynamiques ne sont pas conservées.

Le récit recommence dans une nouvelle session serveur. Les données de progression ne sont pas transférées entre Places; seul le guidage de retour utilise la porte de provenance. Aucun succès de lecture n'est déduit d'une donnée de téléportation.

Les neuf PlaceIds ne sont toujours pas renseignés. Les scènes séparées s'explorent chacune dans Studio; le parcours complet sans publication exige l'installateur de secours LOCAL_UNIVERSE. Les passages réels nécessitent publication et qualification dans le client Roblox.

## Documentation technique consultée

- https://create.roblox.com/docs/reference/engine/classes/Motor6D/Transform
- https://create.roblox.com/docs/reference/engine/classes/AnimationConstraint
- https://create.roblox.com/docs/reference/engine/classes/ContextActionService
