# KC-ADR-006 — Aucun faux succès

**Statut : DÉCIDÉ · Date : 2026-10-18**

## Contexte

L’utilisateur doit savoir qu’aucune fonction métier n’est active en mode autonome.

## Décision

Les stubs renvoient coming_soon et performed_operation=false ; UI honnête.

## Conséquences et contraintes

Interdiction d’afficher un vote enregistré, un crédit gagné ou un cours achevé fictif.

## Vérification

Vérifier les manifestes touchés, l'absence de contournement de l'autorité et les tests indiqués dans `docs/05-qualification/acceptation.md`. Aucun statut « implémenté » n'est induit par ce document.
