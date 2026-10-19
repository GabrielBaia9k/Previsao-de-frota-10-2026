# ==============================================================================
# play_modelagem.R - Script para rodar isoladamente o módulo de Previsões
# ==============================================================================


# shiny::runApp("playmodelagem.R")


# 1. Carrega os pacotes necessários para a UI e Servidor do módulo
library(shiny)
library(bs4Dash)
library(dplyr)
library(echarts4r)
library(DT)
library(shinycssloaders)
library(here)

# 2. Carrega o arquivo do módulo
source("modulos/modelagem_todas.R")

# 3. Constrói uma UI minimalista
ui <- bs4DashPage(
  header = bs4DashNavbar(title = "Teste - Painel de Previsões"),
  sidebar = bs4DashSidebar(disable = TRUE), # Desabilita o menu lateral para focar no conteúdo
  body = bs4DashBody(
    # Renderiza a UI do módulo passando um ID único
    previsoes_ui("teste_prev")
  )
)

# 4. Função Server minimalista
server <- function(input, output, session) {
  # Instancia a lógica do servidor do módulo passando o mesmo ID
  previsoes_server("teste_prev")
}

# 5. Executa o App
shinyApp(ui, server)