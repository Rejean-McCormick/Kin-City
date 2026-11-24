# 08 — One central Art Deco asset library

## Actual owner Studio evidence

- Original GLBs were found locally in `C:\mycode\Kin_City\Blender\KinCity_ArtDeco_V3_2_Sortie\IMPORTER_121_GLB` (121 files).
- User imported all 121 into `KinCity_AssetsMaster.rbxl`. Studio scan: 121 source wrappers, 121 distinct models, **463 MeshParts**, zero duplicates and invalid IDs.
- Script created `ServerStorage.KinCityArtDecoLibrary` with 121 canonical names `KC32__AD_*`; user converted it to a Roblox Package and inserted it into `KinCity_35.rbxl`.
- User's check in the city Place: `MODELES=121`, `MESHPARTS=463`, `PACKAGE LIE=true`, `STREAMING=true`, `PLACE ID=0`, `SOURCE COUNT=121` and `PASS`.

These are **user-provided Studio observations**; the actual `.rbxl` and Roblox package contents are not embedded in the KC35 source archive.

## Package integration contract

- The **authoritative editable** asset master remains in `KinCity_AssetsMaster.rbxl` and the corresponding private Roblox Package; `KinCity_35.rbxl` holds a linked copy.
- Build code **never writes to children of the linked Package**, never breaks `PackageLink`, never removes the master from `ServerStorage`, and never requires 121 GLBs to be reimported into each branch session.
- If a new asset version is required, modify/publish it through the master workflow and validate the linked copy on a staging Place. Require human authorization for package publishing and production deployment.
- Distinguish 121 available sources from 41 configured active placements and 80 library-only catalog records. Do not automatically scatter every model throughout the city.
- Verify the Package in a safe local/staging copy before installing or updating runtime. Roll back to a saved `.rbxl` if drift detected.

Asset package **presence is not** a performance guarantee. KC36 plans should track model budgets per district, not assume all 463 MeshParts are resident at once in all nine Places.
