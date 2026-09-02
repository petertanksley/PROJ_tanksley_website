---
project: Tanksley Personal Website & CV
type: web
status: active
priority: medium
path: /Users/PTT2/Documents/GitHub/PROJ_tanksley_website
deadline: null
target: Personal academic website with CV, about page, and blog
effort_remaining: ~0 (monitoring; volume/pages when Nature assigns them)
weekly_commitment: 1h
last_updated: 2026-09-02
repo: https://github.com/petertanksley/petertanksley.github.io
blockers: null
blocking_others: null
importance: medium
phase: in-progress
sync: github
---

## Objectives

- Maintain current academic CV as a Quarto document (HTML + PDF output)
- Personal website with about page and occasional posts
- CV is the primary deliverable — must stay current for grant applications and job materials

## This Week

- [x] Nature DOI LIVE 2026-09-02: commit `0de0c1d` pushed after embargo lift (11:37 EST,
      Peter's OK); doi:10.1038/s41586-026-10992-9 verified on homepage + CV. No
      volume/pages assigned yet (Crossref checked 09-02) — add when they appear.
- [x] CI cleanup DONE 2026-09-01: commit `24b3dce` (runner Chrome, no puppeteer Chromium
      download) pushed alone and verified green before the DOI push rode on it.
- [x] Published-title swap DONE 2026-09-02 (commit `264f416`, pushed with Peter's OK):
      site/CV now carry Nature's trimmed title "Robust inference and correlates from
      genetic associations with personality" (verified against Crossref).
- [ ] **NEW 2026-09-01 — news/announcements feed** (recorded, not yet built or scoped):
      (a) add an announcements/news feed section to the site; (b) first entry = the
      published Substack article, "The Mortality Numbers Agency Heads Actually Need" —
      https://tacticalscience.substack.com/p/the-mortality-numbers-agency-heads

## Side project: hex stickers (DONE 2026-09-01, wired into site; committed + pushed, commit 0efc7ce)

Finals: `www/hex/{research,projects,left-hand-thoughts}.png` (480px web copies) + anchor
`www/hearth.jpg`. Wired: `.hex-mark` float on Research/Projects/Left-hand Thoughts intros,
`.hearth-figure` at bottom of About. Renders clean locally. Style guide + prompt lessons in
logs/2026-09-01_sticker-generation.md. Total spend ~$2.03. Live on the site.

### Pipeline notes (2026-08-31 build)

Pipeline scaffolded in `4_stickers/` (Hadley's bananarama approach,
https://tidydesign.substack.com/p/illustrating-my-slides-with-ai): `bananarama.yaml` (shared
style + 3 starter section-mark prompts: research, projects, left-hand-thoughts), `refs/` for
reference crops, `frame_hex.R` (magick point-up hex clip + border + title — tested, works).
`pak`, `ellmer`, `bananarama` installed; `~/.R/Makevars` fixed (stale gcc-13 → gcc-16).
Output dir `4_stickers/bananarama/` gitignored; framed finals go to `www/hex/`.
**Remaining:** Peter adds `GEMINI_API_KEY` to `~/.Renviron` (has key, 2026-08-31), then
`Rscript -e 'bananarama::bananarama("4_stickers/")'` (~$0.21/idea at n=3).
Prototype history in logs/2026-08-28_ci-hang-and-housekeeping.md.

## Upcoming Milestones

- ~~2026-09-02: Nature embargo lift + push~~ — DONE, live 2026-09-02 (published title too). Residual: volume/pages when assigned

## Notes

Live at https://petertanksley.github.io; CI in `.github/workflows/publish.yml` (runner Chrome
via PUPPETEER_SKIP_DOWNLOAD/PUPPETEER_EXECUTABLE_PATH as of `24b3dce`, install retries kept,
20-min job cap, superseded runs auto-cancelled). Redesign shipped 2026-08-28. History: `logs/`.

CV source: `2_cv/tanksley_cv.qmd`
CSS: `2_cv/tanksley_cv.css`

SciENcv note pruned 2026-09-01 — it was tied to the NIDA application and is stale (Peter's call).
