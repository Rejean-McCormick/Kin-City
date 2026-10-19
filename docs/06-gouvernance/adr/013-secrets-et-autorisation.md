# KC-ADR-013 — Secrets et droits côté serveur

**Statut : CIBLE · Date : 2026-10-18**

## Contexte

Le client Roblox n’est pas fiable et les secrets ne peuvent pas s’y trouver.

## Décision

Valider porte/interaction côté serveur et utiliser ultérieurement un mécanisme de secrets officiel côté serveur.

## Conséquences et contraintes

Aucun secret kOA dans catalogues ni code de jeu client.

## Vérification

Vérifier les manifestes touchés, l'absence de contournement de l'autorité et les tests indiqués dans `docs/05-qualification/acceptation.md`. Aucun statut « implémenté » n'est induit par ce document.
