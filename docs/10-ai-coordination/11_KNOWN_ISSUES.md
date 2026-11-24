# 11 — Current blockers and contradictions register

| Issue | Evidence | Confidence | Required next action | Owner |
|---|---|---|---|---|
| Lawn flashes white/large white wedge | User's KC35 Play screenshot, KC36 ground study | OBSERVED symptom, UNCONFIRMED source | Identify exact overlapping/oversized Part(s) or imported mesh; trace to generator | B09/B10 |
| Buildings placed on public roads | Source-derived KC35 oriented-footprint intersections (six cases) | STATIC AUDIT; Studio QA pending | Compile roads before plots; reject conflict; migrate as a group | B09/B10 |
| Floating `SECTEUR 10 H` labels | Source `B10Wayfinding` + Play screenshot | CONFIRMED | Remove dynamic BillboardGui city signage; physical signs only | B10/B09 |
| Suspended facade/visual clutter | User's Play screenshot | OBSERVED visual issue | Compare identical camera paths with V30, update height/parcel plan | B10 |
| Museum entrance locked | Explicit owner decision, code in B07/PromptRouter | INTENDED behavior | Keep protected; verify server policy and accessible broadcast placement | B07/B09/B10 |
| YouTube livestream screen | Roblox VideoFrame cannot embed actual YouTube stream; no authorized asset in source | KNOWN LIMITATION | Show honest configured/unconfigured state; choose approved video asset | B07/B09 |
| Nine contribution runtime result | KC35 `BranchRuntime` code + user's successful installer Output | WIRED; LIMITED LOCAL TEST | Execute full UX/geometry/visual QA before release | B09 + all |
| V30 visual quality regression | User preference, screenshot, V30 source comparison | CONFIRMED preference; no complete feature-by-feature QA | Capture comparison and restore positive design choices intentionally | B10 + art direction |
| 110×100 nominal interior bounds vs wings | KC33 contract audit | DOCUMENTED architectural mismatch | B09 RFC/geometry review to align bounds with actual six rooms | B09 + B01–B08 |
| Asset library centralization | User Studio output 121/121, 463 meshes, PackageLink true | CONFIRMED in user's local Place at time of test | Keep package linked and backed up; validate changes in staging | B09/assets |
| Multi-Place publication | No user-provided real PlaceIds or published-client test for nine KC35 Places | UNVERIFIED | Stage all nine, authorize/publish and test teleportation | B09 |

**Do not erase blockers simply because a static unit test passes.** The details live under [`09-refonte-urbaine/07_QUALIFICATION_ET_MIGRATION.md`](../09-refonte-urbaine/07_QUALIFICATION_ET_MIGRATION.md).
