# Kin City v29.0.0 — livraison cumulative à partir de v28.0.1

## Référence et périmètre

Source **réelle** : archive `KinCity_Source_Construction_v28.0.1 (1)(2).zip`, 454 entrées. Aucune v29 antérieure supposée ni intégrée. Les autres pièces jointes v27 et King Klown v6 n'ont pas remplacé la v28 officielle (l'archive contient King Klown v7). La séparation « une ville / huit institutions » est conservée ; les catalogues des portes, ancres et interactions n'ont pas été migrés et aucun identifiant publié, asset ou kOA n'a été ajouté.

## Changements réalisés dans les sources

| Domaine | Modification | Limite mesurable |
|---|---|---|
| Sol | `GroundCompatibility` v28.0.1 conservé : déplacement conservatoire d'une Baseplate affleurante, sous critères stricts ; pas de destruction du Terrain. Sol de place centrale à collision cohérente. | La Baseplate n'a pas été observée dans Studio, sa culpabilité reste hypothétique. |
| Chemins | `catalog/central_furniture.json` est un registre commun pour la fontaine, 7 bancs, 7 jardinières, 2 sculptures, monument et enseigne ; `compile_plan.py` produit des parcours évitant leurs zones, avec marge. `CityGenerator` et `UrbanDetails` utilisent ce registre. Les rectangles de pavement non superposés sont fusionnés par raster de 2 studs, y compris aux jonctions de trajets. | Sur le plan v29 fourni : 8 parcours, 19 obstacles ; **23 rectangles de pavage après union** calculée, au lieu des **48 segments individuels** des itinéraires de la v28. Ce ne sont pas des FPS. |
| Jonctions / décor | Les segments annulaires et radiaux sont raccourcis aux jonctions (pas de chevauchement longitudinal) et évitent la zone des chemins principaux. Filigranes opalins fusionnés par intervalles collinéaires, avec une hauteur différenciée aux croisements transversaux ; jalons au sol dedupliqués. | Sur le plan livré : **31 intervalles collinéaires** dérivés de **48 segments de chemin**. Les croisements d'autres modules restent à inspecter visuellement. |
| Signalétique | Une cible par institution, dédoublonnée, panneaux de largeur 19 étudiés avec marge de 13 et 25/26 studs d'espacement, zone de l'apparition laissée libre ; implantation de secours sur couronne si nécessaire. | Test géométrique local : 8 emplacements trouvés, aucun dans l'enveloppe simplifiée des 8 structures. Orientation physique exacte à confirmer dans Studio. |
| Apparition et caméra | Source canonique de l'apparition conservée (`city.central.spawn`, 0,3,-16), `SpawnLocation` calculé depuis l'ancre, placement serveur puis attribution `KinArrivalFrame`, arrivée caméra après ce signal sur chaque personnage. Occlusion native `Invisicam`. Panorama restaure type, cadrage, FOV et sujet ; sortie sur changement de zone ou respawn, barre mobile redimensionnée. | Mouvements de caméra, clips et collisions non exécutés dans Roblox. |
| Menu | Menu commun Kin City avec carte, lieux, bibliothèque, gare, carnet, galeries, ateliers, ciel, carnet de voyages, qualité et performance. Fenêtres exclusives, bouton ✕ par outil, fermetures clavier/manette ; contenu défilable et tailles limitées au viewport. Deux compteurs purement secondaires rassemblés dans Indicateurs. | L'affichage des dialogues et du récit reste hors du gestionnaire d'outils. Éprouver manette et téléphone en Studio. |
| Guide / visite | Aucune destination choisie au chargement ; bibliothèque proposée dans le menu, activation volontaire, guide bibliothèque et guide destinations mutuellement exclusifs via `KinGuideMode`; sélection nouvelle ou fermeture permet de changer ou masquer. Indication claire des portes en aperçu non publié. | Le parcours du récit, les objets et les portes du livre sont inchangés. |
| Touches | G réservé au geste de King Klown ; panneau gare déplacé sur H après inspection des scripts client. Mention des raccourcis actualisée. | Tests de présence et non-collision statiques. |
| Mesure locale | Nouveau `LocalPerformanceProbeV29.luau`, 20 secondes opt-in, échantillons RenderStepped, FPS moyen calculé sur moyenne des durées d'images, médiane et p95 du temps/image, mention d'un changement de zone/qualité ou d'un échantillon incomplet. Aucune transmission. | Aucune mesure FPS réelle, donc aucun gain FPS affirmé. |

## Vérification reproductible (hors moteur)

```bash
python tools/validate_catalog.py
python tools/validate_spatial.py
python tools/validate_v28_journey.py
python tools/export_roblox.py
python tools/build_release.py
python -m unittest discover -s tests -p 'test_v29_comfort.py' -v
python tools/check_luau_structure_v29.py
python -m unittest discover -s tests -v
python tools/check_luau_syntax.py
```

### Résultats observés dans cet environnement

- `validate_catalog.py`, `validate_spatial.py`, `validate_v28_journey.py` : **valides** (les avertissements sur les PlaceIds non publiés sont attendus en aperçu local).
- `test_v29_comfort.py` : **13 tests réussis** (géométrie du plan, obstacles, panneaux, absence de conflit G/H, menu/guides, mesure locale, intégrité des identifiants).
- Suite Python totale : **87 tests découverts, 84 réussis, 3 erreurs d'importation** (`test_ground_arrival.py`, `test_v27_reliability.py`, `test_v28_journey.py`) car le module **`lupa` est absent**. Aucun échec d'assertion parmi les 84 tests exécutés. Les traces se trouvent dans `build/v29-unittest-full.log`.
- `check_luau_structure_v29.py` : contrôle lexical, délimiteurs, chaînes et commentaires sur les sources et installateurs **sans erreur détectée**. Ce vérificateur **ne remplace pas un parseur Luau**.
- `check_luau_syntax.py` : grammaire complète **non exécutée faute des modules `tree_sitter` et `tree_sitter_luau`**. La tentative d'installation des dépendances via pip a échoué faute d'accès réseau. Les scripts client et serveur **n'ont pas été compilés ni exécutés par Roblox**.
- Aucun FPS mesuré, aucune collision observée dans le moteur, aucun téléport réel testé. Les nombres de segments/pièces représentent seulement les calculs hors moteur.

Les dépendances des trois tests Python et du parseur peuvent être installées en environnement connecté via `requirements-dev.txt`, avant de relancer les commandes.

## Installation, intégrité et retour arrière

Consulter `NOTICE_V29.md`. La reconstruction par Command Bar **remplace les retouches de `KinCityGenerated`**, ne prétend pas restaurer une scène précédente et ne crée pas de PlaceId. Le ZIP source d'origine v28.0.1 conservé séparément constitue le point de retour arrière. Les copies d'installateurs historiques v28 sont maintenues dans le projet mais ne doivent pas être utilisées pour obtenir la v29.

## Validation Roblox Studio encore requise

- Exécuter l'installateur en mode Édition puis Play dans une Place dupliquée ; vérifier la sortie de compilation Luau (client/serveur), l'absence d'erreur et la stabilité d'une deuxième génération.
- Tester l'apparition initiale, réapparition après la mort, orientation et visibilité de King Klown, passage derrière fontaine, monuments et bâtiments, et les cas d'occlusion native.
- Examiner avec une caméra en mouvement le clignotement du gazon, limites de la Baseplate archivée, fissures ou joints des couronnes radiales et des filigranes ; traverser les revêtements et relever d'éventuelles collisions.
- Vérifier les 8 panneaux, leurs faces lisibles, les dégagements et la cohérence avec le chemin qui évite le mobilier et laisse l'interaction des portes ouverte.
- Tester menu, zoom et panorama après navigation/respawn au clavier, tactile et manette ; vérifier clavier G/H, touches Select/B, fenêtre unique et accessibilité des récits.
- Valider séparément la bibliothèque, les 3 fragments, les retours et la persistance de session. Tester les téléportations **uniquement après** configuration des véritables PlaceIds et publication réelle des 9 Places.
- Faire des mesures 20 s dans des conditions comparables (même machine, zone, qualité), sans déduire de FPS depuis les seules réductions de pièces.
