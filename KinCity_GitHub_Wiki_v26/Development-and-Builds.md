# Development & Reproducible Builds

Kin City is a **Luau + Python** repository with data catalogs, world generators, a Rojo project map, and autonomous Studio Command Bar installers.

## Repository structure

```text
config/             Runtime, Place IDs, visual, audio, mesh options
catalog/            Canonical spatial and domain data
schemas/            Validation contracts
src/shared/         Shared compiled plans/configuration
src/server/         World generators, door travel and local activities
src/client/         HUDs, visual options and view-specific behaviors
tools/              Plan compiler, validators, installers, asset generation
build/              Generated plans, per-Place manifest and release hashes
assets/             Original OBJ meshes, PBR maps, WAV sound beds
tests/              Python-based offline checks
docs/               Design, engineering and qualification reference material
```

`default.project.json` maps `src/shared` to `ReplicatedStorage.KinCityShared`, `src/server` to `ServerScriptService.KinCityRuntime`, and `src/client` to `StarterPlayer.StarterPlayerScripts.KinCityUI`. The Rojo project file declares streaming enabled; the direct installer **does not guarantee that Roblox Studio enables this property**, so verify the live Place setting manually.

## Developer prerequisites

- Python and the packages listed in `requirements-dev.txt`.
- Roblox Studio for actual world tests and publishing.
- Optional Rojo for a sync-based workflow.

## Rebuild the release

From the repository root:

```bash
python -m pip install -r requirements-dev.txt
python tools/validate_catalog.py
python tools/validate_spatial.py
python tools/build_release.py
python -m unittest discover -s tests -q
```

`tools/build_release.py` generates the current v26 artifacts, including:

- `build/world-plan.json`
- `build/place-package-plan.json`
- `build/release-manifest.json`
- `KinCity_Installation_Place_<key>_v26.luau` for each of the nine targets
- `KinCity_Installation_Directe_v26.luau` for exterior-only testing
- `KinCity_Installation_Univers_Local_v26.luau` for the legacy all-in-one route.

Do not hand-edit generated Luau modules or release outputs and then expect regeneration to preserve those changes. Update their catalog/config/source of truth instead.

## Adding a feature safely

1. Decide whether it belongs in the exterior city, one institution, or shared code.
2. Preserve existing stable IDs and the correct Place boundary.
3. Add the physical build through a generator; add server-side behavior only if the object actually needs interaction.
4. Use explicit server validation for proximity interactions and travel.
5. Keep optional detail non-colliding when it is not part of navigation.
6. Add an offline invariant and regenerate the relevant package scripts.
7. Confirm in Studio, not just from Python tests.

A **large new interior** should not automatically be placed in `city`; v26's main architectural decision reserves large institution environments for separate Places.

## Distribution and licensing

Source availability is not the same as an open-source license. The repository's `LICENSE-DECISION.md` still calls for an explicit owner decision; see [Contribution & Licensing](Contribution-and-Licensing).
