# ==============================================================================#
# MÓDULO: EXPORTAÇÃO DE RELATÓRIO PDF
# ARQUIVO: mod_pdf.R
# ==============================================================================#

# ==============================================================================#
# 1. INTERFACE DO USUÁRIO (UI)
# ==============================================================================#
mod_pdf_ui <- function(id) {
  ns <- NS(id)
  
  # Puxando os dados diretos da memória global para não ter tela em branco
  muni_validos <- lista_municipios[lista_municipios != "Pará"]
  
  fluidPage(
    fluidRow(
      
      # =======================================================================#
      # COLUNA 1 (Esquerda): Apresentação e Contexto
      # =======================================================================#
      column(
        width = 4,
        bs4Dash::box(
          title = tagList(icon("circle-info"), "Sobre o Relatório"),
          width = 12,
          status = "primary", 
          solidHeader = FALSE,
          elevation = 2,
          headerBorder = TRUE,
          
          tags$p(
            style = "font-size: 11pt; color: #555; text-align: justify; margin-bottom: 15px;",
            "Geração de documento oficial e estático com indicadores de segurança viária, ideal para auditorias e arquivamento."
          ),
          
          tags$h6(style = "font-weight: bold; color: #1D44B8; margin-bottom: 10px;", 
                  icon("list-check"), " O Que Está Incluído?"),
          
          tags$ul(
            style = "font-size: 11pt; color: #444; line-height: 1.6; list-style-type: none; padding-left: 0;",
            tags$li(icon("check", style = "color: #28A745; margin-right: 5px;"), strong("Resumo Executivo:"), " KPIs gerais."),
            tags$li(icon("check", style = "color: #28A745; margin-right: 5px;"), strong("Análise Temporal:"), " Sazonalidade."),
            tags$li(icon("check", style = "color: #28A745; margin-right: 5px;"), strong("Perfil:"), " Veículos mais Autuados."),
            tags$li(icon("check", style = "color: #28A745; margin-right: 5px;"), strong("Geografia:"), " Recorte da Localidade.")
          ),
          
          tags$div(
            style = "background-color: #f8f9fa; border-left: 5px solid #6c757d; padding: 12px; border-radius: 4px; margin-top: 20px;",
            tags$p(
              style = "margin: 0; font-size: 10pt; color: #333;",
              icon("microchip"), strong(" Nota Técnica:"), " Renderizado via Quarto (LaTeX). A compilação pode levar de 05 a 20 seg."
            )
          )
        )
      ),
      
      # =======================================================================#
      # COLUNA 2 (Meio): Painel de Controle e Botão
      # =======================================================================#
      column(
        width = 4,
        bs4Dash::box(
          title = tagList(icon("sliders"), "Parâmetros de Exportação"),
          status = "primary", 
          width = 12,
          solidHeader = FALSE,
          elevation = 2,
          headerBorder = TRUE,
          
          tags$p(
            style = "font-size: 11pt; color: #666; margin-bottom: 15px;",
            "Defina o escopo dos dados:"
          ),
          
          # AS LISTAS AGORA ESTÃO AQUI DIRETAMENTE NA UI!
          selectInput(
            inputId = ns("filtro_ano"), 
            label = "Ano de Referência:",
            choices = lista_anos_acumulado, 
            selected = ano_maximo_global,
            width = "100%"
          ),
          
          selectInput(
            inputId = ns("filtro_municipio"), 
            label = "Município:",
            choices = c("TODOS OS MUNICÍPIOS", muni_validos), 
            selected = "TODOS OS MUNICÍPIOS",
            width = "100%"
          ),
          
          tags$hr(style = "margin-top: 20px; margin-bottom: 20px;"),
          
          downloadButton(
            outputId = ns("btn_gerar_pdf"), 
            label = " GERAR RELATÓRIO",
            icon = icon("file-pdf"),
            class = "btn-danger btn-lg btn-block", 
            style = "font-weight: bold; font-size: 12pt; padding: 12px; width: 100%; box-shadow: 0 4px 6px rgba(220, 53, 69, 0.3); border-radius: 6px;"
          )
        )
      ),
      
      # =======================================================================#
      # COLUNA 3 (Direita): Imagem da Capa
      # =======================================================================#
      column(
        width = 4,
        bs4Dash::box(
          title = tagList(icon("image"), "Visualização da Capa"),
          status = "primary", 
          width = 12,
          solidHeader = FALSE,
          elevation = 2,
          headerBorder = TRUE,
          
          tags$div(
            align = "center",
            tags$img(
              src = "CAPA_TEX.png", 
              style = "width: 100%; height: auto; box-shadow: 0 4px 8px rgba(0,0,0,0.15); border-radius: 5px;" 
            )
          )
        )
      )
    )
  )
}

# ==============================================================================#
# 2. LÓGICA DO SERVIDOR (SERVER)
# ==============================================================================#
mod_pdf_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # -------------------------------------------------------------------------
    # Lógica de Download e Renderização via QUARTO
    # -------------------------------------------------------------------------
    output$btn_gerar_pdf <- downloadHandler(
      
      filename = function() {
        municipio_nome <- gsub(" ", "_", input$filtro_municipio)
        paste0("Boletim_Frota_", municipio_nome, "_", input$filtro_ano, ".pdf")
      },
      
      content = function(file) {
        
        # 1. Notificação visual de carregamento
        id_notif <- showNotification(
          "Iniciando a compilação do relatório LaTeX/Quarto. Isso pode levar de 10 a 20 segundos...",
          duration = NULL, 
          type = "message",
          closeButton = FALSE
        )
        on.exit(removeNotification(id_notif), add = TRUE)
        
        tryCatch({
          # 2. Criação do ecossistema temporário seguro
          temp_dir <- tempfile("relatorio_")
          dir.create(temp_dir)
          
          # 3. MÁGICA AQUI: Copia a PASTA INTEIRA de reports para não perder nenhuma imagem (ex: CAPA_TEX.png)
          file.copy(from = here::here("reports"), to = temp_dir, recursive = TRUE, overwrite = TRUE)
          if (dir.exists(here::here("www"))) {
            file.copy(from = here::here("www"), to = temp_dir, recursive = TRUE, overwrite = TRUE)
          }
          
          # Caminho do arquivo QMD agora dentro da pasta temporária
          qmd_temp <- file.path(temp_dir, "reports", "QUARTO_DOC.qmd")
          
          if (!file.exists(qmd_temp)) {
            stop("O arquivo QUARTO_DOC.qmd não foi encontrado na pasta temporária.")
          }
          
          # 4. Renderização do Quarto
          # O quiet=FALSE faz o R imprimir no console qualquer errinho do LaTeX!
          quarto::quarto_render(
            input = qmd_temp,
            output_format = "pdf",
            quiet = FALSE, 
            execute_params = list(
              cidade_selecionada = input$filtro_municipio,
              year_initial = as.numeric(input$filtro_ano),
              data_dir = here::here("data") 
            )
          )
          
          # 5. Captura e exportação do PDF
          pdf_gerado <- file.path(temp_dir, "reports", "QUARTO_DOC.pdf")
          
          if (file.exists(pdf_gerado)) {
            file.copy(pdf_gerado, file, overwrite = TRUE)
          } else {
            stop("A renderização falhou. O PDF não foi gerado pelo Quarto (Verifique o console do R).")
          }
          
        }, error = function(e) {
          # Se quebrar, cospe o erro no console do R para podermos ver o que houve!
          message("\n[ERRO NO QUARTO/LATEX]: ", e$message, "\n")
          showNotification(paste("Falha ao gerar o PDF:", e$message), type = "error", duration = 15)
        })
      }
    )
  })
}