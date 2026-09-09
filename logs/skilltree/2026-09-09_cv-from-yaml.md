# 2026-09-09 — CV publications now generated from articles.yml

Plan: `plans/2026-09-09_cv-from-yaml.md`. Peter: "let's do the CV tie in"; "no blurbs for preprints".

## Done

- Extractor stores `authors_cv` (verbatim author line, bold markers kept) and `et_al`; reads
  `2_cv/_publications.qmd` when it exists, so it is now a migration/back-compat tool.
- `render_cv_pubs.R` writes `2_cv/_publications.qmd`: year headings, numbered pub-item divs, Preprints
  section; every string verbatim from the YAML. **Fidelity gate:** 100 normalised lines vs the
  hand-written block, 0 differences. **Rendered gate:** publications HTML identical before/after the
  swap (whitespace/comments normalised).
- CV: block replaced by `{{< include _publications.qmd >}}` with a "generated" comment.
- `add_article.R <DOI> [--dry-run]`: CrossRef → entry with bibliographic fields, `authors_cv` built
  (first author inverted, Peter bold), judgement fields null, `cv_number` = max + 1, prepended. Dry run
  against the Wooldredge JRCD DOI produced the right shape; CrossRef's known gaps (Title Case, no
  middle initials, no volume for online-first) are documented in the script header and CLAUDE.md.
- Preprints: blurbs cleared to null; panel omits the description for `status: preprint`; helper
  completeness treats preprint blurbs as satisfied. Tree rebuilt: 30 nodes, 7 edges, unchanged.

## Consequences

One YAML entry per paper now drives the CV (HTML and pagedjs PDF), the tree, and the panel. The
homepage / research-page `.worklist` blocks are still hand-written — a possible follow-on.

## Side fix: hex band in the CV PDF

Peter, checking the CV after the swap: "the hex stickers are appended to the bottom of the pdf." Not
from today's work — the live PDF and a 2026-09-05 local one both had it since the band was wired in on
09-02. Cause: the pagedjs PDF is a standalone render without `theme.scss`, so `.hexband` had no
styles, and its root-absolute image paths fail → seven broken-image alt texts after Teaching.
`::: {.content-visible when-format="html"}` did NOT exclude it (pandoc's target for pagedjs is html).
Fix: `.pagedjs_pages .hexband, .pagedjs_page .hexband { display: none !important }` in
`tanksley_cv.css`. Verified: PDF 9 pages, 0 images, no alt text, all 28 publications present; HTML
page still carries the band. Also learned: `quarto render <cv>` alone builds only the HTML — use
`--to pdf` for the PDF.
