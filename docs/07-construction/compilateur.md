# Compilateur de monde — contrat d'ingénierie

## Source canonique et sorties
Entrées versionnées : `catalog/*.json`, `schemas/*.json`, sources d'assets et palettes. Sorties : `world-plan.json`, `build-manifest.json`, rapport d'erreurs et *scènes Roblox* produites par des générateurs Luau / Rojo restant à implémenter. Le compilateur **ne doit jamais** faire d'appel à une IA pendant l'exécution.

```text
load → schema → normalize → resolve-assets → spatial-check → nav-check
     → IR stable → scene emit → static verify → Studio inspection → publish gate
```

**Référence fournie :** `tools/compile_plan.py` produit un plan logique déterministe, il ne crée pas de `.rbxl` ni de scène Roblox. C'est une délimitation volontaire et explicite entre preuve documentaire et code exécuté dans le moteur.

## Interfaces attendues
```text
normalize(inputs: CatalogBundle) -> CanonicalBundle
resolveAssets(bundle: CanonicalBundle) -> ResolvedAssetGraph
planCity(bundle: CanonicalBundle) -> CityPlan
planInterior(place_key: str, bundle: CanonicalBundle) -> InteriorPlan
bindInteractions(plan: ScenePlan) -> ScenePlan
emitRoblox(plan: ScenePlan, target: PlaceKey) -> SceneArtifacts
inspectScene(scene: RobloxScene) -> QualificationEvidence
```

Le contrat d'erreur est `{code, severity, entity_id, location, explanation, remedy}`; le build est atomique : **aucun artefact partiellement approuvé** en cas d'erreur bloquante. Les sorties doivent contenir une empreinte SHA-256 du bundle normalisé, le nombre de bâtiments/pièces/ancres et la provenance des assets.

## Générateurs nécessaires
- `RoadAndAccessPlanner`: chemins de marche entre arrivée et portes, évitement des empreintes et obstacles, lisibilité des accès.
- `FacadeNativeV1`: volumes, toit, colonnes/baies, enseigne, variations typologiques contrôlées.
- `InteriorNativeV1`: géométrie des pièces et ouvertures, escalier/rampe lorsque requis, mobilier.
- `PropNativeV1`: meubles et terminaux reconnaissables, avec points d'interaction sur vrais objets.
- `DoorBinder`: ancre source, destination, retour, attente et erreurs de téléportation.
- `InteractionBinder`: registre idempotent d'identifiants, `ProximityPrompt`, UI stub et contrôles serveur.
- `SceneInspector`: existence des modèles, état des scripts, collisions critiques, mémoire, chargement, téléportations.

## Reproductibilité
Même état des sources + même version du générateur + même seed → même IR JSON canonique et même empreinte. **Ne pas promettre les mêmes octets `.rbxl`** si Roblox ajoute des métadonnées internes.

## Personnalisations validées
Une intervention artistique manuelle devient un `override` versionné avec ID cible, opérations autorisées, auteur et empreinte du modèle de base. Les éditions non recensées ne peuvent être écrasées silencieusement. Un diff sémantique est obligatoire avant régénération en production.
