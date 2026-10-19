
library(dplyr)
library(janitor)
library(lubridate)
library(arrow)


# 1. Carrega o arquivo pesado uma última vez

#Julho/2026
load("data2026-08-17.RData")

#Agosto/2026
load("data2026-08-28.RData")

# 2. Salva o seu mapa geográfico em RDS
saveRDS(geopa, "data/geopa.rds", compress = FALSE)


# 3. Salva suas tabelas de Frota em Parquet

arrow::write_parquet(base_expandida, "data/base_expandida.parquet") 
arrow::write_parquet(db01_acumulado, "data/db01_acumulado.parquet")
arrow::write_parquet(db01_ano, "data/db01_ano.parquet") 
arrow::write_parquet(db02_categoria_acumulado, "data/db02_categoria_acumulado.parquet") 
arrow::write_parquet(db02_categoria_ano, "data/db02_categoria_ano.parquet") 
arrow::write_parquet(db03_tipo_veiculo_acumulado, "data/db03_tipo_veiculo_acumulado.parquet") 
arrow::write_parquet(db03_tipo_veiculo_ano, "data/db03_tipo_veiculo_ano.parquet") 
arrow::write_parquet(db04_cores_acumulado, "data/db04_cores_acumulado.parquet") 
arrow::write_parquet(db04_cores_ano, "data/db04_cores_ano.parquet") 
arrow::write_parquet(db05_combustivel_acumulado, "data/db05_combustivel_acumulado.parquet") 
arrow::write_parquet(db05_combustivel_ano, "data/db05_combustivel_ano.parquet") 
arrow::write_parquet(db06_especie_veiculo_acumulado, "data/db06_especie_veiculo_acumulado.parquet") 
arrow::write_parquet(db06_especie_veiculo_ano, "data/db06_especie_veiculo_ano.parquet") 
arrow::write_parquet(db07_nacionalidade_acumulado, "data/db07_nacionalidade_acumulado.parquet") 
arrow::write_parquet(db07_nacionalidade_ano, "data/db07_nacionalidade_ano.parquet") 
arrow::write_parquet(db08_tipo_vs_categoria_acumulado, "data/db08_tipo_vs_categoria_acumulado.parquet") 
arrow::write_parquet(db09_tipo_vs_cor_pa_acumulado, "data/db09_tipo_vs_cor_pa_acumulado.parquet") 
arrow::write_parquet(db10_tipo_vs_combustivel_pa_acumulado, "data/db10_tipo_vs_combustivel_pa_acumulado.parquet") 
arrow::write_parquet(db11_tipo_vs_especie_pa_acumulado, "data/db11_tipo_vs_especie_pa_acumulado.parquet") 
arrow::write_parquet(db12_tipo_vs_nacionalide_pa_acumulado, "data/db12_tipo_vs_nacionalide_pa_acumulado.parquet") 
arrow::write_parquet(frota_acumulado, "data/frota_acumulado.parquet") 
arrow::write_parquet(frota_ano, "data/frota_ano.parquet") 
arrow::write_parquet(frota_geral, "data/frota_geral.parquet") 
arrow::write_parquet(frota_licenciamento, "data/frota_licenciamento.parquet") 
arrow::write_parquet(frota2, "data/frota2.parquet") 



# 2. Define os caminhos (buscando na sua pasta 'data')
caminho_rds <- here::here("data", "FROTA.rds")
caminho_parquet <- here::here("data", "FROTA.parquet")

df_frota <- readRDS(caminho_rds)


arrow::write_parquet(df_frota, caminho_parquet) 









