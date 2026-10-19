tipo_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    fluidRow(
      bs4Dash::box(
        title = tagList(icon("filter"), "Filtros Dinâmicos por Tipo"),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        collapsible = TRUE,
        width = 12,
        fluidRow(
          column(
            3,
            selectInput(
              inputId = ns("tipo"),
              label = "TIPO DE VEÍCULO",
              choices = NULL,
              width = "100%"
            )
          ),
          column(
            3,
            popover(
              title = "Filtro Dinâmico",
              selectInput(
                inputId = ns("ano"),
                label = "ANO",
                choices = NULL,
                width = "100%"
              ),
              placement = "right",
              content = "A lista de anos está condicionada à ocorrência do licenciamento do tipo de veículo. Por exemplo, se um carro foi licenciado em 2020, esse ano específico estará disponível para seleção."
            )
          ),
          column(4),
          column(
            2,
            tags$label(HTML("&nbsp;")),
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
    fluidRow(
      bs4Dash::box(
        title = htmlOutput(ns("txtgeral")),
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        status = "primary",
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
    fluidRow(
      bs4Dash::box(
        title = htmlOutput(ns("txtcat")),
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        status = "primary",
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
      bs4Dash::box(
        title = htmlOutput(ns("txtcor")),
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        status = "primary",
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          echarts4rOutput(ns("corbar"), width = "100%", height = "500px"),
          type = 8,
          color = "#dc3545",
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
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("cordown")))
          )
        )
      ),
      bs4Dash::box(
        title = htmlOutput(ns("txtcombu")),
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        status = "primary",
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
      bs4Dash::box(
        title = htmlOutput(ns("txtesp")),
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        status = "primary",
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
      bs4Dash::box(
        title = htmlOutput(ns("txtnac")),
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        status = "primary",
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

tipo_Server <- function(id) {
  moduleServer(id, function(input, output, session) {
    updateSelectInput(session, "tipo", choices = lista_tipo_outros)
    
    anotipo <- reactive({
      req(input$tipo)
      frota_acumulado %>%
        filter(tipo_veiculo == !!input$tipo, valor > 0) %>%
        select(ano) %>% distinct() %>% collect()
    })
    
    observeEvent(anotipo(), {
      choices <- sort(unique(anotipo()[["ano"]]), decreasing = TRUE)
      updateSelectInput(inputId = "ano", choices = choices, session)
    })
    
    observeEvent(input$reset_filtros, {
      freezeReactiveValue(input, "tipo")
      updateSelectInput(session, "tipo", selected = lista_tipo_outros[1])
    })
    
    dados_cat <- reactive({
      req(input$tipo, input$ano)
      db08_tipo_vs_categoria_acumulado %>% filter(tipo_veiculo == input$tipo, ano == as.numeric(input$ano)) %>% collect() %>% filter(!is.na(valor) &
                                                                                                                                       valor > 0) %>% arrange(valor)
    })
    dados_cor <- reactive({
      req(input$tipo, input$ano)
      db09_tipo_vs_cor_pa_acumulado %>% filter(tipo_veiculo == input$tipo, ano == as.numeric(input$ano)) %>% collect() %>% filter(!is.na(valor) &
                                                                                                                                    valor > 0) %>% arrange(valor)
    })
    dados_combu <- reactive({
      req(input$tipo, input$ano)
      db10_tipo_vs_combustivel_pa_acumulado %>% filter(tipo_veiculo == input$tipo, ano == as.numeric(input$ano)) %>% collect() %>% filter(!is.na(valor) &
                                                                                                                                            valor > 0) %>% arrange(valor)
    })
    dados_esp <- reactive({
      req(input$tipo, input$ano)
      db11_tipo_vs_especie_pa_acumulado %>% filter(tipo_veiculo == input$tipo, ano == as.numeric(input$ano)) %>% collect() %>% filter(!is.na(valor) &
                                                                                                                                        valor > 0) %>% arrange(valor)
    })
    dados_nac <- reactive({
      req(input$tipo, input$ano)
      db12_tipo_vs_nacionalide_pa_acumulado %>% filter(tipo_veiculo == input$tipo, ano == as.numeric(input$ano)) %>% collect() %>% filter(!is.na(valor) &
                                                                                                                                            valor > 0) %>% arrange(desc(valor))
    })
    
    titulo6 <- reactive({
      req(input$tipo, input$ano)
      HTML(
        paste0(
          "<h4 style='text-align: center; font-weight: bold; margin: 0;'> Tabela - Resumo dos Veículos Registrados do tipo ",
          toupper(input$tipo),
          " - ",
          input$ano,
          "</h4>"
        )
      )
    })
    
    titulo6_clean <- reactive({
      req(input$tipo, input$ano)
      paste0("Resumo_Veiculos_Tipo_", input$tipo, "_", input$ano)
    })
    
    output$txtgeral <- renderText({
      titulo6()
    })
    
    base_tabela_perfil <- reactive({
      req(input$tipo, input$ano)
      
      get_lider <- function(df_hub, nome_variavel) {
        if (nrow(df_hub) == 0)
          return(data.frame())
        total_hub <- sum(df_hub$valor, na.rm = TRUE)
        df_hub %>%
          slice_max(valor, n = 1, with_ties = FALSE) %>%
          mutate(variavel = nome_variavel,
                 Percentual = (valor / total_hub) * 100) %>%
          select(variavel, categoria, valor, Percentual)
      }
      
      bind_rows(
        get_lider(dados_cat(), "Categoria"),
        get_lider(dados_cor(), "Cor"),
        get_lider(dados_combu(), "Combustível"),
        get_lider(dados_esp(), "Espécie"),
        get_lider(dados_nac(), "Nacionalidade")
      ) %>% mutate(tipo_veiculo = input$tipo, ano = input$ano)
    })
    
    downset_Server("tabdown", base_tabela_perfil, titulo6_clean)
    
    output$tab <- renderReactable({
      df <- base_tabela_perfil()
      validate(need(nrow(df) > 0, "Sem dados para esta tabela."))
      
      df[1, 1] <- "Categoria do Veículo"
      df[2, 1] <- "Cor do Veículo"
      df[3, 1] <- "Tipo de Combustível"
      df[4, 1] <- "Espécie de Veículo"
      df[5, 1] <- "Nacionalidade do Veículo"
      
      cores_linhas <- c("blue", "red", "green", "orange", "grey")
      
      icones_linhas <- c("layer-group", "palette", "gas-pump", "tags", "globe")
      
      df %>% reactable(
        defaultPageSize = 5,
        pagination = FALSE,
        highlight = TRUE,
        borderless = TRUE,
        theme = reactableTheme(
          headerStyle = list(
            backgroundColor = "white",
            color = "black",
            fontWeight = "bold",
            fontSize = "15px"
          ),
          cellStyle = list(
            fontSize = "14px",
            display = "flex",
            alignItems = "center"
          )
        ),
        columns = list(
          tipo_veiculo = colDef(show = FALSE),
          ano = colDef(show = FALSE),
          variavel = colDef(
            name = "CARACTERÍSTICAS",
            minWidth = 180,
            style = list(fontWeight = "bold", 
                         color = "black",
                         align = "left"
                         ),
            cell = function(value, index) {
              icone <- icones_linhas[index]
              cor <- cores_linhas[index]
              tags$div(style = "display: flex; align-items: center; gap: 10px;",
                       tags$i(
                         class = paste0("fa fa-", icone),
                         style = paste0(
                           "color: ",
                           cor,
                           "; font-size: 18px; width: 25px; text-align: center;"
                         )
                       ),
                       tags$span(value))
            }
          ),
          categoria = colDef(name = "PREDOMINÂNCIA", 
                             style = list(fontWeight = "bold", 
                                          color = "black",
                                          align = "center")
                             ),
          valor = colDef(
            name = "QUANTIDADE",
            minWidth = 120,
            style = list(fontWeight = "bold", 
                         color = "black",
                         align = "center"),
            format = colFormat(separators = TRUE, locales = "pt-BR")
          ),
          Percentual = colDef(
            name = "REPRESENTATIVIDADE (%)",
            minWidth = 220,
            align = "center",
            cell = function(value, index) {
              css_width <- paste0(gsub(",", ".", as.character(value)), "%")
              cor_barra <- cores_linhas[index]
              bar <- tags$div(
                style = paste0(
                  "background: ",
                  cor_barra,
                  "; width: ",
                  css_width,
                  "; height: 16px; border-radius: 4px;"
                )
              )
              tags$div(
                style = "display: flex; align-items: center; gap: 10px; width: 100%;",
                tags$div(style = "flex-grow: 1; background: #e9ecef; border-radius: 4px;", bar),
                tags$div(style = "width: 45px; text-align: right; font-weight: bold; color: #333;", paste0(
                  formatC(
                    value,
                    format = "f",
                    digits = 1,
                    dec = ","
                  ), "%"
                ))
              )
            }
          )
        )
      )
    })
    
    titulo1 <- reactive({
      req(input$ano, input$tipo)
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Categorias dos Veículos do tipo ",
          toupper(input$tipo),
          " - ",
          input$ano,
          "</h4>"
        )
      )
    })
    
    titulo1_clean <- reactive({
      req(input$ano, input$tipo)
      paste0("Categorias_Por_Tipo_", input$tipo, "_", input$ano)
    })
    
    output$txtcat <- renderText({
      titulo1()
    })
    
    downset_Server("catdown", dados_cat, titulo1_clean)
    
    output$catbar <- renderEcharts4r({
      df_cat <- dados_cat()
      validate(need(nrow(df_cat) > 0, "Sem dados de categorias."))
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
              "new echarts.graphic.LinearGradient(0, 0, 1, 0, [{offset: 0, color: '#74B4E8'}, {offset: 1, color: '#17a2b8'}])"
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
          backgroundColor = "rgba(255,255,255,0.95)",
          borderColor = "#17a2b8",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            paste0(
              "function(params) { var val = Intl.NumberFormat('pt-BR').format(params.value[0]); var pct = ((params.value[0]/",
              total_cat,
              ")*100).toFixed(1).replace('.',',') + '%'; return '<strong style=\"font-size:16px; color:#17a2b8;\">' + params.name + '</strong><br/>Frota: <b>' + val + '</b><br/>Representatividade: <b>' + pct + '</b>'; }"
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
              "function(value){ return value >= 1000 ? (value/1000) + 'k' : value; }"
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
          left = "20%",
          right = "15%",
          bottom = "15%"
        ) %>% e_animation(duration = 800) %>% e_toolbox_feature("saveAsImage") %>% e_flip_coords()
    })
    
    titulo2 <- reactive({
      req(input$ano, input$tipo)
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Cores dos Veículos do tipo ",
          toupper(input$tipo),
          " - ",
          input$ano,
          "</h4>"
        )
      )
    })
    
    titulo2_clean <- reactive({
      req(input$ano, input$tipo)
      paste0("Cores_Por_Tipo_", input$tipo, "_", input$ano)
    })
    
    output$txtcor <- renderText({
      titulo2()
    })
    
    downset_Server("cordown", dados_cor, titulo2_clean)
    
    output$corbar <- renderEcharts4r({
      df_cor <- dados_cor()
      validate(need(nrow(df_cor) > 0, "Sem dados de cores."))
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
              "new echarts.graphic.LinearGradient(0, 0, 1, 0, [{offset: 0, color: '#FF7676'}, {offset: 1, color: '#dc3545'}])"
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
          backgroundColor = "rgba(255,255,255,0.95)",
          borderColor = "#dc3545",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            paste0(
              "function(params) { var val = Intl.NumberFormat('pt-BR').format(params.value[0]); var pct = ((params.value[0]/",
              total_cor,
              ")*100).toFixed(1).replace('.',',') + '%'; return '<strong style=\"font-size:16px; color:#dc3545;\">' + params.name + '</strong><br/>Frota: <b>' + val + '</b><br/>Representatividade: <b>' + pct + '</b>'; }"
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
              "function(value){ return value >= 1000 ? (value/1000) + 'k' : value; }"
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
          left = "20%",
          right = "15%",
          bottom = "15%"
        ) %>% e_animation(duration = 800) %>% e_toolbox_feature("saveAsImage") %>% e_flip_coords()
    })
    
    titulo3 <- reactive({
      req(input$ano, input$tipo)
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Combustível utilizado pelos Veículos do tipo ",
          toupper(input$tipo),
          " - ",
          input$ano,
          "</h4>"
        )
      )
    })
    
    titulo3_clean <- reactive({
      req(input$ano, input$tipo)
      paste0("Combustivel_Por_Tipo_", input$tipo, "_", input$ano)
    })
    
    output$txtcombu <- renderText({
      titulo3()
    })
    
    downset_Server("combudown", dados_combu, titulo3_clean)
    
    output$combubar <- renderEcharts4r({
      df_combu <- dados_combu()
      validate(need(nrow(df_combu) > 0, "Sem dados de combustível."))
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
              "new echarts.graphic.LinearGradient(0, 0, 1, 0, [{offset: 0, color: '#6EE7B7'}, {offset: 1, color: '#28a745'}])"
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
          backgroundColor = "rgba(255,255,255,0.95)",
          borderColor = "#28a745",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            paste0(
              "function(params) { var val = Intl.NumberFormat('pt-BR').format(params.value[0]); var pct = ((params.value[0]/",
              total_combu,
              ")*100).toFixed(1).replace('.',',') + '%'; return '<strong style=\"font-size:16px; color:#28a745;\">' + params.name + '</strong><br/>Frota: <b>' + val + '</b><br/>Representatividade: <b>' + pct + '</b>'; }"
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
              "function(value){ return value >= 1000 ? (value/1000) + 'k' : value; }"
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
          left = "20%",
          right = "15%",
          bottom = "15%"
        ) %>% e_animation(duration = 800) %>% e_toolbox_feature("saveAsImage") %>% e_flip_coords()
    })
    
    titulo4 <- reactive({
      req(input$ano, input$tipo)
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Espécie dos Veículos do tipo ",
          toupper(input$tipo),
          " - ",
          input$ano,
          "</h4>"
        )
      )
    })
    
    titulo4_clean <- reactive({
      req(input$ano, input$tipo)
      paste0("Especie_Por_Tipo_", input$tipo, "_", input$ano)
    })
    
    output$txtesp <- renderText({
      titulo4()
    })
    
    downset_Server("espdown", dados_esp, titulo4_clean)
    
    output$espbar <- renderEcharts4r({
      df_esp <- dados_esp()
      validate(need(nrow(df_esp) > 0, "Sem dados de espécie."))
      total_esp <- sum(df_esp$valor, na.rm = TRUE)
      if (total_esp == 0)
        total_esp <- 1
      
      df_esp %>%
        e_charts(x = categoria, renderer = "svg") %>%
        e_bar(
          serie = valor,
          name = "Quantidade",
          barWidth = "55%",
          legend = FALSE,
          itemStyle = list(
            color = htmlwidgets::JS(
              "new echarts.graphic.LinearGradient(0, 1, 0, 0, [{offset: 0, color: '#F6E05E'}, {offset: 1, color: '#ffc107'}])"
            ),
            borderRadius = c(5, 5, 0, 0)
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
          backgroundColor = "rgba(255,255,255,0.95)",
          borderColor = "#ffc107",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            paste0(
              "function(params) { var val = Intl.NumberFormat('pt-BR').format(params.value[0]); var pct = ((params.value[1]/",
              total_esp,
              ")*100).toFixed(1).replace('.',',') + '%'; return '<strong style=\"font-size:16px; color:#ffc107;\">' + params.name + '</strong><br/>Frota: <b>' + val + '</b><br/>Representatividade: <b>' + pct + '</b>'; }"
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
              "function(value){ return value >= 1000 ? (value/1000) + 'k' : value; }"
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
          left = "20%",
          right = "15%",
          bottom = "15%"
        ) %>% e_animation(duration = 800) %>% e_toolbox_feature("saveAsImage") %>% e_flip_coords()
    })
    
    titulo5 <- reactive({
      req(input$ano, input$tipo)
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin: 0;'>Nacionalidade dos Veículos do tipo ",
          toupper(input$tipo),
          " - ",
          input$ano,
          "</h4>"
        )
      )
    })
    
    titulo5_clean <- reactive({
      req(input$ano, input$tipo)
      paste0("Nacionalidade_Por_Tipo_", input$tipo, "_", input$ano)
    })
    
    output$txtnac <- renderText({
      titulo5()
    })
    
    downset_Server("nacdown", dados_nac, titulo5_clean)
    
    output$nacpie <- renderEcharts4r({
      df_nac <- dados_nac()
      validate(need(nrow(df_nac) > 0, "Sem dados de nacionalidade."))
      
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
        e_color(c("#6c757d", "#38B2AC", "#FF7676", "#1D44B8")) %>%
        e_tooltip(
          trigger = "item",
          backgroundColor = "rgba(255, 255, 255, 0.95)",
          borderColor = "#6c757d",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            "function(params) { var valorFormat = Intl.NumberFormat('pt-BR').format(params.value); var pct = params.percent.toFixed(1).replace('.', ','); return '<strong style=\"font-size:16px; color:' + params.color + ';\">' + params.name + '</strong><br/>Frota: <b>' + valorFormat + '</b><br/>Representatividade: <b>' + pct + '%</b>'; }"
          )
        ) %>%
        e_legend(
          orient = "horizontal",
          bottom = "0%",
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
#ui = dashboardPage(header = dashboardHeader(),
#                   sidebar = dashboardSidebar(),
#                   body = dashboardBody(fluidPage(tipo_ui("tipo"))))

#server <- function(input, output) {
#  tipo_Server("tipo")
#}

#shinyApp(ui, server)
