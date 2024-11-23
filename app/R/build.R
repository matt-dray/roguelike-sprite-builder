pick_part <- function(
    part_files = list.files(file.path("www", "img"), "\\.png$", full.names = TRUE),
    part_type = c(
      "body",
      "trousers",
      "shoes",
      "jersey",
      "hair",
      "hat",
      "shield",
      "weapon"
    ),
    part_weight = 100
) {
  part_type <- match.arg(part_type)
  part_files_type <- part_files[stringr::str_detect(part_files, part_type)]
  if (sample(1:100, 1) <= part_weight) sample(part_files_type, 1) else NULL
}

pick_parts <- function(
    part_files = list.files(
      file.path("www", "img"), "\\.png$",
      full.names = TRUE
    ),
    part_weights = c(
      "body" = 100,
      "trousers" = 90,
      "shoes" = 90,
      "jersey" = 90,
      "hair" = 90,
      "hat" = 40,
      "shield" = 20,
      "weapon" = 20
    )
) {

  part_types <- names(part_weights)

  parts <- vector("list", length(part_types)) |> setNames(part_types)

  for (part in part_types) {
    parts[[part]] <- pick_part(part_files, part, part_weights[part])
  }

  parts

}

read_sprite_parts <- function(parts = pick_parts()) {
  # Read all selected sprite parts
  images <- parts[["body"]] |> magick::image_read()  # start with body
  for (i in 2:length(parts)) {  # append remaining parts
    images <- c(images, magick::image_read(parts[[i]]))
  }
  images  # magick-image object
}

sprite_parts_to_nr <- function(parts_magick = read_sprite_parts()) {
  # Write out image mosaic and back in as nativeRaster
  temp_file <- tempfile(fileext = ".png")
  on.exit(file.remove(temp_file))
  parts_magick |> magick::image_mosaic() |> magick::image_write(temp_file)
  temp_file |> png::readPNG(native = TRUE)
}

draw_sprite <- function(sprite_nr = sprite_parts_to_nr()) {
  grid::grid.newpage()
  grid::grid.raster(sprite_nr, interpolate = FALSE)
}
