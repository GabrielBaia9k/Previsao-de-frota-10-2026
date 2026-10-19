#===============================================================================================================#
# Função de UI
total_ui <- function(id) {
  ns <- NS(id)
  
  fluidPage(div(
    class = "navbar_dash",
    
    # --- Caixas de Informação (InfoBoxes) ---
    fluidRow(
      bs4InfoBoxOutput(ns("total_pa_acumulado"), width = 3),
      bs4InfoBoxOutput(ns("total_pa_ano"), width = 3),
      bs4InfoBoxOutput(ns("max_ri"), width = 3),
      bs4InfoBoxOutput(ns("max_tipo"), width = 3)
    ),
    
    tags$br(),
    
    # --- Painel de Filtros Modernizado ---
    fluidRow(
      bs4Dash::box(
        title = tagList(icon("filter"), "Filtros de Análise Geral"),
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
              label = "PARÁ / REGIÕES",
              choices = NULL,
              # Atualizado no Server
              width = "100%"
            )
          ),
          column(
            3,
            selectInput(
              inputId = ns("tipo"),
              label = "TIPOS DE VEÍCULOS",
              choices = NULL,
              width = "100%"
            )
          ),
          column(
            3,
            selectInput(
              inputId = ns("ano"),
              label = "ANO",
              choices = NULL,
              width = "100%"
            )
          ),
          column(
            3,
            tags$label(HTML("&nbsp;")),
            # Alinhamento perfeito do botão
            actionBttn(
              inputId = ns("reset_btn"),
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
    
    #-----------------------------------------------------------------------------------------#
    # --- Mapa e Tabela Lado a Lado ---
    fluidRow(column(
      7,
      bs4Dash::box(
        title = htmlOutput(ns("txt1")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          leafletOutput(ns("map"), width = "100%", height = "600px"),
          type = 8,
          color = "#1D44B8",
          size = 0.8
        ),
        footer = list(
          tags$h6(
            tags$b("Fonte:", style = 'font-family: sans-serif;'),
            "DTI/DETRAN-PA"
          ),
          tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA")
        )
      )
    ), column(
      5,
      bs4Dash::box(
        title = htmlOutput(ns("txt2")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          reactableOutput(ns("tab"), width = "100%", height = "600px"),
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
    )),
    
    # --- Gráficos em Linha ---
    fluidRow(
      # Gráfico de Barras 1
      bs4Dash::box(
        title = htmlOutput(ns("txt3_1")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        fluidRow(column(
          3,
          selectInput(
            inputId = ns("anografbar1"),
            label = "ANO DE REFERÊNCIA",
            choices = NULL,
            width = "100%"
          )
        )),
        withSpinner(
          echarts4rOutput(ns("grafbar1"), width = "100%", height = "500px"),
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
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("grafbardown1")))
          )
        )
      ),
      
      # Gráfico de Barras 2
      bs4Dash::box(
        title = htmlOutput(ns("txt3_2")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        fluidRow(column(
          3,
          selectInput(
            inputId = ns("anografbar2"),
            label = "ANO DE REFERÊNCIA",
            choices = NULL,
            width = "100%"
          )
        )),
        withSpinner(
          echarts4rOutput(ns("grafbar2"), width = "100%", height = "500px"),
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
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("grafbardown2")))
          )
        )
      ),
      
      # Gráfico de Linhas (Comparativo)
      bs4Dash::box(
        title = htmlOutput(ns("txt4")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        fluidRow(column(
          4,
          selectInput(
            inputId = ns("localc1"),
            label = "LOCALIDADE BASE (1)",
            choices = NULL,
            width = "100%"
          )
        ), column(
          4,
          selectInput(
            inputId = ns("localc2"),
            label = "LOCALIDADE PARA COMPARAÇÃO (2)",
            choices = NULL,
            width = "100%"
          )
        )),
        withSpinner(
          echarts4rOutput(ns("graf"), width = "100%", height = "500px"),
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
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("grafdown")))
          )
        )
      ),
      
      # Gráfico Treemap
      bs4Dash::box(
        title = htmlOutput(ns("txt5")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        fluidRow(column(
          3,
          selectInput(
            inputId = ns("anografmap"),
            label = "ANO DE REFERÊNCIA",
            choices = NULL,
            width = "100%"
          )
        )),
        withSpinner(
          echarts4rOutput(ns("graftreemap"), width = "100%", height = "600px"),
          type = 8,
          color = "#6c757d",
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
              tags$h6(tags$b("Elaboração:"), "CNP/Detran-PA", style = "margin-bottom: 0;")
            ),
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("graftreedown")))
          )
        )
      )
    )
  ))
}

#===============================================================================================================#
# Função do modulo servidor

total_Server <- function(id) {
  moduleServer(id, function(input, output, session) {
    #------------------------------------------------------------------------------#
    # 1. INICIALIZAÇÃO RÁPIDA DOS INPUTS 
    updateSelectInput(
      session,
      "local",
      choices = c("Pará", lista_regioes[lista_regioes != "Pará"]),
      selected = "Pará"
    )
    updateSelectInput(session, "tipo", choices = lista_tipos_completa, selected = "Total de Veículos")
    updateSelectInput(session, "ano", choices = lista_anos_acumulado, selected = ano_maximo_global)
    
    updateSelectInput(session,
                      "anografbar1",
                      choices = lista_anos_acumulado,
                      selected = ano_maximo_global)
    updateSelectInput(session,
                      "anografbar2",
                      choices = lista_anos_ano,
                      selected = ano_maximo_global)
    updateSelectInput(session,
                      "anografmap",
                      choices = lista_anos_acumulado,
                      selected = ano_maximo_global)
    
    updateSelectInput(session,
                      "localc1",
                      choices = lista_municipios,
                      selected = "Belém")
    
    
    #------------------------------------------------------------------------------#
    # 2. BOTÃO DE RESET
    observeEvent(input$reset_btn, {
      updateSelectInput(session, "local", selected = "Pará")
      updateSelectInput(session, "tipo", selected = "Total de Veículos")
      updateSelectInput(session, "ano", selected = ano_maximo_global)
      updateSelectInput(session, "anografbar1", selected = ano_maximo_global)
      updateSelectInput(session, "anografbar2", selected = ano_maximo_global)
      updateSelectInput(session, "anografmap", selected = ano_maximo_global)
      updateSelectInput(session, "localc1", selected = "Belém")
      updateSelectInput(session, "localc2", selected = "Selecione um Município")
    })
    
    #-------------------------------------------------------------------------------#
    # 3. INFOBOXES DINÂMICOS
    
    # TOTAL ACUMULADO
    output$total_pa_acumulado <- renderInfoBox({
      req(input$ano, input$local, input$tipo)
      
      base_dados <- if (input$tipo == "Total de Veículos")
        db01_acumulado
      else
        db03_tipo_veiculo_acumulado
      
      if (input$local == "Pará") {
        valor_num <- base_dados %>%
          filter(local == "Pará",
                 ano == !!as.numeric(input$ano),
                 tipo_veiculo == !!input$tipo) %>%
          collect() %>% pull(valor)
      } else {
        valor_num <- base_dados %>%
          filter(
            ri == !!input$local,
            local != "Pará",
            ano == !!as.numeric(input$ano),
            tipo_veiculo == !!input$tipo
          ) %>%
          summarise(total = sum(valor, na.rm = TRUE)) %>%
          collect() %>% pull(total)
      }
      
      valor_num <- if (length(valor_num) > 0)
        valor_num[1]
      else
        0
      titulo_box <- if (input$local == "Pará")
        "PARÁ"
      else
        input$local
      
      bs4InfoBox(
        title = tags$strong(toupper(titulo_box)),
        value = tags$h2(tags$strong(
          prettyNum(
            valor_num,
            big.mark = ".",
            decimal.mark = ",",
            scientific = FALSE
          )
        )),
        subtitle = paste0("FROTA ACUMULADA (", input$tipo, ") - ", input$ano),
        color = "primary",
        fill = TRUE,
        gradient = TRUE,
        iconElevation = 2,
        icon = icon("car")
      )
    })
    
    # TOTAL REGISTRADO NO ANO
    output$total_pa_ano <- renderInfoBox({
      req(input$ano, input$local, input$tipo)
      
      base_dados_ano <- if (input$tipo == "Total de Veículos")
        db01_ano
      else
        db03_tipo_veiculo_ano
      
      if (input$local == "Pará") {
        valor_num <- base_dados_ano %>%
          filter(local == "Pará",
                 ano == !!as.numeric(input$ano),
                 tipo_veiculo == !!input$tipo) %>%
          collect() %>% pull(valor)
      } else {
        valor_num <- base_dados_ano %>%
          filter(
            ri == !!input$local,
            local != "Pará",
            ano == !!as.numeric(input$ano),
            tipo_veiculo == !!input$tipo
          ) %>%
          summarise(total = sum(valor, na.rm = TRUE)) %>%
          collect() %>% pull(total)
      }
      
      valor_num <- if (length(valor_num) > 0)
        valor_num[1]
      else
        0
      titulo_box <- if (input$local == "Pará")
        "PARÁ"
      else
        input$local
      
      bs4InfoBox(
        title = tags$strong(toupper(titulo_box)),
        value = tags$h2(tags$strong(
          prettyNum(
            valor_num,
            big.mark = ".",
            decimal.mark = ",",
            scientific = FALSE
          )
        )),
        subtitle = paste0("NOVOS REGISTROS NO ANO - ", input$ano),
        color = "danger",
        fill = TRUE,
        gradient = TRUE,
        iconElevation = 2,
        icon = icon("calendar-alt")
      )
    })
    
    # DESTAQUE GEOGRÁFICO
    output$max_ri <- renderInfoBox({
      req(input$ano, input$local, input$tipo)
      
      base_dados <- if (input$tipo == "Total de Veículos")
        db01_acumulado
      else
        db03_tipo_veiculo_acumulado
      
      if (input$local == "Pará") {
        valor_max <- base_dados %>%
          filter(
            ri != "Pará",
            local != "Pará",
            ano == !!as.numeric(input$ano),
            tipo_veiculo == !!input$tipo
          ) %>%
          group_by(ri) %>%
          summarise(valor = sum(valor, na.rm = TRUE),
                    .groups = "drop") %>%
          collect() %>% slice_max(valor, n = 1, with_ties = FALSE)
        
        nome_destaque <- if (nrow(valor_max) > 0)
          paste0("RI ", valor_max$ri)
        else
          "N/A"
        valor_destaque <- if (nrow(valor_max) > 0)
          valor_max$valor
        else
          0
        sub_texto <- paste0("RI DE DESTAQUE NO ESTADO - ", input$ano)
      } else {
        valor_max <- base_dados %>%
          filter(
            ri == !!input$local,
            local != "Pará",
            ano == !!as.numeric(input$ano),
            tipo_veiculo == !!input$tipo
          ) %>%
          collect() %>% slice_max(valor, n = 1, with_ties = FALSE)
        
        nome_destaque <- if (nrow(valor_max) > 0)
          valor_max$local
        else
          "N/A"
        valor_destaque <- if (nrow(valor_max) > 0)
          valor_max$valor
        else
          0
        sub_texto <- paste0("MAIOR FROTA DA RI ",
                            toupper(input$local),
                            " - ",
                            input$ano)
      }
      
      bs4InfoBox(
        title = tags$strong(toupper(nome_destaque)),
        value = tags$h2(tags$strong(
          prettyNum(
            valor_destaque,
            big.mark = ".",
            decimal.mark = ",",
            scientific = FALSE
          )
        )),
        subtitle = sub_texto,
        fill = TRUE,
        gradient = TRUE,
        iconElevation = 2,
        color = "success",
        icon = icon("globe")
      )
    })
    
    # TIPO PREDOMINANTE
    output$max_tipo <- renderInfoBox({
      req(input$ano, input$local)
      
      if (input$local == "Pará") {
        valor_max <- db03_tipo_veiculo_acumulado %>%
          filter(
            local == "Pará",
            variavel == "Tipo de Veículo Acumulado",
            ano == !!as.numeric(input$ano),
            tipo_veiculo != "Total de Veículos"
          ) %>%
          collect() %>% slice_max(valor, n = 1, with_ties = FALSE)
      } else {
        valor_max <- db03_tipo_veiculo_acumulado %>%
          filter(
            ri == !!input$local,
            local != "Pará",
            variavel == "Tipo de Veículo Acumulado",
            ano == !!as.numeric(input$ano),
            tipo_veiculo != "Total de Veículos"
          ) %>%
          group_by(tipo_veiculo) %>%
          summarise(valor = sum(valor, na.rm = TRUE),
                    .groups = "drop") %>%
          collect() %>% slice_max(valor, n = 1, with_ties = FALSE)
      }
      
      tipo_nome <- if (nrow(valor_max) > 0)
        valor_max$tipo_veiculo
      else
        "N/A"
      tipo_valor <- if (nrow(valor_max) > 0)
        valor_max$valor
      else
        0
      
      bs4InfoBox(
        title = tags$strong(paste0("TIPO: ", toupper(tipo_nome))),
        value = tags$h2(tags$strong(
          prettyNum(
            tipo_valor,
            big.mark = ".",
            decimal.mark = ",",
            scientific = FALSE
          )
        )),
        subtitle = paste0("PREDOMINANTE EM ", toupper(input$local), " - ", input$ano),
        fill = TRUE,
        gradient = TRUE,
        iconElevation = 2,
        color = "purple",
        icon = icon("chart-bar")
      )
    })
    
    
    #-----------------------------------------------------------------------------------------------------------------#
    # 4. MAPA LEAFLET OTIMIZADO (COM LÓGICA DE CORES OFICIAL DO DETRAN)
    titulo1 <- reactive({
      req(input$local, input$tipo, input$ano)
      localizacao <- if (input$local == "Pará")
        "Pará"
      else
        paste0("Região de Integração ", input$local)
      
      titulo_texto <- if (input$tipo == "Total de Veículos") {
        paste0("Mapa da Frota Registrada - ", localizacao, " - ", input$ano)
      } else {
        paste0("Distribuição de ",
               input$tipo,
               " - ",
               localizacao,
               " - ",
               input$ano)
      }
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin:0;'>",
          titulo_texto,
          "</h4>"
        )
      )
    })
    output$txt1 <- renderText({
      titulo1()
    })
    
    output$map <- renderLeaflet({
      req(input$tipo, input$ano, input$local)
      
      base_dados <- if (input$tipo == "Total de Veículos")
        db01_acumulado
      else
        db03_tipo_veiculo_acumulado
      
      # Coleta os dados filtrados
      df <- base_dados %>%
        filter(ri != "Pará",
               ano == !!as.numeric(input$ano),
               tipo_veiculo == !!input$tipo) %>%
        select(ri, local, ano, valor) %>%
        collect()
      
      # Junta com o shapefile
      x <- left_join(geopa, df, by = c("name_muni" = "local")) %>%
        mutate(valor = replace_na(valor, 0))
      
      if (input$local != "Pará") {
        x <- x %>% filter(ri == input$local)
      }
      
      validate(need(
        nrow(x) > 0 && sum(x$valor, na.rm = TRUE) > 0,
        "Sem dados suficientes para mapear esta região."
      ))
      
      total_mapa <- sum(x$valor, na.rm = TRUE)
      x$percentual <- (x$valor / total_mapa) * 100
      
      # LÓGICA DE CORES IDÊNTICA AO REFERENCIAL (usando classInt)
      z <- x$valor[!is.na(x$valor) & x$valor > 0]
      if (length(z) == 0) z <- 0
      
      bk <- tryCatch(
        unique(suppressWarnings(classInt::classIntervals(z, n = 6, style = "jenks")$brks)),
        error = function(e) pretty(z, 5)
      )
      if (length(bk) < 2) bk <- pretty(z, 5)
      
      x$valor <- ifelse(x$valor == 0, NA, x$valor)
      
      pal <- colorBin(
        palette = c("#B6EDF0", "#74B4E8", "#1F83E0", "#1D44B8", "#090991"),
        domain = x$valor,
        bins = bk,
        na.color = "#E0E0E0"
      )
      
      # Tooltip
      conteudo <- sprintf(
        "<div style='padding: 2px; font-family: sans-serif;'>
           <strong style='font-size: 15px; color: #1D44B8;'>%s</strong><br/>
           <span style='color: #666;'>%s:</span> <strong>%s</strong><br/>
           <span style='color: #666;'>Representatividade:</span> <strong>%s</strong>
         </div>",
        x$name_muni,
        input$tipo,
        ifelse(
          is.na(x$valor),
          "Não disponível",
          format(round(x$valor), big.mark = ".", decimal.mark = ",", nsmall = 0)
        ),
        ifelse(is.na(x$percentual) | x$percentual == 0, "N/A", paste0(
          format(round(x$percentual, 1), nsmall = 1, decimal.mark = ","), "%"
        ))
      ) %>% lapply(htmltools::HTML)
      
      # Renderiza o mapa com estilo exato do painel de infrações
      leaflet(x, options = leafletOptions(
        minZoom = 0,
        maxZoom = 15,
        zoomControl = FALSE
      )) %>%
        addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
        addPolygons(
          weight = 2,
          opacity = 1,
          color = "black",
          fillOpacity = 1,
          fillColor = ~ pal(valor),
          dashArray = "1",
          smoothFactor = 1.5,
          highlightOptions = highlightOptions(
            weight = 3,
            color = "white",
            dashArray = "3",
            fillOpacity = 0.5,
            bringToFront = TRUE
          ),
          label = conteudo,
          labelOptions = labelOptions(
            style = list(
              "box-shadow" = "0 3px 14px rgba(0,0,0,0.4)",
              "border-radius" = "5px",
              padding = "6px 10px"
            ),
            textsize = "14px",
            direction = "auto"
          )
        ) %>%
        addLegend(
          pal = pal,
          values = ~ valor,
          opacity = 0.7,
          title = "Frota",
          position = "bottomright",
          na.label = "Não disponível",
          labFormat = labelFormat_decimal(
            big.mark = ".",
            decimal.mark = ",",
            digits = 2
          )
        )
    })
    
    #-----------------------------------------------------------------------------------------------------------------#
    # 5. TABELA REACTABLE
    titulo2 <- reactive({
      req(input$local, input$tipo, input$ano)
      localizacao <- if (input$local == "Pará")
        "Pará"
      else
        paste0("Região de Integração ", input$local)
      
      titulo_texto <- if (input$tipo == "Total de Veículos") {
        paste0("Tabela da Frota Registrada - ",
               localizacao,
               " - ",
               input$ano)
      } else {
        paste0(
          "Distribuição de ",
          input$tipo,
          " por Município - ",
          ifelse(input$local == "Pará", "", localizacao),
          " - ",
          input$ano
        )
      }
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin:0;'>",
          titulo_texto,
          "</h4>"
        )
      )
    })
    
    titulo2_clean <- reactive({
      req(input$local, input$tipo, input$ano)
      paste0("Frota_", input$local, "_", input$tipo, "_", input$ano)
    })
    
    output$txt2 <- renderText({
      titulo2()
    })
    
    downtab <- reactive({
      req(input$tipo, input$ano, input$local)
      base <- if (input$tipo == "Total de Veículos")
        db01_acumulado
      else
        db03_tipo_veiculo_acumulado
      
      df <- base %>% filter(ri != "Pará",
                            ano == !!as.numeric(input$ano),
                            tipo_veiculo == !!input$tipo)
      if (input$local != "Pará")
        df <- df %>% filter(ri == !!input$local)
      df %>% collect()
    })
    
    downset_Server("tabdown", downtab, titulo2_clean)
    
    output$tab <- renderReactable({
      req(input$tipo, input$ano, input$local)
      
      df <- downtab() %>%
        select(ri, local, valor) %>%
        mutate(Percentual = (valor / sum(valor, na.rm = TRUE)) * 100)
      
      df %>% reactable(
        defaultPageSize = 10,
        striped = FALSE,
        highlight = TRUE,
        bordered = TRUE,
        outlined = TRUE,
        resizable = TRUE,
        showSortable = TRUE,
        pagination = FALSE,
        defaultSorted = list(valor = "desc"),
        columns = list(
          ri = colDef(name = "Região de Integração"),
          local = colDef(name = "Municípios", footer = "Total"),
          valor = colDef(
            name = "Quantidade",
            format = colFormat(separators = TRUE, locales = "pt-BR"),
            aggregate = "sum",
            footer = function(values)
              format(
                sum(values, na.rm = TRUE),
                big.mark = ".",
                decimal.mark = ","
              )
          ),
          Percentual = colDef(
            name = "(%)",
            format = colFormat(
              separators = TRUE,
              locales = "pt-BR",
              digits = 2
            ),
            aggregate = "sum",
            footer = function(values)
              sprintf("%.2f", sum(values, na.rm = TRUE))
          )
        ),
        defaultColDef = colDef(
          na = "-",
          footerStyle = list(fontWeight = "bold"),
          headerStyle = list(background = "#f7f7f8")
        ),
        language = reactableLang(
          noData = "Sem informação",
          pageInfo = "{rowStart} a {rowEnd} de {rows} linhas",
          pagePrevious = "Anterior",
          pageNext = "Próximo"
        )
      )
    })
    
    #-------------------------------------------------------------------------------------------------------------#
    # 6. GRÁFICOS DE BARRAS (ECHARTS4R)
    titulo3_1 <- reactive({
      req(input$anografbar1)
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin:0;'>Frota Geral Registrada por Tipo - ",
          input$anografbar1,
          "</h4>"
        )
      )
    })
    
    titulo3_1_clean <- reactive({
      req(input$anografbar1)
      paste0("Frota_Geral_por_Tipo_", input$anografbar1)
    })
    
    output$txt3_1 <- renderText({
      titulo3_1()
    })
    
    downgrafbar1 <- reactive({
      req(input$anografbar1)
      db03_tipo_veiculo_acumulado %>% filter(local == "Pará", ano == !!as.numeric(input$anografbar1)) %>% collect() %>% arrange(valor)
    })
    
    downset_Server("grafbardown1", downgrafbar1, titulo3_1_clean)
    
    output$grafbar1 <- renderEcharts4r({
      df_grafico <- downgrafbar1()
      validate(need(
        nrow(df_grafico) > 0,
        "Não há registros de veículos para esta combinação de filtros."
      ))
      
      total_frota <- sum(df_grafico$valor, na.rm = TRUE)
      if (total_frota == 0)
        total_frota <- 1
      
      df_grafico %>%
        e_charts(tipo_veiculo, renderer = "svg") %>%
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
          backgroundColor = "rgba(255, 255, 255, 0.9)",
          borderColor = "#1D44B8",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            paste0(
              "
             function(params) {
               var valorFormatado = Intl.NumberFormat('pt-BR').format(params.value[0]);
               var total = ",
              total_frota,
              ";
               var calcPercentual = ((params.value[0] / total) * 100).toFixed(1).replace('.', ',') + '%';
               return '<strong style=\"font-size:16px; color:#1D44B8;\">' + params.name + '</strong><br/>' +
                      'Frota Registrada: <b>' + valorFormatado + '</b><br/>' +
                      'Representatividade: <b>' + calcPercentual + '</b>';
             }
           "
            )
          )
        ) %>%
        e_y_axis(
          name = "",
          scale = TRUE,
          splitNumber = 6,
          axisLabel = list(
            color = "#666",
            fontWeight = "bold",
            formatter = htmlwidgets::JS(
              "function (value, index) { return value >= 1000 ? (value / 1000) + 'k' : value; }"
            )
          ),
          splitLine = list(show = FALSE),
          axisLine = list(show = FALSE),
          axisTick = list(show = FALSE)
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
        e_locale("pt-Br") %>%
        e_grid(
          show = TRUE,
          width = "75%",
          height = "80%",
          left = "20%"
        ) %>%
        e_animation(duration = 1000, easing = "cubicOut") %>%
        e_toolbox_feature("saveAsImage", title = "Salvar") %>%
        e_toolbox_feature("dataZoom", title = "Zoom") %>%
        e_flip_coords()
    })
    
    # GRAFICO DE BARRAS 2
    titulo3_2 <- reactive({
      req(input$anografbar2)
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin:0;'>Novos Registros por Tipo - ",
          input$anografbar2,
          "</h4>"
        )
      )
    })
    
    titulo3_2_clean <- reactive({
      req(input$anografbar2)
      paste0("Novos_Registros_por_Tipo_", input$anografbar2)
    })
    
    output$txt3_2 <- renderText({
      titulo3_2()
    })
    
    downgrafbar2 <- reactive({
      req(input$anografbar2)
      db03_tipo_veiculo_ano %>% filter(local == "Pará", ano == !!as.numeric(input$anografbar2)) %>% collect() %>% arrange(valor)
    })
    
    downset_Server("grafbardown2", downgrafbar2, titulo3_2_clean)
    
    output$grafbar2 <- renderEcharts4r({
      df_grafico2 <- downgrafbar2()
      total_frota2 <- sum(df_grafico2$valor, na.rm = TRUE)
      if (total_frota2 == 0)
        total_frota2 <- 1
      
      df_grafico2 %>%
        e_charts(tipo_veiculo, renderer = "svg") %>%
        e_bar(
          serie = valor,
          name = "Quantidade",
          barWidth = "65%",
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
          color = "#333333",
          formatter = htmlwidgets::JS(
            "function(params) {return Intl.NumberFormat('pt-BR', { style: 'decimal'}).format(params.value[0]);}"
          )
        ) %>%
        e_tooltip(
          trigger = "item",
          backgroundColor = "rgba(255, 255, 255, 0.9)",
          borderColor = "#C92A2A",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            paste0(
              "
             function(params) {
               var valorFormatado = Intl.NumberFormat('pt-BR').format(params.value[0]);
               var total = ",
              total_frota2,
              ";
               var calcPercentual = ((params.value[0] / total) * 100).toFixed(1).replace('.', ',') + '%';
               return '<strong style=\"font-size:16px; color:#C92A2A;\">' + params.name + '</strong><br/>' +
                      'Novos Registros: <b>' + valorFormatado + '</b><br/>' +
                      'Representatividade: <b>' + calcPercentual + '</b>';
             }
           "
            )
          )
        ) %>%
        e_y_axis(
          name = "",
          scale = TRUE,
          splitNumber = 6,
          axisLabel = list(
            color = "#666",
            fontWeight = "bold",
            formatter = htmlwidgets::JS(
              "function (value, index) { return value >= 1000 ? (value / 1000) + 'k' : value; }"
            )
          ),
          splitLine = list(show = FALSE),
          axisLine = list(show = FALSE),
          axisTick = list(show = FALSE)
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
        e_locale("pt-Br") %>%
        e_grid(
          show = TRUE,
          width = "75%",
          height = "80%",
          left = "20%"
        ) %>%
        e_animation(duration = 1000, easing = "cubicOut") %>%
        e_toolbox_feature("saveAsImage", title = "Salvar") %>%
        e_toolbox_feature("dataZoom", title = "Zoom") %>%
        e_flip_coords()
    })
    
    #-------------------------------------------------------------------------------------------------#
    # 7. GRÁFICO DE EVOLUÇÃO (LINHA CRUZADA OTIMIZADA)
    
    observeEvent(input$localc1, {
      updateSelectInput(
        inputId = "localc2",
        choices = c("Selecione um Município", lista_municipios[lista_municipios != input$localc1]),
        session
      )
    })
    
    titulo4_total_server <- reactive({
      req(input$localc1, input$localc2)
      min_ano <- min(lista_anos_acumulado, na.rm = T)
      max_ano <- max(lista_anos_acumulado, na.rm = T)
      
      titulo_texto <- if (input$localc2 == "Selecione um Município") {
        paste0(
          "Evolução Histórica da Frota Geral, ",
          input$localc1,
          " (",
          min_ano,
          " - ",
          max_ano,
          ")"
        )
      } else {
        paste0(
          "Evolução Histórica da Frota Geral, ",
          input$localc1,
          " vs ",
          input$localc2,
          " (",
          min_ano,
          " - ",
          max_ano,
          ")"
        )
      }
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin:0;'>",
          titulo_texto,
          "</h4>"
        )
      )
    })
    
    titulo4_total_server_clean <- reactive({
      req(input$localc1, input$localc2)
      if (input$localc2 == "Selecione um Município") {
        paste0("Evolucao_Frota_", input$localc1)
      } else {
        paste0("Evolucao_Frota_",
               input$localc1,
               "_x_",
               input$localc2)
      }
    })
    
    output$txt4 <- renderText({
      titulo4_total_server()
    })
    
    downgraf <- reactive({
      req(input$localc1, input$localc2)
      if (input$localc2 == "Selecione um Município") {
        db01_acumulado %>%
          filter(local == !!input$localc1) %>%
          collect() %>% rename(regiao_integracao = ri)
      } else {
        db01_acumulado %>%
          filter(local %in% c(input$localc1, input$localc2)) %>%
          collect() %>% rename(regiao_integracao = ri)
      }
    })
    
    downset_Server("grafdown", downgraf, titulo4_total_server_clean)
    
    output$graf <- renderEcharts4r({
      req(input$localc1, input$localc2)
      
      a <- db01_acumulado %>% filter(local == !!input$localc1) %>% collect() %>% mutate(valor = replace_na(valor, 0))
      
      grafico <- a %>% e_charts(x = ano, renderer = "svg") %>%
        e_tooltip(
          trigger = "axis",
          axisPointer = list(
            type = "cross",
            label = list(backgroundColor = "#1D44B8")
          ),
          backgroundColor = "rgba(255, 255, 255, 0.95)",
          borderColor = "#ccc",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            "
             function(params) {
               var ano = params[0].value[0];
               var html = '<strong style=\"font-size:16px; color:#333;\">Ano Histórico: ' + ano + '</strong><br/><div style=\"margin-top: 5px;\">';
               if (params.length === 1) {
                 var valor = Intl.NumberFormat('pt-BR').format(params[0].value[1]);
                 html += params[0].marker + ' ' + params[0].seriesName + ': <b>' + valor + '</b><br/>';
               } else if (params.length > 1) {
                 var val1 = params[0].value[1] || 0;
                 var val2 = params[1].value[1] || 0;
                 var diferenca = Math.abs(val1 - val2);
                 html += params[0].marker + ' ' + params[0].seriesName + ': <b style=\"color:#1D44B8;\">' + Intl.NumberFormat('pt-BR').format(val1) + '</b><br/>';
                 html += params[1].marker + ' ' + params[1].seriesName + ': <b style=\"color:#C92A2A;\">' + Intl.NumberFormat('pt-BR').format(val2) + '</b><br/>';
                 html += '<hr style=\"margin: 8px 0; border: 0; border-top: 1px dashed #aaa;\"/>';
                 html += '<span style=\"color:#555; font-size:13px;\">Diferença de Frota: <b>' + Intl.NumberFormat('pt-BR').format(diferenca) + '</b> veículos</span>';
               }
               html += '</div>';
               return html;
             }
           "
          )
        ) %>%
        e_x_axis(
          axisLabel = list(
            show = TRUE,
            fontSize = 14,
            fontWeight = "bold",
            color = "#444"
          ),
          name = "",
          splitLine = list(show = FALSE)
        ) %>%
        e_locale("pt-Br") %>%
        e_grid(
          show = TRUE,
          left = "10%",
          right = "20%",
          bottom = "15%"
        ) %>%
        e_datazoom(
          type = "slider",
          toolbox = FALSE,
          fillerColor = "rgba(29, 68, 184, 0.15)",
          selectedDataBackground = list(lineStyle = list(color = "#1D44B8"))
        ) %>%
        e_toolbox_feature("saveAsImage", title = "Salvar") %>%
        e_toolbox_feature("dataZoom", title = "Zoom")
      
      if (input$localc2 == "Selecione um Município") {
        grafico %>%
          e_line(
            serie = valor,
            name = input$localc1,
            color = "#1D44B8",
            symbol = "none",
            smooth = TRUE,
            lineStyle = list(width = 4),
            areaStyle = list(opacity = 0.15),
            endLabel = list(
              show = TRUE,
              formatter = "{a}",
              fontWeight = "bold",
              fontSize = 15,
              color = "#1D44B8"
            )
          ) %>%
          e_legend(show = FALSE) %>%
          e_y_axis(
            name = "",
            scale = TRUE,
            splitLine = list(lineStyle = list(
              type = "dashed", color = "#eee"
            )),
            axisLine = list(show = FALSE),
            axisTick = list(show = FALSE),
            axisLabel = list(
              fontWeight = "bold",
              color = "#666",
              formatter = htmlwidgets::JS(
                "function (value) { return value >= 1000 ? (value / 1000) + 'k' : value; }"
              )
            )
          )
      } else {
        b <- db01_acumulado %>% filter(local == !!input$localc2) %>% collect() %>% mutate(valor = replace_na(valor, 0))
        grafico %>%
          e_line(
            serie = valor,
            name = input$localc1,
            color = "#1D44B8",
            symbol = "none",
            smooth = TRUE,
            lineStyle = list(width = 4),
            areaStyle = list(opacity = 0.15),
            endLabel = list(
              show = TRUE,
              formatter = "{a}",
              fontWeight = "bold",
              fontSize = 15,
              color = "#1D44B8"
            )
          ) %>%
          e_data(b, ano) %>%
          e_line(
            serie = valor,
            name = input$localc2,
            color = "#C92A2A",
            symbol = "none",
            smooth = TRUE,
            lineStyle = list(width = 4),
            areaStyle = list(opacity = 0.15),
            endLabel = list(
              show = TRUE,
              formatter = "{a}",
              fontWeight = "bold",
              fontSize = 15,
              color = "#C92A2A"
            )
          ) %>%
          e_legend(show = FALSE) %>%
          e_y_axis(
            name = "",
            scale = TRUE,
            splitLine = list(lineStyle = list(
              type = "dashed", color = "#eee"
            )),
            axisLine = list(show = FALSE),
            axisTick = list(show = FALSE),
            axisLabel = list(
              fontWeight = "bold",
              color = "#666",
              formatter = htmlwidgets::JS(
                "function (value) { return value >= 1000 ? (value / 1000) + 'k' : value; }"
              )
            )
          )
      }
    })
    
    #-------------------------------------------------------------------------------------------------#
    # 8. GRÁFICO TREEMAP HIERÁRQUICO
    titulo5_total_server <- reactive({
      req(input$anografmap)
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin:0;'>Distribuição da Frota por Região e Município - ",
          input$anografmap,
          "</h4>"
        )
      )
    })
    
    titulo5_total_server_clean <- reactive({
      req(input$anografmap)
      paste0("Treemap_Frota_", input$anografmap)
    })
    
    output$txt5 <- renderText({
      titulo5_total_server()
    })
    
    downgraftreemap <- reactive({
      req(input$anografmap)
      db01_acumulado %>% filter(ri != "Pará", ano == !!as.numeric(input$anografmap)) %>% collect()
    })
    
    downset_Server("graftreedown",
                   downgraftreemap,
                   titulo5_total_server_clean)
    
    output$graftreemap <- renderEcharts4r({
      req(input$anografmap)
      
      dados_basicos <- downgraftreemap()
      dados_filhos <- dados_basicos %>% select(ri, name = local, value = valor) %>% group_by(ri) %>% nest(children = c(name, value))
      dados_pais <- dados_basicos %>% group_by(ri) %>% summarise(value = sum(valor, na.rm = TRUE),
                                                                 .groups = 'drop') %>% rename(name = ri)
      dados_hierarquicos <- left_join(dados_pais, dados_filhos, by = c("name" = "ri"))
      
      dados_hierarquicos %>%
        e_charts(renderer = "svg") %>%
        e_treemap(
          upperLabel = list(
            show = TRUE,
            height = 35,
            color = "#FFFFFF",
            fontWeight = "bold",
            fontSize = 14,
            backgroundColor = "#1D44B8"
          ),
          label = list(
            show = TRUE,
            fontSize = 13,
            fontWeight = "bold",
            formatter = htmlwidgets::JS(
              "
             function(params) {
               var valor = params.value;
               var formatado = valor >= 1000 ? (valor / 1000).toFixed(1).replace('.', ',') + 'k' : valor;
               return params.name + '\\n' + formatado;
             }
           "
            )
          ),
          leafDepth = 1,
          roam = "move",
          itemStyle = list(
            borderWidth = 2,
            borderColor = "#FFFFFF",
            gapWidth = 2
          ),
          breadcrumb = list(
            show = TRUE,
            itemStyle = list(color = "#74B4E8"),
            textStyle = list(color = "#333", fontWeight = "bold")
          )
        ) %>%
        e_tooltip(
          trigger = "item",
          backgroundColor = "rgba(255, 255, 255, 0.95)",
          borderColor = "#1D44B8",
          textStyle = list(color = "#333"),
          formatter = htmlwidgets::JS(
            "
             function(params) {
               var valorFormat = Intl.NumberFormat('pt-BR').format(params.value);
               var treePath = params.treePathInfo;

               if (treePath.length === 2) {
                 return '<b style=\"color:#1D44B8; font-size:16px;\">Região: ' + params.name + '</b><br/>Frota Total: <b>' + valorFormat + '</b> veículos';
               }
               if (treePath.length === 3) {
                 var nomeRegiao = treePath[1].name;
                 var totalRegiao = treePath[1].value;
                 var percentualRegiao = ((params.value / totalRegiao) * 100).toFixed(1).replace('.', ',') + '%';

                 return '<b style=\"color:#1D44B8; font-size:16px;\">' + params.name + '</b><br/><span style=\"color:#666; font-size:12px;\">Região: ' + nomeRegiao + '</span><br/><hr style=\"margin: 6px 0; border-top: 1px dashed #ccc;\"/>Frota Registrada: <b>' + valorFormat + '</b><br/>Fatia da Região: <b>' + percentualRegiao + '</b>';
               }
               return params.name;
             }
           "
          )
        ) %>%
        e_toolbox_feature("saveAsImage", title = "Salvar") %>%
        e_toolbox_feature("restore", title = "Restaurar Visão")
    })
    
  })
}

#=======================================================================================================#
# Play do Módulo (Comentado para não dar conflito com o App Global)
#=======================================================================================================#
#ui = dashboardPage(
#    header = dashboardHeader(),
#    sidebar = dashboardSidebar(),
#    body = dashboardBody(fluidPage(total_ui("total")))
#    )

# server <- function(input, output) {
#    total_Server("total")
# }
#shinyApp(ui, server)