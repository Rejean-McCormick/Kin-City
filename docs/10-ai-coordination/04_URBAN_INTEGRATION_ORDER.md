# 04 — Master urban layout and orchestration order

## Existing design (code-observed, not necessarily approved)

- Circular nominal island radius ~495 studs; 6 radial directional axes + central civic core.
- Radial avenues span approximately radii 62–442 studs, about 19 studs wide in 20-stud segments; a catalog also describes 8 pedestrian paths about 6 studs wide.
- Outer sectors: `keenkonnect` (north-ish, -Z), `ethikos` (+X,-Z), `kreative` (+X,+Z), `uckk` (+Z), `ekole` (-X,+Z), `konnected` (-X,-Z). These are spatial descriptors, **not** user-facing `12 H`/`10 H` labels.
- Eight institution footprints exist at fixed KC35 coordinates, but static footprint checks found **six road/building overlaps**. The current coordinates are *source evidence*, not automatically approved KC36 positions.

Detailed actual building centers, yaw angles and evidence map: [`09-refonte-urbaine/01_VISION_ET_PLAN_DIRECTEUR.md`](../09-refonte-urbaine/01_VISION_ET_PLAN_DIRECTEUR.md); intersections: [`09-refonte-urbaine/preuves/KC35_CHEVAUCHEMENTS_VOIRIE.csv`](../09-refonte-urbaine/preuves/KC35_CHEVAUCHEMENTS_VOIRIE.csv).

## Proposed build algorithm

1. Establish bounds, terrain/water masks, civic hub and immutable public navigation priorities.
2. Lay out an explicit **connected street graph**, junctions and pedestrian crossings; reserve their full horizontal + vertical envelopes, emergency and sidewalk clearances.
3. Partition remaining land into **eligible parcels**. Calculate oriented building footprints, entrances, forecourts, setbacks, tree line and façade-facing.
4. Resolve all plot/road/path intersections by moving/reorienting **site placement records**; keep stable IDs. Any anchor transform migration must be deliberate, approved and diffed.
5. Compile a world plan and fail if a hard exclusion, sightline, route continuity or surface ownership gate is violated.
6. Generate terrain and surface masks, then roads, sidewalks, crossings, site pads, physical façades and interiors in that order.
7. Add nonblocking foliage, furniture, light and **physically anchored signs** with bounded real dimensions; then bind prompts/portals and branch decor inside approved slots.
8. Run scene verification and Studio QA before committing new design as the baseline.

## Acceptance criteria

No institution intersects a reserved road footprint; every entry has a path from the public graph; no unapproved floating volume hangs over the central spawn; visual storytelling remains recognizable from normal on-foot camera height; V30 reference views are at least matched for legibility and warmth. Plans should show *roads, building footprints, accessibility paths and grass masks in the same diagram*.
