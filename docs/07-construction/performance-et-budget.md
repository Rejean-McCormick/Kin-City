# Performance : budgets sans fiction

## Mesure avant arbitrage
Le projet vise un univers final massif, mais sa performance est **dépendante du matériel utilisateur**, de la taille des assets, de la réplication et du nombre de joueurs. Toute valeur doit être liée à un appareil cible et à un protocole reproductible.

Construire un tableau d'essais par appareil (téléphone modeste / téléphone récent / PC moyen), par situation (arrivée, place centrale, intérieur riche, changement de Place, 8 joueurs), et enregistrer FPS median/p5, mémoire utilisée, durée entrée/chargement, erreurs et stutters. **Aucune mesure terrain n'est incluse dans la v3.**

## Optimisations requises
- Activer/tester `Workspace.StreamingEnabled`, qui se configure dans Studio et non par script.
- Dissocier silhouettes lointaines, collision réelle et détails des intérieurs; Streaming peut décharger les instances, les scripts clients doivent tolérer leur absence.
- Préférer réutilisation de MeshParts simples et matériaux, éviter un Part par petit détail quand le budget d'instances sature.
- Ne jamais mettre un intérieur géant en `Persistent` sans preuve de nécessité.
- Mesurer chargement inter-Place; un nombre excessif de Places augmente le coût de transition.
- Réduire prompt/UI actifs aux zones pertinentes et éviter polling réseau par objet.

## Critère de décision
Si une frontière architecturale échoue au budget appareil approuvé, revoir `interior_mode` ou la complexité de la scène, **sans changer les IDs métier**.

Sources : https://create.roblox.com/docs/workspace/streaming ; https://create.roblox.com/docs/performance-optimization/design ; https://create.roblox.com/docs/studio/testing-modes
