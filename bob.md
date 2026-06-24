---
project: Tanksley Personal Website & CV
type: web
status: active
priority: medium
path: /Users/PTT2/Documents/GitHub/PROJ_tanksley_website
deadline: null
target: Personal academic website with CV, about page, and blog
effort_remaining: ~4h
weekly_commitment: 1h
last_updated: 2026-06-19
repo: https://github.com/petertanksley/PROJ_tanksley_website
blockers: null
blocking_others: SciENcv biosketch (CV must be current first)
phase: in-progress
sync: github
---

## Objectives

- Maintain current academic CV as a Quarto document (HTML + PDF output)
- Personal website with about page and occasional posts
- CV is the primary deliverable — must stay current for grant applications and job materials

## This Week

- [x] PDF rendering overhaul — switched engine to pagedjs-cli; full print CSS pass (2026-06-19)
- [x] Fixed critical HTML structure bug: orphaned `<div class="pub-list">` was closing `</main>` prematurely, making Presentations and all subsequent sections invisible in PDF
- [x] Fixed curly-quote attribute bug on pub-item entry #1 — CSS selectors now match correctly
- [x] Removed navbar from HTML/PDF output; fixed h2 border lines; unified year header styling
- [x] Committed and pushed to GitHub (2026-06-19)
- [ ] Export updated PDF for SciENcv biosketch workflow (post-R01)
- [ ] Add NIDA R01 to Funding section once submitted

## Upcoming Milestones

- Website overhaul: TBD (parked until after R01)

## Deferred Work (post-R01)

- **Website overhaul:** Broader redesign of the full site (index, about, posts). Structure is in place but styling and content need significant work. Treat as a separate project once R01 is submitted.

## Notes

Migrated from `/Users/PTT2/Documents/GitHub/website` on 2026-06-08.
Original repo was an abortive start — structure and content preserved, styling/deployment overhaul deferred.

CV source: `2_cv/tanksley_cv.qmd`
CSS: `2_cv/tanksley_cv.css`

SciENcv biosketch workflow: update CV first → log into https://www.ncbi.nlm.nih.gov/sciencv/ → update entries → export NIH biosketch PDF.
