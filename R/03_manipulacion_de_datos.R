# Para manipular necesitamos la libreria tidyverse
source("R/01_librerias.R")

# Para instalar tablas de prueba en español ejecutar 
# remotes::install_github("cienciadedatos/datos") en la consola

library(datos)

# Escribir un excel
salarios %>% 
  write_xlsx("data/salarios.xlsx")

# Leer un excel

read_xlsx("data/salarios.xlsx")


# Libreria  Dplyr ---------------------------------------------------------

# Dplyr está dentro de Tidyverse
#Funciones principales de Dplyr son:


# Filtrar: filter() -----------------------------------------------------



#observar registros de una tabla

glimpse(salarios)

filter(salarios, anio > 1985)

filter(salarios, id_equipo == "NYN") # El == es para comparar

# Juntemos estos dos filtros

# opcion 1
filter(salarios, anio > 1985)
filter(filter(salarios, anio > 1985), id_equipo == "NYN")

#opcion 2
salarios_1985 <- filter(salarios, anio > 1985)
filter(salarios_1985, id_equipo == "NYN")

#opcion 3

filter(salarios_1985, anio > 1985  & id_equipo == "NYN") # EL "y" lógico es "&"

## En R se inventaros los tubos (pipes) que son conectores de verbos

salarios %>% # shift + ctrl + m = %>%  
  filter(anio > 1985 & id_equipo == "NYN") %>% 
  filter(salario > 50000)

# EL complemento de un filtro (o la negación)

salarios %>% 
  filter(!anio > 1985) # SImplemente poner el signo de exclamación antes

# esto es lo mismo que 

salarios %>% 
  filter(anio <= 1985)












# Crear una variable: mutate() ----------------------------------------------

salarios %>% glimpse()

salarios %>% 
  mutate(salario_mensual = salario / 12) 

salarios %>% 
  mutate(salario_mensual = salario / 12,
         salario_mensual_clp = salario_mensual * 780) %>% 
  glimpse()

salarios %>% 
  mutate(salario_mensual = salario / 12,
         salario_mensual_clp = salario_mensual * 780) %>% 
  filter(salario_mensual_clp == max(salario_mensual_clp))


# Seleccionar : select() --------------------------------------------------

#seleccionar las variables con las que deseo trabajar
salarios %>% 
  select(id_jugador, salario) 

# sacar una variables
salarios %>% 
  select(-id_liga)
  
# Mezclando funciones

salarios %>% 
  mutate(salario_mensual = salario / 12,
         salario_mensual_clp = salario_mensual * 780) %>% 
  filter(salario_mensual_clp == max(salario_mensual_clp)) %>% 
  select(id_jugador, salario_mensual_clp)


# Resumir: summarise() ----------------------------------------------------

salarios %>% 
  group_by(anio) %>% # Agrupar
  summarise(salario = sum(salario)/1e6) %>% # Resumir
  arrange(desc(salario)) # ordenar de mayor a menor

salarios %>% 
  group_by(anio) %>% # Agrupar
  summarise(salario = sum(salario)/1e6) %>% # Resumir
  arrange(-desc(salario)) # ordenar de menor a mayor


# Ejercicios --------------------------------------------------------------

# Quièn gano más dienro en el 2016?

salarios %>% 
  filter(anio == 2016) %>% 
  filter(salario == max(salario))












