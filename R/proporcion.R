###############################################################
# PROPORCIÓN FIJA 18:9 (2:1)
#
# Regla de identidad gráfica: toda gráfica debe verse en proporción
# 18:9 horizontal, sin importar el tamaño de la ventana de RStudio,
# el dispositivo donde se corra el script, o las dimensiones con las
# que se guarde el archivo final.
#
# Nota: 18:9 equivale a una proporción de 2:1 (el doble de ancho que
# de alto) -- es más ancha que el 16:9 "de pantalla" (que es 1.778:1).
#
# ggplot2 permite fijar la proporción del PANEL (no de la ventana)
# con theme(aspect.ratio = alto/ancho). Al fijarla ahí, el panel
# siempre se dibuja 18:9 real, y por lo tanto los cálculos de
# colisión de etiquetas (calcular_alineacion_inteligente()) pueden
# asumir esa proporción con confianza, sin importar el entorno.
###############################################################

#' @export
PROPORCION_ANCHO <- 18

#' @export
PROPORCION_ALTO <- 9

#' Fuerza la proporción 18:9 en el panel de una gráfica
#'
#' Agrega \code{theme(aspect.ratio = alto/ancho)}, lo que hace que el
#' panel se dibuje siempre en proporción 18:9 (2:1) horizontal sin
#' importar el tamaño de la ventana o el archivo de salida. Se aplica
#' automáticamente dentro de \code{finalizar_grafico()}, así que
#' normalmente no necesitas llamarla por separado.
#'
#' Nota para gráficas con \code{facet_wrap()}/\code{facet_grid()}:
#' \code{aspect.ratio} se aplica A CADA PANEL individual, no al
#' conjunto. Si tienes muchas facetas, forzar 18:9 en cada una puede
#' generar una cuadrícula demasiado ancha; en ese caso
#' \code{finalizar_grafico()} lo detecta y lo omite automáticamente
#' (puedes forzarlo de todas formas con \code{widescreen = TRUE}).
#'
#' @param ancho,alto Proporción deseada (por defecto 18:9).
#' @export
proporcion_18_9 <- function(ancho = PROPORCION_ANCHO, alto = PROPORCION_ALTO) {
  ggplot2::theme(aspect.ratio = alto / ancho)
}

#' Guarda una gráfica respetando la proporción 18:9
#'
#' Envoltura de \code{ggplot2::ggsave()} que SIEMPRE calcula dimensiones
#' en proporción 18:9 exacta (18/9 = 2.0), para evitar el error común
#' de fijar \code{width} y \code{height} "a mano" y que terminen en
#' otra proporción sin darse cuenta.
#'
#' Puedes fijar SOLO una dimensión (ancho o alto) y la función calcula
#' la otra automáticamente para garantizar 18:9 exacto. Si tratas de
#' fijar ambas y no cuadran con 18:9, la función se detiene con un
#' error explicando la proporción real que estabas a punto de generar,
#' en vez de guardar un archivo con la proporción equivocada en
#' silencio.
#'
#' @param plot Objeto ggplot a guardar.
#' @param ruta Ruta/archivo de salida (ej. "grafica.png").
#' @param ancho Ancho en pulgadas. Si se omite, se calcula a partir de
#'   \code{alto} (o del tamaño base 18 x 9 si tampoco se da \code{alto}).
#' @param alto Alto en pulgadas. Si se omite, se calcula a partir de
#'   \code{ancho}.
#' @param escala Multiplicador del tamaño base (18 x 9 pulgadas), usado
#'   solo si no se fija ni \code{ancho} ni \code{alto}. Valores menores
#'   a 1 dan archivos más pequeños de igual proporción (ej. 0.75 ->
#'   13.5 x 6.75 in).
#' @param dpi Resolución en puntos por pulgada.
#' @param ... Argumentos adicionales pasados a \code{ggsave()}.
#' @export
guardar_grafico_18_9 <- function(plot, ruta, ancho = NULL, alto = NULL,
                                  escala = 1, dpi = 300, ...) {

  proporcion <- PROPORCION_ANCHO / PROPORCION_ALTO  # 18/9 = 2.0

  if (!is.null(ancho) && !is.null(alto)) {
    # El usuario fijó ambas dimensiones: verificamos que sí sea 18:9
    proporcion_dada <- ancho / alto
    if (abs(proporcion_dada - proporcion) > 0.01) {
      stop(
        "Las dimensiones ancho = ", ancho, " y alto = ", alto,
        " NO son 18:9 (dan una proporción de ", round(proporcion_dada, 3),
        ":1). 18:9 real es ", round(proporcion, 3), ":1.\n",
        "Fija solo una de las dos (ancho o alto) y deja que la otra se ",
        "calcule automáticamente, por ejemplo:\n",
        "  guardar_grafico_18_9(p, ruta, ancho = ", ancho, ")  # alto se calcula solo\n",
        "  guardar_grafico_18_9(p, ruta, alto = ", alto, ")   # ancho se calcula solo"
      )
    }
  } else if (!is.null(ancho)) {
    alto <- ancho / proporcion
  } else if (!is.null(alto)) {
    ancho <- alto * proporcion
  } else {
    ancho <- PROPORCION_ANCHO * escala
    alto  <- PROPORCION_ALTO * escala
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
