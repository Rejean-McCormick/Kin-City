# Architecture — City Exterior and Institution Interiors

The **user-facing door** is the boundary between the exterior city and a major institution. Starting with v26, this boundary can also be a **Roblox Place boundary**: one exterior Place plus eight institution Places.

```text
Roblox experience (target deployment)
|
+-- city                  Exterior streets, transport, NPCs, public spaces, facades
|   +-- 8 institution entrances (portals)
|
+-- city_hall             City Hall interior
+-- ekoh_tower            EkoH Tower interior
+-- library               Great Library interior
+-- campus                KonnectED University interior
+-- justice_palace        Justice Palace interior
+-- innovation_lab        Innovation Park/Lab interior
+-- museum                Kreative Museum interior
+-- orgo_center           Orgo Center interior
```

## Three supported routing modes

| Mode | Purpose | Exterior and interiors share a Place? | Real inter-Place teleports? |
| --- | --- | --- | --- |
| `SPLIT_PREVIEW` | Independent Studio previews from the nine targeted installers | No | **No** |
| `LOCAL_UNIVERSE` | Legacy all-in-one navigation tests | **Yes** | No, local movement only |
| `MULTI_PLACE` | Target published nine-Place experience | No | **Designed to use** `TeleportService:TeleportAsync`, subject to publication and in-client testing |

`config/runtime.json` records the repository's routing mode; the targeted installer controls the preview target. In the v26 delivery, the default configuration remains `LOCAL_UNIVERSE` and all published Place IDs are `null`.

## Runtime layers

```text
config/ + catalog/ + schemas/
      ↓
tools/compile_plan.py + tools/export_roblox.py
      ↓
src/shared/        World plan, routing, visual and runtime settings
      ↓
Studio installer / Roblox DataModel
      ├── ReplicatedStorage/KinCityShared
      ├── ServerScriptService/KinCityRuntime
      ├── StarterPlayer/StarterPlayerScripts/KinCityUI
      └── Workspace/KinCityGenerated
      ↓
Server: WorldBuilder, travel, validated proximity prompts, local activities
Client: HUD, maps (city), journals, visual quality, R15 visual animation
```

`src/server/init.server.luau` calls `WorldBuilder.build(true)` and starts the relevant services. City-specific NPC, transport and ambient services are only started for `city` (or the all-in-one local mode); institution Places use their own relevant interior mechanisms and exhibits. `src/client/init.client.luau` similarly reserves city maps and transit UI for the exterior.

## Stable IDs and composition

The plan maintains stable place, door, anchor and interaction identifiers. Generators construct parts of the world from catalog data plus specialized Luau code; not every decorative object is listed individually in the canonical plan. Do not rename an existing ID casually: door routing, manifests and interactions depend on it.

`build/place-package-plan.json` describes the expected per-Place scenes; `build/release-manifest.json` records release fingerprints. `KinCity_Diagnostic_Places_v26.luau` inspects the **actual Studio scene** for misplaced exterior/interior content.

## Security model

- The **server** validates prompt hosts, the active character, health, distance, expected world, and known routes.
- Clients render UI and some visual animation. They are not trusted to choose arbitrary teleport destinations or award business outcomes.
- `KinCityReply` is used for server-to-client interaction replies; kOA, account, economy and AI gateways are not connected.

See [Configuration](Configuration), [Development & Builds](Development-and-Builds), and [Validation & Diagnostics](Validation-and-Diagnostics).
