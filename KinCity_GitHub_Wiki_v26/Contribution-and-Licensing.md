# Contribution & Licensing

Kin City is developed as a modular Luau/Python project. Before proposing changes, read `CONTRIBUTING.md`, `AGENTS.md`, `SECURITY.md` and the current build status in the source repository.

## Important licensing notice

**No project-wide redistribution license has been selected in the v26 repository.** `LICENSE-DECISION.md` explicitly leaves that decision to the owner. Therefore, **do not assume that public access means permission to reuse, fork, distribute, or commercially exploit the code and assets under an open-source license**. Contributors and prospective reusers should obtain the owner's license terms before distributing derivatives.

Third-party tools and future kOA integrations have their **own** licenses and terms. Do not copy code from other kOA repositories just because it is publicly visible.

## Good contribution areas

- Fixing Studio-reproduced errors or unreachable prompts.
- Improving the nine-Place build/installation workflow and real teleport handling.
- Designing efficient and reusable visual assets that preserve the teal/opal design system.
- Reducing client/server load based on measurable profiles.
- Improving accessibility, visual focus and controller/mobile interface behavior.
- Adding tests tied to actual invariants, not only to source text.

## Contribution rules

1. Reproduce or explain the problem with the Place key and runtime mode.
2. Preserve canonical door, place, and interaction IDs unless a migration is explicitly planned.
3. Respect the exterior/interior separation: large institution rooms belong in their institution Place.
4. Keep server authority for actions and destination validation.
5. Never invent Roblox asset IDs or activate unapproved kOA endpoints.
6. Add an offline test when possible, regenerate the release and report **what was actually tested**.
7. Avoid committing secrets or credentials. Use the repository's reporting guidance for security issues.

## Source code vs. GitHub Wiki

The GitHub Wiki is a **separate Git repository** (`<repository>.wiki.git`). Changing a wiki page does not automatically change the code, and vice versa. The wiki in this delivery is a publishing-ready documentation package; it is not evidence that the GitHub-hosted wiki has already been updated.
