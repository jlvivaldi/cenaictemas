###############################################################
# PROPORCIÓN FIJA 16:9
#
# Regla de identidad gráfica: toda gráfica debe verse en proporción
# 16:9 horizontal, sin importar el tamaño de la ventana de RStudio,
# el dispositivo donde se corra el script, o las dimensiones con las
# que se guarde el archivo final.
#
# ggplot2 permite fijar la proporción del PANEL (no de la ventana)
# con theme(aspect.ratio = alto/ancho). Al fijarla ahí, el panel
# siempre se dibuja 16:9 real, y por lo tanto los cálculos de
# colisión de etiquetas (calcular_alineacion_inteligente()) pueden
# asumir esa proporción con confianza, sin importar el entorno.
###############################################################

#' @export
PROPORCION_ANCHO <- 16

#' @export
PROPORCION_ALTO <- 9

#' Fuerza la proporción 16:9 en el panel de una gráfica
#'
#' Agrega \code{theme(aspect.ratio = alto/ancho)}, lo que hace que el
#' panel se dibuje siempre en proporción 16:9 horizontal sin importar
#' el tamaño de la ventana o el archivo de salida. Se aplica
#' automáticamente dentro de \code{finalizar_grafico()}, así que
#' normalmente no necesitas llamarla por separado.
#'
#' Nota para gráficas con \code{facet_wrap()}/\code{facet_grid()}:
#' \code{aspect.ratio} se aplica A CADA PANEL individual, no al
#' conjunto. Si tienes muchas facetas, forzar 16:9 en cada una puede
#' generar una cuadrícula demasiado ancha; en ese caso
#' \code{finalizar_grafico()} lo detecta y lo omite automáticamente
#' (puedes forzarlo de todas formas con \code{widescreen = TRUE}).
#'
#' @param ancho,alto Proporción deseada (por defecto 16:9).
#' @export
proporcion_16_9 <- function(ancho = PROPORCION_ANCHO, alto = PROPORCION_ALTO) {
  ggplot2::theme(aspect.ratio = alto / ancho)
}

#' Guarda una gráfica respetando la proporción 16:9
#'
#' Envoltura de \code{ggplot2::ggsave()} con dimensiones ya calculadas
#' en proporción 16:9, para que el archivo final (PNG, PDF, etc.)
#' siempre salga con las mismas proporciones sin tener que recordar
#' width/height cada vez.
#'
#' @param plot Objeto ggplot a guardar.
#' @param ruta Ruta/archivo de salida (ej. "grafica.png").
#' @param escala Multiplicador del tamaño base (16 x 9 pulgadas).
#'   Usa valores menores a 1 para archivos más pequeños de igual
#'   proporción (ej. 0.75 -> 12 x 6.75 in).
#' @param dpi Resolución en puntos por pulgada.
#' @param ... Argumentos adicionales pasados a \code{ggsave()}.
#' @export
guardar_grafico_16_9 <- function(plot, ruta, escala = 1, dpi = 300, ...) {
  ggplot2::ggsave(
    filename = ruta,
    plot = plot,
    width = PROPORCION_ANCHO * escala,
    height = PROPORCION_ALTO * escala,
    units = "in",
    dpi = dpi,
    ...
  )
}
