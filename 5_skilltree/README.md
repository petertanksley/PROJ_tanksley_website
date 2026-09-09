# 5_skilltree — the publication skill tree generator

R thinks, JS draws. `data/articles.yml` is the source of truth (30 articles, all rated by Peter).

```bash
# from the site repo root
Rscript 5_skilltree/R/extract_cv.R     # refresh bibliographic fields from 2_cv/tanksley_cv.qmd (keeps ratings)
Rscript 5_skilltree/R/build_tree.R     # validate, lay out the hex rings, write www/tree.json + www/hex/sm/
Rscript -e 'shiny::runApp("5_skilltree/tools/rate_articles", launch.browser = TRUE)'   # rate/edit articles
quarto preview                          # skilltree.qmd renders with the rest of the site
```

`www/tree.json` and `www/hex/sm/` are **committed** so CI can render without R, like `_hexband.qmd`.
Adding a paper: add it to the CV, run the extractor, rate it in the app, rebuild, commit.

Conventions live in the repo `CLAUDE.md` (Skill tree section). Plan and history:
`logs/skilltree/`. Built 2026-09-07/09 in the (now archived) `PROJ_skill_tree` repo.
