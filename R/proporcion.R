###############################################################
# PROPORCIÓN FIJA 18:9 (2:1) - HORIZONTAL Y VERTICAL
#
# Regla de identidad gráfica: toda gráfica debe verse en proporción
# 18:9 (2:1), en una de dos orientaciones estándar:
#   - "horizontal" (por defecto): 18 x 9 in, apaisada.
#   - "vertical": 9 x 18 in, en retrato (para redes sociales,
#     infografías verticales, etc.).
# Ambas se exportan a 150 dpi por defecto.
#
# ggplot2 permite fijar la proporción del PANEL (no de la ventana)
# con theme(aspect.ratio = alto/ancho). Al fijarla ahí, el panel
# siempre se dibuja en la proporción correcta real, sin importar el
# tamaño de la ventana de RStudio o el dispositivo donde se corra el
# script, y por lo tanto los cálculos de colisión de etiquetas
# (calcular_alineacion_inteligente()) pueden asumir esa proporción
# con confianza.
###############################################################

#' @export
PROPORCION_ANCHO <- 18

#' @export
PROPORCION_ALTO <- 9

#' @export
DPI_ESTANDAR <- 150

#' Dimensiones base (en pulgadas) según la orientación
#'
#' Función interna de apoyo: devuelve \code{list(ancho, alto)} para la
#' orientación pedida, usando siempre las mismas dos medidas (18 y 9),
#' solo intercambiadas según se quiera horizontal o vertical.
#'
#' @param orientacion \code{"horizontal"} (18 x 9, por defecto) o
#'   \code{"vertical"} (9 x 18).
#' @export
dimensiones_estandar <- function(orientacion = c("horizontal", "vertical")) {
  orientacion <- match.arg(orientacion)
  if (orientacion == "horizontal") {
    list(ancho = PROPORCION_ANCHO, alto = PROPORCION_ALTO)
  } else {
    list(ancho = PROPORCION_ALTO, alto = PROPORCION_ANCHO)
  }
}

#' Fuerza la proporción 18:9 (u 9:18) en el panel de una gráfica
#'
#' Agrega \code{theme(aspect.ratio = alto/ancho)}, lo que hace que el
#' panel se dibuje siempre en la proporción correcta sin importar el
#' tamaño de la ventana o el archivo de salida. Se aplica
#' automáticamente dentro de \code{finalizar_grafico()}, así que
#' normalmente no necesitas llamarla por separado.
#'
#' Nota para gráficas con \code{facet_wrap()}/\code{facet_grid()}:
#' \code{aspect.ratio} se aplica A CADA PANEL individual, no al
#' conjunto. Si tienes muchas facetas, forzar la proporción en cada
#' una puede generar una cuadrícula demasiado ancha/alta; en ese caso
#' \code{finalizar_grafico()} lo detecta y lo omite automáticamente
#' (puedes forzarlo de todas formas con \code{widescreen = TRUE}).
#'
#' @param orientacion \code{"horizontal"} (18:9, por defecto) o
#'   \code{"vertical"} (9:18).
#' @export
proporcion_18_9 <- function(orientacion = c("horizontal", "vertical")) {
  orientacion <- match.arg(orientacion)
  dim <- dimensiones_estandar(orientacion)
  ggplot2::theme(aspect.ratio = dim$alto / dim$ancho)
}

#' Proporción ancho:alto para usar en cálculos de colisión de etiquetas
#'
#' Devuelve el valor que hay que pasarle a \code{proporcion} en
#' \code{calcular_alineacion_inteligente()} / \code{etiqueta_final_inteligente()}
#' para que el reparto de márgenes coincida con la orientación real del
#' panel. Úsala siempre que generes una gráfica en orientación
#' \code{"vertical"}, para que el margen de colisión se calcule
#' correctamente (si no, por defecto se asume horizontal).
#'
#' @param orientacion \code{"horizontal"} (por defecto) o \code{"vertical"}.
#' @export
proporcion_para_orientacion <- function(orientacion = c("horizontal", "vertical")) {
  orientacion <- match.arg(orientacion)
  dim <- dimensiones_estandar(orientacion)
  dim$ancho / dim$alto
}

#' Guarda una gráfica respetando la proporción 18:9 (horizontal o vertical)
#'
#' Envoltura de \code{ggplot2::ggsave()} que SIEMPRE calcula dimensiones
#' en proporción 18:9 exacta (2:1, en la orientación pedida), para
#' evitar el error común de fijar \code{width} y \code{height} "a mano"
#' y que terminen en otra proporción sin darse cuenta. Exporta a
#' \code{dpi = 150} por defecto.
#'
#' Puedes fijar SOLO una dimensión (ancho o alto) y la función calcula
#' la otra automáticamente para garantizar la proporción exacta. Si
#' tratas de fijar ambas y no cuadran, la función se detiene con un
#' error explicando la proporción real que estabas a punto de generar,
#' en vez de guardar un archivo con la proporción equivocada en
#' silencio.
#'
#' @param plot Objeto ggplot a guardar.
#' @param ruta Ruta/archivo de salida (ej. "grafica.png").
#' @param orientacion \code{"horizontal"} (18 x 9, por defecto) o
#'   \code{"vertical"} (9 x 18).
#' @param ancho Ancho en pulgadas. Si se omite, se calcula a partir de
#'   \code{alto} (o del tamaño base de la orientación si tampoco se da
#'   \code{alto}).
#' @param alto Alto en pulgadas. Si se omite, se calcula a partir de
#'   \code{ancho}.
#' @param escala Multiplicador del tamaño base, usado solo si no se fija
#'   ni \code{ancho} ni \code{alto} (ej. 0.75 -> 13.5 x 6.75 in en
#'   horizontal).
#' @param dpi Resolución en puntos por pulgada (por defecto 150).
#' @param ... Argumentos adicionales pasados a \code{ggsave()}.
#' @export
guardar_grafico_18_9 <- function(plot, ruta,
                                  orientacion = c("horizontal", "vertical"),
                                  ancho = NULL, alto = NULL,
                                  escala = 1, dpi = DPI_ESTANDAR, ...) {

  orientacion <- match.arg(orientacion)
  dim_base <- dimensiones_estandar(orientacion)
  proporcion <- dim_base$ancho / dim_base$alto

  if (!is.null(ancho) && !is.null(alto)) {
    proporcion_dada <- ancho / alto
    if (abs(proporcion_dada - proporcion) > 0.01) {
      stop(
        "Las dimensiones ancho = ", ancho, " y alto = ", alto,
        " NO corresponden a la orientación '", orientacion, "' (dan una ",
        "proporción de ", round(proporcion_dada, 3), ":1; se esperaba ",
        round(proporcion, 3), ":1).\n",
        "Fija solo una de las dos (ancho o alto) y deja que la otra se ",
        "calcule automáticamente, por ejemplo:\n",
        "  guardar_grafico_18_9(p, ruta, orientacion = '", orientacion,
        "', ancho = ", ancho, ")  # alto se calcula solo\n",
        "  guardar_grafico_18_9(p, ruta, orientacion = '", orientacion,
        "', alto = ", alto, ")   # ancho se calcula solo"
      )
    }
  } else if (!is.null(ancho)) {
    alto <- ancho / proporcion
  } else if (!is.null(alto)) {
    ancho <- alto * proporcion
  } else {
    ancho <- dim_base$ancho * escala
    alto  <- dim_base$alto * escala
  }

  ggplot2::ggsave(
    filename = ruta,
    plot = plot,
    width = ancho,
    height = alto,
    units = "in",
    dpi = dpi,
    ...
  )
}
