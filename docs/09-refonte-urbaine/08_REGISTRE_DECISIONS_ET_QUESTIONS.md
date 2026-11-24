# 08 — Décisions, arbitrages et responsabilités

## 1. Décisions explicites du propriétaire (retenues comme exigences)

| ID | Décision | Statut |
|---|---|---|
| D-01 | Refonte **plus profonde** ; priorité à la documentation et à l'orchestration | `DÉCIDÉ` |
| D-02 | Aucun édifice « sur la route » : routes et parcelles doivent être planifiés ensemble | `DÉCIDÉ` |
| D-03 | Pas de panneaux de secteur flottants/dynamiques | `DÉCIDÉ` |
| D-04 | Ne pas désigner les secteurs par leurs heures | `DÉCIDÉ` |
| D-05 | Réexaminer V30 comme référence de qualité visuelle supérieure à KC35 sur plusieurs aspects | `DÉCIDÉ` |
| D-06 | B07 Musée fermé ; porte barrée, écran de broadcast visible près de l'entrée | `DÉCIDÉ` |
| D-07 | Préserver la bibliothèque centrale 121 modèles, PackageLink et mises à jour partagées | `DÉCIDÉ` |
| D-08 | Clignotement pelouse / zone blanche = anomalie à résoudre, pas une finition acceptable | `DÉCIDÉ` |

## 2. Propositions d'architecture à approuver

| ID | Proposition | Pourquoi | Décideur |
|---|---|---|---|
| P-01 | Compilateur urbanisme seul propriétaire de toutes les emprises | prévient les conflits de générateurs | B09 + commanditaire |
| P-02 | Un propriétaire de surface visible par cellule | prévient z-fighting et conflits matériaux | B09 + revue Studio |
| P-03 | PlotAllocator et ApprovedPlan stricts avant géométrie | évite de réparer chaque bâtiment manuellement | B09 + B10 |
| P-04 | Migrations géométriques versionnées, IDs stables | préserve les interactions et les retours | B09 |
| P-05 | Signalétique uniquement SurfaceGui sur supports physiques | qualité et confort de lecture | direction artistique |
| P-06 | Comparaison V30/V35/KC36 caméra par caméra | évite les déclarations subjectives de réussite | direction artistique |
| P-07 | Plus aucun « fallback » silencieux entre générateurs majeurs | empêche faux succès / vieux contenus | B09 |

## 3. Questions ouvertes à traiter dans le plan directeur

1. Les trois anneaux cités par `catalog/city.json` doivent-ils devenir trois voies continues, ou seulement trois niveaux de progression paysagers ? **Ne pas les matérialiser avant décision.**
2. Souhaite-t-on une **voirie piétonne uniquement**, ou des couloirs de service/transport ? Quelle largeur libre et quelle hiérarchie de traversée ?
3. Les huit institutions conservent-elles leurs positions approximatives avec recul latéral, ou réorganise-t-on entièrement les parcelles ? La stabilité des portes exige une migration si elles bougent.
4. Quelle partie du V30 convient mieux : proportions des façades, densité, jardin, matériaux, panneau, éclairage, animation, intégration urbaine ? Documenter par captures comparables.
5. Pelouse : conserver le disque géométrique « Île circulaire » ou migrer vers un terrain Roblox maîtrisé ? La décision doit suivre le diagnostic de clignotement.
6. Quel est le niveau de détail visuel validé sur mobile bas de gamme pour la bibliothèque centrale ? Nécessite métriques de rendu.
7. Écran B07 : quel AssetId vidéo Roblox légal/autorisé, et quelles plages de lecture ? En l'absence de média, quel texte honnête montrer ?
8. Les huit intérieurs seront-ils séparés publiquement dès la prochaine étape, ou après une phase locale ? Exige tests TeleportService.

## 4. Gouvernance des désaccords

Aucun module n'a le droit de déplacer une porte ou une parcelle pour « faire rentrer » son décor. Une branche qui découvre un conflit ouvre une **RFC géométrique** avec capture, IDs concernés, alternatives, test et proposition de coordonnée ; **B09 résout le conflit dans le plan commun avant toute régénération**. Les heuristiques esthétiques ne remplacent pas cette acceptation explicite.
