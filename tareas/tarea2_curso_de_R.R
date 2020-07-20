
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
library(tidyverse)
#'
#' Utilice la libería datos, y de ella la tabla salarios
#' 
library(datos)
#' 
#' ## Preguntas:
#' #### 1. ¿Cuál fue el salario máximo en el año 2000?
#' 
salarios %>% glimpse() # La función glimpse sirve para observar cualquier objeto

salarios %>% 
  filter(anio == 2000) %>% 
  filter(salario == max(salario))

#' #### 1.1 ¿Cuál es el salario mínimo de todos los años múltiplos de 5?
#'
salarios %>% 
  filter(anio %in% seq(1985,2015, by = 5)) %>% 
  filter(salario == min(salario))
#' Otra lectura del mismo problema
salarios %>% 
  filter(anio %in% seq(1985,2015, by = 5)) %>% 
  group_by(anio) %>% 
  summarise(salario = min(salario))
#'
#' #### 2. Crear variable salario en millones de pesos
#' 
salarios %>% 
  mutate(salario_clp_mm = salario*750/1e6) %>% 
  glimpse()
#' Definimos la tabla salarios con una nueva variable, que es salario en millones de pesos
salarios_2 <- salarios %>% 
  mutate(salario_clp_mm = salario*750/1e6) 
#'
salarios_2 %>% glimpse()
#'
#' #### 2. Guarde el resultado en excel 
#'
# writexl::write_xlsx(salarios_2, "tareas/salarios_2.xlsx") 
#'
#' #### 3. Resumir total salario en millones de pesos entre los año 1985 y 1995
#' 
salarios_2 %>% 
  filter(anio %in% seq(1985, 1995, by = 1)) %>% 
  group_by(anio) %>% 
  summarise(suma_salario_clp_mm = sum(salario_clp_mm))

salarios_2 %>% 
  filter(anio %in% 1985:1995) %>% 
  group_by(anio) %>% 
  summarise(suma_salario_clp_mm = sum(salario_clp_mm))

salarios_2 %>% 
  group_by(anio) %>% 
  summarise(suma_salario_clp_mm = sum(salario_clp_mm)) %>% 
  ungroup() %>% 
  filter(anio %in% 1985:1995) 
#' guardamos objeto
resumen_salario_3 <- salarios_2 %>% 
  filter(anio %in% 1985:1995) %>% 
  group_by(anio) %>% 
  summarise(suma_salario_clp_mm = sum(salario_clp_mm))
#'
#' #### 4. Graficar pregunta 3
#' 
#' grafico de lineas
resumen_salario_3 %>% 
  ggplot(aes(anio, suma_salario_clp_mm)) + 
  geom_line()
#' grafico de columnas
resumen_salario_3 %>% 
  ggplot(aes(anio, suma_salario_clp_mm)) + 
  geom_col()
#' grafico de area
resumen_salario_3 %>% 
  ggplot(aes(anio, suma_salario_clp_mm)) + 
  geom_area()
#' grafico de lineas + aproximación de la curva
resumen_salario_3 %>% 
  ggplot(aes(anio, suma_salario_clp_mm)) + 
  geom_point() +
  geom_smooth()
#'
#' ## Juntando dos tablas
#' Para juntar dos tablas, se ocupa la función join. Ejemplo:
#'
#' Creemos la Table A:
# Definimos la tabla con dos variables y dos registros (tibble es un objeto de tipo tabla)
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
#' 
salarios %>% 
  group_by(anio) %>% 
  summarise(total = sum(salario)/1e6)
#'
resumen_p5 <- salarios %>% 
  group_by(anio) %>% 
  summarise(total = sum(salario)/1e6) %>% 
  ungroup()
#'
#' #### 6. Crear una tabla resumen de cantidad de jugadores distintos por año
#' 
salarios %>% 
  group_by(anio) %>% 
  summarise(n = n_distinct(id_jugador)) %>% 
  ungroup()
#'
resumen_p6 <- salarios %>% 
  group_by(anio) %>% 
  summarise(n = n_distinct(id_jugador)) %>% 
  ungroup()

#'   
#' #### 7. Juntar tabla del ejercicio 5 con ejercicio 6.
#' 
resumen_p5 %>% 
  left_join(resumen_p6)

resumen_p5 %>% 
  left_join(resumen_p6, by = "anio")
#' 
#' #### 8. Se puede hacer tabla de pregunta 7 de otra forma?
#'
salarios %>% 
  group_by(anio) %>% 
  summarise(
    total = sum(salario)/1e6,
    n = n_distinct(id_jugador))
#' 