---
project: Tanksley Personal Website & CV
type: web
status: active
priority: medium
path: /Users/PTT2/Documents/GitHub/PROJ_tanksley_website
deadline: null
target: Personal academic website with CV, about page, and blog
effort_remaining: ~1h (Nature DOI swap; SciENcv PDF export). Hex stickers deferred.
weekly_commitment: 1h
last_updated: 2026-09-01
repo: https://github.com/petertanksley/petertanksley.github.io
blockers: null
blocking_others: SciENcv biosketch (CV must be current first)
importance: medium
phase: in-progress
sync: github
---

## Objectives

- Maintain current academic CV as a Quarto document (HTML + PDF output)
- Personal website with about page and occasional posts
- CV is the primary deliverable — must stay current for grant applications and job materials

## This Week

- [ ] After 2026-09-02 11am EST Nature publication (DOI in hand, but EMBARGOED — no publicizing before then): replace placeholder link with the article DOI, add volume/pages, drop "(forthcoming)"
- [ ] Export updated PDF for SciENcv biosketch workflow
- [ ] Optional CI cleanup: skip puppeteer Chromium download, use runner Chrome — see logs/2026-08-28_ci-hang-and-housekeeping.md
- [ ] **NEW 2026-09-01 — news/announcements feed** (recorded, not yet built or scoped):
      (a) add an announcements/news feed section to the site; (b) first entry = the
      published Substack article, "The Mortality Numbers Agency Heads Actually Need" —
      https://tacticalscience.substack.com/p/the-mortality-numbers-agency-heads

## Side project: hex stickers (DONE 2026-09-01, wired into site; uncommitted)

Finals: `www/hex/{research,projects,left-hand-thoughts}.png` (480px web copies) + anchor
`www/hearth.jpg`. Wired: `.hex-mark` float on Research/Projects/Left-hand Thoughts intros,
`.hearth-figure` at bottom of About. Renders clean locally. Style guide + prompt lessons in
logs/2026-09-01_sticker-generation.md. Total spend ~$2.03. Remaining: Peter approves look →
commit; push publishes (site is public — no embargo content involved).

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

- 2026-09-02 11am EST: Nature article publishes (embargo lifts) — update CV entry #27, then export PDF for SciENcv

## Notes

Live at https://petertanksley.github.io; CI in `.github/workflows/publish.yml` (retrying
pagedjs-cli install, 20-min job cap, superseded runs auto-cancelled). Redesign shipped 2026-08-28.
History: `logs/`.

CV source: `2_cv/tanksley_cv.qmd`
CSS: `2_cv/tanksley_cv.css`

SciENcv biosketch workflow: update CV first → log into https://www.ncbi.nlm.nih.gov/sciencv/ → update entries → export NIH biosketch PDF.
