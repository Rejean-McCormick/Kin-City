# ADR 014 — Géométrie canonique avant génération
Statut : ADOPTÉ comme **règle de documentation de référence**, implémentation Roblox à qualifier.

**Décision :** toutes les structures, pièces, meubles interactifs et ancres possèdent des transforms explicites dans `catalog/spatial.json`. Le compilateur rejette les ressources non résolues. Un catalogue d'IDs sans géométrie ne qualifie plus le monde.

**Conséquence :** une édition manuelle doit être enregistrée comme patch de scène; les scripts générateurs deviennent testables sur l'IR, sans constituer pour autant une preuve de jeu publié.
