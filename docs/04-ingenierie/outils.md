# Outillage et programmes de génération

## Objectif industriel

Fabriquer un **outil de création de ville**, pas une collection de scripts jetables. Les familles de générateurs décrites dans l'architecture doivent partager un contrat commun : entrée validée, seed, ressources autorisées, sortie canonique, rapport de diagnostic et pouvoir de rollback.

## Contrat de générateur

```text
Input: CatalogBundle + AssetRegistry + GeneratorVersion + Seed
Output: SceneGraph + PlaceBuildPlan + BuildReport + DeterministicDigest
Failure: structured error with source file, schema path and repair suggestion
```

Le compilateur ne doit pas faire dépendre le contenu de l'heure courante ou d'un nombre aléatoire global non initialisé. Des géométries imposées peuvent être paramétrées plutôt que « peintes » à la main.

## Outils recommandés

| Outil | Utilité | Statut |
|---|---|---|
| Roblox Studio | moteur, éditeur, publication et tests | externe requis |
| Rojo | synchronisation entre fichiers et Studio | open source MPL 2.0, non inclus |
| StyLua | formatage Luau/Lua | externe, version à épingler |
| Selene | analyse statique Lua/Luau | externe, version à épingler |
| Wally | gestion de bibliothèques Roblox | optionnel, version/licence à vérifier |
| Python | validation des fichiers documentaires | validateur fourni sans dépendance obligatoire |

## Politique d'installation

Épingler les versions exactes approuvées, auditer dépendances/permissions, conserver notices de licence. Éviter la dépendance à un plugin Roblox opaque qui générerait du code incontrôlé. Toute IA utilisée pour écrire du code doit produire des fichiers vérifiables et reproductibles.

## Rapport de build exigé

Révisions de catalogues et assets, nombre de bâtiments/portes/interactions, portes orphelines, collisions, taille et performance estimées, logs d'import et provenance, warnings bloquants/non bloquants. Le tableau de bord doit rendre visibles les cas où le monde est incomplet avant publication.
