# Peter T. Tanksley — personal website and CV

Quarto website. Live at https://petertanksley.github.io/petertanksley/ (repo `petertanksley/petertanksley`).

## Layout

- `index.qmd` — profile landing page
- `research.qmd` — high-level research pillars (project detail lives at alerrt-research.org)
- `projects.qmd` — data-science side projects
- `2_cv/tanksley_cv.qmd` — CV; HTML + PDF (pagedjs-cli). Print rules in `2_cv/tanksley_cv.css`
- `1_about/about.qmd`, `3_posts/` — about page and the Left-hand Thoughts blog
- `theme.scss` — the design system (tokens, belt-bar mark, components)
- `logs/plans/` — design/implementation plans

## Build

`quarto render` builds to `docs/` (gitignored). `.github/workflows/publish.yml` renders on push to `main` and publishes to `gh-pages`.
Requires `pagedjs-cli` (`npm i -g pagedjs-cli`) for the CV PDF.

## Design

Viridis-derived palette (teal `#21918C`, indigo `#3B0F5C`) on warm paper; Cormorant Garamond display, Public Sans body, JetBrains Mono utility. The single mark is a black-belt rank bar (black rule, red segment) under the name and as CV section dividers.
