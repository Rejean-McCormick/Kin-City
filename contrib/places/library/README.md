# Kin City KC34 — B03 Grande Bibliothèque

**Territoire exclusif :** `library` (`konnected.library`, KonnectED). **Proposition locale B03, pas intégrée au runtime de B09 et non validée dans Roblox Studio.**

## Intention architecturale

*La bibliothèque des liens* prolonge le parcours narratif existant **« Le livre sans dernière page »** sans ajouter de faux boutons ni de doublons des prompts. Le hall accueille, la galerie invite à **Observer**, la salle de lecture à **Relier et Imaginer**, l'aile ouest préserve la mémoire, l'aile est propose la lecture libre, et l'atrium arrière matérialise le jardin des connaissances. Les filets bronze, l'opaline, le sarcelle et l'accent terre cuite constituent une unité Art déco lisible sans repeindre intégralement les volumes.

## Géométrie et sécurité

Six salles existantes préservées (dont les trois salles générées par `InteriorWings`), quatre connecteurs d'extension préservés et 16 portes de la ville **non modifiées**. Les ornements sont des éléments muraux entre Y=7 et Y=14, **sans aucune collision**, et leurs centres sont à plus de sept studs des centres des portails connus. Ils ne servent pas de sol, ne font pas office de spawn, n'ajoutent pas de prompt, ne déclenchent pas de téléportation et ne contactent aucun service externe. Le volume étendu des salles occupe X=[-105,105] et Z=[-46,104] en coordonnées locales : ne pas utiliser l'ancien rectangle 110×100 comme limite du décor.

### Fichiers

- `scene_plan.json` : source déclarative des six salles, 24 ornaments, niveaux de détail, couleurs et engagements de sécurité.
- `LibrarySceneData.luau` : conversion déterministe du JSON (fichier généré).
- `LibraryScene.luau` : constructeur natif Roblox des ornements muraux, idempotent, appelé **uniquement** par un orchestrateur autorisé.
- `STUDIO_APERCU_LOCAL_B03.luau` : commande autonome d'essai à coller en mode **Édition** dans Roblox Studio, **Place locale non publiée (`PlaceId==0`) uniquement**; ne modifie que le sous-modèle `Intérieur — library` de la génération existante.
- `build_tools.py` : reconstruire les deux fichiers générés sans dépendance Python externe.
- `recipe.json` : stub conforme au contrat B09 `kincity.place-recipe/1.0`; `decorations: []` reste volontaire : les décorations procédurales nécessitent un type de recette B09 spécifique avant que WorldBuilder puisse les charger.

## Mode d'essai local, non destructif pour la ville

1. **Sauvegarder le fichier `.rbxl` de test**. Il doit s'agir d'une copie *locale* non publiée, sur laquelle un installateur Kin City a déjà créé `Workspace/KinCityGenerated/Bâtiments visitables/Intérieur — library`.
2. Arrêter Play, ouvrir Command Bar et coller le contenu de `STUDIO_APERCU_LOCAL_B03.luau`.
3. Inspecter les 6 pièces, vérifier les murs, les quatre portails, l'enseigne du retour vers la ville et les prompts du livre existant. Contrôler également la lisibilité des textes opalins sur mobile.
4. Pour revenir à la scène avant B03, supprimer uniquement le modèle `KC34_B03_Library` enfant d'`Intérieur — library`. Ne jamais supprimer `KinCityGenerated` pour désinstaller B03.

Le script refuse une Place publiée, le mode Play, l'absence du bon modèle ou d'origine, et toute collision du nom B03 avec un modèle étranger. **L'exécution Studio n'a pas été vérifiée ici** : c'est une procédure de qualification à réaliser, non une réussite déjà constatée.

## Future intégration B09 (RFC requise)

B09 doit créer un adaptateur qui installe `LibrarySceneData.luau` et `LibraryScene.luau` dans le runtime serveur, puis appelle explicitement :

```luau
local B03Scene=require(script.Parent:WaitForChild("LibraryScene"))
local result=B03Scene.build({
    authorized=true,
    place_key="library",
    interiorModel=libraryInteriorModel,
    origin=Spatial.origin("library"),
    profile=VisualConfig.profile,
})
```

**Cette ligne n'a pas été ajoutée à `InteriorGenerator` ou `WorldBuilder`.** B09 doit protéger l'appel par la bonne `place_key`, mesurer son coût réel sur appareils, garantir que les modules sont présents dans chaque installateur staging, documenter l'API de recette et valider une erreur de build sans casser les 16 portes.

## Performance et vérification

Les éléments décoratifs **n'instancient aucun mesh commercial**. Nombre de pièces natives ajoutées si la scène est pleinement construite : LITE 88 (12 décors), STANDARD 121 (18), SHOWCASE 145 (24). Ces valeurs sont des **comptes logiques de la recette**, ni draw calls ni FPS. Les effets déjà présents dans la bibliothèque d'origine ne sont pas supprimés. B09 doit évaluer le coût combiné.

## Manques connus

Tests de compilation complète Luau `tree-sitter-luau`, essais Roblox Studio/client publié, capture jour/nuit, vérification des conflits avec les volumes des autres modules d'intérieur, mesure mobile et intégration KC33/B09 **non réalisés**. Le projet logiciel KC33/B09 n'étant pas physiquement disponible dans cette session, les tests ont été réalisés contre l'archive V3 initiale. **B09 doit revalider le patch sur la baseline KC33** avant acceptation.
