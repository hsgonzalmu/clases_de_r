
# Cargar Librerias --------------------------------------------------------
library(tidyverse) # Conjunto de librerias para manipular datos
library(lubridate) # Para manipular fechas
library(readxl) # Lectura de xlsx

data_swap_clp <- read_excel("data/Datos R  05.08.2020.xlsx", sheet = 2)
# inspeccionar 

data_swap_clp %>% glimpse()

data_swap_clp %>% 
  select(1:13) %>% 
  glimpse()

data_swap_clp_1 <- data_swap_clp %>% 
  select(1:13)

data_swap_clp_1 %>% glimpse()

data_swap_clp_1 %>% 
  mutate( #Actualizamos variables que ya existian
    Effective = mdy(Effective),
    Maturity = mdy(Maturity),
    `Trade Time` = mdy(str_sub(`Trade Time`, 1, 10))
  ) %>% 
  mutate( # Crear nuevas variables
    plazo = as.numeric(round((Maturity - Effective)/365, digits = 2))
  ) %>% 
  glimpse()


data_swap_clp_2 <- data_swap_clp_1 %>% 
  mutate( #Actualizamos variables que ya existian
    Effective = mdy(Effective),
    Maturity = mdy(Maturity),
    `Trade Time` = mdy(str_sub(`Trade Time`, 1, 10))
  ) %>% 
  mutate( # Crear nuevas variables
    plazo = as.numeric(round((Maturity - Effective)/365, digits = 2))
  )

data_swap_clp_2 %>% 
  group_by(`Trade Time`) %>% 
  summarise(Not. = sum(Not.)) %>% 
  ungroup() %>% 
  ggplot(aes(`Trade Time`, Not.)) +
  geom_col()


# Vamos a crear una tabla

liquidez_clp <- data.frame(
  plazo = c(0.5, 0.75, 1, 1.5, 2:10),
  sens_5k = c(90, 60, 44, 29, 22, 15, 11, 9, 7, 6, 5.3, 4.6, 4.2)
)


liquidez_clp_2 <- data.frame(
  plazo = seq(0, 25, by = 0.01)
) %>% 
  mutate(
    sens_5k = case_when(
      plazo <= 0.5 ~ 90,
      plazo <= 0.75 ~ 60, 
      plazo <= 1 ~ 44,
      plazo <= 1.5 ~ 29,
      plazo <= 2 ~ 22,
      plazo <= 3 ~ 15,
      plazo <= 4 ~ 11,
      plazo <= 5 ~ 9,
      plazo <= 6 ~ 7,
      plazo <= 7 ~ 6,
      plazo <= 8 ~ 5.3,
      plazo <= 9 ~ 4.6,
      plazo <= 10 ~ 4.2,
      TRUE ~ 3
    )
  )

liquidez_clp_2 %>% glimpse()

data_swap_clp_2 %>% 
  left_join(liquidez_clp_2, by = "plazo") %>% # Cruce de dos tablas
  mutate(Not._bn = Not. / 1e9) %>% # Cambiar de escala el Not.
  mutate(sens = Not._bn / sens_5k * 5) %>% 
  glimpse()

data_swap_clp_3 <- data_swap_clp_2 %>% 
  left_join(liquidez_clp_2, by = "plazo") %>% # Cruce de dos tablas
  mutate(Not._bn = Not. / 1e9) %>% # Cambiar de escala el Not.
  mutate(sens = Not._bn / sens_5k * 5) 

# Algunos graficos
data_swap_clp_3 %>% 
  group_by(`Trade Time`, plazo) %>% 
  summarise(sens_sum = sum(sens)) %>% 
  ungroup() %>% 
  filter( plazo == 1) %>% 
  ggplot(aes(`Trade Time`, sens_sum)) +
  geom_line()

data_swap_clp_3 %>% 
  group_by(`Trade Time`, plazo) %>% 
  summarise(sens_sum = sum(sens)) %>% 
  ungroup() %>% 
  ggplot(aes(`Trade Time`, sens_sum)) +
  geom_line() +
  facet_wrap(. ~ plazo, scales = "free")

data_swap_clp_3 %>% 
  group_by(`Trade Time`, plazo) %>% 
  summarise(sens_sum = sum(sens)) %>% 
  ungroup() %>% 
  filter(plazo %in% c(1, 2, 5, 10)) %>% 
  ggplot(aes(`Trade Time`, sens_sum)) +
  geom_line() +
  facet_grid(plazo ~ ., scales = "free")

# vamos a parametrizar los plazos
data_swap_clp_4 <- data_swap_clp_3 %>% 
  mutate(plazo_2 = case_when(
    plazo <= 0.625 ~ 0.5,
    plazo <= 0.875 ~ 0.75,
    plazo <= 1.5 ~ 1,
    plazo <= 2.5 ~ 2,
    plazo <= 3.5 ~ 3,
    plazo <= 4.5 ~ 4,
    plazo <= 5.5 ~ 5,
    plazo <= 6.5 ~ 6,
    plazo <= 7.5 ~ 7,
    plazo <= 8.5 ~ 8,
    plazo <= 9.5 ~ 9,
    plazo <= 10.5 ~ 10,
    TRUE ~ plazo
  ))
  
data_swap_clp_4 %>% 
  group_by(`Trade Time`, plazo_2) %>% 
  summarise(sens_sum = sum(sens)) %>% 
  ungroup() %>% 
  filter(plazo_2 %in% c(1, 2, 5, 10)) %>% 
  ggplot(aes(`Trade Time`, sens_sum)) +
  geom_line() +
  facet_grid(plazo_2 ~ ., scales = "free")

