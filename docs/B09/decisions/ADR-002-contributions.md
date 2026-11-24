# ADR-002 — Contributions locales et revue transversale
**Date :** 2026-10-26  
**État :** ACCEPTÉ pour le protocole documentaire ; loader Roblox proposé/non connecté.

Dix branches opèrent sur neuf Places. B01–B08 et B10 peuvent travailler dans `contrib/places/<place_key>/` sans toucher aux identifiants canoniques. Les nouveaux `recipe.json` sont des points de contrat : aucun constructeur en production ne les charge encore.

Les changements de `catalog/`, `config/`, `src/shared/`, `src/server/`, `tools/`, `installer/`, `build/` ou de la Place centrale depuis une branche d'intérieur sont par défaut **SHARED** et nécessitent une RFC. Les modifications d'identifiants, portes ou palettes sont **BREAKING**, nécessitent ADR, vérification des partenaires et versionnement de contrat.

La validation automatisée refuse un patch hors namespace, un hash mensonger, un handoff marqué ACCEPTED par sa branche, un test PASS sans preuve et une rupture sans ADR. Elle ne peut ni interpréter artistiquement un mesh ni démontrer la performance en jeu. L'adaptateur Luau sera accepté avec une RFC lorsque les recettes non vides auront un propriétaire et des tests effectifs.
