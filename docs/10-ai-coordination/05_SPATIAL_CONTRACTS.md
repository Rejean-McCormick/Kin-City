# 05 — Spatial and placement contracts

## Immutable identifiers

Never rename `place_key`, `building_id`, `door_id`, anchor IDs or interaction IDs unilaterally. See `reference_KC34/contrats/index_machine.json`, `catalog/doors.json`, `catalog/buildings.json`, `build/world-plan.json` and [`../03-contrats/portes.md`](../03-contrats/portes.md).

**Important distinction:** a **stable ID** need not imply an immutable world coordinate for all eternity. The approved KC36 planner may migrate a physical location, but must update entrance frame, spawn/return anchor, pedestrian link, surface masks and related tests **together**, through B09 RFC/ADR review. No unmatched end points.

## Placement request proposal

Each branch-owned scene that needs world-facing geometry provides a declarative request, not a secretly chosen global CFrame:

```yaml
request_id: B07.broadcast.sign.001
place_key: museum
building_id: kreative.museum
slot_role: EXTERIOR_BROADCAST_VIEW
clearance_studs: 8
height_studs: 5
must_face: public_approach
collision_policy: no_public_path_obstruction
approval: B09_AND_B10_REQUIRED
```

**This YAML is a proposed shape**, not an implemented parser or guaranteed approved location. Detailed future JSON Schema and the example `site_manifest` are stored under [`09-refonte-urbaine/contrats`](../09-refonte-urbaine/02_CONTRAT_PARCELLAIRE_ET_VOIRIE.md).

## Required constraints

- Oriented footprint collision (not merely axis-aligned) vs all avenues/junctions and other parcels.
- Separate ground collision, vertical clearance/overhang and visual sightline constraints.
- Guaranteed clear pedestrian paths from public network to entrance; protect spawn and egress volumes.
- Stable room graph for six-room institutions, including wing/atrium passages.
- Door reciprocity checked against `catalog/doors.json` and no PlaceId invention.
- For museum locked gate, retain logical IDs and test that the **public** entry prompt is disabled by both UI and server policy, not only by a decorative barricade.
