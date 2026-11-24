# B10 — Plan directeur de la Place centrale

## Statut

V1/B10 est **une contribution de couches d'orientation et un plan d'intégration**. Ce n'est pas une reconstruction de la ville entière. Les façades et pavés Art déco KC33 existants doivent être conservés. Les pièces ajoutées dans la proposition B10 sont des éléments procéduraux Roblox : aucun modèle GLB commercial nouveau, aucune conversion de voie en chaussée roulable.

## 1. Topologie conservée

Ville circulaire à six axes : 12h keenKonnect, 2h ethiKos, 4h Kreative, 6h UCKK, 8h Ekole, 10h KonnectED. Centre commun sarcelle. Six avenues radiales entre r~62 et r~442 studs; huit chemins piétons issus du centre et menant aux entrées des huit institutions; 18 pavillons thématiques existants. Ces contrats sont **lus** depuis `WorldPlan` et `HexagonalDistricts`, non recopiés sous de nouveaux identifiants.

## 2. Matrice chromatique

| Secteur | Accent | Orientation | Signal secondaire non coloré |
|---|---|---|---|
| keenKonnect | `#D0BF86` | Nord, 12h | Keen / Conception |
| ethiKos | `#A97C4F` | Nord-est, 2h | Éthique / Débat |
| Kreative | `#CB809D` | Sud-est, 4h | Kultur / Création |
| UCKK | `#758EA6` | Sud, 6h | Campus / Apprentissage |
| Ekole | `#E5EAE7` | Sud-ouest, 8h | Éducation / Savoir |
| KonnectED | `#BC674C` | Nord-ouest, 10h | Parcours / Transmission |

**Couleur institutionnelle transversale :** sarcelle `#1E6864`. La teinte seule ne suffit pas : chaque borne comporte le nom du secteur et son heure. La typographie Art déco gotham utilise une colonne orientée, un cadre et un cartouche; tester spécifiquement Ekole avec texte clair sur fond sombre.

## 3. Cheminements et arrivées : analyse statique V3

| Destination | Écart extrémité du chemin → point de retour ville (XZ) |
|---|---:|
| Accueil / Hôtel de ville | 2,3 studs |
| Tour EkoH | 4,7 studs |
| Palais de justice | 4,3 studs |
| Laboratoire d'innovation | 3,7 studs |
| Bibliothèque | 4,6 studs |
| Campus UCKK | 4,5 studs |
| Musée Kreative | 6,3 studs |
| Centre Orgo | 2,7 studs |

Ces distances de plan indiquent la proximité des références, **pas** une collision ou navigabilité prouvée dans Studio. Les noms historiques des IDs de la bibliothèque/campus doivent demeurer inchangés même s'ils évoquent un autre quartier.

## 4. Construction proposée

- `Wayfinding.luau`: six totems minimum plus huit repères d'accès, avec mode d'affichage par profil LITE/STANDARD/SHOWCASE.
- Tous les objets sont non-collidables, non-touchables, non-query et sans ombre. Pas de lumières dynamiques supplémentaires. Les messages d'orientation sont visuels, non des interactions actives.
- Avenues : positionnement radial dans les accotements, déport 35 studs; si structure ou ancre à moins du dégagement requis, essaie l'autre côté. 18 positions possibles en SHOWCASE, validation géométrique statique sur la base fournie.
- Entrées : signalisation issue des huit portes canoniques et de leurs `return_spawn`, sans déplacement d'une seule ancre. Le code n'installe aucun ProximityPrompt de transport.
- Absence d'asset commercial requise : l'aperçu fonctionne même sans nouveau mesh du pack Art déco, pour ne pas rendre plus fragile l'installateur KC33.

## 5. Avenues / transports / étapes ultérieures

**Conservé** : dalles piétonnes, bordures, pavage du pack KC33, chemins, lampadaires, circulation piétonne, accès aux bâtiments. **Non construit dans cette passe** : tramway opérationnel, réseau bus, voies motorisées, véhicules Art déco roulants, feux de circulation pilotés. Ne pas les annoncer comme actifs.

**RFC B10-002 à préparer** après tests terrain : plan cotée des intersections, parcours séparés des piétons, stations, traversées, navettes éventuellement scénarisées. Mesurer le coût LOD, collisions et présence de foule avant activation des scripts historiques.

**RFC B10-003 à préparer** : finition visuelle des façades, inventaire des 80 assets Art déco KC33 encore en bibliothèque, performance par quartier, hauteur des repères colorés et continuité des surfaces. Les façades ne bougeront que sur une demande explicite approuvée B09 + la branche d'intérieur correspondante.

## 6. Critères d'acceptation B09

A. Vue compile hors moteur : 6/6 secteurs, 8/8 entrées, 8/8 chemins, 16/16 portes inchangées, pas de production. B. Studio local : 3 profils, lisibilité et intersections jour/nuit, absence de collisions, aucune disparition des pavillons et façades. C. Staging publié : 8 aller-retour client, performance mobile comparée à KC33, rollback opérationnel. Le stade A seul est actuellement couvert.
