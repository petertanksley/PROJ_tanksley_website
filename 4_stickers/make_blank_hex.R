# make_blank_hex.R — a blacked-out hex sticker for the hex band (hexband.R).
# Same geometry and ink as the framed stickers, so it nests with them; the
# fill matches the border colour so the whole hex reads as one silhouette.
# Run from repo root: Rscript 4_stickers/make_blank_hex.R

library(magick)
source("4_stickers/frame_hex.R")

ink <- "#1a1a1a"
tmp <- tempfile(fileext = ".png")
image_write(image_blank(1200, 1200, color = ink), tmp, format = "png")
frame_hex(tmp, "www/hex/blank.png", border_col = ink)

# match the shipped stickers' pixel size (480 x 554)
ref <- image_info(image_read("www/hex/research.png"))
image_read("www/hex/blank.png") |>
  image_resize(sprintf("%dx%d!", ref$width, ref$height)) |>
  image_write("www/hex/blank.png", format = "png")
cat("www/hex/blank.png written\n")
