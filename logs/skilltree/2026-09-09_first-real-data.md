# 2026-09-09 — First build on Peter's real ratings

Peter rated all 30 articles in the rating app over 2026-09-07/09 and asked for a rebuild.

- 30/30 complete on areas, contribution, effort, blurb. Roles: 7 lead, 23 contributing (no co-lead).
  Featured: 28; muted: 2 (Peter re-featured one of the three biomarker papers — his call, the tier is
  his to assign). Effort spread 1–5: 5/4/10/7/4.
- Dominant areas after his ratings: biosocial 12, responders 9, criminology 4, mixed 5 (the guesses had
  11/6/5/8 — he pulled several papers toward responders and off the pure-mix corners).
- 7 `builds_on` edges, drawn as S-curves beneath the nodes.
- YAML fix: `read_yaml` returns a one-item sequence as a bare string, and rewriting it produced a
  scalar `builds_on: id`. `write_articles()` now normalises `builds_on` to a list on every write;
  the file was normalised once in place. Round-trip test still passes.

## Blurb pass (same day)

Peter updated one rating in the app, then asked for a grammar/tone pass over the blurbs, content kept.
27 of 28 blurbs lightly edited (the Schwaba one was already clean): typos ("attempt" → "attempts",
"New Years" → "New Year's", missing space after a full stop), agreement, "a merry band", hyphenation
(self-control, immediate-entry, multi-cohort), "who" for people, CASTLE Lab capitalised consistently,
a few tangled sentences untangled (Wertz contribution sentence, Willems parenthetical, the 2020
polyvictimization ending). Voice untouched: "EVER", "impossible-ish", "Laurel is a badass", the
ggplot2 legend joke all stay. **One factual fix flagged to Peter:** the 2026 inflammation paper is the
firefighter study, but its blurb said police officers; changed to firefighter. The two preprints still
read "Preprint". Backup of the pre-pass YAML kept in the session scratchpad. Rebuilt and re-rendered.
