# Kin City v30.0.6 — Garamond partout, Bodoni en repli

**Installateur recommandé :** `KinCity_Installation_Univers_Complet_v30.0.6.luau`.

Cette passe standardise la typographie visible sur **Garamond** dans l’interface et les éléments de signalétique, avec **Bodoni** comme repli via un module commun pour tous les textes du projet si la police préférée est indisponible. J’ai aussi conservé et étendu les optimisations de lisibilité : panneaux moins aplatis, hauteur ajustée selon le texte, rendu plus net et léger déport vers l’avant pour éviter les conflits avec les marquises et éléments décoratifs.

## Inclus
- typographie Garamond sur les HUD et panneaux textuels visibles
- fallback Bodoni partagé dans toutes les interfaces et pancartes (`Typography`)
- estimation automatique du nombre de lignes pour les enseignes
- hauteur de panneau ajustée automatiquement selon la longueur du titre
- enseignes avancées et relevées sur les façades principales
- aucun changement aux identifiants de portes, bâtiments, ancres ou interactions

## Installateur
Coller `KinCity_Installation_Univers_Complet_v30.0.6.luau` dans la **Command Bar** de Roblox Studio en mode **Edit** (Play arrêté), puis exécuter. L’installation remplace `Workspace.KinCityGenerated` et les scripts associés; les retouches manuelles à l’intérieur sont régénérées.

## Vérifications restantes dans Studio
- vérifier visuellement les façades les plus chargées (gare, promenade, ateliers)
- vérifier que les titres très longs restent lisibles sans chevauchement
- vérifier sur petit écran que les HUD en Garamond restent confortables

## Validation hors moteur
- `python3 tools/build_release.py`
- `python3 tools/make_universe_recovery_installer.py`
- `python3 -m unittest discover -s tests -v`

Le parseur Luau avancé n’a pas été relancé ici faute de dépendance `tree_sitter` dans l’environnement de travail.

La sélection s’appuie uniquement sur les énumérations de polices natives Roblox (`Enum.Font.Garamond` et `Enum.Font.Bodoni`), sans asset externe.
