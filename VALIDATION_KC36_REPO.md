# KC36 repository package — validation report

Prepared as a directly extractable full repository for `C:\mycode\Kin_City\KinCityV36`.

## Included
- KC35 Luau source code (`src/`), installation tools (`installer/`, `releases/`), tests, configs, catalogs and existing assets.
- KC36 Markdown-first AI documentation (`AGENTS.md`, `docs/09-refonte-urbaine`, `docs/10-ai-coordination`, branch `AGENTS.md` files).
- B01–B08 and B10 contributions and B09 integrator, with archived original submissions in `inputs/branch_archives`.
- 121 original Art Deco GLB source assets in `assets/art-deco-glb`.

## Verified outside Roblox Studio
- `python tools/b09_verify_consolidation.py` — PASS (83 staged files, 9 contributing Places).
- `python tools/b09_recipes.py --repo .` — PASS (9 Place recipes).
- `python -m unittest discover -s tests -p 'test_b09_integration.py' -q` — PASS, 20 tests.
- `python -m unittest discover -s tests -p 'test_b09_consolidation.py' -q` — PASS, 10 tests.
- `python -m unittest discover -s tests -p 'test_b07_broadcast_integration.py' -q` — PASS, 3 tests.
- 121 GLBs exported without rebuilding them.

## Limitations
- KC36 urban redesign is specification only; KC35 remains the baseline implementation.
- Does not include the live Roblox `.rbxl`, published Package IDs, or a new verified nine-Place publication.
- Local source testing does not verify Play-mode rendering, mobility/performance, streaming, or teleportation.
- The assets' GLB backups are distinct from the Studio Package's registered 463 MeshParts.
