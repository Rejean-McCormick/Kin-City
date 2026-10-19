# Matrice d'acceptation de Kin City autonome

**Décision utilisateur : la livraison autonome doit être la ville permanente, non une maquette.** Tous les critères obligatoires sont vérifiés dans l'expérience Roblox réelle ou les outils explicites indiqués.

| ID | Critère de succès observable | Méthode / preuve | Bloquant |
|---|---|---|---|
| KC-WORLD-01 | Place centrale disponible, avatar mobile | Client, capture, journal build | Oui |
| KC-WORLD-02 | Ville cohérente avec ses districts et cheminements | Traversée documentée de chaque district | Oui |
| KC-WORLD-03 | Extérieurs et intérieurs riches réellement chargés | Visite + inspection scènes et assets | Oui |
| KC-WORLD-04 | Chaque porte d'entrée mène à sa destination | Test client publié de chaque route | Oui |
| KC-WORLD-05 | Chaque porte de sortie ramène en ville | Test client publié aller/retour | Oui |
| KC-WORLD-06 | Objets interactifs identifiés et atteignables | Audit d'ancrage + tests Studio/client | Oui |
| KC-WORLD-07 | Stubs affichent « Fonctionnalité à venir » et sont fermables | Tests clavier/tactile/manette | Oui |
| KC-WORLD-08 | Zéro appel kOA, zéro compte lié, zéro succès métier factice | Revue config/code + test négatif | Oui |
| KC-WORLD-09 | Catalogues génératifs revalidables et IDs stables | Schémas + diff + rapport de build | Oui |
| KC-WORLD-10 | Sécurité, résilience, performance et contenu qualifiés | Matrice tests, rapport appareil et conformité | Oui |
| KC-WORLD-11 | Aucun Place référencé non publié à la livraison | Registre de déploiement prouvé | Oui |
| KC-WORLD-12 | Versions compatibles et procédure de rollback | Essai de restauration en privé | Oui |
| KC-WORLD-13 | Assets recensés avec droits et modération | Registre et preuves d'import | Oui |
| KC-WORLD-14 | Interactions tolèrent streaming et multijoueur | Campagne Server & Clients + client | Oui |
| KC-WORLD-15 | La génération reproduit le graphe logique avec même seed | Vérification de digest logique | Oui |

## Critères complémentaires du système connecté (plus tard)

`KC-KOA-01` Gateway contractuel qualifié, `KC-KOA-02` identité autorisée, `KC-KOA-03` aucune confusion EkoH/votes, `KC-KOA-04` intégrité des mutations, `KC-KOA-05` admissibilité du canal Roblox, `KC-KOA-06` délais/cache/idempotence, `KC-KOA-07` débrayage d'une capacité vers stub sans modifier la scène. Ces critères ne bloquent pas `WORLD_STUB` et ne sont pas réputés satisfaits aujourd'hui.

## Seuils de performance

Les appareils visés et seuils FPS/mémoire/chargement sont des paramètres obligatoires à fixer et mesurer avant signature de KC-WORLD-10. Inventer « 60 FPS garantis » sans démonstration est interdit.

## Procès-verbal

Une livraison est qualifiée lorsque tous les critères bloquants disposent d'une preuve positive signée et qu'aucun blocage critique n'est ouvert. L'existence de ces documents ou de manifestes validés ne remplace pas cette preuve.
