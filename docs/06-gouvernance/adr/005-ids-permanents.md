# KC-ADR-005 — IDs immuables

**Statut : CIBLE · Date : 2026-10-18**

## Contexte

Le branchement futur ne doit pas forcer la reconstruction des intérieurs.

## Décision

IDs stables pour Place logique, bâtiment, porte, ancre, interaction et capacité ; pas d’index dépendant du nom.

## Conséquences et contraintes

Migration explicite pour tout changement d’identité ; registre de dépréciation.

## Vérification

Vérifier les manifestes touchés, l'absence de contournement de l'autorité et les tests indiqués dans `docs/05-qualification/acceptation.md`. Aucun statut « implémenté » n'est induit par ce document.
