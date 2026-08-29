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
last_updated: 2026-08-28
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

- [ ] After 2026-09-01 Nature publication: replace placeholder link with the article DOI, add volume/pages, drop "(forthcoming)"
- [ ] Export updated PDF for SciENcv biosketch workflow
- [ ] Optional CI cleanup: skip puppeteer Chromium download, use runner Chrome — see logs/2026-08-28_ci-hang-and-housekeeping.md

## Side project: hex stickers (deferred 2026-08-28)

Replicate Hadley Wickham's slide-illustration pipeline
(https://tidydesign.substack.com/p/illustrating-my-slides-with-ai) with his R package
`bananarama` (`pak::pak("hadley/bananarama")`): YAML with a shared `style` prompt + per-image
`description`, `aspect-ratio: "1:1"`, `n: 3`, `seed`, `[refimage]` references. Gemini image
model (~$0.07/image) via `ellmer::chat_google_gemini()`. Wrap the PNG in R with `magick`:
clip to point-up hex, ink border, title. Model paints, code frames.
**Blocker:** needs a `GEMINI_API_KEY` (personal Google AI Studio account + payment method;
TXST Gemini is the Workspace app, not an API). Key goes in `~/.Renviron`, never the repo.
**Missing locally:** `pak`, `ellmer`. Prototype history in logs/2026-08-28_ci-hang-and-housekeeping.md.

## Upcoming Milestones

- 2026-09-01: Nature article publishes — update CV entry #27, then export PDF for SciENcv

## Notes

Live at https://petertanksley.github.io; CI in `.github/workflows/publish.yml` (retrying
pagedjs-cli install, 20-min job cap, superseded runs auto-cancelled). Redesign shipped 2026-08-28.
History: `logs/`.

CV source: `2_cv/tanksley_cv.qmd`
CSS: `2_cv/tanksley_cv.css`

SciENcv biosketch workflow: update CV first → log into https://www.ncbi.nlm.nih.gov/sciencv/ → update entries → export NIH biosketch PDF.
