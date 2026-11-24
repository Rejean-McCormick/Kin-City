# 07 — Feuille de route, tests et migration de la refonte

## 1. Stratégie : tester un plan avant d'affiner le rendu

Pour KC36, le premier livrable exécutable **ne sera pas une ville décorée** mais un *greybox* : rues, intersections, parcelles, bâtiments simples, connexions piétonnes et seuils. Il doit détecter les erreurs de composition avant que les 121 modèles Art déco ne masquent leurs causes.

## 2. Lots de travail recommandés

| Lot | Livrable précis | Dépendance | Gate |
|---|---|---|---|
| **P0-A** | Audit des surfaces Studio : instance du triangle blanc et de la pelouse clignotante, sans destruction | Place KC35 installée | cas reproductible identifié par nom et transform |
| **P0-B** | `RoadNetwork` versionné : 6 axes, carrefours, éventuels anneaux documentés, centres et largeurs | plan source | aucune voie flottante/ambiguë |
| **P0-C** | `PlotInventory` et emplacement candidat des 8 institutions | P0-B | 0 chevauchement non justifié |
| **P0-D** | `ApprovedPlan` + compte-rendu d'acceptation humaine | P0-C | coordonnées et parvis approuvés |
| **P1-A** | génération de sols exclusive, suppression des doublons | P0-D + P0-A | 0 clignotement sur parcours de QA |
| **P1-B** | façades et entrées repositionnées, ancrages migrés | P0-D | tous les seuils reliés au graphe |
| **P1-C** | signalétique physique uniquement | P1-B | 0 `BillboardGui` géographique, 0 texte horaire |
| **P1-D** | orchestrateur + adaptateurs de branches | P1-A/B/C | 9 contributions identifiées et 16 IDs de portes cohérents |
| **P2-A** | restauration artistique ciblée V30 par zone | P1-D | comparaison caméra validée |
| **P2-B** | staging multi-Place + mobile + diffusion | P2-A | tests en client publié + plan de rollback |

## 3. Tests automatiques hors moteur

- **Contrats source** : schema, clés de Place, IDs, réciprocités de portes, correspondance bâtiment↔parcelle, catalogue asset versionné.
- **Géométrie** : plan polygonal, collisions bâtiment↔rue et bâtiment↔bâtiment, recul, surplombs, couverture et connexité chemins.
- **Surface** : pas de deux propriétaires visibles au même XY avec Y compatible dans la tolérance définie ; détecter les rectangles/triangles incohérents et intersections de voies non fusionnées.
- **Signage** : texte public sans heures/cadran, sans `BillboardGui` géographique ; `support_id` physique ; pas de doublons.
- **Reproductibilité** : mêmes inputs + seed = même plan canonique ; aucun déplacement silencieux d'ancre.
- **Preuves** : rapport par build avec erreurs classées en `BLOCKER`, `REVIEW`, `INFO` ; pipeline refuse la génération si `BLOCKER` non résolu.

Un projet Python reproductible peut porter ces tests, mais l'exécution `shapely` sur l'IR **ne garantit jamais la réalité des collisions de MeshParts importés**.

## 4. Campagne Studio minimale

Pour les six avenues et huit parvis : captures **avant/après** identiques, stationnaire et en marchant, angles bas et hauts, graphismes bas et hauts. Ajouter une session client tactile, vérification du spawn et des retours, une traversée de chaque intersection, accès au monument et absence de panneau flottant. Un seul bug visuel reproductible sur l'axe principal bloque l'acceptation de la finition urbaine.

**Critères quantifiables proposés :** 0 intersection non autorisée ; 0 panneaux géographiques `BillboardGui` ; 0 références d'heure dans l'UI de destination ; 8/8 accès aux façades ; 16/16 IDs de portes cohérents ; 9/9 contributions reprises sans erreur ; 0 remplacement du Package central. Les mesures FPS/chargement/mobile seront **rapportées, jamais inventées**.

## 5. Comment migrer depuis la Place locale existante

1. Ne jamais écraser `KinCity_35.rbxl` : conserver **snapshot et source** de l'existant ; sauvegarder `KinCity_AssetsMaster.rbxl` séparément.
2. Construire la version KC36 dans **une nouvelle Place locale de validation** ; ne pas modifier la Place en production ni la master assets.
3. Écrire un manifeste de migration : avant/après des huit parvis, des façades et des ancrages ; conserver les IDs mais recalculer les coordonnées dépendantes.
4. Tester la carte en **greybox**, avant import de décor. Comparer les obstacles et le graphe de navigation.
5. Réinsérer les façades et 121 modèles **par le Package central** après validation des collisions spatiales ; mesurer le rendu.
6. Activer une branche à la fois avec journal de résultats ; enregistrer la révision exacte du Package.
7. Ne proposer une publication de staging que si les checklists Studio et droits sont terminées.

## 6. Risques et décisions de rollback

- **Déplacement d'une institution** : conserver l'ancienne révision KC35 en fichier local et l'ensemble des ancres d'origine dans le rapport de migration. Le rollback revient à l'ancien plan, pas à un patch partiel de hauteur.
- **Clignotement** : ne jamais masquer la totalité des sols par transparence lors de la publication sans certificat de cause.
- **Package central** : enregistrer version visuelle + PackageLink ; ne pas dépaqueter et modifier les sources dans les consommateurs.
- **Branches** : conserver le handoff d'origine et la version d'adaptateur ; aucune publication de Places imaginaires ou non testées.

## 7. Définition de « fini »

Une refonte est finie seulement lorsque : la ville est lisible à pied, les édifices ne chevauchent pas les axes publics, le sol ne scintille pas en déplacement, les panneaux sont physiques et appropriés, V30 n'est plus visuellement supérieure sur les points de comparaison approuvés, les portes marchent, et le package central reste versionné. Sans tests réels sur Studio et client publié, le statut est **candidat non qualifié**, pas « production prête ».
