# Stratégie intégrale de test

## Pyramide

| Niveau | Exécution | Prouve |
|---|---|---|
| Validation source | Python, schémas JSON | syntaxe et références, pas comportement Roblox |
| Tests unitaires futurs | fonctions pures et modules Luau | géométrie, calcul de routes, état stub, invariants |
| Tests en Studio | Play, Server & Clients, simulateur appareil | rendu, prompts, réplication, interactions locales |
| Tests Roblox publiés privés | client Roblox réel | `TeleportAsync`, droits de Place, traversées, retour |
| Tests d'acceptation | appareils/classes réseau réels | expérience complète, performance, fiabilité, accessibilité |

## Scénarios fonctionnels

**T-001** Apparition sur place centrale, caméra normale, aucun obstacle.  
**T-002** Déplacement à pied vers chaque district et retour.  
**T-003** Chaque porte de bâtiment rejoint la destination correcte.  
**T-004** Chaque porte de retour ramène à un ancrage valide.  
**T-005** Une destination temporairement inaccessible laisse le joueur libre dans la scène source.  
**T-006** Toutes les interactions du catalogue montrent leur titre et « Fonctionnalité à venir ».  
**T-007** Tous les modals peuvent être fermés puis rouverts.  
**T-008** Une interaction répétée rapidement ne bloque pas l'UI ni le serveur.  
**T-009** L'expérience reste fonctionnelle sans API kOA ni internet vers ses services.  
**T-010** Validation de références, versions et assets terminée sans erreur bloquante.  
**T-011** Test à au moins deux joueurs et absence de confusion d'UI/portes.  
**T-012** Validation d'un appareil tactile et d'une manette.  
**T-013** Streaming de l'objet hors portée puis retour.  
**T-014** Connexion puis déconnexion pendant une transition, possibilité de revenir.  
**T-015** Aucune réussite de vote, score, crédit ou certification inventée.  
**T-016** Build identique sur le graphe logique à entrée/seed/versions identiques.

## Négatifs/sécurité

ID forgé, interaction hors portée, ouverture agressive de fenêtres, double porte simultanée, téléportation avec destination falsifiée, texte localisé manquant, modèle tiers non approuvé, `PlaceId` nul à publication, migration d'ID non documentée, appel HTTP kOA accidentel.

## Enregistrement des preuves

Chaque rapport porte `test_id`, date, version du catalogue, build, Place, appareil, mode Studio/client, actions, résultat mesuré, captures/vidéos éventuelles, trace d'échec, résolveur et correctif. Ne jamais compter des tests prévus comme exécutés.
