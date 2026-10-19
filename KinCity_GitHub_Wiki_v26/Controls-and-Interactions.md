# Controls & Interactions

Most physical interactions use Roblox **ProximityPrompts**: approach a visible prompt and activate it (commonly the **E** key on desktop). Device prompts may provide corresponding mobile/gamepad controls.

## Documented desktop shortcuts

| Key | Feature | Availability |
| --- | --- | --- |
| `E` | Activate a nearby ProximityPrompt | Where prompts are installed |
| `M` | City map | Exterior city |
| `N` | Route guide | Exterior city |
| `J` | Exploration journal | Exterior city |
| `G` | Intermodal/station panel | Exterior city |
| `K` | Workshop interface | Exterior city |
| `P` | Sky tour | Exterior city |
| `T` | Gallery discovery journal | Institution Places and local mode |
| `V` | Local crystal/detail visual quality settings | Both city and interiors |
| `Esc` | Close a supported dialogue or panoramic view | While the relevant UI is active |

Several features also expose on-screen buttons. Keyboard shortcuts are documented from the v26 client modules; they have **not** been exhaustively qualified for mobile or controller interfaces.

## What is interactive?

- **Doors and elevators:** server-validated routing and arrivals, with the actual travel behavior depending on the selected Place mode.
- **Transit and local routes:** buses, trams, ferries and other city systems when their runtime is active.
- **Exhibits and mechanisms:** local changes of chapter, lighting or sculpture; some shared exhibit states are visible to other players in the same Place.
- **Discovery journals:** explore rooms and mark session discoveries.
- **Cooperative stations:** local two-player interactions where implemented.
- **Future kOA terminals:** clearly identified as **COMING_SOON** and do **not** execute remote work.

## Player safety and authority

Prompts are treated as server-validated requests. The current code checks the prompt host, active character/health, the current world, distance and per-action cooldowns where applicable. Do not turn a purely visual UI click into an unchecked authoritative request.

## Accessibility status

The client uses several on-screen controls and Roblox prompt affordances, but cross-device layout, focus order and full gamepad navigation have **not** been certified. [Project Status & Roadmap](Project-Status-and-Roadmap) tracks the remaining qualification work.
