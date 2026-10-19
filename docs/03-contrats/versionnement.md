# Versionnement et compatibilité

## Versions

- Documentation : `2.0.0-draft` (paquet actuel).
- Catalogue : `kincity.catalog/1.0`.
- Contrats : `kincity.city/1.0`, `.building/1.0`, `.door/1.0`, `.interaction/1.0`, `.capability/1.0`, `.place/1.0`.
- Build Roblox : version et SHA publiés avec chaque Place ; chaque Place doit signaler sa révision de catalogue.

## Politique de changement

**Correctif** : réparer un texte/UI sans changer le sens ni le protocole. **Mineur** : ajouter une capacité ou un champ optionnel compatible. **Majeur** : changement d'ID, de contrat d'autorité, de politique de droits ou de sémantique. Toute modification majeure exige migration explicite et rapport de compatibilité.

## Rollout de Places

Éviter d'envoyer un joueur depuis une ville en version N vers un intérieur incompatible en version N−2. Publier et qualifier les destinations avant d'ouvrir les routes, enregistrer la combinaison de versions, pouvoir désactiver une porte problématique sans corrompre le profil joueur.

## Registre de dépréciation

Ancien ID, nouvel ID, date de dépréciation, alias temporaire, instance concernée, impacts, preuve de tests. Les ID des scènes et des capacités ne suivent pas le nom commercial affiché.
