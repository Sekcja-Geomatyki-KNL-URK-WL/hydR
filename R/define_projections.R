#' Define Projections for Spatial Data
#'
#' This function reads spatial data from a file and assigns a specified Coordinate Reference System (CRS).
#'
#' @param x Path to the input spatial data file (e.g., shapefile).
#' @param y A valid  EPSG code that you want to assign to the spatial data.
#'
#' @return An sf object with the defined CRS.
#' @export
#'
#' @examples
#' define_projections("path/to/input/file.shp", 4326)

define_projections = function(x, y) {
  i = sf::st_read(x)
  sf::st_crs(i) = y
  return(i)
}
