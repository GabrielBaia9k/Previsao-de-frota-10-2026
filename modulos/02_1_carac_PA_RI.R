# Função de UI
loc_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    # --- Painel de Filtros Modernizado ---
    fluidRow(
      bs4Dash::box(
        title = tagList(icon("filter"), "Filtros de Análise Geográfica"),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        collapsible = TRUE,
        width = 12,
        fluidRow(
          column(
            3,
            selectInput(
              inputId = ns("local"),
              label = "LOCALIDADE (ESTADO / R.I)",
              choices = NULL,
              width = "100%"
            )
          ),
          column(
            3,
            selectInput(
              inputId = ns("anolocal"),
              label = "SELECIONE O ANO",
              choices = NULL,
              width = "100%"
            )
          ),
          column(4),
          column(
            2,
            tags$label(HTML("&nbsp;")),
            # Alinhamento perfeito do botão
            actionBttn(
              inputId = ns("reset_filtros"),
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
    #Perfil Pará/R.I----
    fluidRow(
      bs4Dash::box(
        title = htmlOutput(ns("txtgeral")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          reactableOutput(ns("tab")),
          type = 8,
          color = "#1D44B8",
          size = 0.8
        ),
        footer = list(
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(
                tags$b("Fonte:", style = 'font-family: sans-serif;'),
                "DTI/DETRAN-PA",
                style = "margin-bottom: 0;"
              ),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("tabdown")))
          )
        )
      )
    ),
    
    #------------------------------------------------------------------------------#
    fluidRow(
      # Categoria Veículos----
      bs4Dash::box(
        title = htmlOutput(ns("txtcat")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          echarts4rOutput(ns("catbar"), width = "100%", height = "500px"),
          type = 8,
          color = "#17a2b8",
          size = 0.8
        ),
        footer = list(
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(
                tags$b("Fonte:", style = 'font-family: sans-serif;'),
                "DTI/DETRAN-PA",
                style = "margin-bottom: 0;"
              ),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("catdown")))
          )
        )
      ),
      
      #------------------------------------------------------------------------------#
      # Cor dos Veículos----
      bs4Dash::box(
        title = htmlOutput(ns("txtcor")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          echarts4rOutput(ns("corbar"), width = "100%", height = "500px"),
          type = 8,
          color = "#dc3545",
          size = 0.5
        ),
        footer = list(
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(
                tags$b("Fonte:", style = 'font-family: sans-serif;'),
                "DTI/DETRAN-PA",
                style = "margin-bottom: 0;"
              ),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("cordown")))
          )
        )
      ),
      
      #------------------------------------------------------------------------------#
      # Tipo de Combustível----
      bs4Dash::box(
        title = htmlOutput(ns("txtcombu")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          echarts4rOutput(ns("combubar"), width = "100%", height = "500px"),
          type = 8,
          color = "#28a745",
          size = 0.8
        ),
        footer = list(
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(
                tags$b("Fonte:", style = 'font-family: sans-serif;'),
                "DTI/DETRAN-PA",
                style = "margin-bottom: 0;"
              ),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("combudown")))
          )
        )
      ),
      
      #------------------------------------------------------------------------------#
      # Espécie do Veículo----
      bs4Dash::box(
        title = htmlOutput(ns("txtesp")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          echarts4rOutput(ns("espbar"), width = "100%", height = "500px"),
          type = 8,
          color = "#ffc107",
          size = 0.8
        ),
        footer = list(
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(
                tags$b("Fonte:", style = 'font-family: sans-serif;'),
                "DTI/DETRAN-PA",
                style = "margin-bottom: 0;"
              ),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("espdown")))
          )
        )
      ),
      
      #------------------------------------------------------------------------------#
      # Nacionalidade do Veículo----
      bs4Dash::box(
        title = htmlOutput(ns("txtnac")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          echarts4rOutput(ns("nacpie"), width = "100%", height = "500px"),
          type = 8,
          color = "#6c757d",
          size = 0.8
        ),
        footer = list(
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(
                tags$b("Fonte:", style = 'font-family: sans-serif;'),
                "DTI/DETRAN-PA",
                style = "margin-bottom: 0;"
              ),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("nacdown")))
          )
        )
      )
    )
  )
}

#------------------------------------------------------------------------------#
# Função do modulo servidor
loc_Server <- function(id) {
  moduleServer(id, function(input, output, session) {
    #-------------------------------------------------------------------------------#
    # 0. INICIALIZAÇÃO DE INPUTS RÁPIDA
    # O PROBLEMA DA ARAGUAIA RESOLVIDO AQUI: selected = "Pará"
    #-------------------------------------------------------------------------------#
    updateSelectInput(
      session,
      "local",
      choices = c("Pará", lista_regioes[lista_regioes != "Pará"]),
      selected = "Pará"
    )
    updateSelectInput(
      session,
      "anolocal",
      choices = lista_anos_acumulado,
      selected = max(lista_anos_acumulado, na.rm = TRUE)
    )
    
    observeEvent(input$reset_filtros, {
      updateSelectInput(session, "local", selected = "Pará")
      updateSelectInput(session,
                        "anolocal",
                        selected = max(lista_anos_acumulado, na.rm = TRUE))
    })
    
    #-------------------------------------------------------------------------------#
    titulo6 <- reactive({
      req(input$local, input$anolocal)
      titulo_texto <- if (input$local == "Pará") {
        paste0(
          "Estatística Resumo de Veículos Registrados - ",
          input$local,
          " - ",
          input$anolocal
        )
      } else {
        paste0(
          "Tabela - Resumo de Veículos Registrados - Região de Integração ",
          input$local,
          " - ",
          input$anolocal
        )
      }
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin: 0;'>",
          titulo_texto,
          "</h4>"
        )
      )
    })
    
    titulo6_clean <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará") {
        paste0("Resumo_Veiculos_", input$local, "_", input$anolocal)
      } else {
        paste0("Resumo_Veiculos_RI_",
               input$local,
               "_",
               input$anolocal)
      }
    })
    
    output$txtgeral <- renderText({
      titulo6()
    })
    
    #-------------------------------------------------------------------------------#
    # 1. FUNÇÃO REATIVA PARA A TABELA DE PERFIL GERAL
    dados_perfil <- reactive({
      req(input$local, input$anolocal)
      
      ano_req <- as.numeric(input$anolocal)
      local_req <- input$local
      
      # 1.1 Descobre o TOTAL ABSOLUTO
      total_frota_filtro <- db01_acumulado %>%
        filter(ri == local_req, ano == ano_req) %>%
        summarise(total = sum(valor, na.rm = TRUE)) %>%
        collect() %>% pull(total)
      
      if (length(total_frota_filtro) == 0 ||
          total_frota_filtro == 0)
        total_frota_filtro <- 1
      
      # 1.2 Função auxiliar para puxar apenas o maior valor
      get_top_categoria <- function(base_dados) {
        base_dados %>%
          filter(ri == local_req, ano == ano_req) %>%
          group_by(variavel, categoria) %>%
          summarize(valor = sum(valor, na.rm = TRUE),
                    .groups = 'drop') %>%
          slice_max(order_by = valor,
                    n = 1,
                    with_ties = FALSE) %>%
          collect() %>%
          mutate(Percentual = (valor / total_frota_filtro) * 100)
      }
      
      # Coleta isolada e ultrarrápida
      categoria <- get_top_categoria(db02_categoria_acumulado)
      cor <- get_top_categoria(db04_cores_acumulado)
      combustivel <- get_top_categoria(db05_combustivel_acumulado)
      especie <- get_top_categoria(db06_especie_veiculo_acumulado)
      nacionalidade <- get_top_categoria(db07_nacionalidade_acumulado)
      
      df <- bind_rows(categoria, cor, combustivel, especie, nacionalidade)
      
      df %>% mutate(ri = local_req, ano = ano_req) %>%
        select(ri, variavel, categoria, ano, valor, Percentual)
    })
    
    # Download Limpo
    downset_Server("tabdown", dados_perfil, titulo6_clean)
    
    output$tab <- renderReactable({
      df <- dados_perfil()
      validate(need(
        nrow(df) > 0,
        "Não há dados suficientes para esta localidade e ano."
      ))
      
      df %>% reactable(
        defaultPageSize = 10,
        striped = FALSE,
        highlight = TRUE,
        bordered = TRUE,
        outlined = TRUE,
        resizable = TRUE,
        showSortable = TRUE,
        pagination = FALSE,
        columns =  list(
          ri = colDef(show = FALSE),
          ano = colDef(show = FALSE),
          variavel = colDef(name = "Características"),
          categoria = colDef(name = "Predominância"),
          valor = colDef(
            name = "Quantidade",
            format = colFormat(separators = TRUE, locales = "pt-BR")
          ),
          Percentual = colDef(
            name = "Percentual(%)",
            format = colFormat(
              separators = TRUE,
              locales = "pt-BR",
              digits = 2
            )
          )
        ),
        defaultColDef = colDef(
          na = "-",
          footerStyle = list(fontWeight = "bold"),
          headerStyle = list(background = "#f7f7f8")
        ),
        language = reactableLang(noData = "Sem informação", pageInfo = "{rowStart} a {rowEnd} de {rows} linhas")
      )
    })
    
    #--------------------------------------------------------------------------------------------------------------------------#
    # Categoria dos Veículos - Gráfico Barras ----
    titulo1 <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará") {
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Categorias dos Veículos Registrados - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      } else {
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Categorias dos Veículos Registrados - Região de Integração ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      }
    })
    
    titulo1_clean <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará") {
        paste0("Categorias_Veiculos_",
               input$local,
               "_",
               input$anolocal)
      } else {
        paste0("Categorias_Veiculos_RI_",
               input$local,
               "_",
               input$anolocal)
      }
    })
    
    output$txtcat <- renderText({
      titulo1()
    })
    
    dados_categoria <- reactive({
      req(input$local, input$anolocal)
      db02_categoria_acumulado %>%
        filter(ri == input$local, ano == !!as.numeric(input$anolocal)) %>%
        group_by(ri, categoria) %>%
        summarize(valor = sum(valor, na.rm = TRUE),
                  .groups = 'drop') %>%
        collect() %>%
        arrange(valor) %>%
        mutate(variavel = "Categoria do veículo", ano = input$anolocal) %>%
        select(ri, variavel, categoria, ano, valor)
    })
    
    downset_Server("catdown", dados_categoria, titulo1_clean)
    
    output$catbar <- renderEcharts4r({
      df_cat <- dados_categoria()
      validate(need(nrow(df_cat) > 0, "Sem dados de categorias para este filtro."))
      
      total_cat <- sum(df_cat$valor, na.rm = TRUE)
      if (total_cat == 0)
        total_cat <- 1
      
      df_cat %>%
        e_charts(x = categoria, renderer = "svg") %>%
        e_bar(
          serie = valor,
          name = "Quantidade",
          barWidth = "55%",
          legend = FALSE,
          itemStyle = list(
            color = htmlwidgets::JS(
              "new echarts.graphic.LinearGradient(0, 0, 1, 0, [{offset: 0, color: '#74B4E8'}, {offset: 1, color: '#1D44B8'}])"
            ),
            borderRadius = c(0, 5, 5, 0)
          )
        ) %>%
        e_labels(
          position = "right",
          fontWeight = "bold",
          fontSize = 15,
          color = "#333333",
          formatter = htmlwidgets::JS(
            "function(params) {return Intl.NumberFormat('pt-BR', { style: 'decimal'}).format(params.value[0]);}"
          )
        ) %>%
        e_tooltip(
          trigger = "item",
          backgroundColor = "rgba(255, 255, 255, 0.95)",
          borderColor = "#1D44B8",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            paste0(
              "
             function(params) {
               var valorFormat = Intl.NumberFormat('pt-BR').format(params.value[0]);
               var calcPercentual = ((params.value[0] / ",
              total_cat,
              ") * 100).toFixed(1).replace('.', ',') + '%';
               return '<strong style=\"font-size:16px; color:#1D44B8;\">' + params.name + '</strong><br/>Frota: <b>' + valorFormat + '</b><br/>Representatividade: <b>' + calcPercentual + '</b>';
             }
           "
            )
          )
        ) %>%
        e_y_axis(
          name = "",
          scale = TRUE,
          splitLine = list(show = FALSE),
          axisLine = list(show = FALSE),
          axisTick = list(show = FALSE),
          axisLabel = list(
            color = "#666",
            fontWeight = "bold",
            formatter = htmlwidgets::JS(
              "function (value) { return value >= 1000 ? (value / 1000) + 'k' : value; }"
            )
          )
        ) %>%
        e_x_axis(
          axisLabel = list(
            fontWeight = "bold",
            color = "#444",
            fontSize = 13
          ),
          axisLine = list(lineStyle = list(color = "#ccc")),
          axisTick = list(show = FALSE)
        ) %>%
        e_locale("pt-Br") %>% e_grid(
          show = TRUE,
          width = "75%",
          height = "80%",
          left = "20%"
        ) %>%
        e_animation(duration = 800, easing = "cubicOut") %>% e_toolbox_feature(feature = "saveAsImage") %>% e_flip_coords()
    })
    
    #--------------------------------------------------------------------------------------------------------------------------#
    # Cor dos Veículos - Gráfico de Barras----
    titulo2 <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará") {
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Cores dos Veículos Registrados - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      } else{
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Cores dos Veículos Registrados Região de Integração - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      }
    })
    
    titulo2_clean <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará") {
        paste0("Cores_Veiculos_", input$local, "_", input$anolocal)
      } else{
        paste0("Cores_Veiculos_RI_",
               input$local,
               "_",
               input$anolocal)
      }
    })
    
    output$txtcor <- renderText({
      titulo2()
    })
    
    dados_cor <- reactive({
      req(input$local, input$anolocal)
      db04_cores_acumulado %>%
        filter(ri == input$local, ano == !!as.numeric(input$anolocal)) %>%
        group_by(ri, categoria) %>%
        summarize(valor = sum(valor, na.rm = TRUE),
                  .groups = 'drop') %>%
        collect() %>%
        arrange(valor) %>%
        mutate(variavel = "Cor do veículo", ano = input$anolocal) %>%
        select(ri, variavel, categoria, ano, valor)
    })
    
    downset_Server("cordown", dados_cor, titulo2_clean)
    
    output$corbar <- renderEcharts4r({
      df_cor <- dados_cor()
      validate(need(nrow(df_cor) > 0, "Sem dados de cores para este filtro."))
      
      total_cor <- sum(df_cor$valor, na.rm = TRUE)
      if (total_cor == 0)
        total_cor <- 1
      
      df_cor %>%
        e_charts(x = categoria, renderer = "svg") %>%
        e_bar(
          serie = valor,
          name = "Quantidade",
          barWidth = "55%",
          legend = FALSE,
          itemStyle = list(
            color = htmlwidgets::JS(
              "new echarts.graphic.LinearGradient(0, 0, 1, 0, [{offset: 0, color: '#FF7676'}, {offset: 1, color: '#C92A2A'}])"
            ),
            borderRadius = c(0, 5, 5, 0)
          )
        ) %>%
        e_labels(
          position = "right",
          fontWeight = "bold",
          fontSize = 15,
          color = "#333",
          formatter = htmlwidgets::JS(
            "function(params) {return Intl.NumberFormat('pt-BR').format(params.value[0]);}"
          )
        ) %>%
        e_tooltip(
          trigger = "item",
          backgroundColor = "rgba(255, 255, 255, 0.95)",
          borderColor = "#C92A2A",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            paste0(
              "
             function(params) {
               var val = Intl.NumberFormat('pt-BR').format(params.value[0]);
               var pct = ((params.value[0]/",
              total_cor,
              ")*100).toFixed(1).replace('.',',') + '%';
               return '<strong style=\"font-size:16px; color:#C92A2A;\">' + params.name + '</strong><br/>Frota: <b>' + val + '</b><br/>Representatividade: <b>' + pct + '</b>';
             }
           "
            )
          )
        ) %>%
        e_y_axis(
          name = "",
          scale = TRUE,
          splitLine = list(show = FALSE),
          axisLine = list(show = FALSE),
          axisTick = list(show = FALSE),
          axisLabel = list(
            color = "#666",
            fontWeight = "bold",
            formatter = htmlwidgets::JS(
              "function (value) { return value >= 1000 ? (value / 1000) + 'k' : value; }"
            )
          )
        ) %>%
        e_x_axis(
          axisLabel = list(
            fontWeight = "bold",
            color = "#444",
            fontSize = 13
          ),
          axisLine = list(lineStyle = list(color = "#ccc")),
          axisTick = list(show = FALSE)
        ) %>%
        e_locale("pt-Br") %>% e_grid(
          show = TRUE,
          width = "75%",
          height = "80%",
          left = "20%"
        ) %>%
        e_animation(duration = 800, easing = "cubicOut") %>% e_toolbox_feature("saveAsImage") %>% e_flip_coords()
    })
    
    #--------------------------------------------------------------------------------------------------------------------------#
    # Tipo de Combustível - Gráfico de Barras----
    titulo3 <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará") {
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Tipo de Combustível dos Veículos Registrados - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      } else{
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Tipo de Combustível dos Veículos Registrados - Região de Integração ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      }
    })
    
    titulo3_clean <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará") {
        paste0("Combustivel_Veiculos_",
               input$local,
               "_",
               input$anolocal)
      } else{
        paste0("Combustivel_Veiculos_RI_",
               input$local,
               "_",
               input$anolocal)
      }
    })
    
    output$txtcombu <- renderText({
      titulo3()
    })
    
    dados_combu <- reactive({
      req(input$local, input$anolocal)
      db05_combustivel_acumulado %>%
        filter(ri == input$local, ano == !!as.numeric(input$anolocal)) %>%
        group_by(ri, categoria) %>%
        summarize(valor = sum(valor, na.rm = T), .groups = 'drop') %>%
        collect() %>%
        arrange(valor) %>%
        mutate(variavel = "Tipo de combustível", ano = input$anolocal) %>%
        select(ri, variavel, categoria, ano, valor)
    })
    
    downset_Server("combudown", dados_combu, titulo3_clean)
    
    output$combubar <- renderEcharts4r({
      df_combu <- dados_combu()
      validate(need(
        nrow(df_combu) > 0,
        "Sem dados de combustível para este filtro."
      ))
      
      total_combu <- sum(df_combu$valor, na.rm = TRUE)
      if (total_combu == 0)
        total_combu <- 1
      
      df_combu %>%
        e_charts(x = categoria, renderer = "svg") %>%
        e_bar(
          serie = valor,
          name = "Quantidade",
          barWidth = "55%",
          legend = FALSE,
          itemStyle = list(
            color = htmlwidgets::JS(
              "new echarts.graphic.LinearGradient(0, 0, 1, 0, [{offset: 0, color: '#6EE7B7'}, {offset: 1, color: '#059669'}])"
            ),
            borderRadius = c(0, 5, 5, 0)
          )
        ) %>%
        e_labels(
          position = "right",
          fontWeight = "bold",
          fontSize = 15,
          color = "#333",
          formatter = htmlwidgets::JS(
            "function(params) {return Intl.NumberFormat('pt-BR').format(params.value[0]);}"
          )
        ) %>%
        e_tooltip(
          trigger = "item",
          backgroundColor = "rgba(255, 255, 255, 0.95)",
          borderColor = "#059669",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            paste0(
              "
             function(params) {
               var val = Intl.NumberFormat('pt-BR').format(params.value[0]);
               var pct = ((params.value[0]/",
              total_combu,
              ")*100).toFixed(1).replace('.',',') + '%';
               return '<strong style=\"font-size:16px; color:#059669;\">' + params.name + '</strong><br/>Frota: <b>' + val + '</b><br/>Representatividade: <b>' + pct + '</b>';
             }
           "
            )
          )
        ) %>%
        e_y_axis(
          name = "",
          scale = TRUE,
          splitLine = list(show = FALSE),
          axisLine = list(show = FALSE),
          axisTick = list(show = FALSE),
          axisLabel = list(
            color = "#666",
            fontWeight = "bold",
            formatter = htmlwidgets::JS(
              "function (value) { return value >= 1000 ? (value / 1000) + 'k' : value; }"
            )
          )
        ) %>%
        e_x_axis(
          axisLabel = list(
            fontWeight = "bold",
            color = "#444",
            fontSize = 13
          ),
          axisLine = list(lineStyle = list(color = "#ccc")),
          axisTick = list(show = FALSE)
        ) %>%
        e_locale("pt-Br") %>% e_grid(
          show = TRUE,
          width = "75%",
          height = "80%",
          left = "20%"
        ) %>%
        e_animation(duration = 800, easing = "cubicOut") %>% e_toolbox_feature("saveAsImage") %>% e_flip_coords()
    })
    
    #--------------------------------------------------------------------------------------------------------------------------#
    # Espécie do Veículo - Gráfico de Barras----
    titulo4 <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará")  {
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Espécie dos Veículos Registrados - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      } else{
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Espécie dos Veículos Registrados - Região de Integração ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      }
    })
    
    titulo4_clean <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará")  {
        paste0("Especie_Veiculos_", input$local, "_", input$anolocal)
      } else{
        paste0("Especie_Veiculos_RI_",
               input$local,
               "_",
               input$anolocal)
      }
    })
    
    output$txtesp <- renderText({
      titulo4()
    })
    
    dados_esp <- reactive({
      req(input$local, input$anolocal)
      db06_especie_veiculo_acumulado %>%
        filter(ri == input$local, ano == !!as.numeric(input$anolocal)) %>%
        group_by(ri, categoria) %>%
        summarize(valor = sum(valor, na.rm = TRUE),
                  .groups = 'drop') %>%
        collect() %>%
        arrange(desc(valor)) %>%
        mutate(variavel = "Espécie de Veículo", ano = input$anolocal) %>%
        select(ri, variavel, categoria, ano, valor)
    })
    
    downset_Server("espdown", dados_esp, titulo4_clean)
    
    output$espbar <- renderEcharts4r({
      df_esp <- dados_esp()
      validate(need(nrow(df_esp) > 0, "Sem dados de espécie para este filtro."))
      
      total_esp <- sum(df_esp$valor, na.rm = TRUE)
      if (total_esp == 0)
        total_esp <- 1
      
      df_esp %>%
        e_charts(x = categoria, renderer = "svg") %>%
        e_bar(
          serie = valor,
          name = "Quantidade",
          barWidth = "45%",
          legend = FALSE,
          itemStyle = list(
            color = htmlwidgets::JS(
              "new echarts.graphic.LinearGradient(0, 1, 0, 0, [{offset: 0, color: '#F6E05E'}, {offset: 1, color: '#D97706'}])"
            ),
            borderRadius = c(5, 5, 0, 0)
          )
        ) %>%
        e_labels(
          position = "top",
          fontWeight = "bold",
          fontSize = 15,
          color = "#333",
          formatter = htmlwidgets::JS(
            "function(params) {return Intl.NumberFormat('pt-BR').format(params.value[1]);}"
          )
        ) %>%
        e_tooltip(
          trigger = "item",
          backgroundColor = "rgba(255, 255, 255, 0.95)",
          borderColor = "#D97706",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            paste0(
              "
             function(params) {
               var val = Intl.NumberFormat('pt-BR').format(params.value[1]);
               var pct = ((params.value[1]/",
              total_esp,
              ")*100).toFixed(1).replace('.',',') + '%';
               return '<strong style=\"font-size:16px; color:#D97706;\">' + params.name + '</strong><br/>Frota: <b>' + val + '</b><br/>Representatividade: <b>' + pct + '</b>';
             }
           "
            )
          )
        ) %>%
        e_y_axis(
          name = "",
          scale = TRUE,
          splitLine = list(lineStyle = list(
            type = "dashed", color = "#eee"
          )),
          axisLine = list(show = FALSE),
          axisTick = list(show = FALSE),
          axisLabel = list(
            color = "#666",
            fontWeight = "bold",
            formatter = htmlwidgets::JS(
              "function (value) { return value >= 1000 ? (value / 1000) + 'k' : value; }"
            )
          )
        ) %>%
        e_x_axis(
          axisLabel = list(
            fontWeight = "bold",
            color = "#444",
            fontSize = 13
          ),
          axisLine = list(lineStyle = list(color = "#ccc")),
          axisTick = list(show = FALSE)
        ) %>%
        e_locale("pt-Br") %>% e_grid(
          show = TRUE,
          width = "80%",
          height = "75%",
          bottom = "15%"
        ) %>%
        e_animation(duration = 800, easing = "cubicOut") %>% e_toolbox_feature("saveAsImage")
    })
    
    #--------------------------------------------------------------------------------------------------------------------------#
    # Nacionalidade do Veículo - Gráfico de Setor----
    titulo5 <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará")  {
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Nacionalidade dos Veículos Registrados - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      } else{
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Nacionalidade dos Veículos Registrados Região de Integração - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      }
    })
    
    titulo5_clean <- reactive({
      req(input$local, input$anolocal)
      if (input$local == "Pará")  {
        paste0("Nacionalidade_Veiculos_",
               input$local,
               "_",
               input$anolocal)
      } else{
        paste0("Nacionalidade_Veiculos_RI_",
               input$local,
               "_",
               input$anolocal)
      }
    })
    
    output$txtnac <- renderText({
      titulo5()
    })
    
    dados_nac <- reactive({
      req(input$local, input$anolocal)
      db07_nacionalidade_acumulado %>%
        filter(ri == input$local, ano == !!as.numeric(input$anolocal)) %>%
        group_by(ri, categoria) %>%
        summarize(valor = sum(valor, na.rm = T), .groups = 'drop') %>%
        collect() %>%
        arrange(valor) %>%
        mutate(ano = input$anolocal,
               percentual = (valor / sum(valor, na.rm = T)) * 100) %>%
        select(ri, categoria, ano, valor, percentual)
    })
    
    downset_Server("nacdown", dados_nac, titulo5_clean)
    
    output$nacpie <- renderEcharts4r({
      df_nac <- dados_nac()
      validate(need(
        nrow(df_nac) > 0,
        "Sem dados de nacionalidade para este filtro."
      ))
      
      df_nac %>%
        e_charts(x = categoria, renderer = "svg") %>%
        e_pie(
          serie = valor,
          radius = c("45%", "70%"),
          itemStyle = list(
            borderRadius = 8,
            borderColor = '#fff',
            borderWidth = 2
          )
        ) %>%
        e_labels(
          position = "outside",
          fontWeight = "bold",
          fontSize = 15,
          color = "#333",
          formatter = htmlwidgets::JS(
            "function(params){ return params.name + '\\n' + params.percent.toFixed(1).replace('.',',') + '%' }"
          )
        ) %>%
        e_color(c("#1D44B8", "#38B2AC", "#FF7676", "#6B46C1")) %>%
        e_tooltip(
          trigger = "item",
          backgroundColor = "rgba(255, 255, 255, 0.95)",
          borderColor = "#1D44B8",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            "
             function(params) {
               var valorFormat = Intl.NumberFormat('pt-BR').format(params.value);
               var pct = params.percent.toFixed(1).replace('.', ',');
               return '<strong style=\"font-size:16px; color:' + params.color + ';\">' + params.name + '</strong><br/>Frota: <b>' + valorFormat + '</b><br/>Representatividade: <b>' + pct + '%</b>';
             }
           "
          )
        ) %>%
        e_legend(
          orient = "horizontal",
          bottom = "5%",
          left = "center",
          textStyle = list(
            fontSize = 14,
            fontWeight = "bold",
            color = "#444"
          )
        ) %>%
        e_animation(duration = 800) %>% e_toolbox_feature("saveAsImage")
    })
    
  })
}

#=====================================================#
# Play do Módulo (COMENTADO PARA PRODUÇÃO)
#=====================================================#
#ui = dashboardPage(
#   header = dashboardHeader(),
#   sidebar = dashboardSidebar(),
#   body = dashboardBody(fluidPage(loc_ui("loc")))
# )
# server <- function(input, output) {
#   loc_Server("loc")
#}

#shinyApp(ui, server)