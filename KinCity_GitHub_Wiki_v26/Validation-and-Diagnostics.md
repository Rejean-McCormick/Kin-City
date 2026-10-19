# Validation & Diagnostics

Two different kinds of evidence matter for Kin City:

1. **Offline checks**: Python tests, catalogs, spatial plan, file generation and deterministic release hashes.
2. **In-engine checks**: generation inside Roblox Studio, collisions, interactive prompts, multi-player state, performance, sound permissions and real published teleports.

The v26 release records **71 offline tests passing**. This is **not** proof that the game has been executed successfully in Roblox Studio or a published Roblox client.

## Offline verification

```bash
python -m pip install -r requirements-dev.txt
python tools/validate_catalog.py
python tools/validate_spatial.py
python tools/build_release.py
python -m unittest discover -s tests -q
```

Additional data checks live in `tests/` and the corresponding build manifest files under `build/`.

## Studio scripts

| Script | What it checks |
| --- | --- |
| `KinCity_Diagnostic_Places_v26.luau` | Active Place, split-mode flags, presence of exterior/interior models, canonical door/interaction counts |
| `KinCity_Diagnostic_Studio_v25.luau` | Counts of generated parts, meshes, lights, seats, prompts and imported materials |

The Place diagnostic is **read-only**; it inspects `Workspace.KinCityGenerated` and compiled routing settings. It reports expected scene separation but **cannot validate that published TeleportAsync journeys work**.

## Suggested first visit checklist

- [ ] An exterior city build generates with no fatal Output errors.
- [ ] An institution build generates one interior **without** the exterior city.
- [ ] Player spawns safely and can move through exterior paths and institution doors.
- [ ] Eight city entrances and the matching institution return doors can be identified.
- [ ] A local exhibit changes state; its prompt is reachable and not blocked.
- [ ] UI works at a desktop resolution and at least one mobile emulation size.
- [ ] Visual settings can be changed locally without moving physical buildings.
- [ ] All optional audio/mesh fallbacks work when asset IDs are absent.
- [ ] With **real published IDs**, entrance and return teleports work in the published client.
- [ ] No unbounded memory, physics or network growth appears in extended play.

## Performance observations to capture

Device/platform, Roblox version, session length, player count, location (city vs. institution), frame-time distribution, memory, server load, network throughput and reproduction steps. Comparing a crowded civic plaza, a gallery, a ferry journey and a multi-player test is more meaningful than quoting just one average FPS.

The v25 diagnostics count scene objects; they are **not** an FPS profiler.
