# Kin City — Livraison de construction v17.0

## Livré dans le code

- **Direction artistique canonique** : `catalog/crystal_theme.json`, palettes du catalogue existant réorientées vers le sarcelle minéral `#1E6864` et le cristal opalin `#C5F4F0`.
- **Kit 3D procédural** : `src/server/CrystalKit.luau` (pointes, facettes, rosaces, incrustations de sol, socles et accent lumineux).
- **Huit façades majeures redessinées** : `src/server/CrystalFacades.luau`, intégré au générateur standard.
- **Huit intérieurs institutionnels enrichis** : `src/server/CrystalInteriors.luau`, avec prismes muraux, rosaces et sol minéral.
- **Espaces publics unifiés** : `src/server/CrystalPublic.luau` installe une grande signature géométrique au centre, 12 jalons de cristal en profil STANDARD et huit portiques de quartier.
- **Profil géométrique LITE/STANDARD/SHOWCASE** : `config/visual.json` ajuste le nombre de facettes, la transparence des cristaux héros et les motifs du mandala.
- **Extension chromatique aux quartiers et transports** : résidences, marchés, boutiques, marinas, îles, minibus, gare et places utilisent aussi la famille #1E6864 et cristal opalin dans leurs matériaux.
- **Identité dans tous les panneaux** : fond sarcelle profond, textes opalins; tonalité d'éclairage plus minérale.
- **Mise à jour automatique des scènes** : `WorldBuilder` passe à `construction-v17.0.0` pour reconstruire les mondes v16.
- **Module partagé généré** : `src/shared/CrystalTheme.luau`, issu du JSON canonique à chaque compilation.
- **Installateur Command Bar autonome** et projet Rojo mis à jour.

## Choix de performance

La majorité des facettes sont opaques (Slate) et non-collidables. Les rares cristaux héros utilisent chacun une unique facette semi-transparente. Pas de nouvelles textures téléchargées, pas de lumières ponctuelles par cristal. Les transparences héritées des v1-v16 ne sont pas encore toutes optimisées.

## Non fait / toujours nécessaire

- Vérification visuelle du rendu et des collisions dans Roblox Studio.
- Passage des modèles architecturaux complexes à des MeshParts optimisés, textures PBR et LOD selon appareils.
- Optimisation des milliers de pièces déjà produites par les v1–v16.
- Import des sons dans Roblox, tests clients et publication finale.
- Connexion kOA volontairement inactive : `WORLD_STUB`, message « Fonctionnalité à venir ».

Installation : ouvrir un projet Roblox Studio, coller le nouvel installateur v17 dans Command Bar en **mode Édition**, puis exécuter et lancer Play.
