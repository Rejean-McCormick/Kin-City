# 02 — Ten-branch ownership and coordination

**All ten branches are present as workstreams; only nine correspond to Roblox Places.** KC35 contains B01–B08 and B10 source contributions plus B09 integration tooling and runtime. No automatic synchronization exists between separate AI conversations.

| Branch | Place | Scope | Entry path | Review owner |
|---|---|---|---|---|
| [B01](branches/B01.md) | `city_hall` | Accueil / Hôtel de ville | `contrib/places/city_hall/` | B09 + B10 for exterior interfaces |
| [B02](branches/B02.md) | `ekoh_tower` | Observatoire EkoH | `contrib/places/ekoh_tower/` | B09 + B10 for exterior interfaces |
| [B03](branches/B03.md) | `library` | Grande Bibliothèque | `contrib/places/library/` | B09 + B10 for exterior interfaces |
| [B04](branches/B04.md) | `campus` | Université King Klown | `contrib/places/campus/` | B09 + B10 for exterior interfaces |
| [B05](branches/B05.md) | `justice_palace` | Agora Korum | `contrib/places/justice_palace/` | B09 + B10 for exterior interfaces |
| [B06](branches/B06.md) | `innovation_lab` | Atelier Konstruct | `contrib/places/innovation_lab/` | B09 + B10 for exterior interfaces |
| [B07](branches/B07.md) | `museum` | Galerie Konservation | `contrib/places/museum/` | B09 + B10 for exterior interfaces |
| [B08](branches/B08.md) | `orgo_center` | Maison Orgo | `contrib/places/orgo_center/` | B09 + B10 for exterior interfaces |
| [B09](branches/B09.md) | `integration` *(not a Place)* | Integration & contracts, no Place | `tools/`, `src/server/BranchRuntime.luau` | B09 + B10 for exterior interfaces |
| [B10](branches/B10.md) | `city` | Central city / 6 districts | `contrib/places/city/` | B09 + B10 for exterior interfaces |

## Workflow boundaries

- **B01–B08:** geometry inside assigned institution/slots; propose exterior threshold needs but cannot place a façade into a road.
- **B10:** urban shape, public realm, plots, roads, façades, physical signs. It may propose plot shifts, **not** silently change room/spawn/door IDs.
- **B09:** sole integrator of shared code (`WorldBuilder`, `CityGenerator`, `KoaliUrbanism`, `Spatial`, `PlayerTravel`, assets and place routing). It approves spatial migrations and QA, and rejects unilateral conflicting branch changes.
- **B07:** public exterior entrance stays locked; broadcast display near exterior, but no unsupported YouTube live playback.
- **B08:** KC33-native scene module is the current implementation; V3 preview remains historical only.

## Dependency graph

```text
OWNER requirements + V30 visual benchmark
               |
          B09 contracts
               |
   (proposed) UrbanPlanCompiler + SpatialValidator
           /               \
  B10 roads/plots          B01..B08 interior slot requests
           \               /
          B09 approved city plan
               |
   ground / foundations / façades / interiors
               |
         branch overlays + physical signs
               |
       Studio, performance, staging QA
```

The compiler/validator nodes in this diagram are **proposed**, not implemented.
