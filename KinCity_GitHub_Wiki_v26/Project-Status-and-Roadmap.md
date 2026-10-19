# Project Status & Roadmap

**Baseline:** Kin City construction **v26**, October 19, 2026.

## What exists in source code

- Procedural exterior city with neighborhoods, public spaces, transit, decorative and local activity modules.
- Eight institution interiors built with separate Place-targeted installers, while keeping an all-in-one local fallback.
- A reusable teal/opal visual kit, institutional galleries, exhibits, residential and secondary-building architecture.
- Local UI systems: map, navigation, journals, workshop, transport and local detail controls.
- Optional original OBJ meshes, material maps and WAV beds.
- Offline build/contract tests and a v26 per-Place diagnostic.

## Not yet demonstrated as production-ready

- A published Roblox experience containing **all nine real Place IDs**.
- Verified exterior-to-interior and interior-to-exterior `TeleportAsync` travel.
- Full Roblox Studio Play, collision, spawn, R15 and multiplayer behavior.
- Performance budgets on real low-end mobile and desktop hardware.
- Final imports, permissions and visual assessment for OBJ/PBR/audio assets.
- Production-ready accessibility, reliable transport interruptions and long-running-session profiling.

## kOA integration boundary

The runtime remains **`WORLD_STUB`**. No active kOA backend, Smart Vote, education account, identity verification, EkoH ledger, payment service or AI API is configured. Terminals with future capabilities display **“Fonctionnalité à venir”**. This is deliberate and must not be presented as a production service.

## Recommended next milestones

1. **First in-engine reality check:** install exterior-only v26 in Studio; record the first genuine errors and inspect the visual result.
2. **One interior pilot:** build the Great Library (or another single institution) independently; verify doors, spawn, rooms, galleries and exhibits.
3. **Publish and test the nine-Place configuration:** enter real IDs and verify both directions of real client teleportation.
4. **Profile actual costs:** exterior plaza, institution interiors, transport use, low-end mobile, multiple players and 30-minute sessions.
5. **Apply targeted corrections:** colliders, UI, physics, NPC activity, object reuse and streaming based on measured issues.
6. **Finish art integration:** import only the meshes/materials/audio assets that materially improve the visual result and fit measured budgets.

Avoid endlessly expanding the map until the existing city can be visited reliably. This wiki intentionally makes no promise of a finished or publicly accessible game.
