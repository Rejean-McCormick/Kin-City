# KC-ADR-010 — Test de téléportation publié

**Statut : EXTERNE_VÉRIFIÉ · Date : 2026-10-18**

## Contexte

La documentation officielle Roblox indique que les téléports ne se testent pas dans Studio.

## Décision

Exiger une expérience Roblox publiée privée et le client Roblox pour toute preuve d’aller-retour.

## Conséquences et contraintes

Un test Studio ne ferme pas les critères KC-WORLD-04/05.

## Vérification

Vérifier les manifestes touchés, l'absence de contournement de l'autorité et les tests indiqués dans `docs/05-qualification/acceptation.md`. Aucun statut « implémenté » n'est induit par ce document.
