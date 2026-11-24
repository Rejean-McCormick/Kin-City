# 03 — KC35 actual architecture vs KC36 target

## Actual source path

`catalog/*.json` + `config/` → `tools/compile_plan.py` → `build/world-plan.json` and `src/shared/WorldPlan.luau` → `src/server/WorldBuilder.luau` → `CityGenerator` / `InteriorGenerator` → `BranchRuntime.apply(state)` → branch-specific Luau ModuleScripts. The start script is `src/server/init.server.luau`. Existing contributions live at `contrib/places/<key>` and packaged copies at `src/server/Bxx*`.

`BranchRuntime` adapts heterogeneous signatures: `B02...Build(context)`, B04 positional arguments, B10 `build(city,Plan,Districts,profile)` etc. Its successful return is *not* a geometry-clearance proof. The canonical world builder sets world build status and counts but it does **not** enforce a unified city-wide reservation map before all modules create Parts.

## Actual names of relevant modules

- `src/server/WorldBuilder.luau`, `CityGenerator.luau`, `KoaliUrbanism.luau`, `InteriorGenerator.luau`, `InteriorWings.luau`.
- `src/server/BranchRuntime.luau`, `B10Wayfinding.luau`, `ArtDecoAssets.luau`, `ArtDecoProps.luau`.
- `src/server/InstitutionForecourts.luau` (existing forecourt design if present in this baseline), `PromptRouter.luau`, `PlayerTravel.luau`.
- `ServerStorage.KinCityArtDecoLibrary`: Roblox Package instance in owner's Studio, not a tracked source folder containing uploaded Roblox meshes.

## Proposed architecture (NOT implemented)

`CityDefinition → StreetGraph / plot reservations → UrbanPlanCompiler → SpatialValidator → ApprovedPlan → staged builders → SceneVerifier → B09 acceptance`.

Read [`09-refonte-urbaine/04_ORCHESTRATION_ET_DEPENDANCES.md`](../09-refonte-urbaine/04_ORCHESTRATION_ET_DEPENDANCES.md) for role ownership, build stages, change policy, and rollback design. Don't name the proposal's imaginary modules as if they already exist.

## Explicit transition rule

**Refactor the planner before re-enabling decorative city overlays.** Current KC35 may generate and play; it is not proof that the geometry is globally coherent or that public wayfinding is acceptable.
