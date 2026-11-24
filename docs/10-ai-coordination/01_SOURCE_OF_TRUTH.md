# 01 — Source of truth, vocabulary and evidence

## Precedence for future changes

1. Latest explicit product decisions in this conversation (e.g. no floating signs, not `10 H`, museum door locked, V30 artistic preference).
2. Accepted ADRs and versioned contracts. Proposed ADRs remain proposed.
3. Current source and machine contracts as evidence of **what code presently does**.
4. Validated Roblox Studio observations provided by the owner (e.g. 121 models/463 MeshParts and a local Play visual defect).
5. Design/specification documents as target proposals, **not** a claim of implementation.
6. External Roblox guidance for APIs, checked at implementation time.

## Named snapshots

- `KC33`: frozen baseline for 23 contractual files; original shared contract version `KC34-DOC-1.0`.
- `KC34`: parallel branches and B09 governance/consolidation process.
- `KC35`: integrated Luau runtime (`BranchRuntime` and B08 rebase) plus nine logical Places, **not** nine validated/published Roblox Places.
- `KC35 visual hotfix`: reversible local correction for floating B10 banners and GLB paving; the uploaded user's `.rbxl` may differ from these repository ZIP files. Do **not** assume this hotfix was baked into KC35 code without inspecting the exact source.
- `KC36`: **documentation-first proposed refactor** for planning roadways/plots before building, eliminating overlapping surfaces and restoring V30 visual clarity.

## Required status words

`DECIDED` / `DECIDE` — explicit owner policy. `OBSERVED_IN_SOURCE` — inspectable code/data only. `OBSERVED_IN_STUDIO` — output/screenshot from a user session. `PROPOSED` — architectural target, no implementation claim. `OFFLINE_PASS` — scripts/tests succeeded without Roblox runtime. `STUDIO_QA_PENDING` — real QA absent or incomplete. `PUBLISHED_CLIENT_PENDING` — published-client test not performed. `BLOCKED` — cannot mark ready. `ACCEPTED` — B09 decision backed by proof.

## Important facts

- Ten development branches **B01–B10**, but nine `place_key`s. **B09 has no Place**.
- Six outer districts + central civic hub. Eight public institutions. Eight entrances, eight exits represented canonically; museum outer entry explicitly locked, so never call all sixteen prompts publicly usable.
- 49 anchors; 24 rooms in compiled plan and 24 additional wing/atrium rooms from `InteriorWings` = 48 intended rooms.
- Source asset catalog: 121 models, of which 41 configured in the KC33 Art Deco build and 80 library-only. User's imported central Package: 121 models, 463 MeshParts, `PackageLink=true`, `StreamingEnabled=true`, `PlaceId=0` in a local Studio validation session.
- `Plan.canonical_sha256` from KC35 `build/world-plan.json`: `5941cd6ecd89ea806cd5b815fcc128b1abef1cff77f77d670dbe01c7f487039a`.

Read the [source audit](evidence/REPOSITORY_PROVENANCE.md) for the exact archive fingerprints rather than trusting manually copied values in discussions.
