# 2026-09-09 — Integrated into the site

Peter's decisions: navbar → **Research as a dropdown** (Research, Skill tree); generator → **moved
into this repo** as `5_skilltree/` (mirrors `4_stickers/`); `PROJ_skill_tree` archived.

## What moved where

- `5_skilltree/R/{extract_cv,build_tree}.R`, `5_skilltree/data/articles.yml`,
  `5_skilltree/tools/rate_articles/` (Shiny app + helpers + test). Paths rewritten: the repo root is
  the site (`here()`), CV at `2_cv/tanksley_cv.qmd`, outputs to `www/`.
- `skilltree.qmd` (root, `page-layout: full`, belt bar), `www/skilltree.js`, `www/tree.json`,
  `www/hex/sm/` — the latter two are **committed** so CI needs no R.
- `theme.scss`: the `.skilltree*` rules block appended (no defaults, no font import — the site owns
  both); `.skilltree-wrap` centred at max 1240 px.
- `_quarto.yml`: Research menu; `resources` for `www/tree.json` and `www/hex/sm/**`; `!5_skilltree/`
  excluded from render.
- `logs/skilltree/` holds the standalone repo's logs and plan. `CLAUDE.md` gained a Skill tree section.
  `bob.md` carries a one-line pointer. Registry entry moved to Archived.

## Verified

Extractor preserved all 30 rated entries from the CV in its new location; helper round-trip OK; 30
nodes, 7 edges, 8 legend items; Research renders as a dropdown with the Skill tree link; body is paper,
panel is ink; fonts inherit Cormorant / Public Sans / JetBrains Mono from the site theme; panel opens
with the DOI link. `quarto render skilltree.qmd` alone copies the declared resources into `docs/`.

## Gotcha: the fixed-top navbar covered the panel

Quarto's full-width content column is a stacking context (`z-index: 998; opacity: .999`), so no
z-index inside it beats the `fixed-top` header (1030); `!important` and specificity changed nothing.
Fix: `skilltree.js` moves the panel and tooltip to `<body>` on load. Recorded in CLAUDE.md gotchas.

## Not done

Nothing committed in the site repo yet (Peter's call). Push, and therefore the live site, also his.
Stickers deferred. Preprint blurbs still say "Preprint". `projects.qmd` untouched (Peter chose the
dropdown over replacing it).
