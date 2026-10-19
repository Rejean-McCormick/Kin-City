# KC-ADR-002 — Générateurs déterministes et catalogues

**Statut : CIBLE · Date : 2026-10-18**

## Contexte

Le monde massif doit être maintenable avec du vibe coding et sans coût IA à la génération.

## Décision

Décrire topologie, façades, intérieurs, portes, objets et assets dans des catalogues versionnés et compiler depuis des graines.

## Conséquences et contraintes

Comparer les sorties logiques et traiter overrides/provenance avant toute régénération destructrice.

## Vérification

Vérifier les manifestes touchés, l'absence de contournement de l'autorité et les tests indiqués dans `docs/05-qualification/acceptation.md`. Aucun statut « implémenté » n'est induit par ce document.
