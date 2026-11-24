# Kin City — instructions for AI coding agents (KC36 documentation baseline)

**Read first:** [`docs/10-ai-coordination/README.md`](docs/10-ai-coordination/README.md), then [`docs/10-ai-coordination/01_SOURCE_OF_TRUTH.md`](docs/10-ai-coordination/01_SOURCE_OF_TRUTH.md) and your branch brief under [`docs/10-ai-coordination/branches/`](docs/10-ai-coordination/branches/README.md).

This repository contains the **KC35 runtime source**, the historical KC34 contracts and ten branch workstreams, and the **KC36 target architecture documented in Markdown**. KC36's urban planner/orchestrator is not implemented merely because it is documented. Do not report proposed features as shipped.

## Strict behavior

1. B01–B08 own an institution's local content; B10 owns city exteriors/public realm; B09 owns shared APIs, contracts, validation, integration. **B09 is not a Roblox Place** (ten branches, nine Places).
2. Before changing anything, read the KC35 source manifest and the machine contracts. Keep the canonical Place keys, building IDs, doors, anchors and interaction IDs stable; migrate them through B09 RFC/ADR if required.
3. No floating dynamic BillboardGui signage, no public hour-number sector names (e.g. `10 H`), no overlapping ground faces, no institutions intersecting reserved road corridors. Preserve V30 as the **visual-quality reference**, not as source code to blindly roll back.
4. The museum's `city.kreative.museum.entry` stays **blocked by explicit product decision**. A prominent broadcast screen belongs near the museum, but Roblox VideoFrame does not directly play a YouTube livestream. Never pretend a livestream works with no authorized Roblox video asset.
5. `ServerStorage.KinCityArtDecoLibrary` is a **linked, centrally maintained Package** with 121 top-level models and 463 MeshParts verified in the user's Studio log. Do not unpack, overwrite, delete or modify this Package; clone instances when rendering. Local `.rbxl` evidence is not present in this repository.
6. Never invent real PlaceIds, FPS, teleport QA or Studio screenshots; offline unit tests do not establish live acceptance. Never touch production without explicit authorization and a backup.
7. Every branch submission includes modified paths, base revision, tests actually run, affected contracts, visual evidence if measured, risks, rollback and a handoff for B09.
8. Prefer to update **Markdown docs in the same change as code**, documenting observed state separately from target architecture. Stop at any failed spatial or contract gate.

Key maps: [`docs/09-refonte-urbaine/`](docs/09-refonte-urbaine/00_LIRE_EN_PREMIER.md) (KC36 target), [`docs/B09/`](docs/B09/README_B09.md) (integration source docs), [`reference_KC34/branches/`](reference_KC34/branches/B09_integration.md) (original detailed briefs).

## KC36 alignment implementation (source revision)

Read [`docs/09-refonte-urbaine/09_KC36_IMPLEMENTATION_ALIGNEMENT_1.md`](docs/09-refonte-urbaine/09_KC36_IMPLEMENTATION_ALIGNEMENT_1.md) before editing surfaces or public signs. The eight institution foundation levels, removal of avenue mesh overlays and twin-post EkoH sign architecture **are now implemented in source**. B10 historical provenance is preserved; the runtime now uses `B10WayfindingKC36` via B09 `BranchRuntime`. **Road/plot resiting is not implemented**: do not misrepresent the 6 old spatial conflicts as resolved. Use `studio/KC36_INSTALL_ALIGNEMENT_COMMAND_BAR.luau` for a guarded, rebuild-based Studio migration, never old full-reset installers.
