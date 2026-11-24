# 05 — V30 comme référence esthétique ; une signalétique architecturale

## 1. Décision utilisateur

Le rendu KC35 ne peut pas être qualifié de progrès au seul motif qu'il importe 121 GLB et connecte neuf contributions. **La lisibilité et la silhouette de V30 sont la référence qualitative prioritaire**. Les modules KC35 peuvent rester techniquement utiles, mais leur valeur artistique doit être prouvée par comparaison à caméra, luminosité et distance équivalentes.

## 2. Ce qui a été explicitement refusé

- **Aucun panneau flottant, dynamique ou camera-facing** de type `BillboardGui` servant à désigner un secteur ou une institution.
- **Aucune heure comme nom** : « 10 H », « Secteur • 10 H », « 4 H » et la logique de cadran n'appartiennent pas à la lecture publique de la ville.
- Aucun cartouche immense qui cache une façade, une rue ou une perspective.
- Aucune répétition arbitraire de la même enseigne sur totem, façade et UI.
- Aucune superposition de textures brillantes qui fait clignoter le sol ou crée des triangles visibles.

## 3. Signalétique autorisée par rôle

| Rôle | Support | Information | Règle |
|---|---|---|---|
| `institution_primary` | enseigne intégrée à la façade | nom réel du lieu | une par façade principale |
| `district_entry` | borne physique sur socle | nom du secteur, éventuellement destination | hors emprise piétonne, format sobre |
| `path_decision` | flèche/panneau physique au croisement | direction + nom du lieu | seulement si besoin de décision, pas en doublon |
| `local_interaction` | prompt proche d'un meuble | action, pas publicité | neutre et peu encombrant |
| `museum_broadcast` | écran physique près de B07 | diffusion / état réel | écran lisible de la route, porte barrée |
| `temporary_event` | emplacement autorisé, expiration | programme de l'événement | pas d'ancrage au visage/caméra |

Les seules UI en surimpression acceptable sont les contrôles réellement interactifs du jeu (ex. menu), **pas des pancartes géographiques**. Les matériaux, palettes, taille et face visible viennent du `SignTheme` commun ; l'archive `ARCHITECTURE_PANCARTES_V31_7.md` demeure une source précieuse pour le **SurfaceGui fixé à une Part physique**, non pour le BillboardGui B10.

## 4. Gouvernance des enseignes

Chaque panneau a `sign_id`, `owner_building_id|sector_id`, `role`, `support_id`, `frontage_edge`, `legibility_distance`, `palette_key`, `text_key`, `priority`, `revision`. Le validateur refuse : panneau sans support ; heures/cadran dans le texte affiché ; panneau devant une porte ; duplicate `institution_primary` ; collision avec trottoir ; support créé après un élément occupant sa place.

La composition doit passer trois angles à pied (approche, à 45°, depuis le trottoir) et jour/nuit. **Des lettres flottantes à l'intérieur du monde qui sont un composant géométrique d'une façade** peuvent être acceptées si elles sont physiquement portées ; c'est la UI dynamique camera-facing qui est interdite.

## 5. Protocole comparatif V30 / KC35 / KC36

Créer pour chaque secteur 4 caméras déterministes : (1) spawn, (2) entrée d'avenue, (3) milieu d'avenue, (4) entrée principale d'institution. Capturer V30, KC35 et le greybox KC36 **avec même FOV, réglage graphique, heure et qualité**. Classer pour chaque paire : silhouette, rapport façade/route, densité au sol, orientation des portes, contrastes, panneaux, harmonisation du mobilier, confort de marche. Sans image V30 comparable, statut `NON_COMPARÉ`, jamais « restauré ».

## 6. Chantiers artistiques après stabilisation des emprises

- Obtenir une trame de voies claire et régulière avant de raffiner la texture.
- Valider les proportions des éléments Art déco 121 GLB par gabarit, leur pivot et leur échelle dans les façades.
- Réduire les enseignes autonomes : privilégier noms sur linteaux, marquises et frontons.
- Consolider la palette commune `#1E6864` avec accents de quartier sans saturation généralisée.
- Éclairer les circulations, portes et monuments : l'éclairage identifie, ne masque pas les problèmes de géométrie.
- Rendre le musée fermé mais accueillant, avec un véritable espace d'attente public devant l'écran, non un écran posé sur la circulation.
