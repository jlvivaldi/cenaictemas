###############################################################
# TEMA GGPLOT Y ESCALAS
###############################################################

#' Tema visual corporativo
#'
#' Tema base de ggplot2 con la identidad gráfica corporativa: tipografía,
#' colores de fondo, cuadrícula, títulos y leyendas. Los tamaños de fuente
#' están calibrados para el lienzo estándar de exportación (18 x 9 in en
#' horizontal, o 9 x 18 in en vertical, ambos a 150 dpi) — si generas la
#' gráfica a otro tamaño, estos tamaños de texto pueden verse
#' desproporcionados. Pensado para usarse junto con
#' \code{finalizar_grafico()}, que además ajusta automáticamente los
#' márgenes, el eje de fechas y la proporción del panel.
#'
#' @param base_size Tamaño base de fuente (no afecta título/subtítulo/
#'   caption, que tienen tamaño fijo calibrado al lienzo grande).
#' @param base_family Familia tipográfica. Por defecto usa la variable de
#'   opción \code{getOption("cenaictemas.fuente", "sans")}, que se puede
#'   cambiar globalmente con \code{cargar_fuentes_corporativas()}.
#' @export
theme_corporate <- function(base_size = 12,
                             base_family = getOption("cenaictemas.fuente", "sans")) {

  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      text = ggplot2::element_text(family = base_family, color = "grey35"),

      plot.title = ggplot2::element_text(size = 28, face = "bold",
                                          margin = ggplot2::margin(10, 0, 10, 0),
                                          family = base_family, color = "grey25"),
      plot.subtitle = ggplot2::element_text(size = 16, colour = "#666666",
                                             margin = ggplot2::margin(0, 0, 20, 0),
                                             family = base_family),
      plot.caption = ggplot2::element_text(hjust = 0, size = 15),

      plot.background  = ggplot2::element_rect(fill = "white", color = "white"),
      panel.background = ggplot2::element_rect(fill = "white", colour = NA),
      panel.grid        = ggplot2::element_line(linetype = 3, color = "grey85"),
      panel.grid.minor  = ggplot2::element_blank(),
      panel.border      = ggplot2::element_rect(colour = "grey70", fill = "transparent", linewidth = 0.2),

      legend.position    = "bottom",
      legend.title       = ggplot2::element_text(size = 12, face = "bold", family = base_family),
      legend.text        = ggplot2::element_text(size = 12, family = base_family),
      legend.title.align = 0.5,

      axis.title = ggplot2::element_text(size = 12, face = "bold",
                                          margin = ggplot2::margin(10, 0, 10, 0),
                                          family = base_family),
      axis.text   = ggplot2::element_text(size = 12, family = base_family),
      axis.text.x = ggplot2::element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5),

      strip.background = ggplot2::element_rect(fill = "grey70", color = "grey70"),
      strip.text       = ggplot2::element_text(face = "bold", color = "grey10", size = 11),

      plot.margin = ggplot2::margin(t = 15, r = 30, b = 15, l = 15)
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
