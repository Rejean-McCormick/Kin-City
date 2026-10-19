# Audio & Ambience

Kin City contains **eight locally generated `.wav` sound beds** under `assets/audio/`. They are distributed as source assets, not as automatically uploaded Roblox audio assets.

## Included audio sources

| File | Intended atmosphere |
| --- | --- |
| `kin-city-wind-loop.wav` | Wind / outdoor ambience |
| `kin-city-water-loop.wav` | Waterfront / island water |
| `kin-city-chimes.wav` | Crystalline chimes |
| `kin-city-archives.wav` | Archive/library ambience |
| `kin-city-laboratoire.wav` | Laboratory ambience |
| `kin-city-port.wav` | Harbor ambience |
| `kin-city-botanique.wav` | Botanical ambience |
| `kin-city-harmonie-civique.wav` | Civic atmosphere |

## Enabling audio

1. Import the relevant WAV files using a Roblox-supported Creator Hub/Studio audio workflow under an account authorized to use them.
2. Copy their **real asset IDs** into the corresponding fields of `config/audio.json`.
3. Set `"enabled": true` in the same configuration.
4. Run `python tools/build_release.py` from the repository to regenerate the embedded configuration and targeted installers.
5. Install or update the relevant test Places and confirm asset permissions, spatial positioning and volume in the actual Roblox client.

Audio is **disabled by default** in v26 (`"enabled": false`). No audio asset IDs are fabricated. Playback policy, moderation, asset permissions and final mixing remain subject to Roblox.

## Performance and access

Localized sound is intended to enhance scenes, not require a constant city-wide set of expensive emitters. Prefer controlled distance falloff, manageable simultaneous sources, and clear user volume controls as the experience matures. There is no published device-level performance certification yet.
