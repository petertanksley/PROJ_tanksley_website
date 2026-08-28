# Plan: Personal Website Redesign — PROJ_tanksley_website

Status: APPROVED (2026-08-27)
Project: `/Users/PTT2/Documents/GitHub/PROJ_tanksley_website`
Also save to: `docs/logs/plans/2026-08-27_website-redesign.md` on approval (dir does not exist yet; `docs/` is the Quarto output dir and gitignored — so use `logs/plans/` at repo root instead and note that in bob.md).

## Context

The site is a 2024-era placeholder (Quarto `cosmo`, no navbar, "this site is boring right now" index, grad-school-tone About) wrapped around one finished asset: the CV. Peter wants it repositioned as a **quick academic profile** — audience order: program officers / search committees / collaborators, then practitioners, then public. Individual project detail stays on alerrt-research.org; this site stays high-level. Blog ("Left-hand Thoughts") is kept but demoted to a side wing. Austere design, with the personality allowed to leak through: Lord of the Rings, Brazilian Jiu-Jitsu, R, and beautiful academic figures. Reference Peter "vaguely likes": matthewbjane.github.io — specifically the *consistency* of a two-accent palette, not the site itself.

Deploy is currently broken: the 2026-08-27 Actions run (`33138546732`) failed at the "Render and publish to gh-pages" step; June's runs were failure/cancelled. The live Pages site serves a stale build. `gh` is now installed (`/opt/homebrew/bin/gh`) but unauthenticated; Peter runs `gh auth login -w` so logs can be read.

## Design direction (from /frontend-design pass)

**Thesis:** a researcher's profile page whose every accent is borrowed from his actual world, so the austerity reads as *his* austerity, not a template's.

**Palette** (viridis-derived — the R/pretty-figures reference, and it is a genuinely accessible palette):
- `--paper #FBFAF7` background (warm off-white, not the AI-default cream — nearly neutral)
- `--ink #1C1B22` text
- `--teal #21918C` primary accent: links, active nav, CV section markers (viridis midpoint)
- `--indigo #3B0F5C` secondary: eyebrows, small caps labels, hover state (viridis low end)
- `--belt-red #B3261E` used *only* in the signature mark
- `--rule #D9D6CE` hairlines

Rejected: pink+teal copy of the reference (Peter isn't in love with it); black-with-acid-accent; broadsheet.

**Type:**
- Display: **Cormorant Garamond** 600 — Garamond-family is the register of the LOTR editions; carries the fantasy nod without any literal ornament. Used for name, page titles, pillar headings only.
- Body: **Public Sans** 400/500 — already the CV's face; keeps continuity between site and PDF.
- Utility: **JetBrains Mono** — dates, DOIs, tags, the projects list. R-adjacent without a code-editor pastiche.
- All via Google Fonts `@import` as the CV CSS already does.

**Signature element — the belt bar.** A BJJ black belt's rank bar: a short black rule (~72px × 6px) with a red segment at one end. It is the site's only mark: under the name in the masthead, and as the section divider on the CV in both HTML and print (replacing the current `border-bottom: none` + uppercase heading combination). Nobody who doesn't train will read it as anything but a well-set rule; anyone who does will grin. That is the one aesthetic risk; everything else stays quiet. No stripes (degree count) — that would be bragging and would date.

**LOTR beyond the typeface:** one footer line, set in Cormorant italic: "The Road goes ever on and on." Nothing else. Blog title "Left-hand Thoughts" already has the right eccentric register.

**Motion:** none beyond link underline transitions and `prefers-reduced-motion`-respecting fade of the masthead on load. Austere means austere.

**Layout concept (index):**
```
┌────────────────────────────────────────────────────────┐
│ Peter T. Tanksley        Research  CV  Projects  Notes │  ← navbar (restored)
├────────────────────────────────────────────────────────┤
│                                                        │
│  PETER T. TANKSLEY                       ┌──────────┐  │
│  ▬▬▬▬▬▬▬▬▬▬▬▪  (belt bar)                │ headshot │  │
│  Research Scientist, ALERRT Center,      │          │  │
│  Texas State University                  └──────────┘  │
│                                                        │
│  One-paragraph thesis: who I am, what I study, why.    │
│  Google Scholar · ORCID · GitHub · Email               │
│                                                        │
├─ WHAT I WORK ON ───────────────────────────────────────┤
│  Health & mortality of first responders   → Research   │
│  Police training, decision-making, and public opinion  │
│                                                        │
├─ SELECTED WORK ────────────────────────────────────────┤
│  4 entries, mono dates, journal in teal, from CV       │
│                                                        │
│  footer: The Road goes ever on and on.  · CC-BY · RSS  │
└────────────────────────────────────────────────────────┘
```

## Site structure (after)

| Nav label | File | Content |
|---|---|---|
| (home) | `index.qmd` | Profile hero, two pillars teaser, 4 selected works, links |
| Research | `research.qmd` (new) | Three short sections: **Health & mortality of first responders** (primary; NOMS/Lancet RH Americas, firefighter biomarkers, presumptive laws — 2 linked papers); **Police training & public opinion** (secondary; use-of-force perception, active-shooter response, factorial surveys — 2 linked papers); **Where I came from** — the biosocial/genomics history told as the story that explains the CV's shape and the current biomarker interest (Harden Lab postdoc, GWAS consortia; 1–2 linked papers). Closing line pointing to alerrt-research.org for project-level detail. Target ≤ 450 words total. |
| CV | `2_cv/tanksley_cv.qmd` | Content unchanged. Restyle to shared tokens; prominent "Download PDF" button at top (uses existing `format-links: [pdf]` output, `tanksley_cv.pdf`); belt-bar section markers; navbar hidden for print via existing `@media print .navbar {display:none}` |
| Projects | `projects.qmd` (new) | Compact list driven by `projects.yml`: name, one line, mono tag row (R · Shiny · …), link. Launch entry: **Presumptive Laws Dashboard** with an "under construction" tag. Card pattern ready for more. |
| Notes | `3_posts/posts.qmd` | Rename nav label to "Notes" or keep "Left-hand Thoughts" (keep — it's the brand); switch listing from `grid` to `default` list; small; fix hardcoded `citation.url` in both posts (currently `petertanksley.github.io/posts/…`, wrong path) |
| About | `1_about/about.qmd` | Rewrite: current role and trajectory in 2 paragraphs, then the human bullets (keep husband/father, Texan, BJJ black belt, R evangelist; drop dated Twitter link — replace with Bluesky/LinkedIn or none). Drop `trestles` template; hand-laid to match tokens. |

Removed from index: GEB cover essay (move its core "shifting the light" paragraph into the Research page's "Where I came from" section — it's the best-written thing on the site and fits there).

## Files to create / modify

- `_quarto.yml` — enable `navbar` (left: Research, CV, Projects, Left-hand Thoughts, About; right: GitHub/Scholar icons), `theme: [cosmo, theme.scss]` or `theme: theme.scss` standalone, `site-url: https://petertanksley.github.io`, page-footer, `toc: false` default (CV re-enables). Keep `output-dir: docs`, render list, `!bob.md`.
- `theme.scss` (new) — Quarto SCSS with `/*-- scss:defaults --*/` tokens + `/*-- scss:rules --*/`; the belt-bar mixin; nav, masthead, pub-list, project-list rules. Replaces empty `styles.css`.
- `2_cv/tanksley_cv.css` — keep all print/pagination rules (they were hard-won in June: `break-inside: avoid`, orphans/widows, `.print-only`); swap font import to shared faces; add belt-bar `h2::after`; remove now-redundant screen rules that `theme.scss` covers.
- `2_cv/tanksley_cv.qmd` — front matter only: add download button block; no content edits.
- `index.qmd`, `research.qmd`, `projects.qmd`, `projects.yml`, `1_about/about.qmd` — as above.
- `3_posts/posts.qmd`, `3_posts/*/index.qmd` — listing type, citation URLs.
- `www/` — headshot already present; add nothing else (no stock, no icons beyond FontAwesome via existing `_extensions/quarto-ext`).
- `.github/workflows/publish.yml` — fix per Phase 0 findings (likely: add `npx puppeteer browsers install chrome` or install Chromium deps; or create `gh-pages` branch once; or drop CI PDF and commit the PDF instead).
- `README.md`, `bob.md` — update.

## Phases

**Phase 0 — CI repair (blocking; do first, separate commit).**
1. Peter: `gh auth login -w`. Me: `gh run view 33138546732 --log-failed`.
2. Fix root cause. Fallback if Chromium-on-CI is a rabbit hole: build the PDF locally with pagedjs-cli, commit `2_cv/tanksley_cv.pdf` (currently `*.pdf` is gitignored — carve an exception), and remove the pagedjs CI step. The PDF only changes when the CV does, so a committed artifact is acceptable.
3. Confirm green run and that live CV shows "Under review."

**Phase 1 — Repo rename (Peter, GitHub settings).** Rename `PROJ_tanksley_website` → `petertanksley.github.io`. Then me: `git remote set-url`, update `site-url`, `bob.md`, `registry-local.md`, post citation URLs, README. Pages serves from root. Old URL redirects.

**Phase 2 — Design system.** `theme.scss`, `_quarto.yml` navbar/footer, masthead + belt bar. Render locally, screenshot index and CV (screen) at desktop and 390px mobile, self-critique against the design direction. Remove one accessory.

**Phase 3 — Content pages.** `index.qmd`, `research.qmd` (draft copy → Peter reviews wording; this is his voice, not mine), `projects.qmd`/`projects.yml`, `about.qmd`. Blog listing tweak.

**Phase 4 — CV integration.** Restyle, download button, verify the PDF still paginates correctly (9 pages, no orphaned headers, navbar absent). Compare page count and text against the current PDF.

**Phase 5 — Ship.** Commit per phase; push after Phase 4 (push requires Peter's OK each time per standing rule). Update `bob.md`; write `logs/2026-08-27_redesign.md` session note.

## Verification

- `quarto render` clean (existing div warnings acceptable; count must not grow).
- Every nav link resolves; `docs/` contains `index.html`, `research.html`, `projects.html`, `2_cv/tanksley_cv.html`, `2_cv/tanksley_cv.pdf`, `1_about/about.html`, `3_posts/posts.html`.
- PDF: `pymupdf` text check for "Under review", "Nature", page count ≈ 9; visual check page 1 for no navbar/belt-bar misprint.
- Screenshots (Playwright via `example-skills:webapp-testing` or `quarto preview` + browser) at 1280 and 390 widths for index, research, CV.
- Lighthouse-ish sanity: fonts load, contrast on teal links against paper ≥ 4.5:1 (#21918C on #FBFAF7 ≈ 3.9:1 — **use `#1F7F7A` for link text, keep #21918C for decorative**; verify).
- Actions run green; live URL shows new index.

## Out of scope (explicitly)

Custom domain (future); project-by-project pages (alerrt-research.org owns those); new blog posts; analytics.

## Open items for Peter during build

- Review `research.qmd` copy — especially the "Where I came from" paragraph.
- Bluesky/other handle for About, or no social beyond Scholar/ORCID/GitHub/LinkedIn.
- Which 4 works go in "Selected work" on the index (default: Lancet RH Americas 2025 mortality paper, JOEM firefighter biomarkers, JCJ use-of-force perceptions, Nature 2026 forthcoming).
