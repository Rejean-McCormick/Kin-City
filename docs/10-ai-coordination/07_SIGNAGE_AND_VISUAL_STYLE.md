# 07 — Visual direction: V30 quality, KC35 features

## Explicit owner rules (DECIDED)

- **No camera-facing, floating, dynamically sized or giant billboard waypoint panels**; remove the B10 `BillboardGui` overlays rather than replacing them with smaller floating UI.
- **Do not label districts by clock times** (e.g. `SECTEUR 10 H`). Historical hour/cadran metadata may remain internal to the plan math only.
- Prefer **physical signage integrated into façade/parvis/ground architecture**, sized and placed at real-world coordinates, with readable foreground/background contrast.
- Landscape, coherent Art Deco rhythm, building massing, sidewalk and pedestrian access should be **visually superior or at least equal to V30** from matched camera viewpoints.
- Avoid random skyline clutter, buildings that appear suspended over roads or spawn, and too many accent materials/glass layers on mobile.

## Provenance and implementation caveat

`contrib/places/city/Wayfinding.luau` and its `src/server/B10Wayfinding.luau` packaged copy in original KC35 contain dynamic B10 markers. A separate KC35 visual hotfix/proposed corrected source was prepared; do **not** assume it was merged into the source archive used by an agent. Before coding, inspect the actual branch overlay and test for `BillboardGui` and hour labels.

Signage integration is owned by B10; B09 checks runtime/API and user-facing constraints. Institution branches provide destination title and threshold requirements, not city-wide sign-placement functions.

See [`09-refonte-urbaine/05_LANGAGE_VISUEL_V30_ET_SIGNALETIQUE.md`](../09-refonte-urbaine/05_LANGAGE_VISUEL_V30_ET_SIGNALETIQUE.md) and [`09-refonte-urbaine/decisions/ADR-019-SIGNALETIQUE_PHYSIQUE.md`](../09-refonte-urbaine/decisions/ADR-019-SIGNALETIQUE_PHYSIQUE.md).
