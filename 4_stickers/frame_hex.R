# frame_hex.R — clip a generated square image to a point-up hex sticker
#
# Model paints, code frames: bananarama/Gemini produces square candidates
# (see bananarama.yaml); this script clips the chosen candidate to a
# point-up hexagon, inks the border, and optionally adds a title.
#
# Usage (from repo root):
#   source("4_stickers/frame_hex.R")
#   frame_hex("4_stickers/bananarama/research-1.png",
#             "www/hex/research.png", title = "research")
#
# Standard R-community hex proportions: point-up, width = sqrt(3)/2 * height.

library(magick)

frame_hex <- function(input,
                      output,
                      height     = 1200,
                      border_col = "#1a1a1a",
                      border_px  = 24,
                      title      = NULL,
                      title_col  = "#1a1a1a",
                      title_size = 96,
                      title_font = "Helvetica") {
  width <- round(height * sqrt(3) / 2)

  # Inset the hex so the stroked border stays inside the canvas: a stroke
  # straddles its path, so vertices placed exactly on the canvas edge get
  # half the border (and the join at the tips) clipped off
  m  <- border_px / 2 + 2
  hh <- height - 2 * m                 # hex height after inset
  hw <- hh * sqrt(3) / 2               # keep regular-hex proportions
  cx <- width / 2

  # Point-up hex vertices, centered, inset by m from top and bottom
  hx <- c(cx, cx + hw / 2, cx + hw / 2, cx, cx - hw / 2, cx - hw / 2)
  hy <- c(m, m + hh / 4, m + 3 * hh / 4, height - m, m + 3 * hh / 4, m + hh / 4)

  img <- image_read(input) |>
    image_resize(sprintf("%dx%d^", width, height)) |>
    image_crop(sprintf("%dx%d+0+0", width, height), gravity = "center")

  # Hex alpha mask: white hex on transparent, copied into the alpha channel
  mask <- image_blank(width, height, color = "none")
  mask <- image_draw(mask)
  polypath(hx, hy, col = "white", border = NA)
  dev.off()
  clipped <- image_composite(img, mask, operator = "CopyOpacity")

  # Border, drawn as a stroked polygon over the clipped image; round joins
  # keep the tips from spiking past the inset margin (and match the softly
  # rounded corners of standard R hex stickers)
  framed <- image_draw(clipped)
  par(ljoin = "round")
  polypath(hx, hy, col = NA, border = border_col, lwd = border_px)
  if (!is.null(title)) {
    text(width / 2, height * 0.82, labels = title,
         col = title_col, cex = title_size / 12, family = title_font)
  }
  dev.off()

  dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
  # format must be forced: image_write() defaults to the INPUT's format, and
  # Gemini candidates are often JPEG despite their .png names — writing JPEG
  # silently flattens the hex transparency to black corners
  image_write(framed, output, format = "png")
  invisible(output)
}
