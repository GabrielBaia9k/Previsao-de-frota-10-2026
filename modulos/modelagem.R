# ==============================================================================
# modelagem.R - Módulo de Modelagem (Leitura Offline de Dados Pré-Compilados)
# Padronizado segundo as convenções visuais dos demais módulos do dashboard
# ==============================================================================

modelagem_ui <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    #------------------------------------------------------------------------------#
    ## 1. VALUE BOXES (Padrão do projeto: bs4InfoBox) ----
    fluidRow(
      bs4InfoBoxOutput(ns("vb_anos"),  width = 4),   # Anos cobertos
      bs4InfoBoxOutput(ns("vb_rmse"),  width = 4),   # Margem de erro (RMSE)
      bs4InfoBoxOutput(ns("vb_cresc"), width = 4)    # Média de crescimento anual
    ),
    
    tags$br(),
    
    #------------------------------------------------------------------------------#
    ## 2. Painel de Filtros (Padrão do projeto) ----
    fluidRow(
      bs4Dash::box(
        title = tagList(icon("filter"), "Filtro de Localidade"),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        collapsible = TRUE,
        width = 12,
        fluidRow(
          column(
            6,
            selectInput(
              inputId = ns("select_local"),
              label = "MUNICIPIO OU ESTADO",
              choices = NULL,
              selected = NULL,
              width = "100%"
            )
          ),
          column(4),
          column(
            2,
            tags$label(HTML("&nbsp;")), # Alinhamento perfeito do botão
            actionBttn(
              inputId = ns("reset_modelagem"),
              label = "🔄 LIMPAR",
              style = "material-flat",
              color = "primary",
              size = "md",
              block = TRUE
            )
          )
        )
      )
    ),
    
    #------------------------------------------------------------------------------#
    ## 3. Caixa Principal (Métricas + Tabela + Gráfico) ----
    fluidRow(
      bs4Dash::box(
        title = htmlOutput(ns("txtmodelagem")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        
        tags$p(
          style = "text-align: justify; font-size: 11pt;",
          "Resultados pré-compilados do modelo SARIMAX. ",
          "A linha azul representa os valores reais e a vermelha as previsões."
        ),
        tags$p(
          style = "text-align: justify; font-size: 11pt;",
          icon("table"), paste(" Tabela comparativa dos Valores Reais vs Previsões do", "SARIMAX", ".")
        ),
        
        tags$hr(),
        
        uiOutput(ns("metricas_SARIMAX")),
        
        shinycssloaders::withSpinner(
          DT::dataTableOutput(ns("Tabela_real_previsto_sarimax")),
          type = 8, color = "#1D44B8", size = 0.8
        ),
        
        tags$hr(),
        
        shinycssloaders::withSpinner(
          echarts4rOutput(ns("grafico_SARIMAX"), width = "100%", height = "60vh"),
          type = 8, color = "#1D44B8", size = 0.8
        ),
        
        footer = list(
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(tags$b("Fonte:", style = 'font-family: sans-serif;'), "DTI/DETRAN-PA", style = "margin-bottom: 0;"),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(style = "text-align: center;", downset_ui(ns("modeldown")))
          )
        )
      )
    )
  )
}

modelagem_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # =============================================
    # 1. CARREGAMENTO DO PARQUET PRÉ-COMPILADO
    # =============================================
    df_sarimax_lazy <- arrow::open_dataset(here::here("data", "previsoes_sarimax_pre_comp.parquet"))
    
    # =============================================
    # 2. POPULA O FILTRO DE LOCALIDADES
    # =============================================
    todas_localidades <- df_sarimax_lazy |>
      dplyr::select(Localidade_Nome) |>
      dplyr::distinct() |>
      dplyr::collect() |>
      dplyr::pull(Localidade_Nome) |>
      sort()
    localidades_disponiveis <- c("Pará", setdiff(todas_localidades, "Pará"))
    
    updateSelectInput(
      session, "select_local", 
      choices = localidades_disponiveis, selected = "Pará"
    )
    
    # 2.1 Botão LIMPAR (Padrão do projeto)
    observeEvent(input$reset_modelagem, {
      freezeReactiveValue(input, "select_local")
      updateSelectInput(session, "select_local", selected = "Pará")
    })
    
    # =============================================
    # 3. DADOS FILTRADOS REATIVOS COMUNS
    # =============================================
    dados_filtrados <- reactive({
      req(input$select_local)
      df_sarimax_lazy |>
        dplyr::filter(Localidade_Nome == input$select_local) |>   # pushdown direto
        dplyr::collect()
    })
    
    # =============================================
    # FUNÇÕES AUXILIARES GLOBAIS E MATEMÁTICAS
    # =============================================
    calcular_erros_nativos <- function(y_real, y_pred) {
      mae  <- mean(abs(y_real - y_pred), na.rm = TRUE)
      rmse <- sqrt(mean((y_real - y_pred)^2, na.rm = TRUE))
      mape <- mean(abs((y_real - y_pred) / y_real), na.rm = TRUE) * 100
      
      n   <- length(y_real)
      rss <- sum((y_real - y_pred)^2, na.rm = TRUE)
      sst <- sum((y_real - mean(y_real, na.rm = TRUE))^2, na.rm = TRUE)
      r2  <- ifelse(sst > 0, 1 - (rss / sst), NA)
      
      return(list(mae = mae, rmse = rmse, mape = mape, r2 = r2))
    }
    
    # =============================================
    # 4. RESULTADOS COMUNS PARA VALUE BOXES, TABELA E DOWNLOAD
    # =============================================
    resumo_modelo <- reactive({
      df <- dados_filtrados()
      
      # Período de teste (Real + Previsao ambos não-NA) -> RMSE
      df_teste <- df |> dplyr::filter(!is.na(Real) & !is.na(Previsao_SARIMAX))
      erros <- if (nrow(df_teste) > 0) {
        calcular_erros_nativos(df_teste$Real, df_teste$Previsao_SARIMAX)
      } else {
        list(mae = NA_real_, rmse = NA_real_, mape = NA_real_, r2 = NA_real_)
      }
      
      # Período futuro (Previsao apenas, 2026-2031) -> anos cobertos + crescimento anual
      df_fut <- df |> dplyr::filter(is.na(Real) & !is.na(Previsao_SARIMAX))
      if (nrow(df_fut) > 0) {
        anos <- sort(unique(format(df_fut$Data, "%Y")))
        soma_ano <- df_fut |>
          dplyr::mutate(ano = format(Data, "%Y")) |>
          dplyr::group_by(ano) |>
          dplyr::summarise(total = sum(Previsao_SARIMAX, na.rm = TRUE), .groups = "drop") |>
          dplyr::arrange(ano)
        # Média de crescimento anual: média dos crescimentos ano a ano
        if (nrow(soma_ano) >= 2) {
          cresc <- (dplyr::lag(soma_ano$total) != 0)
          cresc[is.na(cresc)] <- FALSE
          variacao <- (soma_ano$total / dplyr::lag(soma_ano$total) - 1) * 100
          cresc_anual <- mean(variacao[!is.na(variacao)], na.rm = TRUE)
        } else {
          cresc_anual <- NA_real_
        }
      } else {
        anos <- NULL
        cresc_anual <- NA_real_
      }
      
      list(
        local = input$select_local,
        anos_min = if (!is.null(anos)) anos[1] else NA,
        anos_max = if (!is.null(anos)) anos[length(anos)] else NA,
        rmse = erros$rmse,
        cresc_anual = cresc_anual
      )
    })
    
    # Tabela formatada (reutilizada na renderização e no download)
    tabela_previsto <- reactive({
      df <- dados_filtrados()
      df |>
        dplyr::filter(!is.na(Real) & !is.na(Previsao_SARIMAX)) |>
        dplyr::mutate(
          `Diferenca Absoluta` = Previsao_SARIMAX - Real,
          `Erro (%)` = (abs(`Diferenca Absoluta`) / Real) * 100,
          Data = format(Data, "%b/%Y")
        ) |>
        dplyr::select(`Mês` = Data, `Frota Real` = Real, `Previsto SARIMAX` = Previsao_SARIMAX, `Diferenca Absoluta`, `Erro (%)`)
    })
    
    # =============================================
    # 5. VALUE BOXES (Anos cobertos | RMSE | Crescimento anual)
    # =============================================
    output$vb_anos <- renderInfoBox({
      r <- resumo_modelo()
      mostra <- if (!is.na(r$anos_min)) paste0(r$anos_min, " - ", r$anos_max) else "N/A"
      bs4InfoBox(
        title = tags$strong("ANOS COBERTOS"),
        value = tags$h2(tags$strong(mostra)),
        subtitle = paste0("Horizonte projetado - ", r$local),
        fill = TRUE, gradient = TRUE, iconElevation = 2, icon = icon("calendar"), color = "primary"
      )
    })
    
    output$vb_rmse <- renderInfoBox({
      r <- resumo_modelo()
      rmse_fmt <- if (is.na(r$rmse)) "N/A" else prettyNum(round(r$rmse, 0), big.mark = ".", decimal.mark = ",")
      bs4InfoBox(
        title = tags$strong("MARGEM DE ERRO (RMSE)"),
        value = tags$h2(tags$strong(rmse_fmt)),
        subtitle = "Erro médio no período de teste (12m)",
        fill = TRUE, gradient = TRUE, iconElevation = 2, icon = icon("ruler-horizontal"), color = "success"
      )
    })
    
    output$vb_cresc <- renderInfoBox({
      r <- resumo_modelo()
      cresc_fmt <- if (is.na(r$cresc_anual)) "N/A" else paste0(format(round(r$cresc_anual, 1), decimal.mark = ","), "%")
      bs4InfoBox(
        title = tags$strong("CRESCIMENTO MÉDIO ANUAL"),
        value = tags$h2(tags$strong(cresc_fmt)),
        subtitle = paste0("Variação média anual projetada - ", r$local),
        fill = TRUE, gradient = TRUE, iconElevation = 2, icon = icon("chart-line"), color = "info"
      )
    })
    
    # =============================================
    # 6. RENDERIZAÇÃO DOS OUTPUTS 
    # =============================================
    
    # Título da caixa principal (Padrão do projeto: h4 centralizado)
    output$txtmodelagem <- renderText({
      HTML(paste0(
        "<h4 style='text-align:center; font-weight:bold; margin: 0;'>",
        "Projeção - Modelo SARIMAX (", input$select_local, ")",
        "</h4>"
      ))
    })
    
    output$metricas_SARIMAX <- renderUI({
      df <- dados_filtrados()
      df_teste <- df |> dplyr::filter(!is.na(Real) & !is.na(Previsao_SARIMAX))
      if (nrow(df_teste) == 0) return(NULL)
      
      erros <- calcular_erros_nativos(df_teste$Real, df_teste$Previsao_SARIMAX)
      cor_mape <- ifelse(erros$mape <= 5, "green", ifelse(erros$mape <= 15, "#d39e00", "red"))
      
      tags$div(
        style = "margin-bottom: 20px;",
        tags$b(icon("chart-bar"), " Resumo de Erros no Período de Teste:"),
        tags$table(
          class = "table table-bordered table-sm table-striped",
          style = "width: 100%; text-align: center; margin-top: 10px;",
          tags$thead(
            tags$tr(
              class = "bg-light",
              tags$th("MAPE (%)"), tags$th("MAE"), tags$th("RMSE"), tags$th("AIC"), tags$th("BIC"), tags$th("R²")
            )
          ),
          tags$tbody(
            tags$tr(
              tags$td(
                style = HTML(paste0("color: ", cor_mape, "; font-weight: bold;")),
                paste0(format(round(erros$mape, 2), decimal.mark = ","), "%")
              ),
              tags$td(format(round(erros$mae, 0), big.mark = ".", decimal.mark = ",")),
              tags$td(format(round(erros$rmse, 0), big.mark = ".", decimal.mark = ",")),
              tags$td(format(round(df$AIC[1], 2), big.mark = ".", decimal.mark = ",")),
              tags$td(format(round(df$BIC[1], 2), big.mark = ".", decimal.mark = ",")),
              tags$td(format(round(erros$r2, 4), decimal.mark = ","))
            )
          )
        )
      )
    })
    
    output$Tabela_real_previsto_sarimax <- DT::renderDataTable({
      df_teste <- tabela_previsto()
      
      DT::datatable(
        df_teste, rownames = FALSE, class = 'cell-border stripe hover',
        options = list(
          dom = 't', paging = FALSE,
          language = list(
            sEmptyTable = "Nenhum registro encontrado",
            sZeroRecords = "Nenhum registro encontrado"
          )
        )
      ) |>
        DT::formatRound(columns = c("Frota Real", "Previsto SARIMAX", "Diferenca Absoluta"), digits = 0) |>
        DT::formatRound(columns = "Erro (%)", digits = 2) |>
        DT::formatStyle('Erro (%)', color = DT::styleInterval(c(5, 15), c('green', 'orange', 'red')), fontWeight = 'bold') |>
        DT::formatStyle(
          columns = c("Frota Real", "Previsto SARIMAX", "Diferenca Absoluta", "Erro (%)"),
          textAlign = "right"
        )
    })
    
    output$grafico_SARIMAX <- renderEcharts4r({
      old_outdec <- getOption("OutDec"); options(OutDec = "."); on.exit(options(OutDec = old_outdec), add = TRUE)
      df <- dados_filtrados()
      
      df |>
        e_charts(x = Data) |>
        e_line(serie = Real, name = "Valores Reais", color = "#007bff", smooth = FALSE, symbol = "roundRect", symbolSize = 3, legendHoverLink = TRUE, itemStyle = list(barBorderRadius=5), lineStyle = list(width=2)) |>
        e_line_(serie = "Previsao_SARIMAX", name = "Previsões SARIMAX", color = "#dc3545", smooth = FALSE, symbol = "roundRect", symbolSize = 3, legendHoverLink = TRUE, itemStyle = list(barBorderRadius=5), lineStyle = list(width=2)) |>
        e_tooltip(
          trigger = "axis", axisPointer = list(type = "shadow"),
          formatter = htmlwidgets::JS(
            "function(params) { 
              if (!params || params.length === 0) return '';
              var result = '<b>' + (params[0].axisValueLabel || params[0].name) + '</b><br/>';
              params.forEach(function(item) {
                var dataVal = item.value.length ? item.value[1] : item.value;
                if(dataVal != null && !isNaN(dataVal)){
                  result += item.marker + item.seriesName + ': <b>' + Math.round(Number(dataVal)).toLocaleString('pt-BR') + ' veículos</b><br/>';
                }
              });
              return result;
            }"
          )
        ) |>
        e_x_axis(type = "time", axisLabel = list(show = TRUE, fontSize = 14, fontWeight = "bold"), name = "", splitLine = list(show = TRUE), nameTextStyle = list(fontWeight = "bold", fontSize = 14, padding = c(0, 0, 0, 20))) |>
        e_y_axis(name = "Veículos", nameTextStyle = list(fontWeight = "bold", fontSize = 16), scale = TRUE, axisLabel = list(formatter = htmlwidgets::JS("function (value) { return value.toLocaleString('pt-BR'); }"))) |>
        e_locale("pt-Br") |>
        e_grid(show = TRUE, bottom = "20%") |>
        e_animation(duration = 600) |>
        e_legend(bottom = 0, textStyle = list(fontSize = 14, fontWeight = "bold")) |>
        e_toolbox(feature = list(saveAsImage = list(title = "Salvar Gráfico")))
    })
    
    # =============================================
    # 7. DOWNLOAD (Padrão do projeto: downset)
    # =============================================
    nome_modelagem <- reactive({"Previsao_x_Real_SARIMAX"})
    downset_Server("modeldown", tabela_previsto, nome_modelagem)
    
  })
}