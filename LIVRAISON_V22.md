# Kin City v22 — Passe majeure sarcelle et cristal

## Objectif

Passer de l'empilement de petites décorations à une **identité de ville lisible à trois distances** : silhouettes reconnaissables de loin, parcours habités à mi-distance, détails et histoires spécifiques lorsqu'on entre dans une salle. Aucune expansion territoriale ni connexion métier.

## Réalisations dans le code

| Domaine | Module | Contenu livré |
|---|---|---|
| Langage géométrique | `ArtisanGeometryV22.luau` | Volumes et facettes natifs, beams, orbes, motifs de 8 familles. Visuel seul. |
| Architecture monuments | `InstitutionSkylineV22.luau` | 8 couronnements distincts en retrait sur les toits existants. |
| Architecture habitation | `NeighborhoodRooflinesV22.luau` | 24 toitures avant avec lucarnes, en gardant visibles les jardins derrière. |
| Intérieurs | `InstitutionStoriesV22.luau` | 48 cadres muraux, œuvres typées, titres et textes, marqueurs physiques. |
| Espaces publics | `CrystalRestStopsV22.luau` | Haltes près des chemins canoniques, bancs utilisables, pergolas, plantations minérales. |
| Carnet | `GalleryJournalV22.luau` | Progression de visite locale des 48 salles; `T`, tactile, panneau défilant. |
| Ambiance | `LocalVisualDirectorV22.luau` | Couleur et bloom subtils adaptés à l'institution; qualité locale `V` et tactile. |
| Distance visuelle | `CrystalDetailLOD.luau` | Prend aussi en compte la position de la caméra panoramique et le choix qualité. |

### Principes de construction préservés

- **#1E6864, opale #C5F4F0, champagne #E5D7AF**; chaque institution garde son accent et sa forme.
- Cristal majoritairement **opaque**, sans surfaces `Glass` additionnelles dans cette passe.
- Ornements de façades, œuvres et lucarnes **sans collision**. Les bancs, eux, sont de vrais `Seat` Roblox.
- Les nouveaux éléments ne modifient pas les IDs des portes, objets métier ou transports.
- Aucune dépendance aux services Konnaxion/Orgo/UCKK, aucun score ou vote simulé.

### Quantité de contenu prévisible

Huit silhouettes uniques, 48 scènes murales, 24 habillages de toits résidentiels. Haltes : une ou deux par chemin piéton canonique selon profil (8 ou 16 pour les 8 parcours actuellement catalogués). Le profil `SHOWCASE` affiche davantage de détails mais pas davantage de bâtiments.

### Ce qui ne peut pas être affirmé

L'exécution Luau dans Roblox Studio n'est pas disponible ici. Les fichiers sont intégrés aux générateurs et livrés, mais les proportions, l'accessibilité, les lignes de vue et les performances ne sont pas certifiées en jeu. Les tests Python portent sur la cohérence hors moteur.

## Travaux importants encore ouverts

Créer/importer des meshes réutilisables véritablement artistiques, textures PBR ciblées, animations R15 vérifiées dans Roblox, optimisation du nombre d'Instances et de lumières selon un profil réel d'appareil, et premier essai complet dans Roblox Studio. Les vrais `PlaceIds` multi-lieux ne sont pas encore publiés et la ville conserve le mode local.

### Remplacement sélectif des vitrages répétitifs

`OpalGlazingV22.luau` applique une opale opaque et claire aux vitrages répétitifs des **24 maisons** et des **8 ateliers de gare**, en conservant seulement certains vitrages héros transparents si le profil de construction `SHOWCASE` est sélectionné. Aucune cloison porteuse, aucun accès ni interaction n'est modifié. Ce choix réduit les superpositions transparentes générées par ces modules, mais **aucune amélioration chiffrée de FPS n'est avancée** sans mesure dans Roblox.
