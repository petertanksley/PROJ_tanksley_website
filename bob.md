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
last_updated: 2026-06-08
blockers: null
blocking_others: SciENcv biosketch (CV must be current first)
phase: in-progress
repo: null
sync: github
---

## Objectives

- Maintain current academic CV as a Quarto document (HTML + PDF output)
- Personal website with about page and occasional posts
- CV is the primary deliverable — must stay current for grant applications and job materials

## This Week

- Update CV: add NIDA R01 to Funding section (pending submission, July 2026)
- Verify all 2025-2026 publications are listed and formatted correctly
- Verify preprints section is current
- Export updated PDF for SciENcv biosketch workflow

## Upcoming Milestones

- CV current before June 16 (travel deadline — needed for SciENcv biosketch)
- Website overhaul: TBD (parked until after R01)

## Deferred Work (post-R01)

- **CV style overhaul:** Full visual redesign of the HTML CV. Current styling is functional but rough. Also need to fix PDF output pipeline — weasyprint requires system libraries (gobject/pango via Homebrew) and the current PDF rendering has layout issues. Consider switching PDF engine or fixing weasyprint dependencies.
- **Website overhaul:** Broader redesign of the full site (index, about, posts). Structure is in place but styling and content need significant work. Treat as a separate project once R01 is submitted.

## Notes

Migrated from `/Users/PTT2/Documents/GitHub/website` on 2026-06-08.
Original repo was an abortive start — structure and content preserved, styling/deployment overhaul deferred.

CV source: `2_cv/tanksley_cv.qmd`
CSS: `2_cv/tanksley_cv.css`

SciENcv biosketch workflow: update CV first → log into https://www.ncbi.nlm.nih.gov/sciencv/ → update entries → export NIH biosketch PDF.
