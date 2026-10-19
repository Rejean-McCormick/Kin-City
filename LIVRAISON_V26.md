# Kin City v26 — Rupture physique ville / huit institutions

**Date : 19 octobre 2026** · **Mode métier : `WORLD_STUB`** · Signature : **#1E6864 + cristal opalin**.

## Décision mise en œuvre

La ville et les huit grandes institutions n'ont plus besoin d'être construites dans la même `Workspace`/Place Roblox. Le mode standard **de la livraison séparée** génère neuf scripts autonomes, chacun avec son identité de Place :

| Package | Contenu instancié dans la scène |
|---|---|
| `city` | Ville extérieure, bâtiments de façade, quartiers, commerces, transports, habitants, espaces publics ; **aucun grand intérieur institutionnel** |
| `city_hall` | Grand intérieur de l'hôtel de ville, ses niveaux, galeries, activités, entrée et sortie ; **aucune ville extérieure** |
| `ekoh_tower` | Intérieur de la tour EkoH |
| `library` | Intérieur de la Grande Bibliothèque |
| `campus` | Intérieur de l'université KonnectED |
| `justice_palace` | Intérieur du palais de justice |
| `innovation_lab` | Intérieur du Parc de l'Innovation |
| `museum` | Intérieur du Musée Kreative |
| `orgo_center` | Intérieur du Centre Orgo |

Chaque institution garde ses aménagements des versions v1-v25 : six salles de base et annexes, étages, galeries, éléments de scénographie, interaction canonique et portes aller/retour. Les bâtiments extérieurs demeurent visibles dans la ville.

## Construction modifiée

- **9 installateurs Command Bar distincts**, générés depuis un dépôt commun : `KinCity_Installation_Place_<key>_v26.luau`. `KinCity_Installation_Directe_v26.luau` = **ville extérieure uniquement**.
- `SPLIT_PREVIEW` par Place sans inventer de PlaceIds : les neuf scènes peuvent être fabriquées séparément en édition, mais **le passage entre Places reste signalé comme indisponible** tant que les vrais PlaceIds n'existent pas.
- `MULTI_PLACE` dès que les neuf PlaceIds ont été saisis dans `config/place_ids.json`, puis `config/runtime.json` réglé sur `MULTI_PLACE` et les neuf installateurs régénérés. Les portes utilisent `TeleportService:TeleportAsync`; l'arrivée est validée avec l'identifiant de porte et l'ancre du plan canonique.
- `Spatial.currentPlace()` refuse une Place de production dont l'ID ne correspond pas au registre, ainsi qu'un installateur ciblé pour une autre Place. Un aperçu Studio non publié peut utiliser le `target_place_key` fourni par l'installateur.
- `WorldBuilder` instancie seulement la ville **ou** l'intérieur visé; enregistre `KinActivePlace`, `KinRoutingMode`, `KinSeparatedWorld`, et les comptes de portes/interactions propres au package. La réhydratation vérifie également l'identité de Place.
- Les services urbains (PNJ, navettes, bus, ferries, tramways, commerces et espaces publics) **ne démarrent plus dans les Places intérieures**. Les services locaux de galeries, science et mécanismes restent disponibles dans leur institution.
- Les interfaces de carte, réseau urbain et transports ne sont plus lancées à l'intérieur d'une Place distincte; un bandeau discret indique l'institution actuelle. Les expériences et le carnet de galeries restent accessibles.
- `PlacePortalsV26` ajoute un portail signalétique sarcelle/cristal **sans collision** aux passages canoniques. Aucune façade ni identifiant de porte n'est renommé.
- `WorldEditor.regenerateInterior` empêche de reconstruire depuis la Place de la ville un intérieur appartenant à une autre Place.
- `build/place-package-plan.json` et `build/release-manifest.json` documentent les neuf packages, les frontières du monde et leurs empreintes. `KinCity_Diagnostic_Places_v26.luau` contrôle la séparation d'après la scène Studio.

## Mode de secours

`KinCity_Installation_Univers_Local_v26.luau` installe le mode historique `LOCAL_UNIVERSE` pour vérifier les circulations internes dans **une seule Place** sans publier : **ce mode n'applique pas la séparation mémoire serveur promise par les neuf Places**. Ne pas confondre les deux modes.

## Ce qui reste manuel et non certifié

La création effective de neuf Places **dans la même expérience Roblox**, leur publication, la collecte de leurs vrais PlaceIds, leur inscription dans le catalogue, et le remplacement par les installateurs `MULTI_PLACE` doivent être réalisés par le propriétaire dans Studio/Creator Hub. Roblox Studio n'est pas disponible ici; aucune traversée publiée, charge client/mobile, collision ou test multijoueur réel n'a été mesuré. Roblox peut avoir des exigences de publication et de streaming propres à chaque Place.

Aucun appel distant kOA, aucune API d'IA et aucun AssetId de remplacement inventé. Les services kOA demeurent « Fonctionnalité à venir ». Les scripts d'installation remplacent la construction actuelle directement; pas de rollback.
