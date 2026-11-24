# KC36-ALIGNMENT-1 — Geometry and signage implementation (27 Oct 2026)

**Status:** Source implemented; 49 scoped offline tests passed; Roblox Studio/client acceptance **NOT EXECUTED**. This is a B09/B10 shared-source migration, not the final urban-site compiler.

## Source of truth / changed files

| Ownership | Source | Actual implemented change |
|---|---|---|
| B09/B10 shared | `src/server/ArtDecoLayout.luau` | Explicit institution foundation top at Y=0.32 relative to the building site. Old Y=0 was coplanar with grass disk top Y=0. |
| B09/B10 shared | `src/server/ArtDecoBuildings.luau` | One foundation per institutional façade even with imported wings; marked `KinGroundAuthority=institution-foundation` and stable building owner. |
| B10 | `src/server/KoaliUrbanism.luau` | Native avenue slab is sole visible avenue pavement authority. Imported paving GLBs are **not placed on top** of it. Other imported assets remain. |
| B10/EkoH | `src/server/EkohHalo.luau` | Central filament removed from six discovery kiosks. Two rotated slim cylinder posts, perimeter fixings and double-sided board, aligned to the actual sector direction. |
| B09 integration | `src/server/BranchRuntime.luau` | Uses `B10WayfindingKC36` instead of the original historical B10 provider. The other eight contributions are unchanged. |
| B10 extension | `src/server/B10WayfindingKC36.luau` | Eight physical, static, two-face institutional access plaques; zero redundant avenue panels; no `BillboardGui`; no public hour labels; museum locked status displayed. |
| B09 Studio | `studio/KC36_INSTALL_ALIGNEMENT_COMMAND_BAR.luau` | Guarded, one-shot, rollback-capable **reconstruction from the source modules**, not hotfix geometry. |
| B09 QA | `studio/KC36_AUDIT_APRES_MIGRATION_RS.luau`, `tests/test_kc36_alignment.py` | In-Studio assertions plus offline invariants. |

## Surface layers

- Main circular grass (`CityGenerator.make`) top: world Y = 0.
- Native pedestrian mesh (`CityGenerator.streetTiles`) top: Y = 0.21.
- Institution foundation surface top: building-site Y + 0.32; **single foundation owning the institution footprint**.
- Native avenue slab top: Y = 0.535. It currently intersects some institutional footprint projections — **not solved by this correction**.
- `ArtDecoProps.street` paving GLB is no longer called over the native avenue slabs. All 121 master models remain unmodified.

Do not generate additive site slabs from bounding boxes. The previous `KC36Hotfixes/FloorPatches` lives only in the archived old world after the explicit rebuild, not the new city. Existing manually created local floor patches must **not** be migrated into the new scene.

## Architectural direction for the two example signs

- **Avenue KonnectED**: original `KoaliUrbanism` sign retained (baseline accepted visually by owner).
- **EkoH • Création & mémoire** and other 5 EkoH panels: remove the opaque shaft at the centre, orient the frame with its avenue, mount between two slim cylinders just outside the text board footprint, and keep front/back `SurfaceGui`.
- B10 may not create a second giant district board or `SECTEUR 10 H`. Existing historical B10 files/hand-offs are preserved for provenance; their **runtime output is replaced** by a new KC36 adapter.

## Migration and rollback contract

1. Save copy `KinCity_36_DEV_AVANT_ALIGNEMENT.rbxl` using Roblox Studio **File > Save As** before running anything.
2. In the working Place, verify Play stopped, `game.PlaceId==0`, `workspace.StreamingEnabled`, `KinArtDecoTestPlace` and the linked central Package 121/121.
3. Paste the entire ~52-k-character `studio/KC36_INSTALL_ALIGNEMENT_COMMAND_BAR.luau` into the Studio **Command Bar**. No VS Code or Rojo required. It stages the *existing* runtime, shared ModuleScripts and existing generated world in `ServerStorage/KC36AlignmentBackup`, installs six corrected server modules and the generated shared `BuildIdentity` from this repository, and calls `WorldBuilder.build(false)` plus the B09 branch adapter.
4. Its postconditions require eight authoritative floors, six corrected EkoH kiosks, eight physical B10 access plaques, **zero** B10 billboards and **nine** integrated branches. Any Lua exception caught during construction triggers world+runtime rollback, preserving the central Package.
5. Run `studio/KC36_AUDIT_APRES_MIGRATION_RS.luau`, save, start Play, walk past EkoH and the three reported lawn sites; take daytime/nighttime front/back captures. Rollback manually by reopening the saved `.rbxl` copy, or from `KC36AlignmentBackup` after inspecting the failed build.
6. Never run the old `installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau` over this Place. It is a historical **full-reset** installer, not the guarded KC36 migration.

If Studio fails before a new world reaches its postconditions, the migration restores the old instances automatically. A crash of Studio itself cannot be guaranteed to rollback; that is why the separate saved `.rbxl` remains mandatory.

## Explicitly NOT fixed/approved

- The six documented rotated building footprint vs avenue intersections remain on the **canonical KC35 positioning plan**. Resiting a building requires a B09-approved site/door/return-anchor migration, not blind movement of a façade.
- The user's flashing lawn has a source-supported potential explanation (`Floor` at Y=0 vs grass at Y=0); in-Studio before/after visibility, streaming and imported-mesh checks are still required. Do not claim fully solved until verified in Play.
- Overlapping *other* public-ground producers, mobile FPS budgets, and published nine-Place navigation are not qualified by this patch.

## QA gates

1. 23 canonical frozen sources unmodified; B09 historical receipts and archives kept intact.
2. Corrected modules are authoritative for all fresh scene builds in this migration; no incremental Part hides or speculative extra slabs.
3. Library PackageLink+121 models retained and in `ServerStorage`.
4. Eight external `Floor` top levels above lawn, six native avenue surface owners, six sign portiques with **two** posts each.
5. No `BillboardGui` under B10; library story labels outside B10 remain untouched.
6. B09 `KinBranchReadyCount=9`; museum entry remains explicitly blocked server-side.
7. Visual screenshots and moving-camera inspection in Roblox Studio are required before promotion to a KC36 release candidate.
