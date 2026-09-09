# 2026-09-09 — Phase 3: legible lineage edges

Peter: "Let's do the Phase 3 polish, make the edges legible." Both repos were committed locally first
(skill tree `8d5d2e6`, website CV fix `bfd0640`; nothing pushed).

## Edges

- R (`build_tree.R`): each edge is trimmed by 0.54 hex widths at both ends so it meets the hex border
  instead of vanishing under the tile; carries `from_colour`/`to_colour` and its length in cells.
- JS: one `linearGradient` per edge in user space (bounding-box gradients degenerate on near-axis
  lines) running parent → child; quadratic path bowed toward the origin (18% of length, max 40 units)
  so edges read as branches, not spokes; a small dot at the child end marks direction.
- Weight 5, opacity 0.85 at rest. Hover or focus on either end lights that node's edges (`hot`: width
  8, soft glow) and dims the rest to 0.18; a pinned node keeps its lineage lit after the pointer leaves;
  unpin clears. Legend gained a "Builds on an earlier article" item and the hover note mentions lineage.

Verified: 7 edges, 7 tips, 7 gradients; hovering the LEO mortality paper lights 2 and dims 5; leaving
clears; pinning holds; Esc clears. No script errors.

## Second pass: bridges for neighbours

First render showed the real problem: 3 of the 7 lineage links join *adjacent* hexes (LEO mortality
→ Kamal response, Raffington 2022 → 2023, Gonzalez → McAllister 2025) and the others are only 2-3 cells, so a
curve trimmed to both borders has nothing left to show across a 4-unit gap. Adopted the skill-tree
"weld" idiom: R flags edges shorter than 1.3 cells as `adjacent` and trims them to 0.36 W instead, so
~0.28 W spans the border; JS draws those as straight 16-unit-wide gradient bars in a layer appended
*above* the nodes. Longer links keep the bowed curve beneath. `has-hot` moved to the `<svg>` so both
layers dim together.
