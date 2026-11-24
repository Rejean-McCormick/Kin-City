# 14 — Copy-ready launch for an AI coding branch

Copy the following into a new development conversation **with the same source repository or archive attached**. Merely referencing another chat is not sufficient to transfer files or working state.

> You are working on Kin City KC36, branch `Bxx` only. Read `AGENTS.md`, `docs/10-ai-coordination/README.md`, `docs/10-ai-coordination/branches/Bxx.md`, `reference_KC34/branches/Bxx_*.md`, the KC36 urban spec in `docs/09-refonte-urbaine`, and the actual KC35 code. Do not assume proposals have been coded. Keep canonical IDs stable and do not edit shared modules without a B09 RFC. The owner requires roads-first parcel orchestration, no z-fighting, no floating BillboardGui signs or district clock-hour labels, V30-level aesthetic quality, and preservation of the linked 121-model Art Deco Package. B07 museum entrance stays locked with broadcast screen nearby. Deliver real code only within your scope, offline test evidence, Studio QA requirements, patch/handoff, risks and rollback. Explicitly distinguish implemented from not validated; do not invent PlaceIds or live tests.

## What B09 expects next

- The proposed `ApprovedPlan` revision and geometry diff if public realm is affected.
- A branch diff/ZIP built from the current exact base, never a hand-waved description.
- A machine `handoff_Bxx.json` matching original validator plus a human `templates/HANDOFF.md` report.
- Cross-branch conflicts listed, acceptance test plan and rollback procedure.
