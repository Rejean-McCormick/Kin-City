# 06 — Ground-surface single-owner rule

## Studio evidence and uncertainty

Owner's screenshot shows a white triangular ground artifact and lawn flashing white while the camera moves. KC35 source has multiple potential visible layers (`CityGenerator` native walks, `KoaliUrbanism` road slabs, imported street paving, institution forecourts and possibly baseplate/terrain). **Z-fighting is plausible but NOT confirmed**. Never fix by random part destruction or unbounded Y offsets.

## KC36 decision target

Exactly one opaque visible top surface owns each traversable map cell/region. A decorative mesh can overlay only with explicit layering rules, no independent collision and no accidental coplanarity. Masks remove grass under roads, plazas, crossings and foundations. Junctions replace overlapping avenue faces instead of stacking slabs.

Planning data per surface: `{region_id, owner, polygon_or_cells, ground_top_y, visual_top_y, collision_owner, material_role, source_module, approved_plan_revision}`. This is a **proposed data model**.

## Diagnostic protocol before edits

1. Duplicate `.rbxl` and reproduce glitch from a fixed camera viewpoint in Play and Edit.
2. Identify the specific path/name/`CFrame`/Size/Material/Transparency/MeshId of candidate Parts. Camera raycasts reveal **first collidable** face, not necessarily the visible flickering one.
3. Toggle *one group at a time on a copy* to isolate the conflicting visible surface(s), recording every step and comparison screenshot.
4. Check first whether the existing **reversible** hotfix removed imported paving; if not, inspect triangle source instead of applying a second blind mask.
5. Register both owners and the final approved single-surface region before code implementation.

See [`09-refonte-urbaine/03_STRATES_DU_SOL_ET_Z_FIGHTING.md`](../09-refonte-urbaine/03_STRATES_DU_SOL_ET_Z_FIGHTING.md). Hard blocker: **no reproducible flashing lawn or giant white polygon** in main traversal route.
