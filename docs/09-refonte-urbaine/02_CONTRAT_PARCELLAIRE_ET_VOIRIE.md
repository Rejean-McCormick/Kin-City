# 02 — Contrat parcellaire : plus aucun bâtiment sur une voie

## 1. Problème démontré par l'audit KC35

Dans le code courant, `CityGenerator` construit des façades à partir de `plan.structures` **avant** `KoaliUrbanism.make(city,plan)`, qui dessine ensuite six avenues sur des axes décidés indépendamment des bâtiments. La fonction `KoaliUrbanism.occupied` évite des sites de pavillons, mais ne repositionne **pas** les huit édifices canoniques. Résultat : leur enveloppe peut occuper la bande d'une avenue.

### Résultat mesuré sur l'IR KC35

Méthode : polygone tourné des empreintes `footprint_studs` à `center_studs`/`yaw_degrees`, intersection avec six bandes droites de **19 studs** centrées sur r=62…442. Les croisements ont une **surface positive** même avec un dégagement de sécurité de zéro. Les chiffres ne sont **pas** des collisions moteur Roblox ni un relevé des murs : la géométrie effectivement visible peut différer du rectangle enveloppe. La comparaison par enveloppe ne tient pas compte du relief ou d'un tunnel/pont.

| Édifice | Avenue actuelle | Aire commune estimée (studs²) | Priorité de revue |
|---|---|---:|---|
| Bibliothèque | KonnectED | **1181,4** | Critique |
| Hôtel de ville | Kreative | **1020,1** | Critique |
| Musée | Kreative | **785,0** | Critique |
| Campus | UCKK | 57,0 | Revoir |
| Maison Orgo | ethiKos | 41,7 | Revoir |
| Atelier Konstruct | keenKonnect | 3,5 | Revoir |

**Cible KC36 proposée : 0 intersection non autorisée** pour bâtiment vs route, trottoir protégé, voie de secours, chemin accessible et parvis réservés. Les trois intersections majeures sont les premières à traiter en *greybox*.

## 2. Définitions à rendre testables

- **Route** : bande surfacique orientée, calculée depuis un polyline et une largeur ; inclut chaussée/dalle, emprise utile et réserves spécifiques.
- **Trottoir** : bande dédiée aux piétons, éventuellement contiguë à une voie ; même statut d'occupation que la route.
- **Parcelle** : polygone constructible avec `lot_id`, district, accès public et recul ; ne dépend pas du nom d'un bâtiment.
- **Bâtiment** : empreinte OBB/polygone + zones de surplomb/escaliers/emmarchement, plus encombrement visuel projeté.
- **Parvis** : zone intermédiaire entre voie, trottoir et porte, qui appartient au domaine public ou possède une servitude accessible. Il **ne doit pas être produit après** un lampadaire qui occuperait sa place.
- **Clearance** : enveloppe de sécurité dilatée *séparément* selon usage (circulation, accessibilité, maintenance, effet visuel).
- **Niveau de voie** : paire `(layer, elevation)` pour pont, tunnel ou passerelle. Une intersection en vue de dessus n'est acceptable **que si** elle a un contrat 3D attesté, un dégagement vertical et une intention d'infrastructure.

## 3. Ordre des autorités géométriques

1. Réserver l'île/le rivage et les contraintes fortes (`coastline`, limites, eau).
2. Réserver les accès publics majeurs (`major_road`, boulevard/avenue, anneau, chemin, traversée).
3. Réserver la zone autour du spawn, les intersections et les perspectives monumentales.
4. Construire des polygones de **parcelles candidates** hors de ces réservations.
5. Choisir les parcelles d'institutions et vérifier leur accès à pied, au plus court depuis le réseau.
6. Placer la façade et calculer sa rotation **à partir de la bordure/parvis**, avec correction d'angle selon style, jamais à partir d'un yaw esthétique isolé.
7. Poser les marches/rampe/parvis, puis reboucler les accès vers le graphe de marche.
8. Placer le mobilier, la végétation, les enseignes et les éléments temporaires uniquement dans l'espace non réservé.

## 4. Contraintes de vérification proposées

| Invariant proposé | Calcul hors moteur | Preuve Roblox |
|---|---|---|
| Pas d'emprise bâtiment/voirie | intersection polygonale area=0, sauf exception 3D approuvée | aucun mur/colonne dans la voie |
| Parvis débouche sur trottoir | extrémité d'accès connectée au graphe piéton | avatar R15 passe sans sauter |
| Dégagement de porte | tampon autour de chaque porte et spawn ; aucun obstacle non déclaré | aller/retour + caméra |
| Sentier principal continu | graphe des segments et intersections connexes | boucle complète à pied |
| Aucun élément décoratif opaque dans cône de visibilité | test de cône/segment (préfiltrage) | vue au sol jour/nuit |
| Bâtiment dans l'île | polygone/îlot inclus dans domaine constructible | façade entièrement portée par le sol |
| Mobilier hors emprise | tests des AABB/OBB et des réservations | trottoir disponible tactile/manette |
| Parvis sans surépaisseur | un seul titulaire du plan de collision, hauteurs compatibles | aucun scintillement en mouvement |

**Valeurs provisoires à faire adopter :** largeur libre de voie piétonne *au moins 8 studs* sur axes publics, bande de marche *au moins 6 studs* sur accès institutionnel, recul préliminaire *4 à 10 studs* selon le lieu, zone de dégagement préliminaire *6 studs* autour des portes. Ce sont des cibles de design **non certifiées** ; R15/mobile/accessibilité doivent les justifier ou les modifier. L'ancien `entrance_clearance_studs=10` reste une propriété de l'IR existant, sans préjuger de sa conformité.

## 5. Contrat de parcelle proposé (machine-readable)

Voir `contrats/site_manifest_EXEMPLE.json` et `contrats/site_manifest.schema.json`. Il distingue `site_id`, parcelle, building, route principale, `frontage_edge`, `entry_path`, `setback`, `reserved_polygons`, `geometry_layer`, `source_revision`, `approval_state`. **L'exemple n'est pas une relocalisation approuvée** : il contient un `transform_status=PROPOSED_NOT_APPROVED`, des coordonnées de l'état actuel en contexte, et aucune nouvelle coordonnée inventée.

```text
LotAllocator.choose(roads, constraints, candidateLots)
  -> PlacementCandidate[]
  -> validateFootprintClearance(candidate)
  -> validateWalkGraphConnection(candidate)
  -> score(sightlines, identity, accessibility, density)
  -> DESIGN_REVIEW
  -> ApprovedSitePlan
```

Aucune génération de façade ne peut consommer une `PlacementCandidate` non approuvée. Les erreurs échouent le build en mode `strict`, pas une simple ligne de log invisible.

## 6. Cohérence de la migration

Les positions et ancres actuelles appartiennent à l'ancien contrat `KC34-DOC-1.0`. Déplacer les édifices dans une refonte KC36 exige **une révision majeure du contrat géométrique**. Une passe de compatibilité doit recalculer : façades, portes physiques, `city.*.front_door`, `city.*.return_spawn`, trajet depuis le spawn, placement des rampes et dégagements. **Ne pas changer les IDs** de bâtiments, portes, interactions et places ; changer les coordonnées avec migration déclarée et tests des seize routes. B09 orchestre le changement et B10 reçoit seulement le plan approuvé.

## 7. Critères de livraison

Le dernier placement ne doit plus être celui qui « semble bon » après un patch. Livrer : `road_network`, `plot_inventory`, `site_assignments`, `conflict_report`, une image de dessus, les chemins vers les huit portes, captures avant/après et avis de revue. Le ticket se ferme seulement quand **aucune intersection illégale** n'est déclarée par le validateur et que l'inspection Studio confirme l'absence de collision visible.
