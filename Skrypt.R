library(here)
library(tidyverse)
library(raster)
library(sf)
library(whitebox)
library(tmap)
whitebox::install_whitebox()

nmt = raster("D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/NMT_clip.tif")
plot(nmt)
dir.create("D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki")
# terra::crs(nmt) = 2180
# 
# writeRaster(nmt, "wyniki/nmt.tif", overwrite = TRUE)
  # Generowanie hillshade
  wbt_hillshade(dem = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/NMT_clip.tif",
                output ="D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/",
                azimuth = 115)

fun_hydro = function(i) {
  
  # Wygładzenie NMT
  wbt_breach_depressions_least_cost(
    dem = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/NMT_clip.tif",
    output = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/breach_depressions_least_cost.tif",
    dist = 5,
    fill = TRUE)
  
  wbt_fill_depressions_wang_and_liu(
    dem = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/breach_depressions_least_cost.tif",
    output = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/fill_depressions_wang_and_liu.tif"
  )
  
  # Akumkulacja spływu
  wbt_d8_flow_accumulation(input = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/fill_depressions_wang_and_liu.tif",
                           output = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/D8FA.tif")
  
  
  # Detekcja ciekow
  wbt_extract_streams(flow_accum = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/D8FA.tif",
                      output = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/raster_streams.tif",
                      threshold = i)
  
  wbt_d8_pointer(dem = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/fill_depressions_wang_and_liu.tif",
                 output = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/D8pointer.tif")
  
  wbt_raster_streams_to_vector(streams = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/raster_streams.tif",
                               d8_pntr = "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/D8pointer.tif",
                               output = paste("D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/wyniki/Streams/",paste(i, "streams.shp", sep = "_"), sep=""))

}
i=1
rm(streams, i, nmt)
fun_hydro(5000)
fun_hydro(4000)
install.packages("future")
library(future)
plan(multisession, workers = 10)
map(seq(1000, 10000, 50), fun_hydro, .progress = FALSE)
usethis::create_package(here(), "hydR")
