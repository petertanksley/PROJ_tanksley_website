---
project: Tanksley Personal Website & CV
type: web
status: active
priority: medium
path: /Users/PTT2/Documents/GitHub/PROJ_tanksley_website
deadline: null
target: Personal academic website with CV, about page, and blog
effort_remaining: ~0 (monitoring; DOI/volume for AJPH and Nature papers when assigned)
weekly_commitment: 1h
last_updated: 2026-09-05
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

- Review, commit, and push the 2026-09-05 work (four new stickers, seven-sticker band, news
  feed + navbar entry, landing-page sticker collage) — uncommitted in the working tree; see `logs/2026-09-05_round2-stickers-and-news-feed.md`.
- Check Crossref for volume/pages on the Nature paper before touching the CV.

## This Week

- [ ] Commit + push 2026-09-05 changes after Peter reviews the rendered pages
- [ ] Optional: phase stickers beside the matching Research-page sections

## Upcoming Milestones

- TBD: add volume/issue/pages to CV entry 27 (Schwaba et al., Nature, doi:10.1038/s41586-026-10992-9)
  when assigned — check `api.crossref.org/works/<doi>`; none as of 2026-09-02
- TBD: add DOI (and later volume/pages) to CV entry 28 (Tanksley, Logan, & Barnes, AJPH, in press)
  on the CV, homepage, and research page; also link the titles once a DOI exists

## Notes

- Live at https://petertanksley.github.io
- CI: `.github/workflows/publish.yml` — uses the runner's preinstalled Chrome
  (PUPPETEER_SKIP_DOWNLOAD / PUPPETEER_EXECUTABLE_PATH), install retries kept, 20-min job
  cap, superseded runs auto-cancelled
- CV source: `2_cv/tanksley_cv.qmd`; CSS: `2_cv/tanksley_cv.css`
- Hex stickers: finals in `www/hex/` (7 art + blank) + anchor `www/hearth.jpg`; pipeline in
  `4_stickers/`; style guide and prompt lessons in `logs/2026-09-01_sticker-generation.md`;
  round-2 picks and the "one clean subject" rule in `logs/2026-09-05_round2-stickers-and-news-feed.md`
- News feed: `news.yml` (add entries here) → `news-listing.ejs` → `news.qmd` + homepage
  (latest 3); navbar entry between Projects and Left-hand Thoughts. Quarto's EJS rejects `<%# %>` comments.
- Landing page masthead = 4-sticker hex collage (`.hexcollage`); real headshot lives on About only
- CV hex band: `4_stickers/hexband.R` → `_hexband.qmd` (included by the CV). New stickers:
  append to `stickers` in the script and rerun. Design notes in
  `logs/2026-09-02_hex-band-and-cv-fixes.md`
- CV publication entries must be fenced divs (`::: {.pub-item}`), never raw `<div>` — raw
  divs stay unclosed in pandoc and truncate the TOC (same log)
- History: `logs/` (prune record: `logs/2026-09-02_bob-prune.md`)
