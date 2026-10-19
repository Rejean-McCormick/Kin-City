# Places & Teleportation

**v26's major structural change** is the ability to build the exterior city and each major institution as an independent Roblox Place. This is a code/build feature today; the **published, end-to-end travel path remains unverified**.

## Place registry

| Place key | Content | Installer |
| --- | --- | --- |
| `city` | Exterior city, eight visible entrances | `KinCity_Installation_Place_city_v26.luau` |
| `city_hall` | City Hall interior | `KinCity_Installation_Place_city_hall_v26.luau` |
| `ekoh_tower` | EkoH Tower interior | `KinCity_Installation_Place_ekoh_tower_v26.luau` |
| `library` | Great Library interior | `KinCity_Installation_Place_library_v26.luau` |
| `campus` | KonnectED University interior | `KinCity_Installation_Place_campus_v26.luau` |
| `justice_palace` | Justice Palace interior | `KinCity_Installation_Place_justice_palace_v26.luau` |
| `innovation_lab` | Innovation Park/Lab interior | `KinCity_Installation_Place_innovation_lab_v26.luau` |
| `museum` | Kreative Museum interior | `KinCity_Installation_Place_museum_v26.luau` |
| `orgo_center` | Orgo Center interior | `KinCity_Installation_Place_orgo_center_v26.luau` |

`KinCity_Installation_Directe_v26.luau` is an alias for the **exterior city** installer. The backup-compatible `KinCity_Installation_Univers_Local_v26.luau` deliberately builds everything in one Place.

## First, preview the split scenes

Use the targeted installers **in different Studio Places**. They do not require published Place IDs; consequently, the doors cannot make real inter-Place journeys in this preview. Their unavailable-state signage is intentional.

## Then, prepare a published experience

1. Create a Roblox **experience** with nine Places, with `city` as the intended entry Place.
2. Publish each Place and collect its **real numeric Place ID** from Roblox.
3. Fill **all nine** values in `config/place_ids.json`. Do not reuse an ID or invent a placeholder.
4. Change `config/runtime.json` to `{"mode":"MULTI_PLACE"}` (preserving or appropriately updating other JSON fields).
5. Rebuild with `python tools/build_release.py`.
6. Run the corresponding **regenerated** installer in each matching published Studio Place.
7. Publish all nine Places and test an entrance **and return trip** from an actual published Roblox client.

The router checks source/target place identity and the canonical door/arrival anchor. Actual Roblox teleport behavior and any publishing restrictions must be confirmed in the client.

## Expected package boundaries

The v26 manifest documents **eight canonical city entrance doors** and **one canonical exit per institution**. Institutions should generate **no exterior city**, while `city` should contain **no large institution interior**. The per-Place package contains its own relevant interior mechanisms and UI.

Run `KinCity_Diagnostic_Places_v26.luau` on each scene to inspect `KinActivePlace`, `KinSeparatedWorld`, door and interaction counts, and whether the expected city/interior geometry is present.

## Important limitations

- The delivered `config/place_ids.json` contains **only `null`** values.
- `SPLIT_PREVIEW` and local tests do **not** prove inter-server teleportation.
- A transition may have loading time, errors, or restrictions; handle failures and retry from a safe location in the published client.
- The nine-Place model was chosen to keep major interiors separate, **not** to guarantee a particular FPS or memory saving without measured tests.

[Quick Start](Quick-Start) · [Troubleshooting](Troubleshooting)
