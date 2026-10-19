# KC-ADR-011 — Outillage ouvert, sans IA runtime

**Statut : DÉCIDÉ · Date : 2026-10-18**

## Contexte

Le commanditaire utilise ChatGPT par copier-coller et refuse les frais à l’usage IA.

## Décision

Le pipeline de construction est déterministe, local/automatisable et travaille sur des fichiers.

## Conséquences et contraintes

Les services d’hébergement, publication ou assets tiers peuvent avoir leurs propres coûts.

## Vérification

Vérifier les manifestes touchés, l'absence de contournement de l'autorité et les tests indiqués dans `docs/05-qualification/acceptation.md`. Aucun statut « implémenté » n'est induit par ce document.
