###############################################################
# TEMA GGPLOT Y ESCALAS
###############################################################

#' Tema visual corporativo
#'
#' Tema base de ggplot2 con la identidad gráfica corporativa: tipografía,
#' colores de fondo, cuadrícula, títulos y leyendas. Pensado para usarse
#' junto con \code{finalizar_grafico()}, que además ajusta automáticamente
#' los márgenes y el eje de fechas.
#'
#' @param base_size Tamaño base de fuente.
#' @param base_family Familia tipográfica. Por defecto usa la variable de
#'   opción \code{getOption("cenaictemas.fuente", "sans")}, que se puede
#'   cambiar globalmente con \code{cargar_fuentes_corporativas()}.
#' @export
theme_corporate <- function(base_size = 13,
                             base_family = getOption("cenaictemas.fuente", "sans")) {

  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.background   = ggplot2::element_rect(fill = "#F7F9FB", colour = NA),
      panel.background  = ggplot2::element_rect(fill = "white", colour = NA),
      panel.grid.major  = ggplot2::element_line(colour = "#E6E6E6", linewidth = .4),
      panel.grid.minor  = ggplot2::element_blank(),
      panel.border      = ggplot2::element_rect(colour = "grey70", fill = "transparent", linewidth = 0.2),

      plot.title    = ggplot2::element_text(size = 20, face = "bold", colour = "#071A26",
                                             margin = ggplot2::margin(b = 6)),
      plot.subtitle = ggplot2::element_text(size = 13, colour = "#4E748B",
                                             margin = ggplot2::margin(b = 14)),
      plot.caption  = ggplot2::element_text(colour = "#666666", size = 9, hjust = 0,
                                             margin = ggplot2::margin(t = 10)),

      axis.title = ggplot2::element_text(face = "bold", colour = "#333333"),
      axis.text  = ggplot2::element_text(colour = "#333333"),

      legend.position   = "bottom",
      legend.direction  = "horizontal",
      legend.title      = ggplot2::element_text(face = "bold", colour = "#071A26"),
      legend.text       = ggplot2::element_text(colour = "#333333"),
      legend.background = ggplot2::element_rect(fill = "white", colour = NA),

      strip.background = ggplot2::element_rect(fill = "#123D4F", colour = NA),
      strip.text       = ggplot2::element_text(colour = "white", face = "bold"),

      plot.margin = ggplot2::margin(t = 10, r = 22, b = 10, l = 10)
    )
}

#' @export
scale_fill_corporate <- function(...) ggplot2::scale_fill_manual(values = corporate_palette, ...)

#' @export
scale_color_corporate <- function(...) ggplot2::scale_color_manual(values = corporate_palette, ...)

#' @export
scale_fill_gradient_corporate <- function(...) {
  ggplot2::scale_fill_gradientn(
    colors = c("#D9E6EE", "#AFC4D3", "#86A5BB", "#4E748B", "#1E5F74", "#123D4F", "#071A26"),
    ...
  )
}

#' @export
scale_color_gradient_corporate <- function(...) {
  ggplot2::scale_color_gradientn(
    colors = c("#D9E6EE", "#AFC4D3", "#86A5BB", "#4E748B", "#1E5F74", "#123D4F", "#071A26"),
    ...
  )
}
