---
project: Tanksley Personal Website & CV
type: web
status: active
priority: medium
path: /Users/PTT2/Documents/GitHub/PROJ_tanksley_website
deadline: null
target: Personal academic website with CV, about page, and blog
effort_remaining: ~2h (copy review + rename follow-through)
weekly_commitment: 1h
last_updated: 2026-08-27
repo: https://github.com/petertanksley/PROJ_tanksley_website
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

- [x] PDF rendering overhaul — switched engine to pagedjs-cli; full print CSS pass (2026-06-19)
- [x] Fixed critical HTML structure bug: orphaned `<div class="pub-list">` was closing `</main>` prematurely, making Presentations and all subsequent sections invisible in PDF
- [x] Fixed curly-quote attribute bug on pub-item entry #1 — CSS selectors now match correctly
- [x] Removed navbar from HTML/PDF output; fixed h2 border lines; unified year header styling
- [x] Committed and pushed to GitHub (2026-06-19)
- [x] GitHub Pages CI/CD set up (2026-06-24) — workflow at .github/workflows/publish.yml; renders via quarto-dev/quarto-actions/publish to gh-pages branch; pagedjs-cli installed in CI; repo Pages configured to serve from gh-pages; latest push pending workflow confirmation
- [ ] Confirm GitHub Actions workflow passes (check Actions tab — latest push should be green)
- [x] Added NIDA R01 to Funding as "Under review" (submitted 2026-07-17; $505,783 requested) (2026-08-27)
- [x] Moved Schwaba et al. from Preprints to 2026 Academic Articles as #27, *Nature* (forthcoming) (2026-08-27)
- [ ] After 2026-09-01 Nature publication: replace placeholder link with the article DOI, add volume/pages, drop "(forthcoming)"
- [ ] Export updated PDF for SciENcv biosketch workflow
- [x] Redesign built 2026-08-27: theme.scss (viridis palette, Cormorant/Public Sans/JetBrains Mono, belt-bar mark), navbar restored, new index/research/projects, about rewritten, blog listing demoted; plan at logs/plans/2026-08-27_website-redesign.md
- [x] CI fixed: Ubuntu 24.04 AppArmor blocked Chromium sandbox for pagedjs-cli; sysctl step added to publish.yml (awaiting green run)
- [ ] Peter: push main; confirm Actions green and live site updated
- [ ] Peter: rename repo to petertanksley.github.io (GitHub settings) — then update remote, registry-local.md, README
- [ ] Peter: review research.qmd copy (esp. "Where I came from") and index thesis paragraph
- [ ] Optional: delete now-unused styles.css (needs approval)

## Upcoming Milestones

- Website overhaul: built 2026-08-27; ship pending push + repo rename

## Deferred Work (post-R01)

- **Website overhaul:** Broader redesign of the full site (index, about, posts). Structure is in place but styling and content need significant work. Treat as a separate project once R01 is submitted.

## Notes

Migrated from `/Users/PTT2/Documents/GitHub/website` on 2026-06-08.
Original repo was an abortive start — structure and content preserved, styling/deployment overhaul deferred.

CV source: `2_cv/tanksley_cv.qmd`
CSS: `2_cv/tanksley_cv.css`

SciENcv biosketch workflow: update CV first → log into https://www.ncbi.nlm.nih.gov/sciencv/ → update entries → export NIH biosketch PDF.
