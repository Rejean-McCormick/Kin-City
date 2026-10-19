# Quick Start — Build Kin City in Roblox Studio

The simplest first test is **the exterior city alone**. You do not need the nine published Places or any imported meshes.

## Prerequisites

- Roblox Studio and a local copy of the **Kin City v26** repository or delivery ZIP.
- A **saved test Place** you are comfortable replacing with the generated world.
- Access to Studio's **Command Bar** and **Output** panels.

> **Caution:** the installation is direct and replaces existing Kin City generated content. There is **no rollback**. Work in a separate test Place or save a backup first.

## A. Preview the exterior city

1. Open Roblox Studio and create/open a test Place (a Baseplate is sufficient).
2. While in **Edit mode**, open **View → Command Bar** (menu location may vary by Studio version).
3. Open `KinCity_Installation_Directe_v26.luau` in a text editor, copy its **entire** contents, paste into the Command Bar, and run it **once**.
4. Inspect Explorer for `Workspace.KinCityGenerated`, `ReplicatedStorage.KinCityShared`, `ServerScriptService.KinCityRuntime`, and `StarterPlayer.StarterPlayerScripts.KinCityUI`.
5. Open **Output** and check for errors. Press **Play** to explore the exterior city.
6. A city entrance to an institution will announce that its separate Place must be published: this is **expected**, not a missing local teleport.

Do **not** run the installer inside Play mode; it is intended for edit-time generation.

## B. Preview an institution separately

1. Open a **different** test Place in Roblox Studio.
2. Choose one of `KinCity_Installation_Place_<key>_v26.luau` (for example, `KinCity_Installation_Place_library_v26.luau`).
3. Run the selected file in the Edit-mode Command Bar.
4. Press Play and explore that one institution, its rooms, galleries and local exhibits.

**Do not run all nine installers sequentially in one Place.** Each installer targets and replaces the currently generated Kin City scene. See [Places & Teleportation](Places-and-Teleportation).

## C. Optional local all-in-one test

`KinCity_Installation_Univers_Local_v26.luau` builds the exterior and all eight interiors inside **one** Place. It is convenient for checking internal doors without publishing. It is **not** the target split deployment and does not separate server memory.

## D. Check what was built

Run `KinCity_Diagnostic_Places_v26.luau` in the Edit-mode Command Bar after installation. The script reads the generated scene and reports the active target, build state, number of city/interior models, parts and prompts, and canonical door/interaction counts.

For detail-level counts (parts, meshes, lights, seats), see `KinCity_Diagnostic_Studio_v25.luau`.

## What to do next

- [Controls & Interactions](Controls-and-Interactions) for visiting the city.
- [Troubleshooting](Troubleshooting) if a script errors or a scene seems incomplete.
- [Places & Teleportation](Places-and-Teleportation) when you are ready to create a real multi-Place experience.

**Validation boundary:** a successful Command Bar run is not a substitute for Play-mode tests; Studio Play tests do not fully replace teleport testing in the published Roblox client.
