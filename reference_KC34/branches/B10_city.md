# B10 — VILLE CENTRALE `city` / SIX SECTEURS

**Branche recommandée :** `kc34/B10-city`  
**Place Roblox :** `city` — **neuvième Place du catalogue et dixième branche**.  
**Autorité technique commune :** B09; **interfaces** : huit portes qui entrent dans les Places B01–B08.

## Contexte non négociable
Tu es un agent travaillant dans un programme **parallèle** de dix branches sur la baseline Kin City KC33. Lis intégralement `BIBLE_KINCITY_REFERENCE_IA_KC34.md`, le ZIP KC33, `contrats/index_machine.json`, `contrats/empreintes_kc33.json` et la présente fiche. Ne déduis aucun contenu d’un autre chat non joint. Tu n’as pas le droit de renommer une clé canonique ni de supposer que les autres IA partagent ton état. Zéro modification de production, aucun PlaceId inventé, aucune API KOALI prétendument fonctionnelle, aucune mesure fictive.

## Règles de livraison
Fournis un patch/ZIP de sources réelles, les chemins modifiés, une raison par modification, des tests positifs et négatifs réellement exécutés, les limites, les captures si tu as accès à Roblox Studio, une liste de régressions et un `handoff` conforme à `protocoles/handoff_modele.json`. Remets à B09 tout changement `SHARED` ou `BREAKING` avant de l’appliquer au tronc commun. Si tu ne peux pas tester Roblox, marque explicitement `NON_TESTÉ`. Évite les modifications ornementales qui augmentent le budget sans améliorer l’expérience.

## Périmètre
Tu prends possession créative/technique de la **Place Koali**, des six secteurs périphériques, des huit façades extérieures, des 18 pavillons, des voies piétonnes, des six grandes avenues radiales, des accotements et repères chromatiques, des espaces publics, transports et mobiliers. Les huit intérieurs ne font pas partie de ta Place en mode `MULTI_PLACE`; B01…B08 les construisent séparément.

## Invariants urbains
- 6 accents stricts selon `HexagonalDistricts.luau` : keenKonnect `#D0BF86` 12h; ethiKos `#A97C4F` 2h; Kreative `#CB809D` 4h; UCKK `#758EA6` 6h; Ekole `#E5EAE7` 8h; KonnectED `#BC674C` 10h. Accent commun `#1E6864`.
- 8 façades au lieu exact de `catalog/spatial.json`; 8 portes d'entrée et 8 anchors de retour intacts dans `catalog/doors.json`. **Ne pas renommer** `city.konnected.university.entry` malgré le secteur UCKK.
- 18 pavillons aux formes désormais diversifiées en KC33; 8 chemins piétons planifiés, 19 obstacles canoniques et 6 avenues à préserver ou modifier seulement après diagnostic de dégagement.
- Le pavage Art déco importé est décoratif/non-collidable au-dessus des surfaces de marche natives; ne pas substituer les sols de gameplay par un mesh fragile.
- L'ancienne bibliothèque de bus, trams, véhicules et ferrys n'est pas automatiquement un service actif. La circulation doit avoir un modèle explicite (piéton prioritaire, routes, traversées, stations, trajectoires).

## Ordre de travail
1. Extraire un plan topologique et un inventaire des huit façades, huit entrées, six hubs, dix-huit pavillons et huit chemins. Produire une carte de conflits 2D et vérifier la hauteur de chaque filet de highlight.
2. Construire une charte visuelle transverse Art déco qui coordonne six accents, sarcelle commun, matières, motifs, signalétique, couronnements, lumière et repères accessibles aux daltoniens; l'approuver en B09 avant propagation dans les intérieurs.
3. Vérifier et enrichir l’intégration des modèles de rue : 5 modèles de rue/pont du pack, insertions KC33, quotas `paving`/`street`, rotations, joints, pivots et répétition visuelle; ne pas remplir le monde inutilement.
4. Vérifier les huit façades et points d'entrée de la ville en conditions de traversée, avec les huit agents d'intérieur pour les transitions; les portes visibles doivent correspondre aux vrais anchors.
5. Curater mobilier (bancs, fontaines, jardinières, enseignes, lanternes) et écologie des lumières; optimiser pour mobile. Préparer transports éventuels en phases (décor, station, parcours contrôlé, multi-joueur), sans activer les anciens systèmes sans QA.
6. Produire tests Studio sur une copie, galerie de captures comparables jour/nuit des six secteurs, tableaux de contraste, trace des budgets, benchmark ville seule vs Place unique, et tests d'accès aux huit bâtiments.
7. Préparer une livraison `city` autonome pour B09 en mode staging, **sans aucun intérieur** dans sa génération active. Toute modification de porte/ancre/canon doit passer en RFC B09, avec consultation de la branche de destination.

## Livrable attendu
Plan urbain coté, guide des six palettes, code/patch complet, matériaux et modèles sourcés, table des points d’intérêt et dégagements, preuve de 8 portes et 6 highlights, matrice du mobilier, risques, mesures, rollback, `handoff` JSON. Ne pas prétendre disposer des PlaceIds réels ni d’un client Roblox testé si non accessible.
