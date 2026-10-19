# ADR 017 — Résolution stricte des assets
Statut : ADOPTÉ.

**Décision :** chaque référence `exterior_template`, `interior_template` et `furnishing.asset_id` doit exister dans `catalog/assets.json`. Une référence fictive ou inconnue est **bloquante**. Un asset déclaré `native_procedural` constitue une recette cible tant que son générateur n'est pas effectivement implémenté et éprouvé en Studio; le validateur ne prétend pas prouver l'existence de géométrie Roblox.
