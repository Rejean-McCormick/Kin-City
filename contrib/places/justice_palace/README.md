# B05 — Agora Korum / `justice_palace`

**Livraison B05.0.1** · contribution locale à soumettre à B09, jamais fusionnée ni publiée automatiquement.

## Identité

Agora Korum n'est pas un tribunal intimidant, mais un **lieu de dialogue, de consultation, de médiation et d'équité**. Son architecture Art déco utilise le bronze d'ethiKos (`#A97C4F`), le sarcelle commun (`#1E6864`), l'opale douce et les montants métalliques fins. La symétrie accompagne la lisibilité plutôt qu'une hiérarchie oppressive.

## Les six salles

| Salle | Fonction spatiale et émotionnelle | Tracé existant |
|---|---|---|
| `justice_palace.lobby` | Hall civique : accueil et direction des parcours | arrivée `justice_palace.lobby.spawn`, sortie `justice_palace.exit.door` |
| `justice_palace.gallery` | Consultation : accès à l'information | terminal `hall.terminal_01`, liens hall / témoignages / atrium |
| `justice_palace.chamber` | Délibération : débat calme | lien hall / médiation / atrium |
| `justice_palace.west_wing` | Témoignages : confidentialité et protection de la parole | passage `gallery_to_west` |
| `justice_palace.east_wing` | Médiation : deux points de vue, terrain commun | passage `chamber_to_east` |
| `justice_palace.rear_atrium` | Atrium de la justice : rencontre et circulation vers étage | deux passages arrière, escaliers et ascenseur |

Les **trois dernières salles sont générées par `InteriorWings`**, pas inscrites comme salles canoniques du fichier `world-plan.json`. En mode LOCAL_UNIVERSE elles coexistent dans la même Place Roblox que la ville. Le passage à une Place distincte reste à réaliser côté B09.

## Contenu technique

- `recipe.json` : en-tête conforme au contrat B09 `kincity.place-recipe/1.0`; `decorations=[]` volontairement, parce que les features utilisent des positions locales plutôt que les trois ancres canoniques. Les objets ne sont **pas** reliés au loader B09 actuel.
- `scene_plan.json` : spécification déterministe et mesurable des 24 éléments de décor, répartis entre 6 salles, profils et zones de dégagement.
- `SceneData.luau` : projection du plan JSON en table Luau, générée par `tools/regenerate_luau.py`.
- `PreviewBuilder.luau` : module Roblox Studio autonome `build(ctx)` sans aucun chargement Internet, API KOALI ni TeleportService.
- `canonical_snapshot.json` : identifiants canoniques protégés, vérifiés contre le ZIP original transmis dans cette conversation.
- `test_b05.py` : tests de cohérence et de périmètre hors moteur.

## Usage de PreviewBuilder (après revue B09, sur une **copie locale Studio**) 

1. Placer les deux sources `SceneData.luau` et `PreviewBuilder.luau` comme ModuleScripts frères, **sans** toucher à `WorldBuilder` ni à `PromptRouter`.
2. Obtenir l'Instance exacte de l'intérieur `justice_palace` (jamais la ville centrale) et la position `origin` utilisée pour ce bâtiment par le générateur. **Ne pas choisir** un autre intérieur.
3. Appeler le module dans un environnement où B09 a déjà vérifié la cible :

```luau
local builder = require(chemin_vers_PreviewBuilder)
local result = builder.build({
    place_key = "justice_palace",
    parent = interieur_existant,
    origin = origine_de_justice_palace,
    profile = "LITE",
})
print(result)
```

Un deuxième appel identique ne rajoute pas de pièces. Une révision ou un profil différent est refusé par défaut. La suppression/remplacement ne peut intervenir qu'avec `replace_decoration=true` sur le seul dossier `KinBranch="B05"` — à faire seulement sur copie de travail, après sauvegarde. Ce module ne doit pas être exécuté dans une Place de production; B09 doit assurer les contrôles de PlaceId, publication et streaming dans son propre installateur.

## Performance et sécurité

- Jusqu'à **72 Parts décoratifs Roblox** (24 features × 3 Parts), aucun MeshPart supplémentaire, aucune PointLight, collision/touch/query désactivés et ombres désactivées.
- Niveaux de détail : LITE 18 Parts, STANDARD 36, SHOWCASE 72.
- Tous les objets sont ancrés et muraux/hauts; aucun pont, sol, escalier, Prompt, terminal ou porte n'est remplacé.
- Les `asset_candidate` du plan sont des **suggestions** du pack Art déco (inventaire réel), pas des clones. L'intégration de meshes est une amélioration facultative et nécessite réservation des budgets B09.
- Aucune mesure de FPS ou mémoire Roblox Studio n'a été faite. Les nombres ci-dessus sont des plafonds de Parts **estimés à partir du code**, pas des relevés GPU.

## Faits et limites de baseline

**Attention :** dans la session de création B05, seule l'archive originale `KinCity_ArtDeco_V3_Complet (1).zip` était accessible dans les fichiers montés. Le ZIP KC33 et le ZIP B09 annoncés précédemment **n'ont pas pu être revérifiés**; le `baseline_sha256` dans le handoff est le SHA publié dans le rapport B09 précédent et doit être confirmé par B09 à réception. Les portes et salles ont été vérifiées directement dans l'original, pas dans un déploiement multi-Place. Tout conflit avec un changement récent KC33 doit passer par revue B09.

## À faire après l'acceptation B09

1. Vérifier le placement visuel et le nombre d'instances dans Roblox Studio, en tenant compte des murs, escaliers et verrières déjà construits.
2. Intégrer un vrai adaptateur `ScenePlan/PreviewBuilder` aux installateurs si B09 valide le design et les budgets.
3. Comparer les positions des décorations aux collisions et mobiliers en jeu. Modifier seulement les plans B05, jamais les ancres canoniques sans RFC.
4. Éventuellement placer 4–8 meshes sélectionnés du pack Art déco, si les budgets le permettent; ne pas charger automatiquement les assets `library_only`.
5. Tester les six salles, quatre passages d'extensions, ascenseur, entrée et retour à la ville dans le client publié avec des IDs réels de staging.
