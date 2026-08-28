# make_hex.R -- point-up hex stickers for petertanksley.github.io
#
# One function per sticker returns a list of ggplot layers drawn in a 200 x 231
# "sticker coordinate" space (x right, y down, like SVG). hex_sticker() wraps the
# layers in the hex border, optional title, and writes an SVG via svglite.
#
# Usage:  Rscript www/hex/make_hex.R        (from the site root)
# Adds a sticker: write a new art_*() function and add two write_hex() calls below.

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(svglite)
})

# ---- palette (matches theme.scss) --------------------------------------------
PAL <- c(paper = "#FBFAF7", ink = "#1C1B22", soft = "#4B4956",
         teal = "#21918C", indigo = "#3B0F5C", red = "#B3261E", brass = "#C9A227")

W <- 200; H <- 231
HEX <- data.frame(x = c(100, 196, 196, 100, 4, 4),
                  y = c(4, 60, 171, 227, 171, 60))

# sticker coords (y down) -> ggplot coords (y up)
flip <- function(y) H - y
px   <- function(pt) pt / ggplot2::.pt          # font size in "px" -> geom_text size

# ---- art: Manhattan plot with a police cap on the y-axis ---------------------
# "Where I came from": criminology + behavior genetics, two careers stapled.
art_origins <- function(seed = 7, n_chr = 8) {
  set.seed(seed)
  x0 <- 58; x1 <- 172; floor <- 178; top <- 108         # plot box, shifted right
  cw <- (x1 - x0) / n_chr
  towers <- c(`1` = 0.95, `3` = 0.6, `5` = 1.0, `6` = 0.5) # chromosome -> rel. height

  chr <- 0:(n_chr - 1)
  dots <- bind_rows(lapply(chr, function(c) {
    col <- if (c %% 2 == 0) PAL["teal"] else PAL["indigo"]
    cx0 <- x0 + c * cw
    fl  <- data.frame(x = cx0 + runif(150, 0.6, cw - 0.6),
                      h = pmin(rexp(150, 1 / 6.5), 26), r = 1.25)
    md  <- data.frame(x = cx0 + runif(6, 1, cw - 1), h = runif(6, 26, 36), r = 1.25)
    tw  <- NULL
    if (as.character(c) %in% names(towers)) {
      tx <- cx0 + cw / 2; th <- (floor - top) * towers[[as.character(c)]]
      tw <- data.frame(x = tx + rnorm(38, 0, 0.9), h = runif(38, 20, th), r = 1.35) |>
        bind_rows(data.frame(x = tx, h = th, r = 1.6))
    }
    bind_rows(fl, md, tw) |> mutate(col = col)
  })) |> mutate(y = floor - h)

  thresh <- floor - 22
  ax <- x0 - 8                                           # y-axis x position

  # police cap perched on top of the y-axis: visor, crown, band, badge
  cap_cy <- top - 14
  crown <- data.frame(x = ax + c(-13, -11, -6, 0, 6, 11, 13, 11, -11),
                      y = cap_cy + c(6, -1, -6, -8, -6, -1, 6, 9, 9))
  band  <- data.frame(xmin = ax - 13, xmax = ax + 13, ymin = cap_cy + 6, ymax = cap_cy + 11)
  visor <- data.frame(x = ax + c(-16, 16, 13, -13), y = cap_cy + c(11, 11, 16, 16))

  list(
    # axes
    annotate("segment", x = ax, xend = x1 + 3, y = flip(floor + 1), yend = flip(floor + 1),
             colour = PAL["ink"], linewidth = 0.55, lineend = "round"),
    annotate("segment", x = ax, xend = ax, y = flip(floor + 1), yend = flip(cap_cy + 15),
             colour = PAL["ink"], linewidth = 0.55, lineend = "round"),
    # genome-wide significance line
    annotate("segment", x = x0, xend = x1, y = flip(thresh), yend = flip(thresh),
             colour = PAL["red"], linewidth = 0.42, linetype = "22"),
    # the skyline
    geom_point(data = dots, aes(x, flip(y), colour = I(col), size = I(r * 0.62)), stroke = 0),
    # cap
    geom_polygon(data = visor, aes(x, flip(y)), fill = PAL["ink"]),
    geom_polygon(data = crown, aes(x, flip(y)), fill = PAL["indigo"]),
    geom_rect(data = band, aes(xmin = xmin, xmax = xmax, ymin = flip(ymax), ymax = flip(ymin)),
              fill = PAL["ink"]),
    annotate("point", x = ax, y = flip(cap_cy + 1), colour = PAL["brass"], size = 1.9),
    # axis labels
    annotate("text", x = (x0 + x1) / 2, y = flip(floor + 12), label = "CHROMOSOME",
             family = "mono", size = px(6.5), colour = PAL["soft"]),
    annotate("text", x = ax - 8, y = flip((floor + top) / 2), label = "-LOG10(P)", angle = 90,
             family = "mono", size = px(6.5), colour = PAL["soft"])
  )
}

# ---- sticker wrapper ----------------------------------------------------------
hex_sticker <- function(art, title = NULL, subtitle = NULL) {
  p <- ggplot() +
    geom_polygon(data = HEX, aes(x, flip(y)), fill = PAL["paper"], colour = NA)
  p <- p + art +
    geom_polygon(data = HEX, aes(x, flip(y)), fill = NA, colour = PAL["ink"],
                 linewidth = 2.2, linejoin = "round")
  if (!is.null(title))
    p <- p + annotate("text", x = 100, y = flip(60), label = title, family = "mono",
                      fontface = "bold", size = px(9), colour = PAL["ink"])
  if (!is.null(subtitle))
    p <- p + annotate("text", x = 100, y = flip(74), label = subtitle, family = "serif",
                      fontface = "italic", size = px(12), colour = PAL["soft"])
  p + coord_fixed(xlim = c(0, W), ylim = c(0, H), expand = FALSE, clip = "on") +
    theme_void() +
    theme(plot.margin = margin(0, 0, 0, 0), plot.background = element_blank())
}

write_hex <- function(p, path, aria = "") {
  svglite(path, width = W / 72, height = H / 72, bg = "transparent",
          system_fonts = list(mono = "Menlo", serif = "Georgia"))
  print(p); dev.off()
  # swap in the site's web fonts (browser falls back to the system names if unavailable)
  s <- readLines(path, warn = FALSE) |> paste(collapse = "\n")
  s <- gsub('font-family: ?["\']?Menlo["\']?;',  'font-family: "JetBrains Mono", Menlo, monospace;', s)
  s <- gsub('font-family: ?["\']?Georgia["\']?;', 'font-family: "Cormorant Garamond", Georgia, serif;', s)
  s <- sub("<svg ", sprintf("<svg role='img' aria-label='%s' ", aria), s)
  writeLines(s, path)
  invisible(path)
}

# ---- build ---------------------------------------------------------------------
if (sys.nframe() == 0) {
  dir <- "www/hex"
  write_hex(hex_sticker(art_origins(), "WHERE I CAME FROM", "two careers, stapled"),
            file.path(dir, "origins.svg"),
            aria = "Hex sticker: a cartoon Manhattan plot with a police cap on the y-axis")
  write_hex(hex_sticker(art_origins()), file.path(dir, "origins-icon.svg"))
  cat("wrote origins.svg, origins-icon.svg\n")
}
