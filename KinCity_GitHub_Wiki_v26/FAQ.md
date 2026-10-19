# Frequently Asked Questions

### Is Kin City already a finished Roblox game?

No. v26 is a **substantial generated source build**, not a validated public Roblox release. The code has passed offline checks; in-engine gameplay and published teleports still require testing.

### Do I need to install v1 through v25 first?

No. The **v26 source and installers are cumulative**.

### Why is my city missing the eight interiors?

The default **v26 direct installer targets the exterior city only**. Use a separate institution installer in a different Place.

### Why does an entrance say its Place is not published?

The v26 delivery has **nine null Place IDs**. This is normal for `SPLIT_PREVIEW` and prevents pretending that a transfer happened.

### Can I test all interiors before publishing?

Yes: independently with their own targeted preview installers, or together with the `LOCAL_UNIVERSE` installer for old-style local door traversal. The latter does **not** have the desired Place/memory separation.

### Do I have to upload assets before installing?

No. Native Roblox geometry is the fallback for optional OBJ models; sound is disabled until asset IDs are configured.

### Does the game connect to the live kOA services?

No. The mode is `WORLD_STUB` and remote business/service actions are **not enabled**.

### Is the source licensed as open source?

A license is **not yet selected** in `LICENSE-DECISION.md`. Do not assume reuse/distribution rights based on source availability.

### Why not put every shop in a separate Place?

The v26 split is intentionally centered on **eight large signature institutions**. Smaller exterior structures remain part of the city; additional splitting should be justified by actual player experience and measured performance.

### How do I report a bug usefully?

Send the installer name, Place key, mode, repro steps, Studio Output errors and a screenshot showing the issue. See [Troubleshooting](Troubleshooting).
