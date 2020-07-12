
#' --- 
#' title: Tarea 02
#' author: Prof. Héctor González
#' output:
#'   html_document:
#'     theme: yeti
#'     toc: true
#'     toc_float: true
#' ---
#+ echo = FALSE, message = FALSE, warning = FALSE
#' 
#' ## Observaciones:
#' Inlcuir la libería tidyverse
#' 
#' Utilice la libería datos, y de ella la tabla salarios
#' 
#' ## Preguntas:
#' #### 1. ¿Cuál fue el salario máximo en el año 2000?
#' #### 1.1 ¿Cuál es el salario mínimo de todos los años múltiplos de 5?
#' #### 2. Crear variable salario en millones de pesos
#' #### 3. Resumir total salario en millones de pesos entre los año 1985 y 1995
#' #### 4. Graficar pregunta 3
#' 
#' ## Juntando dos tablas
#' Para juntar dos tablas, se ocupa la función join. Ejemplo:
#'
#' Creemos la Table A:
# Definimos la tabla con dos variables y dos registros
library(tidyverse)
A <- tibble(
  id = c(1,2),
  name = c("uno", "dos")
) 
# para observar la tabla
A
# otra manera de observar la tabla
A %>%  glimpse()
#' Creamos tabla B
B <- tibble(
  id = c(1,2),
  name_romano = c("I", "II")
)
# Veamos la tabla
B
#' Juntemos A con B
A %>% 
  left_join(B, by = "id")

#' ## Volviendo a las preguntas
#' 
#' #### 5. Crear una tabla resumen de salarios promedios por año
#' #### 6. Crear una tabla resumen de cantidad de jugadores distintos por año
#' #### 7. Juntar tabla del ejercicio 5 con ejercicio 6.
#' #### 8. Se puede hacer tabla de pregunta 7 de otra forma?