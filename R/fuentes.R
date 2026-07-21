###############################################################
# TIPOGRAFÍA PORTABLE
#
# Problema que resuelve: "Source Sans Pro" instalada localmente en tu
# equipo NO viaja contigo a otra máquina. Si la fuente no existe en el
# nuevo equipo, R/Windows puede omitir TODO el texto de la gráfica sin
# marcar error. La solución es dejar de depender de fuentes del sistema
# operativo y cargarla vía Google Fonts en cada sesión con sysfonts +
# showtext. La primera vez se descarga; luego queda en caché.
###############################################################

#' Carga la tipografía corporativa de forma portable
#'
#' Descarga (o toma de caché) la fuente vía Google Fonts usando
#' \code{sysfonts::font_add_google()} y activa \code{showtext} para que
#' se use automáticamente en todos los dispositivos gráficos de la
#' sesión. Si falla (sin internet, por ejemplo), hace fallback silencioso
#' a "sans" para que las gráficas nunca se queden sin texto.
#'
#' @param fuente Nombre de la fuente en Google Fonts. Por defecto
#'   "Source Sans 3" (la variante activa de "Source Sans Pro").
#' @param alias Nombre con el que se referenciará la fuente en
#'   \code{theme_corporate()} y demás funciones de este paquete.
#' @return De forma invisible, TRUE si la fuente cargó correctamente,
#'   FALSE si se usó el fallback.
#' @export
cargar_fuentes_corporativas <- function(fuente = "Source Sans 3", alias = "Source Sans Pro") {

  exito <- tryCatch({
    sysfonts::font_add_google(fuente, alias)
    showtext::showtext_auto()
    options(cenaictemas.fuente = alias)
    TRUE
  }, error = function(e) {
    message("No se pudo cargar '", fuente, "' desde Google Fonts (¿sin internet?). ",
            "Se usará la fuente 'sans' para que las gráficas no se queden sin texto.")
    options(cenaictemas.fuente = "sans")
    FALSE
  })

  invisible(exito)
}
