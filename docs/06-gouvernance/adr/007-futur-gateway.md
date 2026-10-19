# KC-ADR-007 — Gateway futur séparé

**Statut : CIBLE · Date : 2026-10-18**

## Contexte

Les API kOA ne sont pas appelées dans la livraison autonome et ont des propriétaires distincts.

## Décision

Préparer des IDs et adaptateurs symboliques ; n’activer GatewayProvider qu’après preuve du contrat, sécurité et conformité.

## Conséquences et contraintes

La documentation ne prouve pas l’existence des endpoints kOA ; aucun lien serveur de production dans le build stub.

## Vérification

Vérifier les manifestes touchés, l'absence de contournement de l'autorité et les tests indiqués dans `docs/05-qualification/acceptation.md`. Aucun statut « implémenté » n'est induit par ce document.
