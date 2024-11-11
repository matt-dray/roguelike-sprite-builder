new_canvas <- function(size = 16) {
  nara::nr_new(size, size)
}

read_sprite <- function(file) {
  png::readPNG(file, native = TRUE)
}

blit_sprite <- function(sprite, nr) {
  nara::nr_blit(nr, 0, 0, sprite)
}

draw_sprite <- function(nr) {
  grid::grid.newpage()
  grid::grid.raster(nr, interpolate = FALSE)
}

draw_random_sprite <- function(
    part_files,
    part_weights = c(
      "bodies" = 100,
      "trousers" = 90,
      "shoes" = 90,
      "jerseys" = 90,
      "hair" = 90,
      "hats" = 40,
      "shields" = 20,
      "weapons" = 20
    )
) {

  nr <- new_canvas()

  for (part in names(part_weights)) {

    part_files_type <- part_files[stringr::str_detect(part_files, part)]
    part_file <- sample(part_files_type, 1)

    weight <- part_weights[[part]]

    if (sample(0:100, 1) <= weight) {
      part_file |> read_sprite() |> blit_sprite(nr)
    }

  }

  draw_sprite(nr)

}
