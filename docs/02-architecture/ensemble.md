# Architecture globale du produit cible

## Vue logique

```text
                  ROBLOX UNIVERSE — Kin City
         ┌─────────────────────────────────────┐
         │ Place CITY (ville, rues, façades)    │
         │  ├─ portes → autres Places            │
         │  ├─ rues, PNJ, signalétique           │
         │  └─ interactions taguées             │
         └──────────────┬──────────────────────┘
                        │ passage porte réel
           ┌────────────┴────────────────────┐
           │ Places intérieurs riches         │
           │ bibliothèque / justice / campus  │
           │ musée / innovation / mairie...   │
           └──────────────┬────────────────────┘
                          │ interaction
                  InteractionRouter
                          │
                   CapabilityRegistry
                          │
                 ProviderRouter serveur
                     │             │
           WORLD_STUB│             │KOA_CONNECTED (futur)
                     ▼             ▼
                StubProvider    GatewayProvider
                     │             │
             « à venir »       Gateway HTTPS
                                      │
                              propriétaires kOA
```

## Frontières d'autorité

**Client Roblox** : reçoit les scènes répliquées, capture l'intention, affiche UI. **Serveur Roblox** : valide déclenchements, route la porte, lit capacités admises, contrôle les sessions de jeu. **Fournisseur stub** : réponse locale statique. **Gateway futur** : authentification, budgets, traduction, politique de canal et appels aux propriétaires kOA. **Systèmes kOA** : données et calculs officiels.

## Fondamentaux indépendants

Navigation, portes, caméra, dialogues stub, catalogue et compilation fonctionnent sans réseaux HTTP externes. Aucun faux système de crédits, de consultation ou d'apprentissage n'est créé pour « remplir » les bâtiments. Le décor constitue la valeur exploratoire du mode autonome.

## Séparation données / scènes

La ville est définie dans `catalog/` puis produite via la chaîne de génération. Les objets ont `interaction_id` comme donnée stable ; ni la position, ni le nom en français, ni l'ordre de création ne constituent une clé.

## Conditions de bascule futures

Le changement de `StubProvider` à `GatewayProvider` exige contrats métiers réels, consentement/politique d'identité, processus d'admission, tests de sécurité et preuve de conformité Roblox. Cette migration ne modifie ni portes ni positions. Chaque capacité peut rester en stub indépendamment des autres.
