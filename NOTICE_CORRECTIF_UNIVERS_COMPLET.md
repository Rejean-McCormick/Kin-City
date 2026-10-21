# Kin City v30.0.1 — correctif de l'installateur UNIVERS COMPLET

**Installer à utiliser exclusivement pour une seule Place en aperçu :**
`KinCity_Installation_Univers_Complet_v30_CORRIGE.luau`.

## Installation

1. Dans Roblox Studio, ouvrir une **copie** de la Place. Arrêter `Play`.
2. Afficher `View > Output` pour suivre la construction, puis `View > Command Bar`.
3. Ouvrir le fichier `.luau` et coller **son contenu entier** dans la barre Command Bar; exécuter une seule fois.
4. Vérifier dans Explorer que `Workspace > KinCityGenerated` contient **`Ville`**, **`Bâtiments visitables`** (huit `Intérieur — ...`) et `Points de connexion`.
5. Dans Output, une installation terminée affiche `KIN CITY : SUCCES - la ville et les 8 institutions existent`.
6. Démarrer `Play` et visiter les institutions par les portes. Elles sont à des origines spatiales distinctes dans la même Place.

L'installation **remplace** le dossier `Workspace.KinCityGenerated`; les retouches manuelles dans ce dossier sont perdues. Elle n'exige aucun PlaceId, aucun AssetId ni accès HTTP.

## Correctifs techniques

- Génération explicite du monde avec `RuntimeConfig.mode=LOCAL_UNIVERSE` : une ville extérieure et huit institutions à des coordonnées locales éloignées, pas neuf Places publiées.
- Script Command Bar compact de 713 Ko (contre 857 Ko pour la version v30 précédente) ; les sources d'origine v30 sont conservées dans le dépôt.
- Messages d'avancement dans Output. L'installation n'annonce pas de succès tant que la ville et les huit intérieurs ne sont pas présents et que `KinBuildState` ne vaut pas `Ready`.
- Si le module générateur de ville ou un intérieur v30 échoue, essai du générateur v27 correspondant **uniquement comme secours**, depuis le script v27 effectivement fourni. Les sections construites en secours peuvent manquer des améliorations géométriques post-v27 ; le nombre de secours est journalisé et inscrit en attribut `KinGeneratorFallbacks`.
- Les ID canoniques de portes et d'interactions ne sont pas réattribués.

## Limites

La raison exacte de l'échec constaté dans Studio n'a pas pu être vérifiée faute de journal d'erreur et d'exécution Roblox dans cet environnement. La grande taille du script initial est une piste, **pas une cause démontrée**. Si la construction échoue encore, le message affiche l'erreur au lieu d'annoncer un monde prêt. Copier alors la **première erreur rouge** de View > Output avec le nom de l'institution éventuelle.

Hors moteur : catalogue, validation spatiale, parcours de la bibliothèque, tests spécifiques du script, contrôles lexicaux/structurels Luau réussis. La suite Python présente trois modules indisponibles faute de `lupa`; le moteur Roblox et le parseur Luau complet n'ont pas été exécutés.
