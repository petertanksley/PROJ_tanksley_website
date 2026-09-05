# petertanksley.github.io — conventions for anyone working in this repo

Status and scheduling live in `bob.md`; history in `logs/`. This file is how to work here.

## Voice (Peter, 2026-09-05)

The prose on this site is **eccentric and irreverent**, and that is deliberate. It is
Peter's personal site, not an institutional one. When writing or rewriting anything
user-facing (homepage, news, about, project blurbs, post intros):

- Say what the thing *is*, in plain words and in Peter's voice. Do not parrot the formal
  name of the article, journal, newsletter, or grant as the headline.
- Lighthearted, not jokey. Dry beats zany. A wink, not a laugh track.
- One idea per sentence; no information dumps. A news blurb is **one sentence**.
- Do not harp on credentials or numbers (author counts, impact factors, dollar figures)
  unless the number *is* the joke. Peter would rather understate.
- Confident, not hedged. No "interestingly", "it is worth noting", "I am honored to".
- Worked examples, both approved:
  - Headline: "Career achievement unlocked: get published in Nature. Check."
    Blurb: "I was part of a project on the genetics of personality that took years to
    come together, and boy, did it finally land."
  - Headline: "Wrote a thing for police chiefs about which mortality numbers actually matter."
    Blurb: "Over on Tactical Science, an essay on the death statistics a chief can do
    something with, and why the answer changes at 45."

Exception: the CV (`2_cv/`) is formal and stays formal. Publication titles there and in the
`.worklist` blocks on the research/home pages are quoted exactly.

## Content rules

- High-level only. Project detail belongs on alerrt-research.org; this site points there.
- The ALERRT research unit is the **Research Ring** (never "wing").
- Do not feature the McAllister/Gonzalez firefighter biomarker papers.
- Harden Lab link is https://www.kpharden.com/.
- Real headshot appears on the About page only; the landing page uses the sticker collage.

## News feed

- Source of truth: `news.yml`. Fields: `date`, `id`, `title` (the headline), `description`
  (the one-sentence blurb; markdown links allowed and encouraged).
- Rendering: `news-listing-home.ejs` on the homepage (latest 3; links stripped; headline ->
  `news.html#<id>`) and `news-listing.ejs` on `news.qmd` (everything; links live; anchors).
  Mirrors the Research Ring site's `_media_entries.yaml` / `_render_media.R` pattern.
- Always give an entry an `id`, or the homepage headline can only link to the top of the page.
- Quarto's EJS: no `<%# %>` comments (bare SyntaxError), and the escaping convention is
  reversed from standard EJS (`<%= %>` is raw, `<%- %>` escapes).

## Hex stickers

- Style: 16-bit pixel art, sepia-warm, Dresden-universe homage with Peter's likeness and dogs,
  anachronisms welcome. **Hexagons, never hexagrams or pentagrams.** Skull stays nameless.
- **One clean symbolic subject per hex.** Stickers are read at 92px on the CV band; anything
  that needs magnifying to parse gets cut. Judge candidates *after* hex-clipping.
- Pipeline: `4_stickers/bananarama.yaml` (prompts; append, existing outputs are skipped) ->
  `frame_hex.R` (clip to 480x554 point-up hex) -> `www/hex/`. Band: `hexband.R` ->
  `_hexband.qmd` (append new names to `stickers`, rerun). Refs in `4_stickers/refs/` are
  gitignored personal photos. Full lessons: `logs/2026-09-01_sticker-generation.md`.

## Build gotchas

- CV publication entries must be fenced divs (`::: {.pub-item}`), never raw single-line
  `<div>`; pandoc leaves those open and truncates the TOC.
- Raw HTML blocks go in ```` ```{=html} ```` fences or Quarto wraps each line in `<p>`.
- `row` as a class name collides with Bootstrap's grid.
- Headless Chrome screenshots at narrow widths overflow body text on every page; viewport
  quirk, not a layout bug.
- CI (`.github/workflows/publish.yml`) renders on push to `main`, including the pagedjs CV
  PDF, using the runner's preinstalled Chrome.
