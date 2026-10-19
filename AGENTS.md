# Consignes pour assistants de développement (vibe coding)

## Objectif

Travailler sur le système cible final Kin City. Construire la ville Roblox durablement, en mode `WORLD_STUB` d'abord, sans exiger une API kOA. Ne jamais convertir ce travail en « prototype jetable » sans demande explicite.

## Avant toute modification

1. Lire `README.md`, `docs/00-fondations/perimetre.md`, `docs/02-architecture/ensemble.md` et les ADR.
2. Chercher les schémas et IDs existants avant d'ajouter un objet ou un bâtiment.
3. Distinguer : `EXISTANT_VÉRIFIÉ`, `PROPOSÉ`, `RÉSERVÉ_FUTUR`, `INCONNU`.
4. Restreindre chaque changement à une responsabilité et un contrat, sans écrire de monolithe géant.
5. N'affirmer « fonctionne » qu'avec un test reproductible fourni.

## Interdictions absolues

- Appels réseau kOA, URLs API kOA et jetons, même en dur pour une démonstration autonome.
- Votes, crédits, certifications ou permissions fictifs présentés comme véritables.
- Scripts dupliqués sur chaque objet alors qu'un routeur central peut gérer le cas.
- Références à des `PlaceId` inventés comme s'ils existaient.
- Asset réutilisé sans provenance et droits explicités.
- Migration silencieuse d'un ID de porte, de bâtiment, d'interaction ou de capacité.
- Modification directe de l'autorité métier d'Orgo, Konnaxion ou UCKK.

## Contrat des réponses de l'agent

Toujours fournir fichiers précis créés/modifiés, hypothèses vérifiées, commandes de vérification, résultat mesuré, limites et risques. Préférer des changements localisés, des commandes reproductibles, des tests automatisés et un plan de retour arrière. Si l'outil ne peut pas tester la téléportation dans un client Roblox publié, le dire.

**Mode autonome** : tout `capability` non connecté répond `coming_soon`; les portes constituent des capacités de navigation locales actives et ne doivent pas répondre `coming_soon`.


## Directives obligatoires v3

- Lire `docs/07-construction/README.md` et `catalog/spatial.json` avant toute modification de façade, pièce, mobilier, porte ou interaction.
- Toute nouvelle référence d'asset doit exister dans `catalog/assets.json`, avec provenance, version et licence.
- Toute implantation nouvelle doit avoir transform XYZ, yaw, empreinte, ancre de porte et contrôle d'enveloppe.
- Exécuter `python tools/validate_spatial.py` et `python -m unittest discover -s tests -v` en plus du validateur initial.
- Ne jamais présenter `build/world-plan.json` comme une scène Roblox jouable.
- Ne jamais déclarer les téléportations testées sans les preuves d'un client Roblox publié.

## Code livré depuis la version 0.1.0

Les règles documentaires ci-dessus restent en vigueur. **Il existe maintenant du code sous `src/`**. Ne plus affirmer que ce dépôt ne possède aucun runtime Luau. Lire `docs/08-implementation/etat-executable.md` pour les preuves d'exécution effectivement disponibles. Toute modification de `catalog/` doit régénérer `src/shared/` et `KinCity_Installer_CommandBar.luau`.

Commandes préalables à une proposition de changement :

```bash
python tools/validate_catalog.py
python tools/validate_spatial.py
python tools/export_roblox.py
python -m unittest discover -s tests -v
python tools/make_studio_installer.py
```

Ne jamais prétendre « testé dans Roblox » si seul le test Python a été exécuté.

## Direction artistique v17 : convention de développement

- Préserver **#1E6864** comme couleur d’architecture partagée et **#C5F4F0** comme cristal opalin.
- Modifier `catalog/crystal_theme.json` pour les couleurs et `config/visual.json` pour le profil visuel (`LITE`, `STANDARD`, `SHOWCASE`), puis regénérer le module partagé et l’installateur.
- Réutiliser `src/server/CrystalKit.luau` au lieu de copier des WedgeParts, Neo et PointLights dans chaque bâtiment.
- Aucun nouveau cristal décoratif ne doit barrer une circulation (`CanCollide=false`), masquer une interaction ou réutiliser l’identifiant d’un objet métier.
- Garder les facettes majoritairement opaques; réserver Glass aux rares cristaux `hero`.


## V23 : modèles et expositions locales

- Les cinq OBJ et les 12 PNG de matériau sont des sources originales locales, mais ne prétendre ni les avoir importés ni les avoir vus dans Roblox sans capture.
- Aucun AssetId Roblox n'est présumé. `config/meshes.json` et `config/audio.json` acceptent `null` et les gabarits ont une forme native.
- `LivingExhibitsV23` est une activité pédagogique d'exploration, **pas** un service Konnaxion ni un simulateur de vote.
- L'installateur est cumulatif et direct; ne pas imposer de mécanisme de rollback contrairement au choix produit.
