# QA B07 — Galerie Konservation

## Intention de cette passe

En l'absence d'un musée pleinement ouvert, la consolidation finale conserve **la porte d'entrée barrée** et redirige visuellement les joueurs vers **un écran de broadcast YouTube** proche de la façade, clairement visible depuis l'avenue Kreative.

## Invariants

- `door_id` inchangé : `city.kreative.museum.entry`
- `return_door_id` inchangé : `museum.exit`
- `place_key` : `museum`
- interaction métier inchangée : `kreative.museum.panel_01`

## Ce que valide la passe offline

- six salles documentées et planifiées ;
- module Luau B07 présent ;
- runtime d'intégration B09 capable de barrer la porte et de déplacer l'écran extérieur ;
- aucune modification des 23 fichiers contractuels verrouillés.
