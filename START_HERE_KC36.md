# Kin City KC36 — Full repo, ready for `C:\mycode\Kin_City\KinCityV36`

## Installation on Windows

**Use a clean, new directory.** Extract the contents of this ZIP *directly* into:

`C:\mycode\Kin_City\KinCityV36`

You should see these top-level paths immediately inside that directory:

```
KinCityV36/
  AGENTS.md
  README.md
  START_HERE_KC36.md
  src/
  docs/
  contrib/
  catalog/
  config/
  installer/
  tools/
  tests/
  inputs/branch_archives/
  assets/art-deco-glb/  (121 source GLB models)
  releases/           (Studio installer and optional visual patch)
  .github/
```

### PowerShell extraction

Run the following from PowerShell, adapting the downloaded ZIP path:

```powershell
$source = "$env:USERPROFILE\Downloads\KinCityV36_FULL_REPO_READY.zip"
$target = 'C:\mycode\Kin_City\KinCityV36'
New-Item -ItemType Directory -Force -Path $target | Out-Null
Expand-Archive -LiteralPath $source -DestinationPath $target -Force
Set-Location $target
Get-ChildItem -Name
```

Alternatively, use Windows **Extract All**, selecting **KinCityV36** as the destination. If your zip utility creates an extra enclosing folder, move that folder's contents up one level.

**Do not extract this repo into your Roblox Studio Place.** The `.rbxl` file remains separately at `C:\mycode\Kin_City\KinCityV35\KinCity_35.rbxl`; this archive is the source code and documentation workspace. Roblox Package `KinCityArtDecoLibrary` is already stored in Studio, not automatically reconstructed by unpacking this ZIP.

## Starting AI work

Read in this order:

1. `AGENTS.md`
2. `docs/10-ai-coordination/README.md`
3. `docs/10-ai-coordination/01_SOURCE_OF_TRUTH.md`
4. `docs/09-refonte-urbaine/` (layout, roads, plots and ground ownership)
5. `docs/10-ai-coordination/branches/B09.md` and the relevant B01–B10 branch brief

## Status and restrictions

- All 10 branch efforts are available: B01–B08 institutions, B09 integration, B10 city.
- The **code baseline remains KC35**; the KC36 geometry and orchestration overhaul is documented but **not yet implemented**.
- Preserve the canonical door/anchor IDs, the protected Art Deco Library PackageLink, and the B07 locked-museum-entry policy.
- V30 is the visual-quality reference; no `BillboardGui` floating road signs or sector clock labels.
- The local Studio Place is not inside this repository; keep a backup of `KinCity_35.rbxl` separately.
- `releases/` contains optional previously prepared local Studio scripts; do not re-run the full installer on your existing Place without a separate backup.

## Validate repo layout

From this directory, with Python installed:

```powershell
python tools/b09_verify_consolidation.py
python tools/b09_recipes.py --repo .
python -m unittest discover -s tests -p 'test_b09_integration.py'
python -m unittest discover -s tests -p 'test_b09_consolidation.py'
```

Historical tests requiring `lupa` may not run until the development dependencies are installed. No Studio or published multi-Place validation is implied.
