# Hébergement des intérieurs — arbitrage plutôt que dogme

**Invariant de produit : la porte est la frontière d'expérience pour l'utilisateur.** Cette frontière ne force pas un `PlaceId` distinct pour chaque bâtiment.

| Mode | Choisir quand | Coût / risque | Test exigé |
|---|---|---|---|
| `inline_streamed` | commerce simple, fréquentation proche, sortie immédiate | mémoire/streaming, collision avec ville | circulation continue + appareils modestes |
| `separate_place` | bâtiment unique, assets lourds, identité visuelle forte | chargement inter-Place, cohortes séparées | client publié, aller-retour, reprise après erreur |
| `shared_template_place` | dizaines d'instances de bibliothèque/salles standard | paramètres d'instance et accès aux bonnes ancres | deux joueurs, deux destinations, aucun mélange |
| `event_place` | événements limités, surcharge publique, grands amphithéâtres | réservation, capacité, gestion d'événement | arrivée groupée et robustesse réseau |

## Règle décisionnelle
1. Créer un *budget* de mémoire mobile, primitives, avatars et complexité par intérieur, **mesuré sur un appareil cible**.
2. Préférer `inline_streamed` pour une petite salle dont la transition inter-Place pénalise inutilement l'expérience.
3. Préférer `separate_place` pour les destinations identitaires uniques, denses en assets, dès lors que le délai de transition est accepté.
4. Préférer `shared_template_place` lorsqu'un seul gabarit de scène reçoit de nombreuses configurations **après** vérification du routage du paramètre d'instance et des contrôles serveur.
5. Un changement de mode ne doit jamais changer `building_id`, `door_id`, `capability_id` ni `interaction_id`.

**Choix du catalogue actuel :** huit `separate_place`. C'est une hypothèse de référence pour valider la séparation aux portes, **pas une loi pour toute l'expansion**. Les Place IDs sont `null` jusqu'à publication; toutes les destinations inter-Place restent non testables en Studio.

**Source Roblox :** https://create.roblox.com/docs/projects/teleport ; https://create.roblox.com/docs/performance-optimization/design
