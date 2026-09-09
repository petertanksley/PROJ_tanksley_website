# Plan — Publication Skill Tree

**Status:** APPROVED (2026-09-07), REVISED twice the same day after Peter saw renders: columns → ternary field → **hexagonal year rings with area axes** (§4 Q1 revision, §5, §8). Phase 1 MVP built on the rings layout.
**Project:** `/Users/PTT2/Documents/GitHub/PROJ_skill_tree` — registered in `~/.claude/bob/registry-local.md`.
**Host site:** `PROJ_tanksley_website` → https://petertanksley.github.io (Quarto, `output-dir: docs`, GitHub Pages via Actions).

## 1. Goal

An interactive "skill tree" where each of Peter's articles is a hex sticker. Hover shows a compact
breakdown of his contribution; click opens a detail panel with a short description (site voice), an
effort breakdown, and a link to the article. Lives as a page on the personal website.

## 2. Decisions already taken (overturn if wrong)

**Separate project, not a sub-component of the website.** Own repo, own `bob.md`, own card.
Reasons: the website card is at "monitoring, 1h/wk" and a three-phase build with its own milestones
would swamp it; experiments (layout attempts, JS scaffolding) stay out of the live-site repo; and
integration becomes an explicit v3 step rather than a series of half-finished pages on `main`.
Cost: one more repo to keep in sync between machines, and the framed sticker PNGs exist in two places
until integration. Sticker *generation* stays in the website's `4_stickers/` pipeline regardless — the
refs, style anchor and lessons live there.

**R-first with a thin JS layer** (see §5). Same split `hexband.R` already uses: R computes, the browser
only draws and listens.

## 3. Requirements

| # | Requirement | Level | Clarity |
|---|-------------|-------|---------|
| R1 | One node per article; hover tooltip with contribution breakdown | MUST | CLEAR |
| R2 | Click → detail panel: blurb, effort breakdown, link (DOI or URL) | MUST | CLEAR |
| R3 | Hex sticker per article, in the established 16-bit sepia style | MUST | CLEAR (art is new work) |
| R4 | "Tree" structure: branches + edges, not just a grid | MUST | CLEAR — Q1 decided |
| R5 | Contribution scheme | MUST | CLEAR — Q2 decided |
| R6 | Which articles are in scope | MUST | CLEAR — Q3 decided |
| R7 | Embeds in the Quarto site; renders in CI without new system deps | MUST | CLEAR |
| R8 | Works on touch (no hover) and keyboard | SHOULD | CLEAR |
| R9 | Data + layout produced in R; no hardcoded absolute paths | SHOULD | CLEAR |
| R10 | Page weight reasonable (< ~2 MB of images) | SHOULD | CLEAR |
| R11 | `articles.yml` later drives the CV publication list too | MAY | out of scope for now |

## 4. Open questions — DECIDED 2026-09-07

Peter took the proposed answer on all three. One rider on Q3, recorded there. Original proposals kept
below for the reasoning.

**Q1 — What is the tree keyed on?** DECIDED: research area — **REVISED 2026-09-07 to a ternary field.**
After seeing the column layout Peter pointed out that most articles straddle areas: the early work is
half biosocial / half criminology, the recent work is first-responder occupational, and he is trying
to pull the biosocial into that. A single `branch` cannot say that. Each article is now rated 0–3 on
three axes (`areas.biosocial`, `areas.criminology`, `areas.responders`); the normalised ratings are
barycentric weights on a triangle whose vertices are the pure areas, snapped to the nearest free hex
so vertex clusters fan out. Pure articles sit at a vertex (Nature GWAS paper: 3/0/0; prison
punishment decisions: 0/3/0), straddlers along an edge (2/2/0), and anything drawing on all three in
the interior — currently empty, which is the honest picture and the direction of travel. (Ternary version: year was dropped as a layout axis. The rings revision below restored it.) Older articles are placed first so they sit nearest the ideal spot and later work grows
outward. Ring colour is a Lab-space blend of the area colours weighted by the ratings. The original
Q1 reasoning is kept below.
Proposed: **branch = research area**, using the three careers already framed on the site and
keyed to the three research-page stickers — `responders` (first-responder health/mortality),
`criminology` (policing, use of force, corrections, methods), `genomics` (biosocial / GWAS /
epigenetics). Depth within a branch = chronological rank; explicit `builds_on` edges draw lineage
(e.g. LEO mortality 2025 → Response to Kamal 2025 → CO mortality 2026). Cross-branch edges allowed.
Alternatives: keyed on method/data source (NOMS, survey experiment, GWAS…), or pure chronology
(that is a timeline, not a tree).

**Q2 — Contribution breakdown: CRediT or looser?** DECIDED: collapsed CRediT, six groups.
Proposed: **collapsed CRediT** — six groups, each scored 0–3, plus author position and a
role tag. Defensible because each group maps onto named CRediT roles, but 6 × 28 cells is fillable in
an afternoon where 14 × 28 percentages is not. Mapping:

| Group | CRediT roles folded in |
|-------|------------------------|
| conceptualization | Conceptualization |
| data | Data curation, Investigation, Resources |
| analysis | Formal analysis, Software, Visualization |
| methods | Methodology, Validation |
| writing | Writing – original draft, Writing – review & editing |
| supervision | Supervision, Project administration, Funding acquisition |

Alternatives: full 14-role CRediT with percentages (precise, tedious, false precision); free-text only
(no tooltip bars possible).

**Q3 — Scope.** DECIDED: all 28 articles, muted ones included.
Proposed: all 28 peer-reviewed articles on the CV, 2019–2026. The two McAllister/Gonzalez
firefighter biomarker papers (site rule: "do not feature") are rendered **muted** (desaturated, no
sticker art, still clickable) rather than omitted — a tree with holes invites questions. Preprints
appear as outline-only "unearned" nodes. Alternatives: curated subset; include Substack/reports.

**Rider (Peter, 2026-09-07):** "we'll just need to be nice and not dog the lead authors." Muted is a
*visual* treatment only — it says "not Peter's headline work," never "lesser paper." Constraints that
follow: the description text for a muted node is written with the same care and neutrality as any
other; no label, tooltip, legend entry, or alt text explains *why* a node is muted; the legend calls
the tier something like "contributing author" rather than anything evaluative; and the contribution
bars for those nodes are honest but the framing stays on Peter's role, not the paper's merit.

Also provisional, not blocking: `importance: low` on the card; where the page sits in the navbar.

## 5. Data model — `data/articles.yml`

One entry per article. Source of truth for the tree; the CV stays as-is for now (R11).

```yaml
- id: leo_mortality_2025            # stable slug: anchors, sticker filename, edge references
  title: "Mortality among law enforcement officers in the United States: ..."
  year: 2025
  venue: "The Lancet Regional Health – Americas"
  doi: 10.1016/j.lana.2025.101270
  url: null                         # fallback when there is no DOI (in press, reports)
  cv_number: 21                     # ties back to the CV list
  authors_n: 4
  author_position: 1
  role: lead                        # lead | co-lead | contributing — drives node ink weight
  areas:                            # 0-3 on each axis → barycentric position (Q1, revised)
    biosocial: 0
    criminology: 1
    responders: 3
  builds_on: []                     # ids of prerequisite/lineage nodes → edges   (Q1)
  tier: null                        # optional manual depth override; default = year rank in branch
  status: published                 # published | in_press | preprint → published/unearned styling
  featured: true                    # false → muted rendering (Q3)
  contribution:                     # collapsed CRediT, 0–3 each (Q2)
    conceptualization: 3
    data: 3
    analysis: 3
    methods: 2
    writing: 3
    supervision: 1
  effort: 4                         # 1–5 relative effort, whole-project
  effort_note: "One sentence on what the effort actually was."
  blurb: "One or two sentences in the site voice."
  sticker: leo_mortality_2025       # www/hex/<sticker>.png; null → blank.png placeholder
```

Validation in R at build time: unique ids, every `builds_on` resolves, `areas` keys complete with
ratings 0–3 and not all zero (unrated → centre of the triangle with a warning), `contribution` keys
complete, DOI or URL present unless `status: in_press`.

## 6. Rendering approach

**Recommended — R builds, vanilla JS draws.**

- `R/extract_cv.R` (one-off): parse the 28 `::: {.pub-item}` blocks in the website's
  `2_cv/tanksley_cv.qmd` into an `articles.yml` skeleton (title, year, venue, DOI, cv_number,
  author position). Peter fills the judgement fields.
- `R/build_tree.R`: read YAML → validate → layout (branch → horizontal region, tier → row, snapped to
  the same point-up hex lattice as `hexband.R`; edges as centre-to-centre paths) → write
  `www/tree.json` (nodes with pixel coords + display fields, edges). Also emits a downscaled sticker
  set `www/hex/sm/` via `magick` (existing finals are 1200 px / 250–360 KB each; 28 of those is
  8 MB — ~220 px wide at ~30–40 KB each is the target, R10).
- `www/skilltree.js` (~250–300 lines, no dependencies): fetch `tree.json`, build one inline `<svg>`
  (`<image>` per node — stickers are already hex-shaped PNGs, `<path>` per edge), tooltip `<div>` on
  hover/focus, detail panel on click/Enter, `#id` deep links, `aria` labels, `tabindex`.
- `skilltree.qmd` + a `skilltree.scss` partial. Site palette variables come from `theme.scss`.

Why this and not an R widget: every piece of *thinking* (data, validation, geometry) is R, which is
where Peter is strong; the JS is a fixed, small, commented event-handling surface that Claude writes
and Peter rarely touches. Zero extra runtime, so page weight is the images and nothing else. D3 is
not needed for the MVP; `d3-zoom` alone is a v3 option if the tree outgrows the viewport.

**Alternatives considered**

| Option | Verdict |
|--------|---------|
| `ggiraph` (R-only hover tooltips, `onclick` snippets) | Viable for MVP hover only. Click → panel still needs JS; images as interactive layers are awkward; htmlwidget bundle ~1 MB. Would be rewritten at v2 — not worth starting there. |
| Quarto OJS cell (Observable JS, D3 built in) | Native to Quarto and reactive, but its own dialect, harder to debug, extra runtime. No advantage for a single static graphic. |
| `r2d3` | D3 wrapped as an htmlwidget from R. Still writing D3; gains nothing over a plain script on a static site. |

## 7. Interaction

- **Hover / focus → tooltip**: title (short), year · venue, six thin contribution bars (0–3), role
  tag. Positioned by the pointer, clamped to the viewport. No links inside (unreachable on hover).
- **Click / Enter → detail panel**: right-hand drawer on desktop, bottom sheet under ~720 px. Blurb,
  effort (1–5) with `effort_note`, contribution bars with the CRediT group names, authors count and
  position, link button (DOI → `https://doi.org/…`). Closes on Esc / outside click. URL hash set to
  `#id` so a node is shareable.
- **Touch**: no hover exists, so tap = click; the panel carries the tooltip content too.
- **Muted / unearned nodes** (Q3): still focusable and clickable, styled down.

## 8. Layout — what "skill tree" means here (revised 2026-09-07, second pass)

**Concentric hexagonal rings on the hex lattice, with three area axes.** Peter's idea, amended from
triangular bands to hexagonal rings so the lattice does the work. Ring k holds year
`FIRST_YEAR + k - FIRST_RING` (2019 sits on ring 2; ring 1 is left empty as a halo and because its six
cells give only 60-degree resolution). Ring k has 6k cells, so capacity grows with radius, which
happens to match the output curve (3 papers in 2019, 9 dated 2026 including preprints). Three axes
leave the origin 120 degrees apart through alternating corners of the rings: biosocial up-left
(240°), criminology down-left (120°), first-responder occupational right (0°). An article's direction
is the vector sum of its three 0–3 ratings along those axes, so a pure paper sits on its axis, a 2/2/0
paper on the corner between two axes, and a 3/1/0 paper leans about 20 degrees off its axis. On its
year ring it takes the free cell nearest that angle; purest articles are placed first so the axis
corners go to the papers that belong there. Equal thirds (1/1/1) have no direction and would go to
270°; none exist yet. The origin cell holds Peter (the site's `puzzled` sticker). Ring guides are the
hexagon through each ring's corner cells; year labels sit on each ring's top edge, over a free cell if
there is one, with a paper halo (inverted if forced onto a hex). Axis labels sit past the axis tips in
a top layer. The empty sector between biosocial and responders (270–360°) is where nothing yet mixes
the two — the direction of travel, left visibly empty on purpose.

Node ink as before: `role` → ring weight, `status` → dashed ring, `featured: false` → muted. Ring
colour is a Lab-space blend of the area colours by weight with a lightness floor. `builds_on` edges
draw as S-curves beneath the nodes, which on this layout will mostly run outward across rings.

Superseded: columns (branch × year) and the ternary triangle — both in git history and in
`docs/logs/2026-09-07_phase1-mvp.md`.

## 9. Embedding in the Quarto site

- During development the repo is a tiny Quarto project (`_quarto.yml`, `skilltree.qmd`) previewed
  locally, so nothing lands on `main` of the live site until v3.
- At integration, copy in: `skilltree.qmd`, `www/skilltree.js`, `www/tree.json`, `www/hex/sm/*.png`,
  and merge the SCSS partial into `theme.scss`. The site's render list already matches `*.qmd`.
  Navbar entry: under Research or replacing Projects — Peter's call.
- `data/articles.yml` and `R/` can move into the site repo at that point (`5_skilltree/`, mirroring
  `4_stickers/`), and this repo is archived. Or keep the tree repo as the generator and copy outputs.
  Decide at v3.
- CI needs nothing new: the `.js`/`.json` are static assets; R only runs locally.

## 10. Stickers

28 per-article stickers, generated in the **website repo's** `4_stickers/` pipeline: append entries to
`bananarama.yaml` (one clean symbolic subject per hex, judged after hex-clipping, no text, hexagons
never hexagrams), run bananarama, frame with `frame_hex.R`, copy finals here. ~$0.21 per idea at
n=3; realistically 2–3 passes on 28 ideas ≈ $12–20 total. `blank.png` is the placeholder, so the
tree ships before the art is finished. Suggested order: lead-author papers first (v2), the rest by v3.

## 11. Phases

Estimates are rough sizing for discussion, not commitments.

**MVP — static hex grid + hover** (~8–12 h Claude-side + Peter's data entry)
1. `_quarto.yml`, `CLAUDE.md` (conventions: R-first, no abs paths, sticker rules pointer)
2. `R/extract_cv.R` → `data/articles.yml` skeleton; Peter fills contribution/effort/blurb/branch
3. `R/build_tree.R` — validate + grid layout (no edges yet) + `tree.json` + `www/hex/sm/`
4. `www/skilltree.js` — render nodes, hover/focus tooltip
5. `skilltree.qmd` renders locally with `blank.png` everywhere
Exit: 28 hexes on a page, tooltip correct for every one, R script runs clean from repo root.

**v2 — click panel + links** (~6–8 h + one sticker pass)
1. Detail panel, deep links, Esc/outside close, touch + keyboard
2. Contribution bars and effort in panel; blurbs written in site voice
3. First 6–8 stickers (lead-author papers)
Exit: every node opens a panel that links to the article; keyboard-only traversal works.

**v3 — tree + polish + ship** (~10–15 h + remaining sticker passes)
1. `builds_on` edges, branch regions, tier logic, role/status styling, legend
2. Responsive behaviour (bottom sheet, horizontal scroll or zoom if needed)
3. Remaining stickers; muted treatment for `featured: false`
4. Integrate into `PROJ_tanksley_website`, navbar, local render, then push (explicit approval per push)
Exit: live at petertanksley.github.io/skilltree.html; site `bob.md` and news feed updated.

## 12. Files this plan creates or touches

| Path | Purpose |
|------|---------|
| `PROJ_skill_tree/data/articles.yml` | source of truth |
| `PROJ_skill_tree/R/extract_cv.R`, `R/build_tree.R` | skeleton extraction; layout + JSON + resized stickers |
| `PROJ_skill_tree/www/skilltree.js`, `www/tree.json`, `www/hex/` | renderer, data, art |
| `PROJ_skill_tree/skilltree.qmd`, `_quarto.yml`, `skilltree.scss`, `CLAUDE.md` | page, preview project, styles, conventions |
| `PROJ_tanksley_website/4_stickers/bananarama.yaml` | +28 sticker prompts (v2/v3) |
| `PROJ_tanksley_website/` (v3 only) | page, assets, `theme.scss`, `_quarto.yml` navbar, `bob.md`, `news.yml` |

## 13. Verification

- `Rscript R/build_tree.R` from repo root, clean session: no errors, no absolute paths, `set.seed()` if
  any jitter is randomised
- `tree.json`: ids unique, all edges resolve, node count = entry count
- `quarto render` locally; open in browser: hover/click every node once (28 — script a checklist)
- Keyboard: Tab reaches every node, Enter opens, Esc closes
- Image budget: `du -sh www/hex/sm` under 1.5 MB
- Voice check on blurbs against the site `CLAUDE.md` (no sass about deaths; say what the thing is)

## 14. Risks

- **Data entry tedium** — 28 × ~10 judgement fields. Mitigated by the CV skeleton extraction and the
  0–3 scale; still Peter's afternoon.
- **Sticker cost/time** — art is the long pole, not code. `blank.png` decouples it.
- **Page weight** — must use the downscaled set, never the 1200 px finals.
- **JS as a maintenance surface** — keep it dependency-free, one file, commented; Claude owns it.
- **Two sources of truth for publications** (`articles.yml` vs CV divs) — accepted for now; R11 is
  the eventual fix and is out of scope until the tree exists.
