# Structure cible du dépôt de développement

Le présent ZIP ne contient **que la documentation**. Une fois adopté comme dépôt d'application, l'organisation suivante est recommandée :

```text
KinCity/
  README.md, AGENTS.md, CONTRIBUTING.md, SECURITY.md
  docs/            documentation normative, décisions et tests
  schemas/         JSON Schema des manifestes Kin City
  catalog/         géométrie, bâtiments, portes, interactions, messages
  assets/          mesh, texture, sons, animations, manifestes de provenance
  generators/      parsing, planning, layout, scènes, QA, export
  roblox/
    default.project.json
    shared/         types, IDs, UI messages et contrat d'erreur
    server/         InteractionRouter, DoorRouter, StubProvider
    client/         prompts UI, affichage, caméra, carte
    places/         city et intérieurs / configurations par Place
  tools/           validation, compilation, migration et inventaire
  tests/           schema, unit, propriétés, intégration, parcours et charge
  build/           sorties temporaires déterministes (non commitées)
  .github/         CI, revue, publication autorisée
```

## Frontières

`catalog` ne contient pas de logique métier, `generators` ne décide pas des droits utilisateur, `client` ne contient pas de secret, `server` ne remplace pas un propriétaire kOA, `GatewayProvider` futur n'est pas importé dans le build autonome.

## Bibliothèques conseillées

Rojo pour éditer/synchroniser les scripts en fichiers, StyLua pour formater, Selene pour analyse statique, outils de tests Luau selon intégration; Wally facultatif pour bibliothèques dont la licence est vérifiée. Ces outils sont recommandés, **non inclus ni installés par le présent paquet**.

## Sources visuelles

Les assets potentiellement exclusifs au format binaire peuvent rester en fichiers `.rbxm/.rbxmx`, en modèle Roblox ou en bundles gérés par une chaîne documentée. Leur provenance et leurs versions doivent être référencées en texte. Des meshes « téléchargés dans Toolbox » ne remplacent pas une discipline de licence.

## Architecture stable pour copie-coller IA

Un agent ne doit pouvoir modifier qu'une surface contractuelle à la fois : ajout de bâtiment → manifeste + asset + tests ; ajout d'une porte → source/destination/spawn + tests ; ajout d'une capacité → registre et réponse stub. La structure rend chaque changement révisable, sans demande générale « crée tout le jeu ».
