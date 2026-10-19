# États de l'interface et microcopie

## États produits

| État | Signification | Message | Action |
|---|---|---|---|
| `coming_soon` | capacité déclarée mais non disponible | « Fonctionnalité à venir » | Fermer |
| `loading` | opération réelle en cours (futur) | « Chargement en cours » | Annuler si sûr |
| `unavailable` | service normalement activé, temporairement inaccessible | « Service temporairement indisponible » | Réessayer plus tard |
| `denied` | accès refusé par un propriétaire/garde | « Accès non autorisé » | Fermer |
| `validation_error` | entrée incorrecte | « Vérifiez les informations » | Corriger |
| `success` | effet réel confirmé | message contextualisé | Fermer / Continuer |
| `teleport_failed` | navigation physique non terminée | « Impossible d'entrer pour le moment » | Réessayer / Rester ici |

`WORLD_STUB` n'utilise **jamais** `success` pour une consultation, un vote, une inscription ou un crédit. Une porte locale réussie peut avoir `success` car le déplacement a réellement eu lieu.

## Machine de fenêtre

`closed → opening → shown → closing → closed`. Une fenêtre ne réentre pas sur elle-même ; un nouveau prompt active une fermeture/remplacement contrôlé. Rendre le contrôle au joueur même après disparition du modèle source.

## Structure de messages

Voir `catalog/messages.fr.json`. Toute interface utilise une clé versionnée (pas une phrase disséminée dans les scripts). Les traductions absentes produisent un repli explicite connu, avec événement de QA ; le fallback ne doit pas rendre un ID interne incompréhensible visible à l'utilisateur.

## Design

Panneau responsive dans l'UI Roblox, titre de ressource et texte concis, bouton Fermer visible, contraste suffisant, fond non trompeur. Ne pas utiliser de badge « vote enregistré » ou « crédit accordé » en mode autonome.
