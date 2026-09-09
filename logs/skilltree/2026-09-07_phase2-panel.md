# 2026-09-07 — Phase 2: detail panel and deep links

Peter: "Good start, much better behavior. Let's move to the next task." Next per plan §7/§11: the
click → detail panel.

## Built

- `<aside class="skilltree-panel">` in `skilltree.qmd`; right-hand drawer (400 px) on desktop, bottom
  sheet (max 78 vh, rounded top) under 720 px; slides in/out; dark tokens; close button.
- Click (or Enter/Space) on a hex now: flips it face-up, pins it, hides the hover tooltip, and opens
  the panel. Panel shows: year · role eyebrow; title; year · venue · volume/pages · status; "kth of N
  authors"; blurb (or "Description to come."); the three area dots; **What I did** — six named CRediT
  groups as bars with n/3 (or "not yet scored"); **Effort** — five blocks with a word label
  (light … consuming) and the effort note (or "not yet rated"); link button (DOI → doi.org, else URL),
  or "In press — link to come." for CV 28.
- Close: × button, Esc, or click anywhere outside a hex or the panel. Closing turns the hex back.
- Hover tooltips keep working on other hexes while a panel is open.
- Deep links: opening a hex sets `#<id>` (replaceState, no history spam); loading the page with a hash
  opens that article and scrolls it into view; `hashchange` switches.
- Extractor: citation text cleaned ("], 52, 101270." → "52, 101270"; "(in press)" → "in press").

## Verified (headless Chrome)

Panel hidden on load; click opens with correct title, meta, author position, DOI href; hash set;
tooltip works on other nodes while open; clicking inside the panel keeps it open; × closes, hash
cleared, no lit nodes left; in-press paper shows no link button and the right message; Esc closes;
fresh load with `#liu_2022_incarceration` opens it; hashchange switches to another; Tab + Enter opens;
at 420 px the panel is a full-width bottom sheet (y = 186 of 800). No script errors.

## Next

Peter's data pass (areas, role, contribution, effort, blurbs) makes the panel worth reading. Then
Phase 3: `builds_on` edges, legend polish, stickers when Peter is ready, integration into the site
(navbar placement still his call).
