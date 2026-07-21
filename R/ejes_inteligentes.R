###############################################################
# EJES INTELIGENTES
#
# Objetivo: que el eje de fechas nunca quede empalmado (texto
# encimado) ni truncado (última fecha o etiqueta cortada por el
# borde), sin importar si la serie dura 2 semanas o 2 años.
###############################################################

#' Escala de fecha con cortes automáticos según el rango de datos
#'
#' Elige el intervalo de \code{date_breaks} según cuántos días abarcan
#' los datos, y agrega una expansión extra a la derecha para que la
#' etiqueta del punto final (ver \code{etiqueta_final_inteligente()})
#' tenga espacio y no quede cortada por el borde del panel.
#'
#' @param fechas Vector de fechas (clase Date) de los datos graficados.
#' @param expandir_derecha Espacio extra a la derecha, como fracción del
#'   rango total (por defecto 8%, suficiente para una etiqueta de punto
#'   final).
#' @param formato Formato de las etiquetas de fecha (por defecto "%d-%b").
#' @export
escala_fecha_inteligente <- function(fechas, expandir_derecha = 0.08, formato = "%d-%b") {

  span_dias <- as.numeric(diff(range(fechas, na.rm = TRUE)))

  cortes <- dplyr::case_when(
    span_dias <= 21  ~ "2 days",
    span_dias <= 45  ~ "1 week",
    span_dias <= 120 ~ "2 weeks",
    span_dias <= 240 ~ "1 month",
    span_dias <= 600 ~ "2 months",
    TRUE             ~ "3 months"
  )

  ggplot2::scale_x_date(
    date_breaks = cortes,
    date_labels = formato,
    expand = ggplot2::expansion(mult = c(0.015, expandir_derecha))
  )
}

#' Tema de eje X con rotación automática según densidad de etiquetas
#'
#' Estima cuántas marcas de fecha van a aparecer en el eje y ajusta el
#' ángulo del texto para que nunca queden encimadas: pocas marcas se
#' quedan horizontales, una cantidad media se inclina 45°, y muchas se
#' rotan 90° (con la alineación correcta en cada caso para que el texto
#' no quede "atravesando" la gráfica).
#'
#' @param fechas Vector de fechas de los datos graficados.
#' @export
tema_eje_x_inteligente <- function(fechas) {

  span_dias <- as.numeric(diff(range(fechas, na.rm = TRUE)))
  # Estimado de marcas visibles según los mismos cortes de escala_fecha_inteligente()
  cortes_dias <- dplyr::case_when(
    span_dias <= 21  ~ 2,
    span_dias <= 45  ~ 7,
    span_dias <= 120 ~ 14,
    span_dias <= 240 ~ 30,
    span_dias <= 600 ~ 60,
    TRUE             ~ 90
  )
  n_marcas_estimadas <- span_dias / cortes_dias

  if (n_marcas_estimadas > 10) {
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1, vjust = 0.5))
  } else if (n_marcas_estimadas > 5) {
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, vjust = 1))
  } else {
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 0, hjust = 0.5, vjust = 1))
  }
}

#' Finaliza una gráfica aplicando tema, ejes y márgenes de forma automática
#'
#' Punto de entrada recomendado: en vez de armar \code{theme_corporate()} +
#' escalas + márgenes a mano en cada gráfica (y arriesgarte a que la
#' combinación truncie textos), esta función arma todo junto y de forma
#' consistente.
#'
#' @param p Objeto ggplot ya construido (geoms, labs, etc.).
#' @param fechas Vector de fechas de los datos, si el eje X es de fecha.
#'   Si se provee, se agrega \code{escala_fecha_inteligente()} y
#'   \code{tema_eje_x_inteligente()} automáticamente.
#' @param expandir_derecha Ver \code{escala_fecha_inteligente()}.
#' @export
finalizar_grafico <- function(p, fechas = NULL, expandir_derecha = 0.08) {

  p <- p + theme_corporate()

  if (!is.null(fechas)) {
    p <- p +
      escala_fecha_inteligente(fechas, expandir_derecha = expandir_derecha) +
      tema_eje_x_inteligente(fechas)
  }

  p
}
