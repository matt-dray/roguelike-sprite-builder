# Roguelike Characters pack (2.0)
#   Created/distributed by Kenney (www.kenney.nl)
# License: Creative Commons Zero, CC0
#   http://creativecommons.org/publicdomain/zero/1.0/

# Read in original spritesheet
spritesheet <- file.path("www", "roguelikeChar_transparent.png") |>
  magick::image_read()

# Build geometry string to help crop sprite parts from spritesheet
build_px_geometry <- function(
    x_tile = 1,  # a 'tile' in the spritesheet that contains one sprite part
    y_tile = x_tile,
    x_px = 16,  # sprites are 16x16px
    y_px = x_px,
    margin_px = 1  # there's a 1px gap between sprite parts in the spritesheet
) {
  paste0(
    x_px, "x", y_px,
    "+", (x_px + margin_px) * (x_tile - 1),
    "+", (y_px + margin_px) * (y_tile - 1)
  )
}

# Table of spritesheet tile locations for each part type
part_types <- list(
  body = expand.grid(x = 1:2, y = 1:4),
  hat = expand.grid(x = 29:32, y = 1:9),
  hair = rbind(
    expand.grid(x = 20:27, y = 1:8),
    expand.grid(x = 20:23, y = 9:12)
  ),
  jersey = expand.grid(x = 7:18, y = 1:10),
  trousers = data.frame(
    x = 4,
    y = c(1:4, 6:9)
  ),
  shoes = data.frame(
    x = c(rep(4, 2), rep(5, 10)),
    y = c(5, 10, 1:10)
  ),
  shield =  rbind(
    expand.grid(x = 34:41, y = 1:2),
    expand.grid(x = 34:35, y = 3),
    expand.grid(x = 38:39, y = 3),
    expand.grid(x = 34:41, y = 4:5),
    expand.grid(x = 34:35, y = 6),
    expand.grid(x = 38:39, y = 6),
    expand.grid(x = 34:41, y = 7:8),
    expand.grid(x = 34:35, y = 9),
    expand.grid(x = 38:39, y = 9)
  ),
  weapon = rbind(
    expand.grid(x = 43:54, y = 1:5),
    expand.grid(x = 43:52, y = 6:10)
  )
) |>
  purrr::list_rbind(names_to = "type")

# Iterate the extraction of all tiles from the spritesheet
for (x in 1:54) {  # the spritesheet is 54 tiles wide
  for (y in 1:12) {  # and 12 high

    geometry <- build_px_geometry(x, y)

    # Get the type for the sprite part at this tile location
    part_type <- part_types[part_types$x == x & part_types$y == y, "type"]
    if (length(part_type) == 0) part_type <- "delete"  # if no type

    # Write path for the part tile
    path <- file.path("www", "img", paste0(part_type, "_", x, "x", y, ".png"))

    spritesheet |>
      magick::image_crop(geometry) |>
      magick::image_write(path)

  }
}

# Remove tiles that have no sprite part
files <- list.files(file.path("www", "img"), full.names = TRUE)
for (file in files) {
  to_delete <- stringr::str_detect(file, "delete")
  if (to_delete) file.remove(file)
}
