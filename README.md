# cenaictemas

Sistema de identidad gráfica corporativa para ggplot2, portable entre
cualquier equipo de cómputo: paleta de colores, tema visual, y
funciones de **posicionamiento inteligente** de etiquetas y ejes que
evitan textos truncados, empalmados o fuera de lugar.

## Instalación

En cualquier equipo con R (aunque sea prestado):

```r
install.packages("remotes")
remotes::install_github("tu_usuario/cenaictemas")
```

Si aún no lo subes a GitHub, también se puede instalar directo desde
una carpeta local:

```r
remotes::install_local("ruta/a/cenaictemas")
```

## Uso básico

```r
library(cenaictemas)
library(ggplot2)

# 1. (Opcional pero recomendado) Cargar tipografía de forma portable
cargar_fuentes_corporativas()

# 2. Construir la gráfica normalmente
p <- ggplot(datos, aes(x = fecha, y = valor)) +
  geom_line(color = corporate_colors[["navy700"]], linewidth = 1.5) +
  labs(title = "Título", subtitle = "Subtítulo", caption = "Fuente: ...",
       x = "Fecha", y = "Valor")

# 3. Etiqueta del punto final SIN calcular hjust/vjust a mano
p <- p + etiqueta_final_inteligente(
  x_punto = max(datos$fecha), y_punto = tail(datos$valor, 1),
  etiqueta = scales::comma(tail(datos$valor, 1)),
  x_rango = datos$fecha, y_rango = datos$valor,
  color = corporate_colors[["navy700"]]
)

# 4. Aplicar tema + eje de fecha inteligente + proporción en un solo paso
p <- finalizar_grafico(p, fechas = datos$fecha, orientacion = "horizontal")

p

# 5. Guardar respetando la proporción y dpi estándar (150)
guardar_grafico_18_9(p, "grafica.png", orientacion = "horizontal")
```

## Funciones clave

| Función | Qué resuelve |
|---|---|
| `theme_corporate()` | Tema visual base (colores, tipografía, cuadrícula) — tamaños de fuente calibrados para el lienzo 18x9/9x18 a 150 dpi |
| `scale_fill_corporate()` / `scale_color_corporate()` | Paleta discreta corporativa |
| `scale_fill_gradient_corporate()` | Paleta continua (mapas de calor) |
| `proporcion_18_9(orientacion)` | Fuerza el panel a proporción 18:9 (o 9:18) real, sin importar el tamaño de ventana/archivo |
| `guardar_grafico_18_9(p, ruta, orientacion)` | `ggsave()` con dimensiones y dpi=150 ya calculados, en horizontal o vertical |
| `dimensiones_estandar(orientacion)` | Devuelve `list(ancho, alto)` en pulgadas para la orientación pedida |
| `proporcion_para_orientacion(orientacion)` | Proporción ancho:alto a pasarle a las funciones de etiquetado inteligente cuando la gráfica es vertical |
| `etiqueta_final_inteligente()` | Coloca la etiqueta del último punto sin que se corte, ajustando el margen de forma asimétrica entre X/Y según la proporción real del panel |
| `etiquetas_repel_inteligentes()` | Etiquetas de múltiples series/categorías sin traslape (usa ggrepel) |
| `escala_fecha_inteligente()` | Cortes de fecha automáticos según el rango de datos |
| `tema_eje_x_inteligente()` | Rotación del eje X automática según cuántas marcas de fecha van a aparecer |
| `finalizar_grafico(p, ..., orientacion)` | Aplica todo lo anterior en una sola línea, incluyendo forzar la proporción correcta |
| `cargar_fuentes_corporativas()` | Tipografía portable vía Google Fonts (no depende del equipo) |

## Dos orientaciones estándar: horizontal y vertical

Toda gráfica se exporta en una de dos formas, ambas a **dpi = 150**:

| Orientación | Dimensiones | Uso típico |
|---|---|---|
| `"horizontal"` (por defecto) | 18 x 9 in | Reportes, presentaciones, tableros |
| `"vertical"` | 9 x 18 in | Infografías verticales, redes sociales |

```r
# Horizontal (por defecto)
p <- finalizar_grafico(p, fechas = datos$fecha)
guardar_grafico_18_9(p, "grafica_horizontal.png")

# Vertical
p <- finalizar_grafico(p, fechas = datos$fecha, orientacion = "vertical")
guardar_grafico_18_9(p, "grafica_vertical.png", orientacion = "vertical")
```

**Importante:** si usas `etiqueta_final_inteligente()` en una gráfica
vertical, pásale también la proporción correcta para que el reparto de
márgenes de colisión sea el correcto:

```r
etiqueta_final_inteligente(
  x_punto = ..., y_punto = ..., etiqueta = ...,
  x_rango = ..., y_rango = ...,
  proporcion = proporcion_para_orientacion("vertical")
)
```

## Sobre la proporción 18:9

Esto se logra fijando la proporción del **panel** (no de la ventana) con
`theme(aspect.ratio = alto/ancho)`, lo que garantiza esa forma sin
importar dónde se ejecute o guarde la gráfica. `finalizar_grafico()` lo
aplica automáticamente, **excepto** en gráficas con
`facet_wrap()`/`facet_grid()` (ahí `aspect.ratio` afectaría cada panel
individual, no el conjunto) — en ese caso lo puedes forzar explícitamente
con `finalizar_grafico(p, widescreen = TRUE)` si de todas formas lo
quieres.

Como el panel siempre tiene una proporción real conocida,
`etiqueta_final_inteligente()` puede repartir su margen de "zona de
riesgo" de forma asimétrica entre X e Y en vez de tratar ambos ejes por
igual, como si el panel fuera cuadrado.

## Por qué esto y no copiar `Tema.R` a cada proyecto

- **Versionado**: si cambias un color, tus proyectos viejos no se rompen a
  menos que actualices el paquete.
- **Portabilidad real**: se instala igual en tu laptop, en un equipo
  prestado o en un servidor — no depende de rutas locales ni de fuentes
  preinstaladas del sistema operativo.
- **Documentación**: `?theme_corporate`, `?etiqueta_final_inteligente`,
  etc., como cualquier función de un paquete de R.
