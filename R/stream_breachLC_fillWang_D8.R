#' Title
#'
#' @param input_dem_path
#' @param output_folder_path
#' @param fill_dist
#' @param x
#'
#' @return
#' @export
#'
#' @examples stream_breachLC_fillWang_D8("D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/NMT_clip.tif", "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/", 5, 2500)
stream_breachLC_fillWang_D8 <- function(input_dem_path, output_folder_path, fill_dist, x) {

  # Tworzenie folderów wynikowych
  dir.create(file.path(output_folder_path, "Results"), showWarnings = FALSE)
  dir.create(file.path(output_folder_path, "Results", "SHP_Streams"), showWarnings = FALSE)
  output_folder_path_result <- file.path(output_folder_path, "Results")

  # Wygładzenie terenu usuwając zagłębienia
  whitebox::wbt_breach_depressions_least_cost(
    dem = input_dem_path,
    output = file.path(output_folder_path_result, "_breach.tif"),
    dist = fill_dist,
    fill = TRUE
  )

  # Wypełnianie zagłębień
  whitebox::wbt_fill_depressions_wang_and_liu(
    dem = list.files(path = output_folder_path_result, pattern = "_breach.tif", full.names = TRUE, recursive = TRUE),
    output = file.path(output_folder_path_result, "_breach_fill.tif")
  )

  # Obliczanie akumulacji spływu
  whitebox::wbt_d8_flow_accumulation(
    input = list.files(path = output_folder_path_result, pattern = "_breach_fill.tif", full.names = TRUE, recursive = TRUE),
    output = file.path(output_folder_path_result, "_D8FLA.tif")
  )

  # Wyodrębnianie cieków
  whitebox::wbt_extract_streams(
    flow_accum = list.files(path = output_folder_path_result, pattern = "_D8FLA.tif", full.names = TRUE, recursive = TRUE),
    output = file.path(output_folder_path_result, "_streams.tif"),
    threshold = x
  )

  # Generowanie wskaźnika przepływu D8
  whitebox::wbt_d8_pointer(
    dem = list.files(path = output_folder_path_result, pattern = "_breach_fill.tif", full.names = TRUE, recursive = TRUE),
    output = file.path(output_folder_path_result, "_D8pointer.tif")
  )

  # Konwersja rastrowych cieków na wektory
  whitebox::wbt_raster_streams_to_vector(
    streams = list.files(path = output_folder_path_result, pattern = "_streams.tif", full.names = TRUE, recursive = TRUE),
    d8_pntr = list.files(path = output_folder_path_result, pattern = "_D8pointer.tif", full.names = TRUE, recursive = TRUE),
    output = file.path(output_folder_path, "Results", "SHP_Streams", paste0(x, "_streams.shp"))
  )
}

