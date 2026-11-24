# Kin City — B01 | Hôtel de ville / Accueil civique

**Owner :** B01 · **Place logique :** `city_hall` · **Contrat :** `KC34-DOC-1.0`  
**Version proposée :** B01.1.0 · **Statut :** construit comme overlay autonome, non raccordé par B09 et non validé dans Roblox Studio.

## Architecture B01

Ce répertoire contient une nouvelle couche Art déco propre à l'Hôtel de ville. Le générateur `CityHallScene.luau` ajoute de la signalétique, des emblèmes civiques et des frises, en respectant **les six salles existantes**. Il ne remplace ni les générateurs de pièces ni le mobilier KC33, ni les portes/ascenseurs/effets globaux. Il crée un seul modèle enfant `KinB01CityHallDecor` du Model canonique `Intérieur — city_hall`.

### Parcours narratif des six salles

| Salle stable | Fonction dans l'expérience | Élément B01 ajouté |
|---|---|---|
| `city_hall.lobby` | Accueil, orientation, entrée et sortie | « Bienvenue à Kin City », emblème civique |
| `city_hall.gallery` | Galerie de services, kiosque d'information | Frise « Services et ressources » |
| `city_hall.chamber` | Conseil, écoute et délibération | Frise « Salle du conseil » |
| `city_hall.west_wing` | Projets citoyens et construction collective | Frise « Projets communautaires » |
| `city_hall.east_wing` | Assemblées et participation | Frise « Assemblées citoyennes » |
| `city_hall.rear_atrium` | Agora, culture et bien commun | Emblème monumental mural |

Le caractère visuel est **Art déco civique** plutôt que palace ou salle d'audience : sarcelle commun `#1E6864`, bronze sobre `#B89C67`, ivoire `#E6E4D9` et graphite `#29383B`. Aucune des six couleurs spécifiques aux secteurs périphériques n'est utilisée comme identifiant de l'Hôtel de ville, car son bâtiment a `district_id=central`.

## Contrats strictement préservés

`building_id=central.city_hall`, `place_key=city_hall` ; entrée `city.central.city_hall.entry` vers `city_hall.lobby.spawn`, sortie `city_hall.exit` depuis `city_hall.exit.door` vers `city.central.city_hall.return_spawn`; interaction `central.city_hall.vote_01` au kiosque `hall.kiosk_01` et fournisseur **stub** (`smartvote.ballots.browse` non connecté).

Deux passages du lobby et quatre passages des ailes restent ceux de KC33. Aucun nouvel `ProximityPrompt` ni Collider n'est ajouté : tout élément B01 est `Anchored=true`, `CanCollide=false`, `CanTouch=false`, `CanQuery=false`. La couche peut être retirée indépendamment sans recréer l'intérieur.

## Architecture des sources

- `city_hall_scene.json` : six programmes de salle, coordonnées, protections d'ancres, palettes, budgets.
- `CityHallSpec.luau` : copie Luau **générée** du JSON ; ne pas modifier manuellement.
- `CityHallScene.luau` : constructeur autonome idempotent avec validation `place_key`, `contracts_version`, `KinInteriorOrigin` et présence des six salles ; supprime seulement l'ancienne couche B01 après avoir construit la nouvelle.
- `recipe.json` : manifeste compatible avec le format préliminaire B09. Il porte **zéro** décoration active au niveau du loader commun : `implementation_status=INTEGRATION_PROPOSED`. C'est voulu : l'adaptateur commun n'a pas été implémenté et aucun pouvoir d'appel ne lui a été donné.
- `tools/` : génération reproductible et scripts de preview locale.
- `tests/` : tests géométriques hors Studio, sans promesse de compilation moteur.
- `preview/` : commandes Roblox Studio autorisées **uniquement sur Place locale PlaceId=0**.

## Contrat d'appel demandé à B09

Après le `InteriorGenerator.make(...)` de la Place `city_hall`, et **seulement pour elle**, le loader B09 importerait les deux ModuleScripts sous un dossier de contribution **sous la même hiérarchie** puis :

```lua
local B01 = require(Contrib.CityHallScene)
local result = B01.build({
    place_key = "city_hall",
    contracts_version = "KC34-DOC-1.0",
    profile = "STANDARD", -- LITE | STANDARD | SHOWCASE
    place_model = interiorModel,
})
```

Le loader doit contrôler les quotas et rapporter `result.created`, `skipped`, `failed`. Il ne doit pas appliquer cette fonction au monde de la ville extérieure, ni aux sept autres intérieurs.

**Important :** B01 n'est pas propriétaire de `WorldBuilder`, `InteriorGenerator`, de `ArtDecoData`, du routage, des catalogues, ni des modules globaux. La proposition d'adaptateur est une RFC à B09, **pas** un patch intégré.

## Prévisualisation Roblox Studio (copie locale uniquement)

1. Ouvrir dans Roblox Studio une **copie locale sauvegardée** avec PlaceId = 0. Ne pas ouvrir une Place publiée / de production.
2. Générer préalablement Kin City au moyen de l'installateur local adapté à la version de base disponible; vérifier `Intérieur — city_hall`, `KinPlaceKey=city_hall`, `KinInteriorOrigin` et les six sous-modèles des salles.
3. Arrêter Play ; exécuter `preview/PREVIEW_B01_COPIE_LOCALE.luau` dans la Command Bar. Le script refuse les conditions non sûres, injecte temporairement les deux ModuleScripts, construit la couche B01 et retire seulement les modules temporaires.
4. Inspecter au minimum les six frises, les portails, les ancres de sortie et le kiosque, la visibilité, la couleur et le framerate mobile. Le code **n'a pas été testé dans Studio ici**.
5. Pour retirer uniquement ce décor : `preview/ROLLBACK_B01_COPIE_LOCALE.luau`, en mode Édition locale.

## Profils visuels et estimation d'instances

| Profil | Rayons/emblème/salle | Filets/salle | Pièces décoratives sur six salles | Quota B01 |
|---|---:|---:|---:|---:|
| LITE | 4 | 1 | **54** | 64 |
| STANDARD | 8 | 2 | **84** | 128 |
| SHOWCASE | 12 | 3 | **114** | 200 |

Ces nombres sont des comptes calculés depuis la source, **pas** des mesures FPS, triangles de meshes, mémoire ou comportement Studio. Les six salles d'origine, leurs textures, leurs PNJ et leur mobilier ne sont pas inclus dans les comptes.

## Reste à faire / limites

1. Faire relire et accepter le patch par B09 sur l'archive réelle **KC33/B09**. Cette session ne disposait que du ZIP V3 original : compatibilité de code démontrée avec la structure initiale, mais la release exacte KC33/B09 n'a pas été rechargée et testée.
2. Faire raccorder la contribution par un module et un exporteur **B09**, avec permission de déploiement en Place `city_hall` uniquement et bilan budgétaire commun.
3. Vérifier visuellement les six salles, les deux portes, les quatre passages d'extension et les vrais points d'arrivée dans Studio/client publié staging.
4. Contrôler lisibilité des textes français, clipping sur murs et contrastes jour/nuit, accessibilité et localisation multilingue.
5. Tester performances mobile, StreamingEnabled et chargement multi-Place ; le choix des Places séparées revient à B09 après mesure.

Les données métiers restent simulées; B01 n'implémente aucune logique de vote réelle.
