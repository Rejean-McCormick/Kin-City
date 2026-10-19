# Troubleshooting

This page covers expected behaviors and likely investigation steps for the **v26** build. It is not a claim that every problem has already been reproduced in Studio.

## The main installer only built the city, not the interiors

**Expected in v26.** `KinCity_Installation_Directe_v26.luau` installs the **exterior Place only**. For interiors, open a different Studio Place and run a corresponding `KinCity_Installation_Place_<key>_v26.luau`. Use `KinCity_Installation_Univers_Local_v26.luau` only when intentionally testing the legacy all-in-one mode.

## A portal says the destination is not published

**Expected in `SPLIT_PREVIEW`.** There are no valid Place IDs in the default registry. To enable real inter-Place travel, publish all nine Places in the same Roblox experience, fill `config/place_ids.json`, change the runtime mode to `MULTI_PLACE`, rebuild and republish. Test with the published Roblox client.

## One installer removed the previous scene

The installers replace the generated Kin City world; they are **not additive** and offer **no built-in rollback**. Create a separate Place for each of the nine targets and use a saved copy before installation.

## Nothing appeared in Workspace

- Make sure you used Studio's **Edit-mode** Command Bar, not a Lua script/LocalScript or the Play-mode command context.
- Paste the **entire** installer (hundreds of kilobytes), not a fragment.
- Open **Output** for the first error and its source line.
- Look for `Workspace.KinCityGenerated` and the expected shared/server/client module containers.
- Confirm a Baseplate or other unrelated content did not hide the spawn view.

## A door or object has no prompt

Check whether you are near the correct scene/object, the prompt is enabled, the host belongs to the generated world, and the relevant canonical interaction was generated. Use the Place diagnostic to verify the target and counts. Check Output if a generator stopped before completion.

## A mesh, texture or sound is missing

This is often **expected** if optional assets have not been imported or their real asset IDs have not been registered. Native geometry remains the fallback for modeled structures; audio is disabled by default. Confirm Creator Hub asset permissions for your experience.

## Streaming or performance seems wrong

The Rojo project declares `StreamingEnabled`, but an installer cannot be assumed to switch Studio's property successfully. Inspect the active Place setting in Studio. Use the diagnostic counts and Roblox performance tools to identify expensive features; do not conclude that the crystal theme alone determines performance.

## Travel works in a local preview, but not across Places

`LOCAL_UNIVERSE` movements stay in one Place and **cannot validate `TeleportAsync`**. Check all nine real IDs, published Place ownership, target identity, and the published-client Output/logs. The target Place must contain the corresponding generated interior; a new target ID alone does not install it.

## Reporting a problem

Include the **build version**, Place key, mode, exact installer file, steps to reproduce, expected and actual behavior, any Studio Output error, and ideally a screenshot of Explorer/Workspace. Never post credentials or private access tokens.

[Quick Start](Quick-Start) · [Validation & Diagnostics](Validation-and-Diagnostics)
