# Session log — 2026-09-05: four new hex stickers, news feed built

## What happened

1. **Round-2 hex stickers** (bananarama, $0.81 for 12 candidates). Peter's brief: one clean
   symbolic subject per hex, nothing that needs magnifying at 92px. Subjects: his own puzzled
   face (experiment went sideways), plus one mark per career phase.
   | File | Candidate | Subject |
   |------|-----------|---------|
   | `www/hex/puzzled.png` | puzzled-2 | Peter, one eyebrow up, holding a flask smoking the wrong colour |
   | `www/hex/criminology.png` | criminology-2 | Brass magnifying glass on one pinned parchment, red string (Cincinnati PhD) |
   | `www/hex/genomics.png` | genomics-2 | Flask with a glowing DNA helix rising as vapour, honeybee on the strand (Harden Lab; royal jelly as the epigenetics nod, bee from the tattoo) |
   | `www/hex/responders.png` | responders-3 | Firefighter helmet on a stone ledge, three candles burned to different heights (mortality surveillance) |
   Candidates were judged *after* hex-clipping (framed all 12 to scratch at full size and at
   92px). Losers mostly lost their subject to the corner clip: bee riding the top edge
   (genomics-1/-3), parchment corner cut (criminology-1/-3). responders-1 has a hexagon carved
   into the ledge, nice, but the helmet reads as a bowl when small.
   Prompts appended to `4_stickers/bananarama.yaml` under "Round 2". Existing entries were
   skipped automatically (bananarama regenerates only when the output is missing or `force`).
2. **Band regenerated** (`4_stickers/hexband.R` → `_hexband.qmd`): seven art stickers now, eligible
   row window widened 3:11 → 3:14 (12 eligible cells for 7 stickers; the min-gap rule relaxes
   itself). Verified on `hexband.qmd` and the CV: all seven fully visible on the first screen,
   some adjacency at the bottom of the band.
3. **News feed built.** Architecture chosen: hand-maintained YAML + Quarto listing, no R
   execution, no freeze, no navbar entry.
   - `news.yml` (root): one entry per item — `date`, `title`, `path`, `source`, `description`.
   - `news-listing.ejs`: compact dated list; external `path` gets `target=_blank`.
   - `news.qmd`: full page (all items). `index.qmd`: "News" eyebrow between the masthead and
     "What I work on", `max-items: 3`, "All news →" to the page.
   - `theme.scss` `.newslist`: `.worklist` grid with a 7.5em date column; stacks < 640px.
   - First entry: "The Mortality Numbers Agency Heads Actually Need", Tactical Science
     (Substack), 2026-08-31.

4. **Follow-ups after Peter reviewed the renders.** News added to the navbar between Projects
   and Left-hand Thoughts (Peter wanted it discoverable, not click-through only). The masthead's
   hexagon-clipped headshot on the landing page replaced by a **four-sticker collage**
   (`.hexcollage` in `theme.scss`, raw HTML in `index.qmd`): a point-up diamond, puzzled Peter on
   top, criminology and genomics beneath, responders at the bottom, so it reads top-to-bottom in
   career order. The real headshot stays on the About page by Peter's instruction. Collage is
   108px cells on desktop, 76px centred on mobile. Full site re-rendered (CV PDF included).

5. **News feed restructured to the Research Ring pattern** (after Peter saw the first two entries).
   Peter's rule for entries: the **headline says what the thing is, in his irreverent voice**, never
   the article/journal/newsletter name; the **blurb is one lighthearted sentence**, no info dump.
   Links live in the blurb as markdown. `news-listing-home.ejs` (homepage) strips them to plain text
   and points the headline at `news.html#<id>`; `news-listing.ejs` (news page) renders them as
   anchors and gives each entry its `id`. Second entry added: the Schwaba et al. Nature paper
   (published online 2026-09-02; Crossref still has no volume/pages). Fields dropped: `path`,
   `source`. Modelled on `PROJ_researchring_website/_media_entries.yaml` + `_render_media.R`
   (landing strip → media-page anchor; description carries the outbound links).

6. **Landing-page sections made distinct** (Peter: "blend together into text and horizontal
   lines"). Mono eyebrows replaced by `.section-head` display headings (Cormorant 1.7rem) with the
   belt bar beneath, as on the CV; "What I work on" moved onto a full-width tinted band
   (`.column-screen .band`, `$paper-deep`, hairline top/bottom) with `.band-inner` sized to the
   body column; news rows switched from hairlines to a 3px teal left rule with whitespace between
   entries so the feed no longer rhymes with `.worklist`. Section spacing 4rem.

7. **Voice pass across the site.** Prose on index (masthead, pillars), research, projects, about,
   and the news intro rewritten in Peter's irreverent register. Two refinements from Peter's
   review, both now in `CLAUDE.md`: **no sass about first responders dying** (state it plainly;
   the about page's "train, live, die, roughly in that order" was cut for this), and CV /
   publication titles stay formal. GEB line capitalised: "Genes, Environment, Behavior."
8. **Research page:** one hex per section (responders → mortality, criminology → training and
   public opinion, genomics → origins), page-top research hex removed; `.hex-mark--section`
   118px, `h2 { clear: both }`. Mortality paragraph no longer names a dataset (Peter: general
   pages describe the work, not the sources). Origins reframed as **three careers**:
   criminologist, biosocial researcher, occupational researcher of policing.
9. LinkedIn added to the masthead link row.

## Gotchas worth keeping

- Quarto's bundled EJS does **not** accept `<%# comment %>` tags — the render dies with a bare
  `SyntaxError: Invalid or unexpected token` and a Deno stack trace. Comment the template in
  an adjacent file or not at all.
- Listing `date-format` does apply inside custom EJS templates (`item.date` arrives formatted).
- Quarto's EJS does **not** HTML-escape `<%= %>` (it is raw output), and `<%- %>` comes out
  *escaped*. Reverse of standard EJS. Use `<%= %>` for HTML you built in the template.
- Judge sticker candidates framed, not square: the point-up hex keeps the top/bottom apexes
  and loses the four corners, so tall centred subjects survive and anything in a corner dies.
- Quarto `.column-screen` is the right tool for a full-bleed band (no `50vw` margin tricks, no
  scrollbar overflow); re-constrain the inner content to `$grid-body-width` with no side
  padding at desktop, or it sits ~1rem right of the surrounding text column.
- zsh: a bare `=====` separator in a Bash command is `=cmd` expansion and errors; quote it.

## Not done / open

- Nothing committed or pushed this session (Peter to review first).
- Round-2 stickers now appear on the CV band and the landing-page collage. Still optional:
  the three phase marks beside the matching Research-page sections.
- AJPH DOI and Nature volume/pages still pending.
