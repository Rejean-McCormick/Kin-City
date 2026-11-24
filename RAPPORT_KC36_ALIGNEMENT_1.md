# KC36 — B09/B10 source alignment and physical-sign correction

Date: 27 October 2026. Input: `znapshot_KinCityV36_10271219.zip` plus missing, separately verified historical branch archives and urban-layout image from the owner's previous deliveries.

## Delivered

- Permanent site-level foundation elevation in the authored `ArtDecoLayout`/`ArtDecoBuildings` graph (eight canonical façades; not added bounding-box patches).
- Exclusive native avenue pavement from `KoaliUrbanism`, with GLB pavement overlays removed from **generation**, not deleted from the linked 121-model Package.
- EkoH 6-kiosk sign framework with **two side cylinders**, frame rotated toward sector axis and no centre occluder, preserving legible front/back text.
- B09 dispatches B10 to newly authored **physical, static** `B10WayfindingKC36`, with eight doorway plaques and zero giant duplicate avenue signs or BillboardGui. Original B10 source and historical receipts stay unchanged.
- `studio/KC36_INSTALL_ALIGNEMENT_COMMAND_BAR.luau` rebuilds the city in Edit mode from the corrected modules, archiving the previous world/runtime/shared modules before performing the build; rollback on a handled build/validation error. 53,129 bytes / 52,914 characters, beneath the 100,000 character Command Bar history limit.
- `studio/KC36_AUDIT_APRES_MIGRATION_RS.luau`: read-only inspection, never edits models.

## Tests actually performed (offline)

- `python -m unittest tests/test_kc36_alignment.py tests/test_b09_consolidation.py tests/test_b09_integration.py tests/test_kc35_integration.py -q`: **49 tests, PASS**.
- `python tools/validate_spatial.py`: **PASS, 0 errors** (canonical catalog/door/spatial consistency; **does not** prove no rotated footprint crosses an avenue).
- `python tools/b09_verify_consolidation.py`: **PASS, 83 historical staged files verified**.
- Frozen KC33 source check: **23/23 unchanged**.
- Full `python -m unittest discover -s tests -q`: 107 discovered; **103 ran/passed, 4 import errors because `lupa` is not installed**, so NOT reported as a complete green run.
- **Not run:** Roblox Studio runtime, mobile render/FPS, user Play visual check or nine published Places.

## Open spatial acceptance risks

- The existing 6 canonical facade/avenue footprint conflicts from `docs/09-refonte-urbaine/preuves/KC35_CHEVAUCHEMENTS_VOIRIE.csv` remain. A geometry-aware `RoadNetwork -> PlotInventory -> ApprovedSiteAssignments` compiler and a B09-coordinated anchor/door migration are still necessary before claiming no building is on a road.
- Flashing grass could also involve imported geometry or additional public-space overlays. The source explains one **real coplanarity** of site Floor vs main grass, but final visual resolution requires before/after Studio walking tests near Maison Orgo, Agora Korum and Kreative.
- Do not delete the `KC36AlignmentBackup` or the pre-migration `.rbxl` copy until inspection and explicit acceptance.

## Recommended immediate steps

1. Replace repo files using the KC36 ZIP overlay or extract the complete updated repo.
2. Open `KinCity_36_DEV.rbxl` in Studio and **save as** `KinCity_36_DEV_AVANT_ALIGNEMENT.rbxl`.
3. Command Bar: paste the *entire* `studio/KC36_INSTALL_ALIGNEMENT_COMMAND_BAR.luau` (Notepad copy/paste; no VS Code).
4. Run the read-only post-install audit in Command Bar, save, then Play and photograph EkoH reverse faces and the three lawn zones.
5. Log live failures; only after visual approval archive/clean old backup and begin the coordinated road/site design migration.
