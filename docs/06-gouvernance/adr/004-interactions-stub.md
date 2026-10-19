# KC-ADR-004 — Interactions centrales et stubs

**Statut : DÉCIDÉ · Date : 2026-10-18**

## Contexte

Les meubles doivent annoncer « Fonctionnalité à venir » en attendant kOA.

## Décision

Utiliser InteractionRouter, CapabilityRegistry et StubProvider, sans script séparé par meuble.

## Conséquences et contraintes

Toute mutation métier future doit passer par un fournisseur contrôlé ; stub est un état, pas une erreur.

## Vérification

Vérifier les manifestes touchés, l'absence de contournement de l'autorité et les tests indiqués dans `docs/05-qualification/acceptation.md`. Aucun statut « implémenté » n'est induit par ce document.
