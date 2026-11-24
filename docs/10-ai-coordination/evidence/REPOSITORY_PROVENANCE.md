# Evidence — archive provenance and branch presence

**Scope:** fingerprints checked against files available in the current artifact workspace. This report is source/document audit, not engine execution.

| Artifact | SHA256 | Role |
|---|---|---|
| `KinCity_KC35_INTEGRATION_9_BRANCHES_COMPLET.zip` | `43bcac524a380387fb0a600c87fcb63e259e4cbc85a4ee09486594712dd32085` | Executable source baseline for agent work |
| `KinCity_KC36_DOCUMENTATION_URBANISME_COMPLET.zip` | `18983ed654ba507e70e72e34c9fcc93acacbe862f583ddce805fd0b557df7156` | Existing Markdown urban refactor proposal, preserved in `docs/09-refonte-urbaine` |
| `KinCity_KC35_VISUEL_V30_CORRIGE_SOURCE_COMPLET.zip` | `0f3cad67db60052f6eb5915b0b1d5615b50f159326a54a21990fb940ed27ad17` | Visual-fix variant; **not silently merged** with baseline source |

**Canonical plan SHA:** `5941cd6ecd89ea806cd5b815fcc128b1abef1cff77f77d670dbe01c7f487039a`. **Frozen KC33 ZIP SHA:** `1fd3968977823a8814f54f766164c85e02cda3e370df984455f8c3f7db877c89` (declared by B09 baseline). **9 logical Places** / **10 branches**.

## Branch ledger as actually shipped in KC35

| Branch | Place | Status in source ledger | Source home |
|---|---|---|---|
| B01 | `city_hall` | ledger status `BLOCKED`, runtime wired `True`, Studio validated `False` | `contrib/places/city_hall/` |
| B02 | `ekoh_tower` | ledger status `BLOCKED`, runtime wired `True`, Studio validated `False` | `contrib/places/ekoh_tower/` |
| B03 | `library` | ledger status `BLOCKED`, runtime wired `True`, Studio validated `False` | `contrib/places/library/` |
| B04 | `campus` | ledger status `BLOCKED`, runtime wired `True`, Studio validated `False` | `contrib/places/campus/` |
| B05 | `justice_palace` | ledger status `BLOCKED`, runtime wired `True`, Studio validated `False` | `contrib/places/justice_palace/` |
| B06 | `innovation_lab` | ledger status `BLOCKED`, runtime wired `True`, Studio validated `False` | `contrib/places/innovation_lab/` |
| B07 | `museum` | ledger status `BLOCKED`, runtime wired `True`, Studio validated `False` | `contrib/places/museum/` |
| B08 | `orgo_center` | ledger status `BLOCKED`, runtime wired `True`, Studio validated `False` | `contrib/places/orgo_center/` |
| B09 | Integration, no Place | branch_ledger status `ACCEPTED` | `src/server/BranchRuntime.luau` |
| B10 | `city` | ledger status `BLOCKED`, runtime wired `True`, Studio validated `False` | `contrib/places/city/` |

**Warning:** `BLOCKED` in a branch ledger does not mean missing source—it denotes outstanding acceptance/staging gates. KC35 runtime adapter includes all nine Place keys. B07 is present with a locked exterior museum entry; B08 was rebased from V3 to KC33-native runtime.

**Files not included:** user's local `.rbxl`, Roblox Package bytes/permissions, published PlaceIds, Studio runtime traces for all nine published Places.
