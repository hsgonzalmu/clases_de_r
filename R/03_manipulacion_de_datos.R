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
