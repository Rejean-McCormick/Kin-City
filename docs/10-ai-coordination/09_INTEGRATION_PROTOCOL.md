# 09 — B09 merge and handoff protocol

## Branch lifecycle

`DRAFT → READY_FOR_REVIEW → CONTRACT_CHECK → SPATIAL_REVIEW → MERGE_CANDIDATE → STAGING_QA → ACCEPTED`.

A branch can be **source-merged and runtime-wired** while still `BLOCKED` for visual or published-client acceptance. The KC35 branch ledger intentionally records `runtime_integrated=true` and `studio_validated=false` together.

## Required handoff

1. Branch ID + owner key + versioned base hash + current commit/patch ID.
2. Exact `changed_files`, SHA256 or diff, and expected runtime invocations.
3. Contract impact (`LOCAL`, `SHARED`, `BREAKING`), any affected door/anchor/plot/surface owner.
4. Positive and negative tests **actually executed** with environment and results.
5. Before/after geometry evidence (plots, sidewalks, screenshot pair) if visual or spatial.
6. Budget and mobile implication, or explicit `NOT_MEASURED`.
7. Outstanding dependencies and revert instructions. Never claim published status without evidence.

Original `kincity.handoff/1.0` JSON validator: `tools/b09_contracts.py` and `reference_KC34/protocoles/handoff_modele.json`. Existing source archive handoffs are under `docs/B09/consolidation/original_handoffs/`. Text [template](templates/HANDOFF.md) accompanies rather than replaces the machine contract.

## Integration sequence

B09 runs schema/handoff/frozen-source checks, then reviews any proposed plot migration with B10, then checks runtime compatibility and absence of duplicate decorations, then signs off greybox/surface maps, then authorizes staging. Do **not** merge world-coordinate hacks independently from `RoadNetwork` / `PlacementPlan` revision.

## Scope conflict rules

- B01–B08 may add building-internal décor only unless explicitly approved via a shared surface/interface RFC.
- B10 may propose building plots but may not rename institutional room/door contracts.
- B09 may adapt runtime but must not erase a branch's approved artistic intention silently.
- Asset master edits occur via separate package publication workflow and are **not** part of ordinary branch handoffs.
