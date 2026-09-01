# 2026-08-31 — Hex sticker pipeline scaffolded

Peter obtained a personal Google AI Studio `GEMINI_API_KEY`, unblocking the bananarama plan
deferred 2026-08-28. Decision: machinery lives **in this repo** (`4_stickers/`), not a
dedicated project — the reusable part is the `bananarama` package itself; YAML prompts and
refs are content and belong with the site that consumes them. Factor out a shared helper to
claude-config only if a second project (lectures/talks) adopts the style later.

## Built

- `4_stickers/bananarama.yaml` — shared style default (flat vector, chalk-pastel grain, no
  text), `aspect-ratio: "1:1"`, `n: 3`, seed set; three starter prompts for the section marks
  from the 2026-08-28 log (research: survival curve; projects: toolbox; left-hand-thoughts:
  spiral notebook). Descriptions are first drafts.
- `4_stickers/refs/` — for cropped reference images (`[refs/file.png]` syntax).
- `4_stickers/frame_hex.R` — magick: resize/crop square candidate, clip to point-up hex
  (width = sqrt(3)/2 × height), stroke border, optional title. Tested on a dummy image;
  renders correctly with transparency.
- `.gitignore` — added `4_stickers/bananarama/` (generated candidates stay out of the public
  repo; framed finals go to `www/hex/`).

## Environment

- Installed `pak`, `ellmer`, `bananarama` (github::hadley/bananarama@9165791), R 4.5.1.
- **Fixed `~/.R/Makevars`:** pointed at `/opt/homebrew/bin/gcc-13`, which Homebrew had
  upgraded away — every source-package compile on this machine was silently broken. Updated
  to `gcc-16`/`g++-16`; `gfortran` path unchanged.
- ellmer accepts the key from `GEMINI_API_KEY` in `~/.Renviron` (verified in its docs).

## Remaining

1. Peter adds the key to `~/.Renviron` himself (never through Claude, never in the repo).
2. `Rscript -e 'bananarama::bananarama("4_stickers/")'` — ~$0.07/image, $0.21/idea at n=3.
3. Pick winners, frame with `frame_hex()`, place finals in `www/hex/`, wire into the site.

## Also

- Corrected bob.md: Nature article publishes **2026-09-02 11am EST**, not 09-01; DOI is in
  hand but embargoed until then.
