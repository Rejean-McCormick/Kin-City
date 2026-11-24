# 10 — Acceptance gates: source → geometry → Studio → published client

## Gate A: source/contract invariants (automatable)

- Nine unique Place keys; B09 without Place; six district keys unchanged.
- Sixteen reciprocal door records, 49 anchors, 24 canonical + 24 generated rooms.
- 23 KC33 contractual files verified against the frozen snapshot, unless an approved migration increments the contract version and fixtures.
- Module adapter signatures and namespaces validated; all nine contributions recognized.
- No hardcoded credentials/real PlaceIds; production remains protected.

## Gate B: city plan (requires new tooling; PROPOSED)

- No oriented building polygon crosses a street or public path reservation.
- Every approach route reaches a valid façade threshold and protected door/spawn.
- Approved surface ownership: one visible opaque ground top per area, no z-fighting candidates.
- Sign positions do not obstruct circulation or follow camera; no `SECTEUR 10 H` public text.
- No giant suspended parts near spawn; restored V30-style visual readability.

## Gate C: Roblox Studio (not replaced by unit tests)

- Import/package preserved; builds complete in Play/Studio without red errors.
- Actual collision, stairs/lifts, doors, interactions and accessibility of all six rooms per institution inspected.
- White lawn flashing reproduced and **shown absent** across camera movement/graphics settings on the corrected code.
- Before/after V30 and KC35 images from repeatable camera rigs, three profiles LITE/STANDARD/SHOWCASE; mobile FPS and memory measured.

## Gate D: private published-client staging

- Create nine Roblox Places with real authorized IDs in one universe; use staging-only installers.
- Seven publicly open city→institution routes, **one museum city entry intentionally blocked**, and eight return routes; test all valid public transitions.
- Test failure/cancelled teleport handling and access permissions; do not claim tested via Studio's ordinary Play mode.
- Verify asset package visibility/update and playback policy in live client; video remains unconfigured until authorized Roblox asset.

## Gate E: release decision

Human review of KPIs/UX, performance, rollback and publishing permissions. Only B09 with explicit owner approval can mark release ready. `KinBuildState=Ready` and `KinBranchRuntimeState=Ready` are **runtime constructor signals**, not all-gates acceptance.
