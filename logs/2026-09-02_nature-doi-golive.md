# Session log — 2026-09-01/02: Nature DOI go-live, CI Chrome fix, SciENcv prune

## What happened

The Schwaba et al. *Nature* article (doi:10.1038/s41586-026-10992-9) published
2026-09-02 ~11am EST. The website was staged ahead of the embargo and pushed live the
same day, with the published title. The CI Chromium flake was fixed and verified along
the way.

## Work done

1. **DOI swap staged 2026-09-01** (commit `0de0c1d` after reorder; originally `32eaf2b`):
   `index.qmd` worklist link + CV entry 27 now point at
   https://doi.org/10.1038/s41586-026-10992-9; "(forthcoming)" → "(online first)" on the
   CV (matches entry 26's style; no volume/pages assigned yet). Held locally until the
   embargo lifted.
2. **CI fix** (commit `24b3dce`, deliberately ordered *before* the DOI commit so it was
   pushable alone, no embargo content): `PUPPETEER_SKIP_DOWNLOAD=1` on the pagedjs-cli
   install (the ~150 MB bundled-Chromium download caused the 2026-08-28 hangs);
   render step sets `PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome`; new guard step
   fails fast if the runner image drops Chrome. Pushed 09-01 with Peter's OK, run went
   green, CV PDF verified on gh-pages (250 KB). The retry loop stays for npm flakiness.
3. **Embargo push 2026-09-02, 11:37 EST** (Peter's OK, 37 min after lift): `0de0c1d` up,
   deploy green, DOI verified live on homepage + CV page.
4. **Published-title fix** (commit `264f416`, Peter's OK): Nature trimmed the title to
   "Robust inference and correlates from genetic associations with personality"
   (caught via Crossref — the site carried the long submitted title). Deploy failed once
   on GitHub's side (`remote: fatal error in commit_refs`, transient, render was fine);
   rerun succeeded, new title verified live.
5. **SciENcv prune** (Peter's call): the biosketch chain (blocking_others, This Week
   item, milestone, Notes workflow) was tied to the NIDA application and stale —
   removed from bob.md with a tombstone note.

## Gotchas worth remembering

- **`git reset --hard` during the commit reorder ate uncommitted bob.md edits** — the
  stash only covered the workflow file. Re-applied from context. Stash everything or
  commit bookkeeping before touching history.
- The reorder (stash → reset → commit CI fix → cherry-pick DOI commit) changed the DOI
  commit's sha (`32eaf2b` → `0de0c1d`); references updated everywhere.
- Crossref (`api.crossref.org/works/<doi>`) is the fast way to check volume/pages and
  the *published* title — nature.com bounces unauthenticated fetches through an IDP
  redirect. Checking the published title against the submitted one caught a real
  discrepancy.

## Still open

- Add volume/issue/pages to CV entry 27 when Nature assigns them (Crossref had none as
  of 09-02).
- News/announcements feed (first entry: the Substack article) — recorded, unscoped.
