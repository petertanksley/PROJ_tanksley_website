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

## Start Here Next Session

- Scope the news/announcements feed: where it lives on the site, how entries are stored
  (Quarto listing vs. hand-maintained section), and how it renders alongside the redesign.
- First entry is the Substack piece (link under This Week). Build once scoped.
- Check Crossref for volume/pages on the Nature paper before touching the CV.

## This Week

- [ ] News/announcements feed (recorded 2026-09-01; not yet scoped or built):
      (a) add an announcements/news section to the site; (b) first entry = the published
      Substack article, "The Mortality Numbers Agency Heads Actually Need" —
      https://tacticalscience.substack.com/p/the-mortality-numbers-agency-heads

## Upcoming Milestones

- TBD: add volume/issue/pages to CV entry 27 (Schwaba et al., Nature, doi:10.1038/s41586-026-10992-9)
  when assigned — check `api.crossref.org/works/<doi>`; none as of 2026-09-02

## Notes

- Live at https://petertanksley.github.io
- CI: `.github/workflows/publish.yml` — uses the runner's preinstalled Chrome
  (PUPPETEER_SKIP_DOWNLOAD / PUPPETEER_EXECUTABLE_PATH), install retries kept, 20-min job
  cap, superseded runs auto-cancelled
- CV source: `2_cv/tanksley_cv.qmd`; CSS: `2_cv/tanksley_cv.css`
- Hex stickers: finals in `www/hex/` + anchor `www/hearth.jpg`; pipeline in `4_stickers/`;
  style guide and prompt lessons in `logs/2026-09-01_sticker-generation.md`
- History: `logs/` (prune record: `logs/2026-09-02_bob-prune.md`)
