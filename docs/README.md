# Index de la documentation Kin City

**Priorité normative** : décisions explicites du commanditaire → ADR acceptées → contrats Kin City versionnés → architecture détaillée de ce dépôt → sources externes → archive v1.1 conservée à titre historique. Lorsqu'un code propriétaire existe, ce code et ses preuves qualifiées restent l'autorité sur ses fonctionnalités.

Les documents Kin City décrivent un **système cible à développer**, pas des fonctionnalités déjà certifiées. Toute fonctionnalité doit passer les tests de la section qualification avant qu'un statut « implémenté » soit attribué.

## Fondations

- [Vision](00-fondations/vision.md)
- [Périmètre et modes](00-fondations/perimetre.md)
- [Invariants](00-fondations/invariants.md)
- [Glossaire](00-fondations/glossaire.md)

## Produit / expérience

- [Plan de la ville](01-produit/ville.md)
- [Bâtiments et intérieurs](01-produit/batiments.md)
- [Navigation et portes](01-produit/navigation.md)
- [Objets et interface utilisateur](01-produit/interactions-ui.md)
- [Avatars, PNJ et vie sociale](01-produit/personnages.md)
- [Accessibilité et localisation](01-produit/accessibilite.md)
- [Contenu et politiques de diffusion](01-produit/politique-contenu.md)

## Architecture

- [Vue d'ensemble](02-architecture/ensemble.md)
- [Constitution du dépôt](02-architecture/depot.md)
- [Roblox : runtime et réplication](02-architecture/roblox-runtime.md)
- [Compilation générative](02-architecture/compilation.md)
- [Données et IDs](02-architecture/donnees.md)
- [Ressources 3D](02-architecture/assets.md)
- [Configuration et environnements](02-architecture/configuration.md)
- [Performances](02-architecture/performance.md)

## Contrats

- [Manifestes / schémas](03-contrats/manifestes.md)
- [Interactions et fournisseurs](03-contrats/interactions.md)
- [Portes et téléportation](03-contrats/portes.md)
- [Machine d'états UI](03-contrats/etats-ui.md)
- [Frontière future kOA](03-contrats/koa-futur.md)
- [Identité future](03-contrats/identite-future.md)
- [Compatibilité et versionnement](03-contrats/versionnement.md)

## Ingénierie et exploitation

- [Environnement de développement](04-ingenierie/developpement.md)
- [Générateurs et outils](04-ingenierie/outils.md)
- [Sécurité / menaces](04-ingenierie/securite.md)
- [Observabilité](04-ingenierie/observabilite.md)
- [Publication et exploitation](04-ingenierie/exploitation.md)
- [Dépannage](04-ingenierie/depannage.md)

## Qualifications et gouvernance

- [Stratégie de test](05-qualification/tests.md)
- [Acceptation vérifiable](05-qualification/acceptation.md)
- [Traçabilité](05-qualification/traçabilite.md)
- [Registre des décisions](06-gouvernance/adr/README.md)
- [Risques](06-gouvernance/risques.md)
- [Preuves et sources](06-gouvernance/sources.md)
- [Questions à trancher](06-gouvernance/ouverts.md)
- [Annexe historique version 1.1](reference/architecture-v1.1.md)

## Conventions de statut

- `DÉCIDÉ` : exigence fournie explicitement par le commanditaire ;
- `CIBLE` : décision recommandée, en attente d'adoption formelle ;
- `FUTUR` : contrat préparé, pas de connexion ni de promesse de disponibilité ;
- `EXTERNE_VÉRIFIÉ` : règle démontrée par une source datée ;
- `À_QUALIFIER` : validation technique qui demande de vrais tests Roblox ;
- `EXEMPLE` : fixtures utilisées pour rendre les contrats explicites, pas inventaire exhaustif du futur jeu.

## Construction v3

Voir [construction industrielle et géométrie](07-construction/README.md). La v3 améliore les contrats avec une géométrie explicite, une résolution des assets, des tests négatifs et un compilateur de plan logique. Aucune revendication de jeu déjà exécuté dans Roblox.


## KC36 — Refonte du plan directeur et orchestration (27 octobre 2026)

**NOUVEAU :** voir [le dossier KC36 — Urbanisme, emprises, sols et orchestration](09-refonte-urbaine/00_LIRE_EN_PREMIER.md). Cette section décrit le plan actuel KC35, les collisions bâtiment/avenue détectées par calcul, le traitement du scintillement du gazon, l'interdiction des panneaux de quartier flottants, et la cible d'orchestration avant toute nouvelle passe de code.

Elle est **documentaire** et proposée pour revue ; elle n'a pas modifié les sources Roblox, ni rendu les scènes actuelles automatiquement correctes.

## KC36 — Refactor and AI branch orchestration

- [KC36 source-derived urban overhaul and evidence](09-refonte-urbaine/00_LIRE_EN_PREMIER.md) — architectural target; not an implemented replacement of KC35.
- [AI agent coordination hub](10-ai-coordination/README.md) — ten branches, source-of-truth, dependencies, geometry and merge gates.
- [Original ten branch missions](../reference_KC34/branches/B09_integration.md) — original locked KC34 reference briefs, now contextualized by the KC36 rules.
- [Root-level coding agent instructions](../AGENTS.md).

**Current status caution:** a successful KC35 local install does not establish visual/staging/mobile acceptance. Owner-observed white lawn flashing and oversized floating B10 signs are known regressions to address architecturally.
