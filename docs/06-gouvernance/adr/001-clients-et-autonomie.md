# KC-ADR-001 — Un produit Kin City, plusieurs interfaces

**Statut : CIBLE · Date : 2026-10-18**

## Contexte

Kin City est une représentation de kOA sans reprise des autorités métiers.

## Décision

La ville Roblox et l’interface Web éventuelle sont des clients du même écosystème. En mode WORLD_STUB, seule l’interface Roblox autonome est nécessaire.

## Conséquences et contraintes

Ne pas dupliquer les modèles de votes/cours/identités ; préserver l’indépendance du moteur 3D.

## Vérification

Vérifier les manifestes touchés, l'absence de contournement de l'autorité et les tests indiqués dans `docs/05-qualification/acceptation.md`. Aucun statut « implémenté » n'est induit par ce document.
