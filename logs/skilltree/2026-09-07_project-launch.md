# 2026-09-07 — Project launch and plan approval

**Goal.** Interactive "skill tree" of Peter's publications for the personal website: one hex sticker
per article, hover → contribution breakdown, click → description, effort breakdown, link to article.

**What happened.**
- Registered as its own project (`registry-local.md`, alongside PROJ_tanksley_website), not a
  sub-component of the site. Reason: the site card is in monitoring mode at 1 h/wk; a three-phase
  build would swamp it, and experiments stay off the live site's `main`. Integration is a v3 step.
- `git init` on `main`; no commits, no remote yet (both wait on Peter's explicit say-so).
- Plan drafted and approved same day: `docs/logs/plans/2026-09-07_skill-tree-plan.md`.

**Decisions.**
- Tree branches keyed on research area (responders / criminology / genomics, matching the site's
  research-page stickers); depth = year within branch; explicit `builds_on` edges for lineage.
- Contribution recorded as collapsed CRediT: six groups scored 0–3, plus author position and a
  lead / co-lead / contributing tag. Mapping table in plan §4.
- Scope: all 28 peer-reviewed articles 2019–2026. The two do-not-feature biomarker papers stay in,
  rendered muted. Peter's rider: muted is a visual tier, never a judgment; description text stays
  neutral and respectful to the lead authors; nothing on the page explains why a node is muted.
- Rendering: R builds (`R/build_tree.R` → `tree.json` + downscaled stickers), vanilla JS draws
  inline SVG. ggiraph, OJS, r2d3 considered and rejected (plan §6).

**Facts that reshaped the brief.**
- The website's existing hex stickers are thematic (seven of them), not per-article. 28 stickers
  are new work via the site's `4_stickers/` bananarama pipeline; `blank.png` placeholders let the
  tree ship first.
- The 28 publications exist only as hardcoded `.pub-item` divs in the CV. No structured data.
  MVP step 1 is therefore an R script that extracts a YAML skeleton for Peter to fill.
- Existing 1200 px sticker finals are 250–360 KB each; 28 of those is ~8 MB. Plan mandates a
  resized set.

**Next.** Phase 1 (MVP): `_quarto.yml` + `CLAUDE.md`, `R/extract_cv.R` → `data/articles.yml`
skeleton, Peter fills contribution scores, then `build_tree.R` + `skilltree.js` + `skilltree.qmd`.
