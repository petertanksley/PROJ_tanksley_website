# 2026-09-01 — Hex stickers generated and framed

First full run of the `4_stickers/` bananarama pipeline. Total API spend ≈ $2.03 across
five generation rounds (12 + 6 + 3 + 3 + 3 images). Finals now live in `www/hex/` plus the
hearth anchor at `www/hearth.png` — not yet wired into any page.

## Finals

| File | Source candidate | Subject |
|------|-----------------|---------|
| `www/hex/research.png` | research-1 (round 1) | Candlelit lab desk, glowing Kaplan-Meier parchment |
| `www/hex/projects.png` | projects-3 (round 1) | Workbench with rune-edged hexagonal talisman |
| `www/hex/left-hand-thoughts.png` | left-hand-thoughts-1 (round 2) | Bodiless skull, glowing eyes, book stack |
| `www/hearth.png` | hearth-1 (round 5) | Anchor scene (16:9), not a hex |

## Style guide decisions (Peter, this session)

- 16-bit pixel art, SNES-era, sepia-warm palette (prototyped by Peter in the Gemini app).
- Dresden-universe homage, deliberately NOT the books' characters: Peter's own likeness
  (refs/peter), his dogs Josie (yellow lab mix) and Winnie (brindle mix) as the familiars,
  anachronisms (working laptop with hex-cluster logo, coffee mug, journal stacks, BJJ black
  belt with red tab / no stripes, flip-flops). Skull with glowing eyes kept — generic fantasy
  imagery, never named. Setting: underground basement apartment (brick/stone, concrete floor
  under overlapping rugs, cluttered-cozy).
- **Hexagons, never hexagrams/pentagrams** — sigil doctrine lives in the YAML style defaults
  ("outline of a regular hexagon... like a honeycomb cell; never any star shape"). Round-1
  projects-1 had a hexagram inside its talisman (predates the doctrine); swapped to
  projects-3 at framing time.
- Peter's forearm tattoo (radial phylogenetic tree + honeybee + DNA helix, refs/tattoo):
  too detailed to place on-body at this style/scale — rendered instead as framed artwork
  above the mantel, explicitly prompted to match the pixel grain (earlier rounds looked
  pasted-in).
- Persistent model quirk at seed 5891: book covers get garbled titles ("ROMANCE NOVEL")
  despite no-text instructions. Accepted as charm.

## Prompt-engineering lessons (bananarama/Gemini)

- `[refs/name]` syntax takes NO extension — `[refs/peter.png]` fails looking for peter.png.png.
- "Composed to survive cropping to a hexagon" made the model draw literal hexagon frames.
  Full-bleed language fixed it.
- ~4 reference images per prompt is the practical ceiling before feature-blending.
- Face/dog likenesses from photo refs work well; text steering overrides ref lighting
  artifacts (headshot's golden light read as red hair until explicitly corrected).
- HEIC refs must be converted (magick handles it; heic feature enabled on this Mac).

## Environment

- `~/.R/Makevars` had been fixed 2026-08-31 (gcc-13 → gcc-16). Generation + framing all in R.
- Superseded candidate rounds archived under `4_stickers/bananarama/archive-*/` (gitignored).
- `refs/*.png` (headshot, dogs, tattoo) gitignored — must be copied manually to the desktop
  if generating there.

## Next steps

- Wire `www/hex/*.png` into the site as section marks (research.qmd, projects.qmd, blog);
  decide placement/size. Hearth anchor could headline the about page.
- Optional: crop favorite details from hearth-1 into refs/ as style anchors for future images.
- NOT DONE: no site pages reference these images yet; CV/DOI task still gated on the
  2026-09-02 11am EST embargo.
