# B09 shared tooling instructions

Changes in `tools/` may modify source generation, plan compilation, staging or contract checks across *all nine* Roblox Places. Before edits, read repo `AGENTS.md`, `docs/10-ai-coordination/branches/B09.md`, `docs/09-refonte-urbaine/` and existing tests. Do not weaken frozen checks merely to make a migration pass; version the approved contract instead. Any generated installer must preserve the linked `ServerStorage.KinCityArtDecoLibrary` Package and refuse unauthorized production targets.
