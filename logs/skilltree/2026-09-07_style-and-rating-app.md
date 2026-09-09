# 2026-09-07 — Style pass and the rating app

Peter: "Let's get the style sharpened up and then i'd like a html widget that will help me work
through the article details quickly."

## Style

- Labels sized for the 2781-unit canvas: axis names 46 px, year labels 26 px with a heavier halo.
- Origin is the focal point: Peter's sticker at 1.45× inside a faint paper ring, with a soft radial
  glow behind the whole field (SVG radialGradient, 10% → 0).
- Ring guides and axes slightly heavier; resting shade 0.58 (was 0.66) so hexes read as objects, not
  outlines; hover shade 0.3.
- Legend rebuilt from `tree.json` by the JS: area swatches are filled hexes, roles and status are hex
  outlines at the same stroke weights the nodes use, with two short reading notes. Nothing about
  colours or labels is hardcoded in the qmd any more.
- Panel title loses Quarto's h2 border. Subtitle shortened to one sentence.
- Canvas margins tightened (LABEL_PAD 70 → 40).

## Rating app (`tools/rate_articles/`)

Peter asked for an "html widget". A browser page cannot write to `articles.yml`, so a static widget
would mean downloading and copying a file after every session. Built a small **Shiny** app instead
(R-first, direct writes): `app.R` + `helpers.R` + `test_helpers.R`.

- Sidebar: progress bar, article list with ○ / ◐ / ✓ marks, Prev/Next, "Rebuild tree.json" button
  (runs `R/build_tree.R` and shows its output), last-saved time.
- Main: bibliographic card (title linked to DOI, venue, authors with Peter bold, position), then
  areas (3 × radio 0–3), role, featured, effort (1–5 with words), effort note, six CRediT-group radios
  with the folded roles named, blurb textarea, `builds_on` selectize over the other articles.
- **Auto-save** on every change (debounced 700 ms) through `apply_judgement()` → `write_articles()`,
  which rewrites only judgement fields, keeps field order and the header comment, and keeps null keys
  as `~`. "Save & next" just advances.
- Verified: `test_helpers.R` round-trip (field order, nulls kept, builds_on, completeness); app served
  over HTTP, one radio click landed in `data/articles.yml` within 1.6 s, list mark flipped ○ → ◐,
  Next advanced. The test edit was reverted from a backup so Peter starts from the guesses.

Gotcha: inside `app.R`, `source("helpers.R")` — `runApp()` sets the working directory to the app
folder; a `sys.frame()`-based path broke on launch.
