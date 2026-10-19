#===============================================================================#
# 1. Função de Módulo de UI: Download
#===============================================================================#
downset_ui <- function(id) {
  ns <- NS(id)
  
  # REMOVIDO o fluidPage() para não quebrar o layout e as margens dos footers
  shinyWidgets::dropMenu(
    padding = "15px",
    placement = "top", # Fica melhor abrindo para cima, já que fica no rodapé
    trigger = "click",
    
    # O botão principal que o usuário clica
    actionBttn(
      inputId = ns("demo1down"), 
      label = "Download", 
      icon = icon("download"), 
      style = "jelly", 
      color = "primary", 
      size = "sm"
    ),
    
    # O conteúdo do menu suspenso
    tags$div(
      style = "text-align: center; min-width: 150px;",
      tags$h6(tags$b("Escolha o formato:"), style = "color: #333; margin-bottom: 15px; font-size: 13px;"),
      
      downloadButton(
        outputId = ns("xlsx"), 
        label = " Excel", 
        icon = icon("file-excel"), 
        class = "btn btn-success btn-sm btn-block", 
        style = "margin-bottom: 8px; text-align: left;"
      ),
      downloadButton(
        outputId = ns("csv"), 
        label = " CSV", 
        icon = icon("file-csv"), 
        class = "btn btn-warning btn-sm btn-block", 
        style = "margin-bottom: 8px; color: #fff; text-align: left;"
      ),
      downloadButton(
        outputId = ns("rds"), 
        label = " RData", 
        icon = icon("database"), 
        class = "btn btn-secondary btn-sm btn-block",
        style = "text-align: left;"
      )
    )
  )
}

#===============================================================================#
# 2. Função de Módulo de Servidor: Download
#===============================================================================#
# ATENÇÃO: df e nome agora são RECEBIDOS COMO FUNÇÕES REATIVAS (sem os parênteses)
downset_Server <- function(id, df_reativo, nome_reativo) {
  moduleServer(id, function(input, output, session) {
    
    # Helper: Limpa o nome do arquivo para evitar erro HTTP no Servidor/Navegador
    clean_nome <- function(n) {
      # 1. Remove acentos graciosamente (ex: Belém -> Belem, Conceição -> Conceicao)
      n_limpo <- iconv(n, to = "ASCII//TRANSLIT")
      # 2. Troca tudo que não for letra ou número por '_'
      n_limpo <- gsub("[^A-Za-z0-9]", "_", n_limpo) 
      # 3. Transforma tudo em Maiúsculo
      n_limpo <- toupper(n_limpo)
      # 4. Remove underlines duplicados, no início e no final
      n_limpo <- gsub("_+", "_", n_limpo)             
      n_limpo <- sub("^_", "", n_limpo)               
      n_limpo <- sub("_$", "", n_limpo)                
      
      return(n_limpo)
    }
    
    # 1. Download Excel
    output$xlsx <- downloadHandler(
      filename = function() { 
        # Chama a função reativa com os parênteses APENAS NA HORA de salvar
        paste0(clean_nome(nome_reativo()), ".xlsx") 
      }, 
      content = function(file) { 
        openxlsx::write.xlsx(df_reativo(), file) 
      }
    )
    
    # 2. Download CSV (Usando write_excel_csv para os acentos funcionarem no Excel do Windows)
    output$csv <- downloadHandler(
      filename = function() { 
        paste0(clean_nome(nome_reativo()), ".csv") 
      }, 
      content = function(file) { 
        readr::write_excel_csv(df_reativo(), file) 
      }
    )
    
    # 3. Download RData/RDS
    output$rds <- downloadHandler(
      filename = function() { 
        paste0(clean_nome(nome_reativo()), ".rds") 
      }, 
      content = function(file) { 
        readr::write_rds(df_reativo(), file) 
      }
    )
    
  })
}
#===============================================================================#