# CV Formatting Session — 2026-06-19

## Summary
Fixed multiple PDF rendering bugs in `2_cv/tanksley_cv.qmd` / `tanksley_cv.css`. PDF now renders correctly with all sections visible and publication entries consistently formatted.

## Bugs Fixed

### 1. Orphaned `<div class="pub-list">` wrapper (critical)
- **Symptom:** PRESENTATIONS, ACADEMIC CONFERENCES, and all subsequent section headers were invisible in the PDF. The gap before PRESENTATIONS persisted regardless of CSS changes.
- **Root cause:** `<div class="pub-list">` at line 90 and its closing `</div>` were parsed by Pandoc as separate raw HTML blocks (Pandoc raw HTML blocks end at blank lines). The standalone `</div>` at line 160 closed the HTML `<main>` container, putting all content from Preprints onwards outside `<main>`. pagedjs cannot page content outside `<main>`.
- **Fix:** Removed both the opening `<div class="pub-list">` and the orphaned `</div>`.

### 2. Curly quotes in raw HTML attribute — entry #1 (pub-item)
- **Symptom:** Entry #1 (Motz et al.) rendered with different indentation and styling than all other pub-items; no `break-inside: avoid` applied.
- **Root cause:** `<div class="pub-item">` on the Motz entry used Unicode RIGHT DOUBLE QUOTATION MARK (U+201D) for both opening and closing quotes of the class attribute. CSS selector `.pub-item` did not match because the actual class name was `"pub-item"` (with quote chars). Also affected `{target="_blank"}` on the same line.
- **Fix:** Replaced curly quotes with ASCII `"` (U+0022) on that line using Python in-place edit.

### 3. Previously fixed (prior session)
- Curly quotes in raw HTML across all other pub-items (bulk Python regex fix)
- `section { break-inside: auto }` caused headers to disappear (pagedjs bug — removed)
- Bootstrap h2 border-bottom lines removed
- Navbar removed from HTML and PDF
- Name block sizing for PDF print view

## CSS State (key print rules)
- `h2 { break-after: avoid; page-break-after: avoid }` — prevents PRESENTATIONS from falling off page bottom
- `h4 { break-after: avoid; page-break-after: avoid }` — year headers stay with first entry
- `.pub-item { break-inside: avoid; page-break-inside: avoid }` — entries don't split across pages
- `.pub-item ol { list-style-position: outside; padding-left: 2.5em }` — hanging indent for numbered entries
- `header { display: none }` — hides Quarto title block in PDF (only one `<header>` element in the HTML)

## Known pagedjs behavior
- `section { break-inside: auto }` causes section headers to disappear — do NOT use
- pagedjs chains `break-after: avoid` through nested `<section>` elements, so adding break rules to h2 and h3 creates progressively longer chains that can delay where sections start
