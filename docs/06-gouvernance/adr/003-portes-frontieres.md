# KC-ADR-003 — Portes comme frontières de Places riches

**Statut : DÉCIDÉ · Date : 2026-10-18**

## Contexte

Le commanditaire veut diviser l’univers aux portes et rendre les intérieurs riches.

## Décision

Ville extérieure dans un Place principal ; grands intérieurs dans des Places séparés quand utile ; seuils/retours explicites.

## Conséquences et contraintes

Vrai chargement réseau entre Places, publication et tests réels nécessaires ; petits intérieurs peuvent rester inline.

## Vérification

Vérifier les manifestes touchés, l'absence de contournement de l'autorité et les tests indiqués dans `docs/05-qualification/acceptation.md`. Aucun statut « implémenté » n'est induit par ce document.
