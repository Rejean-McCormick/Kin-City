# Contribution B08 — orgo_center

**Zone de contribution de B08.** Ne modifier ici que la Place `orgo_center`.

`recipe.json` est un **contrat de données et un placeholder**, pas un ajout visible en jeu. Ne pas annoncer sa présence dans Roblox avant intégration et tests par B09.

Pour toute porte, ancre, asset global, palette, générateur, routage ou propriété canonique : faire une RFC à B09.

## KC35 — Rebase KC33 réalisé dans un nouvel adaptateur

- `scene_recipe_KC33.json` dérive du programme original (six salles / 24 décors), avec baseline KC33 explicite et IDs vérifiés.
- `asset_plan_KC33.json` vérifie les statuts contre `catalog/art_deco_contexts.json` de KC33.
- `OrgoSceneData.luau` et `OrgoScene.luau` chargent des objets visuels natifs non bloquants.
- Le vieux `studio/B08_STUDIO_PREVIEW_LOCAL.luau` reste **archive V3 historique** et n'est jamais lancé par KC35.
- Les assets commerciaux suggérés dans `asset_plan_KC33.json` ne sont pas instanciés sans budget ni accès au pack.
