# B08 — Maison Orgo / `orgo_center` · Contribution isolée

**Version :** `B08-ORGO-0.1.0` · **État :** prototype de décoration exploitable dans une copie Studio locale, non fusionné à B09. **Base effectivement contrôlée dans cette session :** ZIP utilisateur `KinCity_ArtDeco_V3_Complet (1).zip`. Les archives KC33 et B09 générées dans les échanges précédents ne sont pas montées ici : le rebase et la qualification B09 restent obligatoires.

## 1. Périmètre et identité

- `building_id=orgo.admin_center`; `place_key=orgo_center`; `district_id=central` (**aucun septième secteur n'est créé**).
- Deux portes *immuables* : `city.orgo.admin_center.entry` depuis `city.orgo.admin_center.front_door` vers `orgo_center.lobby.spawn`; et `orgo_center.exit` depuis `orgo_center.exit.door` vers `city.orgo.admin_center.return_spawn`.
- Le terminal `hall.terminal_01` possède `interaction_id=orgo.admin_center.terminal_01`, `capability_id=orgo.tasks.browse`, `provider_mode=stub`. Ce prototype n'essaie pas de connecter un vrai service Orgo et n'ajoute pas d'interaction factice.
- Le vestibule, les trois salles canoniques, les trois salles d'extension `InteriorWings`, leurs six passages et les ancres restent inchangés.

## 2. Programme spatial de six salles

| Zone | Centre local (X,Z) | Dimensions X×Z | Proposition B08 | Fonctions conservées |
|---|---:|---:|---|---|
| `lobby` | (0,-29) | 100×34 | Accueil Maison Orgo, repère graphique et orientation | Spawn (0,-32), sortie (0,-45), deux passages |
| `gallery` | (-27,17) | 44×52 | Espace dossiers / parcours documentaire | Terminal canonique (-27,18), deux passages ailes |
| `chamber` | (27,17) | 44×52 | Salle des opérations / coordination | Circulation et table existante |
| `west_wing` | (-79,7) | 52×50 | Atelier de planification, flux et projets | Lien gallery→west via (-51,16) |
| `east_wing` | (79,7) | 52×50 | Bureau communautaire, information associative | Lien chamber→east via (51,16) |
| `rear_atrium` | (0,76) | 100×56 | Atrium commun de découverte des services | Deux ouvertures depuis gallery/chamber |

**Emprise des six salles** dans ce schéma : X ∈ [−105,105], Z ∈ [−46,104]. Le rectangle `bounds` de 110×100 dans le catalogue de base ne couvre pas les extensions. B08 demande une décision B09 via ADR-001 plutôt que de modifier seule `catalog/spatial.json`.

## 3. Direction artistique

Art déco de service public : opale `#E7EEE9`, bronze `#BD945A`, pierre chaude `#DCD2BF`, encre bleu-gris `#263F4C` et **sarcelle commun** `#1E6864`. Cette palette est interne à Maison Orgo, non une couleur supplémentaire de secteur. Un panneau par salle, des sous-titres, des médaillons au sol et pilastres de faible encombrement; qualité progressive LITE / STANDARD / SHOWCASE.

| Profil | Décorations déclarées | Effets ajoutés |
|---|---:|---|
| LITE | 8 | Titres et orientation essentielle |
| STANDARD | 18 | Médaillons, sous-titres, sans lumière dynamique |
| SHOWCASE | 24 | Pilastres supplémentaires, toujours sans ombres ni collisions |

Toutes les Parts décoratives sont `Anchored`, `CanCollide=false`, `CanTouch=false`, `CanQuery=false`, `CastShadow=false`. Les ancrages et les volumes franchissables ne sont pas modifiés. Les coordonnées sont **locales à l'intérieur** et reçoivent `KinInteriorOrigin` pour le mode Place unique.

## 4. Utilisation de la prévisualisation Studio (copie locale uniquement)

1. Ouvrir dans Roblox Studio une **copie locale non publiée** (`game.PlaceId==0`) avec Kin City V3 installée. Sauvegarder une copie `.rbxl` avant essai.
2. Arrêter Play; vérifier l'attribut du monde `KinBuildState=Ready`, `KinRoutingMode=LOCAL_UNIVERSE`, l'intérieur `Intérieur — orgo_center` et les trois ancres locales.
3. Optionnel : dans la Command Bar, régler `workspace:SetAttribute("KinB08Profile","LITE")` ou `"STANDARD"` ou `"SHOWCASE"`.
4. Coller **l'intégralité** de `studio/B08_STUDIO_PREVIEW_LOCAL.luau` dans la Command Bar. Le script refusera les Places publiées, refusera Play, contrôle la Place d'origine, la présence des six salles et les trois ancres. Il n'enlève que sa propre version antérieure `B08_OrgoDecor_V1` après reconstruction réussie.
5. Inspecter visuellement toutes les salles, vérifer l'absence de chevauchements graphiques avec le décor préexistant, les collisions, le chemin de retour, la lisibilité des panneaux, le temps d'affichage et l'effet mobile.

**Attention** : aucun test Studio n'a été effectué dans cette session. Les panneaux `BillboardGui` devront être revus visuellement. En mode multi-Place staging, **ne pas réutiliser cet installateur** : le filtre `PlaceId==0` est volontaire, et il faudra une intégration B09 dédiée avec les gardes de publication.

## 5. Code, contrats et intégration

- `scene_recipe.json` : 6 zones, ancres/passage protégés, 24 éléments graphiques, qualité par profil.
- `src/generate_preview.py` : construit l'installateur sans API réseau ni AssetId; aucun mesh commercial n'est distribué.
- `studio/B08_STUDIO_PREVIEW_LOCAL.luau` : prévisualisation locale sécurisée et idempotente; écrit uniquement sous le Model Orgo.
- `asset_plan.json` : 7 recommandations du pack Art déco réel, **NON CLONÉES**, à budgéter par B09. Le nombre de triangles listé provient du manifeste source, pas d'un profilage GPU.
- `recipe.json` : squelette conforme au format B09 précédent, gardé `NOT_CONNECTED_TO_WORLD_BUILDER` pour empêcher toute fausse affirmation d'intégration runtime.
- `tests/test_b08.py` : tests statiques, positifs et de réservation, à exécuter contre le ZIP source réellement disponible.

Pour vérifier :

```bash
KINCITY_BASE_ROOT=/chemin/vers/Kin-City python -m unittest discover \
  -s contrib/places/orgo_center/tests -v
python contrib/places/orgo_center/src/generate_preview.py
```

Les recettes à brancher dans les futurs `WorldBuilder`/`ArtDecoAssets` doivent être proposées à B09 sous RFC. B08 n'a pas autorité pour modifier le budget des autres institutions, le catalogue partagé, les portes, ou le générateur global.

## 6. Validation & blocages

16 tests statiques B08 **PASS sur le V3 original**. Aucun test client Roblox, aucun test `TeleportService`, aucune compilation Luau en moteur, aucune mesure de FPS ni qualification visuelle. **Rebase sur KC33/B09 : BLOCKED (fichiers de base absents de cette session)**. Le handoff est livré pour préparation, pas pour acceptation immédiate.
