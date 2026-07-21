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

# 4. Aplicar tema + eje de fecha inteligente en un solo paso
p <- finalizar_grafico(p, fechas = datos$fecha)

p
```

## Funciones clave

| Función | Qué resuelve |
|---|---|
| `theme_corporate()` | Tema visual base (colores, tipografía, cuadrícula) |
| `scale_fill_corporate()` / `scale_color_corporate()` | Paleta discreta corporativa |
| `scale_fill_gradient_corporate()` | Paleta continua (mapas de calor) |
| `etiqueta_final_inteligente()` | Coloca la etiqueta del último punto sin que se corte, sin importar en qué zona del gráfico caiga |
| `etiquetas_repel_inteligentes()` | Etiquetas de múltiples series/categorías sin traslape (usa ggrepel) |
| `escala_fecha_inteligente()` | Cortes de fecha automáticos según el rango de datos |
| `tema_eje_x_inteligente()` | Rotación del eje X automática según cuántas marcas de fecha van a aparecer |
| `finalizar_grafico()` | Aplica todo lo anterior en una sola línea |
| `cargar_fuentes_corporativas()` | Tipografía portable vía Google Fonts (no depende del equipo) |

## Por qué esto y no copiar `Tema.R` a cada proyecto

- **Versionado**: si cambias un color, tus proyectos viejos no se rompen a
  menos que actualices el paquete.
- **Portabilidad real**: se instala igual en tu laptop, en un equipo
  prestado o en un servidor — no depende de rutas locales ni de fuentes
  preinstaladas del sistema operativo.
- **Documentación**: `?theme_corporate`, `?etiqueta_final_inteligente`,
  etc., como cualquier función de un paquete de R.
