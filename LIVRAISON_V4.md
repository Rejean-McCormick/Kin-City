# Kin City — Construction v0.4.0 — contenu livré

**Objectif de cette livraison : construire plus d'univers, sans brancher kOA.**

Cette version poursuit le projet v0.3.0. La ville reste `WORLD_STUB` et `LOCAL_UNIVERSE` par défaut. Toutes les futures actions métier (bibliothèque, université, palais de justice, etc.) continuent de répondre « Fonctionnalité à venir ».

## Nouveaux systèmes réels

- `InteriorCollections.luau` : collections thématiques dans les 48 pièces : rayonnages et livres, mobilier civique, ateliers scientifiques, œuvres d'art, tableaux des services et panneaux institutionnels. Chaque pièce a une borne interactive identifiable.
- `FacadeDetail.luau` : détails architecturaux supplémentaires sur les huit façades (auvents, linteaux, balcons, croisés de fenêtres, bannières, lanternons).
- `PromenadeLife.luau` : jusqu'à 36 nouveaux pavillons publics en pergolas, bancs et bornes « Fonctionnalité à venir ». Leur présence réelle dépend des collisions d'emprise avec les institutions.
- `NativeR15Citizens.luau` : tentative asynchrone de créer jusqu'à dix PNJ R15 via l'API Roblox officielle, avec variations morphologiques, déplacements et mouvements articulés. Ils complètent les 36 citoyens procéduraux stylisés. L'échec d'un chargement laisse la population stylisée intacte.
- `OutdoorAtmosphere.luau` : jardins lumineux, lanternes et un cycle d'éclairage conditionnel entre jour et nuit.
- `WorldAmbience.luau` : journée solaire continue, sans saut brusque du soir au matin.
- `Tramways.luau` : quatre rames VISUELLES, non physiques et non embarquables, qui suivent les parcours piétons compilés. Les bornes de navette assurent toujours les déplacements effectifs.
- `ExplorationJournal.luau` : carnet local d'exploration des huit institutions, accessible via **J** ou par bouton tactile ; sans compte kOA, sans crédits et sans sauvegarde persistante.
- `Soundscape.luau` : bornes audio optionnelles branchées sur des fichiers WAV originaux fournis dans `assets/audio`.
- `WorldBuilder.luau` : réutilise la scène déjà générée par la Command Bar au lancement de Play lorsque le plan canonique correspond, au lieu de reconstruire tous les bâtiments en double.
- `PromptRouter.luau` : prend en charge les bornes PNJ apparues APRÈS la construction de la carte (R15), sans leur donner de privilèges métier.

## Audio original — intervention requise pour le rendre audible

Les fichiers PCM WAV sont livrés :

- `assets/audio/kin-city-wind-loop.wav`
- `assets/audio/kin-city-water-loop.wav`
- `assets/audio/kin-city-chimes.wav`

Roblox ne peut pas utiliser directement une URL `file://` ou un fichier local dans `Sound.SoundId`. Pour entendre les sons, importer ces WAV via les outils d'assets Roblox, noter les IDs autorisés pour cette expérience et modifier `config/audio.json`. Remplacer `null` par les IDs correspondants, passer `enabled` à `true`, puis générer de nouveau l'installateur. **Sans cette opération, la ville fonctionne et reste silencieuse.** Les éventuelles règles d'importation, de droits et de modération Roblox s'appliquent.

## Installation par copier-coller

1. Ouvrir Roblox Studio, projet **Baseplate** ; sauvegarder une copie.
2. Ouvrir `KinCity_Installer_CommandBar.luau` et en copier **l'intégralité** dans la Command Bar de Studio, en mode édition.
3. Exécuter la commande ; la ville doit être produite dans l'éditeur. Ne pas interrompre la génération.
4. Lancer **Play**. Se déplacer avec WASD ; **E** près des portes, bornes et habitants ; **M** ouvre la carte ; **N** les destinations ; **J** le carnet des lieux visités.
5. Les PNJ R15 se chargent uniquement en mode **Play**, de manière asynchrone. Les NPC procéduraux décoratifs sont déjà placés en édition.

Le fichier d'installation régénère le contenu Kin City (`KinCityGenerated`, `KinCityShared`, `KinCityRuntime` et `KinCityUI`) et détruit les personnalisations manuelles faites dans ces éléments. Faire une copie du lieu avant de l'exécuter.

## Développement des sources

```bash
python tools/make_sound_assets.py
python tools/validate_catalog.py
python tools/validate_spatial.py
python tools/compile_plan.py --out build/world-plan.json
python tools/export_roblox.py
python tools/make_studio_installer.py
```

La source de vérité des paramètres de monde est `catalog/`. Les modules de génération sont dans `src/server/`. Le projet `default.project.json` convient à une construction Rojo.

## Ce qui reste pour une version visuelle définitive

- Vrais meshes et textures 3D spécialisés, matériaux haute qualité, animations de personnages/objets importées avec les autorisations Roblox nécessaires.
- Importation des sons WAV dans un compte Roblox et attribution des identifiants d'assets.
- Architectures multi-bâtiments de plus grande ampleur, quartiers entièrement personnalisés et mobilier artisanal spécifique à chaque lieu.
- R15 natifs : vérification et ajustement du comportement d'animation, de déplacement, de chargement asynchrone et de compatibilité des appareils.
- Publication d'un jeu Roblox et corrections des comportements effectivement constatés dans Studio (indisponible depuis cet environnement).
- Mesures puis adaptation au matériel mobile, consoles et sessions multijoueurs ; découpage en plusieurs *Places* si nécessaire.
- Branchement futur à kOA : explicitement NON commencé.

**Statut vérifiable :** code et assets originaux livrés, scripts exportés, tests Python hors moteur exécutés ; aucune certification d'exécution dans Roblox Studio.
