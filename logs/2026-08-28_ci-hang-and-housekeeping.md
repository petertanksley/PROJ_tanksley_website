# 2026-08-28 — CI hang diagnosis, workflow hardening, bob.md prune

## What happened

Peter noticed the live site still showed the McAllister (JOEM) article in featured work
despite the swap to Martaindale & Tanksley (JCJ) earlier today. Suspected an unpushed commit.

**Actual cause:** the swap commit (`560b5aa`) was pushed, but its "Render and Publish" run
hung for 2.5 h on the `npm install -g pagedjs-cli` step — puppeteer@20.9.0's postinstall
downloads a bundled Chromium (~150 MB) and the download stalls intermittently on GitHub's
runners. gh-pages was never rebuilt, so the site served the previous render.

## What was done

1. Pushed the pending log commit (`eabdfee`); its run succeeded (6m24s) and the live site
   now shows the correct featured articles.
2. Cancelled the hung run (`33189712585`).
3. `publish.yml` hardened (`a1a3734`): `timeout-minutes: 20` on the job, `concurrency` with
   `cancel-in-progress` so a new push kills a stale run.
4. First run under the new step timeout failed on the same stall (proving the ward works).
   Added a retry loop (`f4fb7d1`): up to 3 attempts, `timeout 150` per attempt, 8-min step
   cap. First run under it: attempt 1 stalled, attempt 2 succeeded, green in 3m20s.

Stall rate today: 3 of 4 first attempts. Retries suffice, but the proper fix is to skip
puppeteer's download (`PUPPETEER_SKIP_DOWNLOAD=1`) and point pagedjs at the runner's
preinstalled Chrome via `PUPPETEER_EXECUTABLE_PATH`. Verify the CV PDF renders before trusting it.

## Housekeeping

bob.md pruned to current state. History moved here from the card:

### Completed items (June–August 2026)
- 2026-06-08: migrated from `/Users/PTT2/Documents/GitHub/website` (abortive start; content kept).
- 2026-06-19: PDF engine switched to pagedjs-cli; full print CSS pass. Fixed orphaned
  `<div class="pub-list">` closing `</main>` early (hid Presentations onward in PDF); fixed
  curly-quote attribute on pub-item #1; navbar removed from CV output; h2 borders and year
  headers unified. Committed and pushed.
- 2026-06-24: GitHub Pages CI/CD via quarto-dev/quarto-actions/publish to gh-pages.
- 2026-08-27: NIDA R01 added to Funding as "Under review" ($505,783, submitted 2026-07-17).
  Schwaba et al. moved from Preprints to 2026 Academic Articles #27, *Nature* (forthcoming).
- 2026-08-27: Redesign built — theme.scss (viridis palette; Cormorant / Public Sans /
  JetBrains Mono; belt-bar mark), navbar restored, new index/research/projects, about
  rewritten, blog listing demoted. Plan: `logs/plans/2026-08-27_website-redesign.md`.
- 2026-08-28: CI fix — Ubuntu 24.04 AppArmor blocked Chromium sandbox; sysctl step added.
  Pushed, Actions green, live. Repo renamed to `petertanksley.github.io`; remote, registry,
  README updated. research.qmd copy reviewed: intro rewritten, GEB cover restored, humanizer
  pass, "Research Ring" naming, featured articles swapped (JOEM out, JCJ in). Unused
  `styles.css` deleted (approved).
- "Deferred Work (post-R01): website overhaul" — done by the 2026-08-27 redesign; removed.

### Hex sticker history
Peter wants point-up hex stickers (as on alerrt-research.org) as section marks. Prototype
(cartoon Manhattan plot + police cap on the y-axis, `www/hex/make_hex.R`, ggplot2 + svglite)
shelved 2026-08-28: cap not recognizable. Files deleted at Peter's request. Idea if revived:
one sticker per Research section (survival curve / Lexis surface; factorial-survey grid or
use-of-force vignette), one for Projects, one for Left-hand Thoughts (spiral notebook).
Current plan (bananarama/Gemini) stays on the card.
