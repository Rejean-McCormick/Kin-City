# KC36 / AI orchestration hub

**Status:** Documentation and architectural planning; KC35 runtime implementation remains a separate, inspectable baseline.

## How an agent starts

1. Read repository [`AGENTS.md`](../../AGENTS.md) and [source-of-truth rules](01_SOURCE_OF_TRUTH.md).
2. Pick **exactly one** [branch brief](branches/README.md); inspect its original KC34 brief, `contrib/places/<place_key>` and `src/server/Bxx*` files.
3. Read the [KC36 urban refactor](../09-refonte-urbaine/00_LIRE_EN_PREMIER.md) **before** proposing placement/road/ground changes.
4. Follow [handoffs](09_INTEGRATION_PROTOCOL.md), [quality gates](10_QUALITY_GATES.md), and [status reporting](13_STUDIO_VS_SOURCE.md).
5. B09 reviews cross-branch changes. One changed dimension does not authorize other shared changes.

## Canonical navigation

| Document | Purpose |
|---|---|
| [01 — Truth and precedence](01_SOURCE_OF_TRUTH.md) | Implemented vs observed vs accepted vs target |
| [02 — Ten-branch matrix](02_BRANCH_MATRIX.md) | Ownership and cross-branch handoffs |
| [03 — System architecture](03_SYSTEM_ARCHITECTURE.md) | Existing KC35 vs target KC36 |
| [04 — Urban order](04_URBAN_INTEGRATION_ORDER.md) | Roads-first, plots, foundations, façade, decor |
| [05 — Spatial contracts](05_SPATIAL_CONTRACTS.md) | Footprints, buffers, portals and paths |
| [06 — Ground ownership](06_GROUND_SURFACE_AUTHORITY.md) | White flashing lawn and single visible top surface |
| [07 — Visual style](07_SIGNAGE_AND_VISUAL_STYLE.md) | V30 reference, no floating/hour banners |
| [08 — Central assets](08_ASSET_PACKAGE.md) | 121 models; versioned Roblox Package |
| [09 — Merge protocol](09_INTEGRATION_PROTOCOL.md) | Agent handoffs and owner review |
| [10 — Gates](10_QUALITY_GATES.md) | Tests and acceptance evidence |
| [11 — Issues](11_KNOWN_ISSUES.md) | Blockers, source/Studio mismatches |
| [12 — Roadmap](12_ROADMAP.md) | Future refactor milestones |
| [13 — Reality check](13_STUDIO_VS_SOURCE.md) | What a successful local Play does *not* prove |
| [14 — Prompt / handoff](14_PROMPT_HANDOFF.md) | How to launch parallel work safely |
| [Branch-specific instructions](branches/README.md) | B01–B10 work scopes |
| [Original KC36 architectural spec](../09-refonte-urbaine/00_LIRE_EN_PREMIER.md) | Deep spatial study, ADRs, proposed schema |

Original source briefs are also available as [read-only KC34 snapshots](historical-kc34-briefs/README.md) for AI workflows that only receive the documentation ZIP.

## Two explicit sources of truth

- **Code/current data:** `build/world-plan.json`, `catalog/`, `config/`, `src/`, `contrib/`, `docs/B09/`, `reference_KC34/` in the KC35 repository snapshot.
- **Target urban design:** `docs/09-refonte-urbaine/` including ADR-018–020, subject to review gates and approval.

If their content diverges, **do not silently reconcile**: record the conflict, cite both paths, propose a migration and request B09 review.
