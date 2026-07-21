###############################################################
# PALETA CORPORATIVA
###############################################################

#' Colores de la paleta corporativa (tonos navy)
#' @export
corporate_colors <- c(
  navy900 = "#071A26",
  navy800 = "#0D1B2A",
  navy700 = "#123D4F",
  navy600 = "#1E5F74",
  navy500 = "#2F738B",
  navy400 = "#4E748B",
  navy300 = "#6E8FA4",
  navy200 = "#86A5BB",
  navy100 = "#AFC4D3",
  navy050 = "#D9E6EE"
)

#' Colores de acento
#' @export
accent_colors <- c(
  teal    = "#008080",
  emerald = "#26A69A",
  green   = "#8BC34A",
  yellow  = "#F2B705",
  orange  = "#F48C06",
  coral   = "#E4572E",
  magenta = "#B03A5B",
  red     = "#C62828",
  purple  = "#6A4C93"
)

#' Colores neutros (grises, fondos)
#' @export
neutral <- c(
  black      = "#1A1A1A",
  darkgray   = "#333333",
  gray       = "#666666",
  lightgray  = "#B0B0B0",
  lighter    = "#E6E6E6",
  background = "#F7F9FB",
  white      = "#FFFFFF"
)

#' Paleta discreta usada por scale_fill_corporate() / scale_color_corporate()
#' @export
corporate_palette <- c(
  "#123D4F", "#1E5F74", "#4E748B", "#86A5BB", "#26A69A",
  "#8BC34A", "#F2B705", "#F48C06", "#E4572E", "#B03A5B", "#6A4C93"
)

#' Paleta semáforo para indicadores de desempeño
#' @export
traffic_colors <- c(
  Excelente   = "#008080",
  Bueno       = "#26A69A",
  Aceptable   = "#8BC34A",
  Advertencia = "#F2B705",
  Riesgo      = "#F48C06",
  Critico     = "#E4572E",
  Muy_Critico = "#C62828"
)

#' Color para valores positivos/objetivo/pronóstico
#' @export
positive_color <- "#26A69A"
#' @export
negative_color <- "#E4572E"
#' @export
target_color <- "#F2B705"
#' @export
forecast_color <- "#B03A5B"
