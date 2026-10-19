# Spécification géométrique canonique — obligatoire

**Statut : NORMATIF, référentiel spatial d'exemple 8 bâtiments.** Source `catalog/spatial.json`. Le catalogue est une spécification d'entrée *constructible*, mais aucun test exécuté ici ne certifie le rendu Roblox. Les dimensions illustrent une implantation cohérente, non une reproduction mesurée d'un plan urbain réel.

## Conventions
- 1 unité = 1 stud Roblox. Coordonnées XYZ : Y vertical. Sol public Y=0. Angles yaw en degrés autour de +Y ; l'avant d'un modèle regarde son axe local -Z.
- Centre du bâtiment = pivot de son empreinte au sol. `footprint_studs=[largeur X, profondeur Z]`, avant vers le noyau central. Hauteur distincte.
- Plan des places intérieures : rectangle 110×100 studs, plafond Y=22 ; le hall occupe le côté -Z. Les identifiants `rooms` et `anchors` sont permanents.
- La scène ville est un disque limité à un rayon de 495 studs. Ce périmètre est une **donnée d'exemple v3**, non une limite Roblox.
- Pour chaque ancre de porte, fournir position, orientation, destination logique, place et ancre de retour. Les points d'arrivée ne doivent pas coïncider avec des murs ni des props.

## Validation de la géométrie
- Conserver les bâtiments à au moins `envelope_clearance_studs` les uns des autres, selon une enveloppe conservatrice de rayon calculée depuis l'empreinte. Cette condition ne remplace pas une inspection 3D des murs inclinés ni un bake de navmesh.
- Toutes les structures doivent rester dans l'enveloppe de la ville.
- La position d'une ancre doit être à l'intérieur du périmètre de sa Place ; elle doit appartenir à une pièce quand `room_id` est fourni.
- Les rôles (`door`, `interaction`, `spawn`, `hub`) sont validés contre les manifestes de la v2.
- Tout objet décoratif doit pointer vers un asset existant et une pièce existante ; un asset sans générateur réel doit être marqué comme `non_executable`, pas considéré comme livré.
- La compatibilité avec l'avatar R15, les ouvertures de portes et les dégagements doit être prouvée dans Studio ; des bornes calculées à partir de rectangles ne suffisent pas.

## Implantation illustrative
| Bâtiment | Centre XYZ | Empreinte studs | Hauteur studs | Style |
|---|---|---|---|---|
| Hôtel de ville | [0, 0, -100] | [70, 56] | 29 | civic_stone |
| Tour du Savoir | [100, 0, 0] | [42, 42] | 73 | central_glass |
| Grande Bibliothèque | [194, 0, 70] | [78, 62] | 24 | warm_academic |
| Univers-Cité | [306, 0, 142] | [82, 64] | 31 | warm_academic |
| Palais de justice | [0, 0, 242] | [76, 56] | 28 | civic_stone |
| Laboratoire d’innovation | [-230, 0, 84] | [76, 60] | 24 | innovation_glass |
| Musée Kreative | [-202, 0, -180] | [82, 62] | 24 | cultural_copper |
| Centre administratif | [135, 0, -239] | [72, 56] | 26 | service_brick |

Les pièces sont reliées par des portails dimensionnés (`clear_width_studs`) et contrôlés comme graphe connexe. Le passage réel de l'avatar et les ouvertures de murs restent à confirmer dans Roblox.

Le plan complet des pièces et coordonnées des ancres est dans `catalog/spatial.json` (source de vérité). Les plans visuels dessinés doivent être générés **à partir** de ce fichier, et non maintenus comme une seconde source concurrente.
