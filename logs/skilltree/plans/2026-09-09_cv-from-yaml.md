# Plan — CV publications generated from articles.yml

**Status:** APPROVED (Peter, 2026-09-09: "let's do the CV tie in"; no blurbs for preprints).

## Goal
`5_skilltree/data/articles.yml` becomes the only place a publication exists. One rebuild updates the
CV (HTML + pagedjs PDF), the skill tree, and the tree's data.

## Steps
1. Extractor stores `authors_cv` (verbatim author string as written in the CV, bold markers kept) and
   `et_al`; rerun (judgement fields preserved).
2. `5_skilltree/R/render_cv_pubs.R` writes `2_cv/_publications.qmd`: year headings, numbered
   `::: {.pub-item}` divs, then the Preprints section. Verbatim strings (authors, title, venue,
   citation) so nothing is silently normalised.
3. **Fidelity gate:** generated block diffed against the current hand-written block. Whitespace-only
   and line-wrapping differences allowed; any character difference in rendered text is resolved
   before the swap.
4. Swap: the CV's publication block → `{{< include _publications.qmd >}}`. Render the CV; diff the
   rendered publication HTML before/after.
5. Extractor reads `_publications.qmd` when it exists (back-compat / migration only).
6. `5_skilltree/R/add_article.R <DOI>`: CrossRef lookup → new YAML entry (bibliographic fields +
   generated `authors_cv`, judgement fields null) for rating in the app. Dry-run against an existing
   DOI to check the shape.
7. Preprints carry no blurb: YAML `blurb: ~`, panel omits the description for `status: preprint`,
   rating app does not count blurb toward completeness for preprints.
8. Docs (CLAUDE.md "adding a paper", 5_skilltree/README, log), commit on Peter's yes.

## Files
`5_skilltree/R/extract_cv.R`, `5_skilltree/R/render_cv_pubs.R` (new), `5_skilltree/R/add_article.R`
(new), `2_cv/tanksley_cv.qmd`, `2_cv/_publications.qmd` (generated, committed), `www/skilltree.js`,
`5_skilltree/tools/rate_articles/helpers.R`, `5_skilltree/data/articles.yml`.

## Verification
Fidelity diff empty; `quarto render 2_cv/tanksley_cv.qmd` clean; rendered pub HTML identical; tree
rebuild unchanged (30 nodes); add_article dry run reproduces an existing entry's fields.
