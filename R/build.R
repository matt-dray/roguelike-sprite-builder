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
  part_file <- sample(part_files_type, 1)
  if (sample(0:100, 1) <= part_weight) part_file else NULL
}

pick_parts <- function(
    part_files = list.files(file.path("www", "img"), "\\.png$", full.names = TRUE),
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

draw_sprite <- function(parts = choose_random_parts(), size = 16) {

  nr <- nara::nr_new(size, size)

  for (file in parts) {
    file |>
      png::readPNG(native = TRUE) |>
      nara::nr_blit(nr, x = 0, y = 0, src = _)
  }

  grid::grid.newpage()
  grid::grid.raster(nr, interpolate = FALSE)

}
