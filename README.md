
# hydR

<!-- badges: start -->
<!-- badges: end -->

The goal of hydR is to ...

## Installation

You can install the development version of hydR from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Sekcja-Geomatyki-KNL-URK-WL/hydR")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
input_dem_path= "D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Hydro_20240229/NMT_clip.tif"
output_folder_path="D:/04_DYDAKTYKA/01_SEKCJA_GEO/_Projekt_Hydro_BUL/Test"
fill_dist=5 
x=seq(1000, 10000, 1000)
purrr::map(x, ~stream_breachLC_fillWang_D8(input_dem_path, output_folder_path, fill_dist, .x), .progress = FALSE)
```

