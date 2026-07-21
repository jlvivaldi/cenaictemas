###############################################################
# ETIQUETADO INTELIGENTE
#
# La idea: en lugar de fijar hjust/vjust "a ojo" para cada gráfica
# (lo cual se rompe en cuanto cambian los datos, el tamaño de la
# ventana, o el equipo donde se ejecuta), estas funciones calculan
# la alineación en automático a partir de la posición relativa del
# punto dentro del rango de datos.
###############################################################

#' Calcula hjust/vjust automáticos para que una etiqueta no se corte
#'
#' Ubica el punto dentro del rango de datos (como porcentaje) y decide
#' hacia qué lado debe "crecer" la etiqueta para no salirse del panel.
#' Si el punto está en el 15% final del eje X, la etiqueta crece hacia
#' la izquierda (hjust = 1); si está en el 15% inicial, crece hacia la
#' derecha (hjust = 0); en cualquier otro caso queda centrada. Se aplica
#' la misma lógica en Y con vjust.
#'
#' @param x_punto Valor de x del punto a etiquetar (numérico o Date).
#' @param y_punto Valor de y del punto a etiquetar.
#' @param x_rango Vector con el rango completo de x de los datos (o los
#'   propios datos, se usa \code{range()} internamente).
#' @param y_rango Vector con el rango completo de y de los datos.
#' @param margen Proporción del rango que se considera "zona de riesgo"
#'   cerca del borde (por defecto 0.15, es decir 15%).
#' @return Lista con \code{hjust} y \code{vjust}.
#' @export
calcular_alineacion_inteligente <- function(x_punto, y_punto, x_rango, y_rango, margen = 0.15) {

  rx <- range(x_rango, na.rm = TRUE)
  ry <- range(y_rango, na.rm = TRUE)

  span_x <- as.numeric(rx[2] - rx[1])
  span_y <- as.numeric(ry[2] - ry[1])

  x_rel <- if (span_x == 0) 0.5 else as.numeric(x_punto - rx[1]) / span_x
  y_rel <- if (span_y == 0) 0.5 else as.numeric(y_punto - ry[1]) / span_y

  hjust <- if (x_rel > 1 - margen) 1 else if (x_rel < margen) 0 else 0.5
  vjust <- if (y_rel > 1 - margen) 1 else if (y_rel < margen) 0 else 0.5

  list(hjust = hjust, vjust = vjust, x_rel = x_rel, y_rel = y_rel)
}

#' Etiqueta de punto final con alineación automática
#'
#' Reemplaza el patrón manual \code{geom_label(hjust = 1, vjust = 1, ...)}
#' que se rompe en cuanto el punto cae en otra zona del gráfico. Esta
#' función calcula la alineación óptima según la posición del punto y
#' agrega un pequeño "empuje" (nudge) en la misma dirección para separar
#' la etiqueta del punto sin que quede pegada o recortada por el borde
#' del panel.
#'
#' @param x_punto,y_punto Coordenadas del punto a etiquetar.
#' @param etiqueta Texto de la etiqueta (ya formateado, ej. con
#'   \code{scales::comma()}).
#' @param x_rango,y_rango Rango completo de datos (para calcular la
#'   posición relativa del punto).
#' @param color Color del texto y borde de la etiqueta.
#' @param size Tamaño de fuente (en mm, como en \code{geom_label}).
#' @param family Familia tipográfica.
#' @param fontface Estilo de fuente.
#' @param empuje Fracción del rango que se usa como separación entre el
#'   punto y la etiqueta (por defecto 3%).
#' @return Una capa \code{annotate("label", ...)} lista para sumarse a un
#'   objeto ggplot.
#' @export
etiqueta_final_inteligente <- function(x_punto, y_punto, etiqueta,
                                        x_rango, y_rango,
                                        color = "#123D4F", size = 5,
                                        family = getOption("cenaictemas.fuente", "sans"),
                                        fontface = "bold",
                                        empuje = 0.03) {

  alineacion <- calcular_alineacion_inteligente(x_punto, y_punto, x_rango, y_rango)

  span_x <- as.numeric(diff(range(x_rango, na.rm = TRUE)))
  span_y <- as.numeric(diff(range(y_rango, na.rm = TRUE)))

  # Empuja la etiqueta en dirección contraria a la que "creció" el hjust/vjust
  dx <- dplyr::case_when(
    alineacion$hjust == 1 ~ -empuje * span_x,
    alineacion$hjust == 0 ~  empuje * span_x,
    TRUE ~ 0
  )
  dy <- dplyr::case_when(
    alineacion$vjust == 1 ~ -empuje * span_y,
    alineacion$vjust == 0 ~  empuje * span_y,
    TRUE ~ empuje * span_y
  )

  ggplot2::annotate(
    "label",
    x = x_punto + dx, y = y_punto + dy,
    label = etiqueta,
    hjust = alineacion$hjust, vjust = alineacion$vjust,
    color = color, size = size, family = family, fontface = fontface,
    label.size = 0, fill = "white", alpha = 0.9
  )
}

#' Etiquetas múltiples sin traslape (varias series, categorías o facetas)
#'
#' Envoltura de \code{ggrepel::geom_label_repel()} preconfigurada con
#' parámetros pensados para gráficas de identidad corporativa: evita
#' cualquier traslape entre etiquetas (\code{max.overlaps = Inf}),
#' mantiene una línea guía sutil hacia el punto real, y usa una semilla
#' fija para que el resultado sea reproducible entre corridas.
#'
#' @param data Data frame con un renglón por etiqueta a colocar (ej. el
#'   último corte de cada categoría/estado).
#' @param mapping Un \code{aes()} con al menos x, y, label.
#' @param color_por Nombre de columna (string) a usar como color de texto,
#'   si se quiere que cada etiqueta tome el color de su serie. Si es NULL
#'   se usa \code{color_fijo}.
#' @param color_fijo Color único si no se usa \code{color_por}.
#' @param ... Argumentos adicionales pasados a \code{geom_label_repel()}.
#' @export
etiquetas_repel_inteligentes <- function(data, mapping,
                                          color_por = NULL,
                                          color_fijo = "#123D4F",
                                          size = 3.5,
                                          family = getOption("cenaictemas.fuente", "sans"),
                                          ...) {

  if (!requireNamespace("ggrepel", quietly = TRUE)) {
    stop("El paquete 'ggrepel' es necesario para etiquetas_repel_inteligentes(). Instálalo con install.packages('ggrepel').")
  }

  args <- list(
    data = data,
    mapping = mapping,
    size = size,
    family = family,
    fontface = "bold",
    max.overlaps = Inf,
    box.padding = 0.6,
    point.padding = 0.4,
    min.segment.length = 0,
    segment.color = "grey60",
    segment.size = 0.3,
    label.size = 0,
    seed = 42,
    ...
  )

  if (is.null(color_por)) {
    args$color <- color_fijo
  }

  do.call(ggrepel::geom_label_repel, args)
}
