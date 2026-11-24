# B05 — Agora Korum / `justice_palace`

**Branche recommandée :** `kc34/B05-justice-palace`  
**Périmètre unique :** Place Roblox `justice_palace` (une des huit Places intérieures); **pas** la façade extérieure.  
**Propriétaire de façade :** B10; **autorité de contrats :** B09.

## Contexte non négociable
Tu es un agent travaillant dans un programme **parallèle** de dix branches sur la baseline Kin City KC33. Lis intégralement `BIBLE_KINCITY_REFERENCE_IA_KC34.md`, le ZIP KC33, `contrats/index_machine.json`, `contrats/empreintes_kc33.json` et la présente fiche. Ne déduis aucun contenu d’un autre chat non joint. Tu n’as pas le droit de renommer une clé canonique ni de supposer que les autres IA partagent ton état. Zéro modification de production, aucun PlaceId inventé, aucune API KOALI prétendument fonctionnelle, aucune mesure fictive.

## Règles de livraison
Fournis un patch/ZIP de sources réelles, les chemins modifiés, une raison par modification, des tests positifs et négatifs réellement exécutés, les limites, les captures si tu as accès à Roblox Studio, une liste de régressions et un `handoff` conforme à `protocoles/handoff_modele.json`. Remets à B09 tout changement `SHARED` ou `BREAKING` avant de l’appliquer au tronc commun. Si tu ne peux pas tester Roblox, marque explicitement `NON_TESTÉ`. Évite les modifications ornementales qui augmentent le budget sans améliorer l’expérience.

## Identité, ancrages et promesses à préserver
- `building_id`: `ethikos.justice_palace` ; `district_id`: `ethikos` ; `place_key`: `justice_palace`.
- Modèle d'intérieur: `civic.justice.interior` ; façade par B10: `civic.justice.frontage`.
- Porte de ville : `city.ethikos.justice_palace.entry` ; ancre ville `city.ethikos.justice_palace.front_door` → arrivée `justice_palace.lobby.spawn`.
- Porte de sortie : `justice_palace.exit` ; ancre sortie `justice_palace.exit.door` → retour ville `city.ethikos.justice_palace.return_spawn`.
- Interaction fonctionnelle simulée : `ethikos.justice_palace.terminal_01` au point `hall.terminal_01`, `capability_id=ethikos.consultation.list` ; ne pas annoncer l'API externe comme branchée.
- Six salles promises : trois canoniques + trois extensions déterministes. **Ne pas sacrifier les quatre passages des ailes** ni les ascenseurs/préservations des sols.

## Salles canoniques dans le plan KC33
- `justice_palace.chamber` — Salle de délibération
- `justice_palace.gallery` — Salle de consultation
- `justice_palace.lobby` — Hall civique

## Extensions dans `InteriorWings`
- `justice_palace.west_wing` — Salle des témoignages
- `justice_palace.east_wing` — Salle de médiation
- `justice_palace.rear_atrium` — Atrium de la justice

## Ordre de travail spécifique
1. Reconstruire sur une copie KC33 le plan des six salles, positions et passages; déclarer les volumes utilisés, dégagements, points de lumière et ligne de vue entrée→sortie.
2. Proposer une direction artistique distincte mais strictement Art déco/Koali, en utilisant la palette structurelle commune et seulement l'accent du secteur si applicable; préserver la lisibilité des cheminements.
3. Enrichir les six salles avec une curation des modèles réels du pack, sans imposer les assets `library_only` et sans transformer le décor en collider de gameplay.
4. Garder la porte de retour à l'ancre prévue et le comportement du mécanisme partagé; tester la présence et le prompt de chaque interaction, escalier/ascenseur, et retour à l'extérieur dans les conditions permises.
5. Définir une recette **paramétrée par `place_key`** sous `contrib/places/justice_palace/` ou module local équivalent; ne jamais forker `WorldBuilder`, `PlayerTravel` ou `InteriorWings` juste pour cette Place.
6. Rendre une fiche UX salle par salle (but, perception, interaction, trajet, contraste, mobile), un budget par profil et un paquet de preuves. Faire un test négatif sans mesh Art déco.
7. Préparer le déploiement en Place séparée pour un futur PlaceId Roblox réel, mais garder la version `LOCAL_UNIVERSE` comme base de secours.

## Critères d'acceptation propres à B05
- 6/6 salles accessibles, 4 liaisons d'extension ouvertes, aucune dérive d'ID; arrivée et sortie non bloquées.
- Aucune erreur silencieuse en absence d'asset; décor non-collidable si dédié à l'habillage.
- Aucune modification des façades de B10, des portes de B09 ni de la configuration de production.
- Écart entre gabarit initial `110×100` et ailes `InteriorWings` mesuré/décrit; correction éventuelle soumise en RFC B09.
- Tests et limites déclarés, handoff conforme, version de base indiquée.

## Message à remettre à B09
Indique ce qui est fini, les chemins exacts, les dépendances B10, les RFC éventuelles, les statistiques de salles/meshes/prompts, les métriques réelles (ou « NON MESURÉ »), la décision d'acceptation souhaitée et le rollback.
