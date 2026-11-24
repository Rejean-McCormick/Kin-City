# B09 — Guide opérationnel de l'intégration Kin City KC34

**Statut : socle initial hors moteur (préproduction non publiée).** B09 est une fonction de gouvernance du projet, **pas** une dixième Place. Les neuf Places restent sous KC33 `LOCAL_UNIVERSE` jusqu'à la création et vérification d'un environnement `MULTI_PLACE` privé.

## 1. Source de vérité, version et portée

| Élément | Référence |
|---|---|
| ZIP logiciel de départ | `KinCity_KC33_Mise_a_Niveau_Complet.zip` |
| SHA-256 exact du ZIP | `1fd3968977823a8814f54f766164c85e02cda3e370df984455f8c3f7db877c89` |
| Version de contrats | `KC34-DOC-1.0` |
| Plan logique canonique | `5941cd6ecd89ea806cd5b815fcc128b1abef1cff77f77d670dbe01c7f487039a` |
| Liste de fichiers verrouillés | `reference_KC34/contrats/empreintes_kc33.json` (23 sources) |
| Tableau unique de réception | `docs/B09/branch_ledger.json` |
| Plaquette des portes | `reference_KC34/contrats/matrice_portes.csv` |
| Décisions et anomalies | `docs/B09/decisions/` |

Le SHA du ZIP couvre **l'archive KC33 initiale**, pas les nouveaux fichiers B09. Les 23 empreintes sont contrôlées sans empêcher l'ajout de nouveaux fichiers B09. En cas de besoin de modifier un contrat verrouillé, **versionner le changement** après RFC et ADR : ne pas réécrire le hash de référence pour « faire passer » le test.

## 2. Instructions pour les dix branches

- **B01** `city_hall` ; **B02** `ekoh_tower` ; **B03** `library` ; **B04** `campus` ; **B05** `justice_palace` ; **B06** `innovation_lab` ; **B07** `museum` ; **B08** `orgo_center`.
- **B09** `integration` sans Place. Valide les interfaces et intègre les changements soumis. Ne décide pas seul du produit ni d'une publication de production.
- **B10** `city` est la neuvième Place. Coordonne avec B09 les six secteurs, huit portes d'entrée et façades. Ne change pas les identifiants de portes historiques.

**Chaque IA doit recevoir** : (1) le ZIP KC33 original, (2) la bible et la fiche de branche du répertoire `reference_KC34`, (3) le présent pack B09, (4) la version de `branch_ledger.json`, (5) son propre `contrib/places/<place_key>/`.

**Chaque remise inclut** : fichiers réels, `handoff.json` avec `baseline_sha256`, `changed_files` contenant des paires `{path,sha256}`, logs des tests PASS/FAIL, liste de tests non exécutés, risques, rollback, captures publiées si disponibles, version de contrat. On ne suppose jamais que les IA ont accès aux autres conversations.

## 3. Périmètres autorisés

- En mode LOCAL, B01–B08 éditent **uniquement** `contrib/places/<leur_clé>/` ; B10 édite `contrib/places/city/`. Un besoin d'édition directe de `src/server`, `catalog`, `src/shared`, `tools`, `config`, `installer` ou `build` exige RFC B09, ensuite B09 fournit un adaptateur ou une migration partagée.
- Les préfixes des IDs des objets propres à une Place commencent par sa `place_key` (ex. `library.new_room_widget`). Les IDs canoniques existants sont immuables sans migration validée.
- Les 16 `door_id`, les 49 ancres, les 9 `place_key`, les 6 couleurs hexadécimales et les huit relations d'entrée-sortie restent figés à `KC34-DOC-1.0`.
- Aucune branche ne renseigne `config/place_ids.json` avec des identifiants réels ni ne copie un ID de production dans staging.

## 4. Commandes de qualification hors moteur

Se placer à la racine `source/Kin-City` :

```bash
python -m pip install 'jsonschema>=4.20,<5'
python tools/b09_contracts.py --repo . --reference reference_KC34 --out docs/B09/reports/audit_local.json
python tools/b09_recipes.py --repo .
python -m unittest discover -s tests -p 'test_b09_*.py' -v
python tools/b09_staging_audit.py --self-test
```

L'audit `b09_contracts.py` compare les 23 fichiers de référence, les 16 portes réciproques, neuf Places, 49 ancres, 24 salles compilées, les 121 modèles, 41 modèles configurés, six districts et les six couleurs au code Luau. Il recompile le plan sans modifier le fichier officiel. Les huit extensions `InteriorWings` sont lues et leurs **emprises calculées**, mais ne sont **pas** ajoutées au plan canonique compilé.

Le test staging génère temporairement les neuf installateurs avec des IDs synthétiques puis les détruit. Ce n'est ni une simulation TeleportService, ni un contrôle de l'appartenance des Places à un univers Roblox.

### Contrôle d'une contribution réelle

```bash
python tools/b09_contracts.py --repo . --reference reference_KC34 \
  --baseline-zip CHEMIN/KinCity_KC33_Mise_a_Niveau_Complet.zip \
  --handoff CHEMIN/handoff.json --patch CHEMIN/patch
```

S'il réussit, cela signifie **PASS HORS MOTEUR, NON FUSIONNÉ, NON PUBLIÉ**. La revue humaine B09 et les tests de runtime sont des étapes distinctes.

Pour consigner la réception dans une **nouvelle** version du registre :

```bash
python tools/b09_intake.py --handoff CHEMIN/handoff.json --patch CHEMIN/patch \
 --baseline-zip CHEMIN/KinCity_KC33_Mise_a_Niveau_Complet.zip \
 --ledger docs/B09/branch_ledger.json --out docs/B09/branch_ledger_reviewed.json
```

Un handoff offline réussi reste `BLOCKED` en attente des preuves Roblox et de l'acceptation explicite B09. L'outil ne copie pas ses fichiers dans la source commune : la fusion demeure délibérée, vérifiable et réversible.

## 5. Contrat des recettes de Place

Les neuf `contrib/places/<key>/recipe.json` sont des manifestes de **contribution**, pas des loaders Luau opérationnels. Le schéma `kincity.place-recipe/1.0` définit :

- `place_key` et `owner_branch` : unicité et propriété ; jamais substituer un nom d'affichage.
- `requires_contracts_version` : `KC34-DOC-1.0` pour cette baseline.
- `seed_policy` : `CITY_SEED_XOR_PLACE_HASH`, un calcul stable à spécifier puis à tester avant raccordement réel.
- `profiles_supported` : `LITE`, `STANDARD`, `SHOWCASE`.
- `decorations` : liste déclarative de contributions portant `id`, `asset_key`, `anchor_id`, `min_profile` ; doit être validée contre l'inventaire source lors de l'intégration d'un vrai loader.
- `implementation_status` : `NOT_CONNECTED_TO_WORLD_BUILDER` jusqu'au raccordement explicite.

**API Luau cible soumise à ADR** (non implémentée dans KC34-B09 initial) : `PlaceRecipe.build(context)` avec `context={place_key, seed, profile, inventory, budget, placeModel, anchors}` ; résultat `{created, skipped, failed, estimated_parts, estimated_triangles, warnings}`. Le budget et l'inventaire doivent être contrôlés par le serveur, non par le module de branche. Les recettes doivent être idempotentes, déterministes et ne jamais modifier une ancre canonique.

Pourquoi ne pas raccorder les recettes vides tout de suite ? Parce que l'installateur KC33 empaquette explicitement les modules. Ajouter un `require` ou un dossier non embarqué ferait échouer Studio, alors qu'aucune recette de branche n'existe encore. B09 intégrera le loader et l'export après acceptation d'un premier cas réel et de tests couvrant les trois profils.

## 6. Anomalie d'emprise : huit intérieurs

La géométrie initiale déclare `bounds.rectangle.size_studs = [110,100]`. `InteriorWings.expand()` ajoute, à l'exécution, trois salles à chaque institution aux centres `[-79,0,7]`, `[79,0,7]`, `[0,0,76]`, respectivement de tailles `[52,16,50]`, `[52,16,50]` et `[100,16,56]`.

L'union réelle des 6 salles par institution occupe **X = −105…+105 et Z = −46…+104 studs**, soit une emprise de **210 × 150** studs. Si la définition conserve le centre `(0,0)` et réclame 10 studs de marge sur chaque extrême, elle doit au minimum afficher **230 × 228 studs** (et non 110 × 100). Ces dimensions ne prennent pas en compte les nouveaux mezzanines, décorations extérieures, zones d'accès ou d'autres modules spécialisés.

**Décision actuelle : AUDIT/MISE EN GARDE, pas migration.** Modifier `catalog/spatial.json` maintenant créerait un changement partagé impliquant huit branches et une recompilation canonique, sans preuve que le moteur utilise les bounds pour le décor généré. Chaque équipe d'intérieur doit confirmer ses futurs dépassements, collisions, passages et budget avant une RFC globale. Voir `decisions/ADR-001-bounds.md`.

## 7. Qualité et critères de release

| Stade | Minimum requis | Signification |
|---|---|---|
| A0 | 23 hashes + compilateur + six couleurs + matrice des portes | Consistance statique |
| A1 | Tests positifs/négatifs B09 + manifestes + revue de patch | Qualité structurelle |
| A2 | Installation locale dans **une copie** Studio + vérification spatiale | Rendu et collisions locaux |
| B1 | Neuf Places staging réelles dans **un seul univers** privé | Installation isolée |
| B2 | Seize portes testées en aller-retour dans client **publié** | Fonctionnement téléport |
| B3 | 48 salles, six sections, huit façades, portes, trois profils, stubs | QA fonctionnelle |
| C1 | Mesures appareils (FPS, mémoire, temps chargement, erreurs) comparant local/multi | Choix architectural justifié |
| R | Sauvegardes, rollback, approbation humaine et changelog | Release candidate admissible |

Aucun stade B/C/R n'est actuellement réputé passé. Les asserts des installateurs staging prouvent une construction en **mode Édition**, pas le fonctionnement client de TeleportService.

## 8. Sécurité de staging et informations humaines nécessaires

`tools/build_staging_places.py` refuse le PlaceId de production connu dans `config/art_deco.json`, demande neuf IDs uniques et vérifie que chaque script s'exécute dans sa Place cible, en Studio arrêté, avec `StreamingEnabled` et `KinArtDecoTestPlace=true`. Il est incapable d'attester que ces IDs appartiennent **au même univers** et que celui-ci est privé. **B09 doit faire vérifier cela par un opérateur Roblox habilité** avant exécution, puis obtenir :

1. ID réel de l'univers de staging, neuf PlaceIds réels et preuve d'appartenance commune ; jamais utiliser l'ID production.
2. Sauvegarde `.rbxl` ou version historisée privée pour chacune des neuf Places et procédure de restauration testée.
3. Copie autorisée des 121 modèles sous licence, preuve de compatibilité des permissions, `StreamingEnabled` actif.
4. Confirmation des configurations d'accès, système de téléportation et publication **staging seulement**.
5. Journal d'essais client publié : entrée, retour, sortie et restauration à travers chacune des huit institutions.
6. Mesures matérielles et observation des erreurs client/serveur sans exposer de données privées.

Le ZIP B09 ne contient aucun PlaceId nouveau réel et aucune clé secrète. Ne jamais placer de tokens Roblox, cookies ou identifiants privés d'utilisateur dans les handoffs.

## 9. Risques ouverts et propriétaires

| Risque | Gravité | Propriétaire / prochain geste |
|---|---|---|
| Bornes intérieures non représentatives du runtime | Haute | B09 + B01–B08 : RFC de géométrie commune |
| Manifeste PlaceRecipe non câblé à l'installateur | Moyenne | B09 après premier handoff applicatif |
| Huit jeux de portes sans essai publié | Critique | B09 + B10 + branches propriétaires |
| Séparation multi-Place non prouvée plus performante | Haute | B09 + opérateur Roblox, mesures C1 |
| Modèles importés sous droits non validés dans staging | Haute | Propriétaire / opérateur Studio |
| Nouveaux changements partagés non représentés par les 23 empreintes | Haute | B09 : RFC, nouveau lock/version |
| Palettes et repères pouvant être masqués visuellement | Moyenne | B10 : captures Studio jour/nuit |
| Dépendance `lupa` indisponible localement | Moyenne | CI outillée ; exécution de la suite Luau à confirmer |

## 10. Communication obligatoire

Une IA transmet à B09 **un zip de patch**, le JSON `handoff`, le diff et des preuves. B09 répond **ACCEPTED**, **CHANGES_REQUESTED** ou **BLOCKED** avec raisons, nouvelles empreintes et prochain jalon. La branche **ne modifie pas le référentiel** tant que sa modification partagée n'est pas approuvée. Les fusions et décisions sont enregistrées dans `branch_ledger.json` et les ADR. Toute rupture nécessite l'avis des Place(s) consommatrices et l'autorisation du propriétaire.
