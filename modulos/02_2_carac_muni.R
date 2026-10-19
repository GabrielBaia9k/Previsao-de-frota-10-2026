#===============================================================================================================#
# Funções de módulo de Demografia Municipal
# Função de UI
#===============================================================================================================#

muni_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    #------------------------------------------------------------------------------#
    # 1. Cartões de Resumo (InfoBoxes) - TOPO
    fluidRow(
      column(4, bs4InfoBoxOutput(ns(
        "ibox_total_muni"
      ), width = 12)),
      column(4, bs4InfoBoxOutput(ns(
        "ibox_peso_estado"
      ), width = 12)),
      column(4, bs4InfoBoxOutput(ns(
        "ibox_veiculo_top"
      ), width = 12))
    ),
    
    tags$br(),
    
    #------------------------------------------------------------------------------#
    # 2. Painel de Filtros Modernizado
    fluidRow(
      bs4Dash::box(
        title = tagList(icon("filter"), "Filtros de Análise Municipal"),
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
              label = "MUNICÍPIO",
              choices = NULL,
              # Atualizado via Cache Global
              width = "100%"
            )
          ),
          column(
            3,
            selectInput(
              inputId = ns("anolocal"),
              label = "ANO DE REFERÊNCIA",
              choices = NULL,
              # Atualizado via Cache Global
              width = "100%"
            )
          ),
          column(4),
          column(
            2,
            tags$label(HTML("&nbsp;")),
            # Alinhador vertical para o botão
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
    # 3. Tabela Perfil (Reactable)
    fluidRow(
      bs4Dash::box(
        title = htmlOutput(ns("txtgeral")),
        solidHeader = FALSE,
        maximizable = TRUE,
        status = "primary",
        elevation = 2,
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
      #------------------------------------------------------------------------------#
      # 4. Tabela (DT) - Frota por Tipo de Veículo
      bs4Dash::box(
        title = htmlOutput(ns("txt_tabela_tipo")),
        solidHeader = FALSE,
        maximizable = TRUE,
        status = "primary",
        elevation = 2,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          DT::DTOutput(ns("tabela_tipo_veiculo")),
          type = 8,
          color = "#17a2b8",
          size = 0.8
        ),
        footer = list(
          div(style = "display: flex; justify-content: space-between; align-items: center;", div(
            tags$h6(
              tags$b("Fonte:", style = 'font-family: sans-serif;'),
              "DTI/DETRAN-PA",
              style = "margin-bottom: 0;"
            ),
            tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
          ))
        )
      ),
      
      #------------------------------------------------------------------------------#
      # 5. Tipo de Veículo
      bs4Dash::box(
        title = htmlOutput(ns("txt3_1")),
        solidHeader = FALSE,
        maximizable = TRUE,
        status = "primary",
        elevation = 2,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          echarts4rOutput(ns("grafbar1"), width = "100%", height = "500px"),
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
            div(style = "display: flex; justify-content: center; align-items: center;", downset_ui(ns("grafbardown1")))
          )
        )
      ),
      
      #------------------------------------------------------------------------------#
      # 6. Categoria Veículos
      bs4Dash::box(
        title = htmlOutput(ns("txtcat")),
        solidHeader = FALSE,
        maximizable = TRUE,
        status = "primary",
        elevation = 2,
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
      # 7. Cor dos Veículos
      bs4Dash::box(
        title = htmlOutput(ns("txtcor")),
        solidHeader = FALSE,
        maximizable = TRUE,
        status = "primary",
        elevation = 2,
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
      
      #------------------------------------------------------------------------------#
      # 8. Tipo de Combustível
      bs4Dash::box(
        title = htmlOutput(ns("txtcombu")),
        solidHeader = FALSE,
        maximizable = TRUE,
        status = "primary",
        elevation = 2,
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
      # 9. Espécie do Veículo
      bs4Dash::box(
        title = htmlOutput(ns("txtesp")),
        solidHeader = FALSE,
        maximizable = TRUE,
        status = "primary",
        elevation = 2,
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
      # 10. Nacionalidade do Veículo
      bs4Dash::box(
        title = htmlOutput(ns("txtnac")),
        solidHeader = FALSE,
        maximizable = TRUE,
        status = "primary",
        elevation = 2,
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

#===============================================================================================================#
# Função do modulo servidor
#===============================================================================================================#
muni_Server <- function(id) {
  moduleServer(id, function(input, output, session) {
    #-------------------------------------------------------------------------------#
    # 0. INICIALIZAÇÃO RÁPIDA DOS INPUTS
    #-------------------------------------------------------------------------------#
    updateSelectInput(session, "local", choices = lista_municipios, selected = "Belém")
    updateSelectInput(
      session,
      "anolocal",
      choices = lista_anos_acumulado,
      selected = max(lista_anos_acumulado, na.rm = TRUE)
    )
    
    # Botão Limpar
    observeEvent(input$reset_filtros, {
      freezeReactiveValue(input, "local")
      freezeReactiveValue(input, "anolocal")
      updateSelectInput(session, "local", selected = "Belém")
      updateSelectInput(session,
                        "anolocal",
                        selected = max(lista_anos_acumulado, na.rm = TRUE))
    })
    
    # ================================================================= #
    # 🌟 O MOTOR DE ALTA VELOCIDADE (HUB REATIVO) 🌟
    base_tipo <- reactive({
      req(input$local, input$anolocal)
      db03_tipo_veiculo_acumulado %>%
        filter(local == input$local, ano == !!as.numeric(input$anolocal)) %>%
        collect()
    })
    
    base_estado <- reactive({
      req(input$anolocal)
      db03_tipo_veiculo_acumulado %>%
        filter(local == "Pará", ano == !!as.numeric(input$anolocal)) %>%
        summarise(total = sum(valor, na.rm = TRUE)) %>%
        collect() %>% pull(total)
    })
    # ================================================================= #
    
    # InfoBoxes Dinâmicos do Município
    output$ibox_total_muni <- renderbs4InfoBox({
      total_muni <- sum(base_tipo()$valor, na.rm = TRUE)
      
      bs4InfoBox(
        title = tags$strong("FROTA TOTAL"),
        value = tags$h3(tags$strong(
          prettyNum(
            total_muni,
            big.mark = ".",
            decimal.mark = ","
          )
        )),
        subtitle = paste0(toupper(input$local), " - ", input$anolocal),
        color = "primary",
        fill = TRUE,
        gradient = TRUE,
        icon = icon("car-side"),
        iconElevation = 2
      )
    })
    
    output$ibox_peso_estado <- renderbs4InfoBox({
      total_muni <- sum(base_tipo()$valor, na.rm = TRUE)
      total_estado <- base_estado()
      total_estado <- if (length(total_estado) > 0 &&
                          total_estado > 0)
        total_estado
      else
        1
      
      pct <- (total_muni / total_estado) * 100
      
      bs4InfoBox(
        title = tags$strong("PESO ESTADUAL"),
        value = tags$h3(tags$strong(paste0(
          format(
            round(pct, 2),
            nsmall = 2,
            decimal.mark = ","
          ), "%"
        ))),
        subtitle = "REPRESENTATIVIDADE NO PARÁ",
        color = "info",
        fill = TRUE,
        gradient = TRUE,
        icon = icon("chart-pie"),
        iconElevation = 2
      )
    })
    
    output$ibox_veiculo_top <- renderbs4InfoBox({
      top_veiculo <- base_tipo() %>%
        filter(tipo_veiculo != "Total de Veículos") %>%
        slice_max(valor, n = 1, with_ties = FALSE)
      
      nome_v <- if (nrow(top_veiculo) > 0)
        top_veiculo$tipo_veiculo
      else
        "N/A"
      val_v <- if (nrow(top_veiculo) > 0)
        top_veiculo$valor
      else
        0
      
      bs4InfoBox(
        title = tags$strong("MAIOR VOLUME"),
        value = tags$h3(tags$strong(nome_v)),
        subtitle = paste0(prettyNum(val_v, big.mark = "."), " unidades"),
        color = "success",
        fill = TRUE,
        gradient = TRUE,
        icon = icon("trophy"),
        iconElevation = 2
      )
    })
    
    #-------------------------------------------------------------------------------#
    # TABELA - Frota por Tipo (DT)
    titulo_tabela_tipo <- reactive({
      req(input$local, input$anolocal)
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin:0;'>Tabela – Frota Geral por Tipo de Veículo - ",
          input$local,
          " - ",
          input$anolocal,
          "</h4>"
        )
      )
    })
    
    output$txt_tabela_tipo <- renderText({
      titulo_tabela_tipo()
    })
    
    tabela_tipo_veiculo <- reactive({
      base <- base_tipo() %>%
        filter(tipo_veiculo != "Total de Veículos") %>%
        select(`Tipo de Veículo` = tipo_veiculo, Valor = valor) %>%
        arrange(desc(Valor))
      validate(need(nrow(base) > 0, "Sem dados."))
      total <- base %>% summarise(`Tipo de Veículo` = "TOTAL GERAL",
                                  Valor = sum(Valor, na.rm = TRUE))
      bind_rows(base, total)
    })
    
    output$tabela_tipo_veiculo <- DT::renderDT({
      req(tabela_tipo_veiculo())
      DT::datatable(
        tabela_tipo_veiculo(),
        rownames = FALSE,
        extensions = c("Buttons"),
        options = list(
          dom = "Bfrtip",
          buttons = c("copy", "csv", "excel", "pdf", "print"),
          pageLength = 10,
          scrollY = "350px",
          scrollCollapse = TRUE,
          paging = FALSE,
          autoWidth = TRUE,
          ordering = TRUE,
          language = list(url = "https://cdn.datatables.net/plug-ins/1.13.6/i18n/pt-BR.json")
        )
      ) %>%
        DT::formatCurrency(
          columns = "Valor",
          currency = "",
          interval = 3,
          mark = ".",
          dec.mark = ",",
          digits = 0
        ) %>%
        DT::formatStyle(
          "Tipo de Veículo",
          target = "row",
          backgroundColor = DT::styleEqual("TOTAL GERAL", "#f0f0f0"),
          fontWeight = DT::styleEqual("TOTAL GERAL", "bold")
        )
    })
    
    #--------------------------------------------------------------------------------------------------------------------------#
    # TABELA - RESUMO GERAL (REACTABLE) COM BARRAS CORRIGIDAS
    titulo6 <- reactive({
      req(input$local, input$anolocal)
      HTML(
        paste0(
          "<h4 style='text-align:center; font-weight:bold; margin:0;'>Tabela - Resumo Geral de Veículos Registrados - ",
          input$local,
          " - ",
          input$anolocal,
          "</h4>"
        )
      )
    })
    
    titulo6_clean <- reactive({
      req(input$local, input$anolocal)
      paste0("Resumo_Geral_Veiculos_",
             input$local,
             "_",
             input$anolocal)
    })
    
    output$txtgeral <- renderText({
      titulo6()
    })
    
    dados_perfil_muni <- reactive({
      req(input$local, input$anolocal)
      ano_req <- as.numeric(input$anolocal)
      local_req <- input$local
      
      total_frota_muni <- db01_acumulado %>%
        filter(local == local_req, ano == ano_req) %>%
        summarise(total = sum(valor, na.rm = TRUE)) %>%
        collect() %>%
        pull(total)
      if (length(total_frota_muni) == 0 ||
          total_frota_muni == 0)
        total_frota_muni <- 1
      
      get_top_categoria <- function(base) {
        base %>% filter(local == local_req, ano == ano_req) %>%
          group_by(variavel, categoria) %>%
          summarize(valor = sum(valor, na.rm = TRUE),
                    .groups = 'drop') %>%
          slice_max(valor, n = 1, with_ties = FALSE) %>%
          collect() %>%
          mutate(Percentual = (valor / total_frota_muni) * 100)
      }
      
      categoria <- get_top_categoria(db02_categoria_acumulado)
      cor <- get_top_categoria(db04_cores_acumulado)
      combustivel <- get_top_categoria(db05_combustivel_acumulado)
      especie <- get_top_categoria(db06_especie_veiculo_acumulado)
      nacionalidade <- get_top_categoria(db07_nacionalidade_acumulado)
      
      df <- bind_rows(categoria, cor, combustivel, especie, nacionalidade)
      df %>%
        mutate(
          ri = input$local,
          local = input$local,
          ano = input$anolocal
        ) %>%
        select(ri, local, variavel, categoria, ano, valor, Percentual)
    })
    
    # Download Limpo
    downset_Server("tabdown", dados_perfil_muni, titulo6_clean)
    
    output$tab <- renderReactable({
      df <- dados_perfil_muni() %>% select(variavel, categoria, valor, Percentual)
      validate(need(nrow(df) > 0, "Sem dados para esta tabela."))
      
      df[1, 1] <- "Categoria do Veículo"
      df[2, 1] <- "Cor do Veículo"
      df[3, 1] <- "Tipo de Combustível"
      df[4, 1] <- "Espécie de Veículo"
      df[5, 1] <- "Nacionalidade do Veículo"
      
      # PALETA DE CORES (Sincronizada com as caixas dos gráficos abaixo)
      cores_linhas <- c("#17a2b8", # Categoria (Info)
                        "#dc3545", # Cor (Danger)
                        "#28a745", # Combustível (Success)
                        "#ffc107", # Espécie (Warning)
                        "#6c757d"  # Nacionalidade (Secondary)
                        )
                        
                        reactable(
                          df,
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
                            variavel = colDef(
                              name = "CARACTERÍSTICAS",
                              minWidth = 150,
                              style = list(fontWeight = "bold", color = "black")
                            ),
                            categoria = colDef(
                              name = "PREDOMINÂNCIA",
                              minWidth = 180,
                              align = "center",
                              style = list(fontWeight = "bold", color = "black")
                            ),
                            valor = colDef(
                              name = "FREQUÊNCIA",
                              minWidth = 120,
                              align = "center",
                              style = list(fontWeight = "bold", color = "black"),
                              format = colFormat(separators = TRUE, locales = "pt-BR")
                            ),
                            Percentual = colDef(
                              name = "REPRESENTATIVIDADE (%)",
                              minWidth = 220,
                              align = "center",
                              cell = function(value, index) {
                                # A MÁGICA: Corrige o bug do OutDec="," para o CSS (troca vírgula por ponto no width)
                                css_width <- paste0(gsub(",", ".", as.character(value)), "%")
                                cor_barra <- cores_linhas[index] # Pega a cor correspondente à linha
                                
                                bar <- htmltools::div(
                                  style = list(
                                    background = cor_barra,
                                    width = css_width,
                                    height = "16px",
                                    borderRadius = "4px"
                                  )
                                )
                                
                                htmltools::div(
                                  style = list(
                                    display = "flex",
                                    alignItems = "center",
                                    gap = "10px",
                                    width = "100%"
                                  ),
                                  htmltools::div(
                                    style = list(
                                      flexGrow = 1,
                                      background = "#e9ecef",
                                      borderRadius = "4px"
                                    ),
                                    bar
                                  ),
                                  htmltools::div(
                                    style = list(
                                      width = "50px",
                                      textAlign = "right",
                                      fontWeight = "bold",
                                      color = "#333"
                                    ),
                                    paste0(formatC(
                                      value,
                                      format = "f",
                                      digits = 1,
                                      dec = ","
                                    ), "%")
                                  )
                                )
                              }
                            )
                          )
                        )
    })
      
      #------------------------------------------------------------------------------#
      # TIPO DE VEICULO - GRAFICO 1
      titulo3_1 <- reactive({
        req(input$local, input$anolocal)
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin:0;'>Frota Geral Registrada por Tipo - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      })
      titulo3_1_clean <- reactive({
        req(input$local, input$anolocal)
        paste0("Frota_Por_Tipo_", input$local, "_", input$anolocal)
      })
      
      output$txt3_1 <- renderText({
        titulo3_1()
      })
      
      dados_tipo_grafico <- reactive({
        base_tipo() %>% filter(tipo_veiculo != "Total de Veículos",
                               !is.na(valor),
                               valor > 0) %>% arrange(valor)
      })
      
      downset_Server("grafbardown1", dados_tipo_grafico, titulo3_1_clean)
      
      output$grafbar1 <- renderEcharts4r({
        df_graf <- dados_tipo_grafico()
        validate(need(
          nrow(df_graf) > 0,
          "Sem registros para este município no ano selecionado."
        ))
        total_frota <- sum(df_graf$valor, na.rm = TRUE)
        if (total_frota == 0)
          total_frota <- 1
        
        df_graf %>%
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
            color = "#333",
            formatter = htmlwidgets::JS(
              "function(params) {return Intl.NumberFormat('pt-BR').format(params.value[0]);}"
            )
          ) %>%
          e_tooltip(
            trigger = "item",
            backgroundColor = "rgba(255,255,255,0.95)",
            borderColor = "#1D44B8",
            textStyle = list(color = "#333"),
            formatter = htmlwidgets::JS(
              paste0(
                "function(params) { var val = Intl.NumberFormat('pt-BR').format(params.value[0]); var pct = ((params.value[0]/",
                total_frota,
                ")*100).toFixed(1).replace('.',',') + '%'; return '<strong style=\"font-size:16px; color:#1D44B8;\">' + params.name + '</strong><br/>Frota: <b>' + val + '</b><br/>Representatividade: <b>' + pct + '</b>'; }"
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
      
      #--------------------------------------------------------------------------------------------------------------------------#
      # CATEGORIA - GRÁFICO
      titulo1 <- reactive({
        req(input$local, input$anolocal)
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin:0;'>Categorias dos Veículos Registrados - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      })
      titulo1_clean <- reactive({
        req(input$local, input$anolocal)
        paste0("Categorias_Veiculos_",
               input$local,
               "_",
               input$anolocal)
      })
      output$txtcat <- renderText({
        titulo1()
      })
      
      dados_categoria <- reactive({
        req(input$local, input$anolocal)
        db02_categoria_acumulado %>% filter(
          local == input$local,
          ano == !!as.numeric(input$anolocal),
          variavel == "Categoria do veículo Acumulado"
        ) %>% collect() %>% filter(!is.na(valor) &
                                     valor > 0) %>% arrange(valor)
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
      
      #--------------------------------------------------------------------------------------------------------------------------#
      # CORES - GRÁFICO
      titulo2 <- reactive({
        req(input$local, input$anolocal)
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin:0;'>Cores dos Veículos Registrados - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      })
      titulo2_clean <- reactive({
        req(input$local, input$anolocal)
        paste0("Cores_Veiculos_", input$local, "_", input$anolocal)
      })
      output$txtcor <- renderText({
        titulo2()
      })
      
      dados_cor <- reactive({
        req(input$local, input$anolocal)
        db04_cores_acumulado %>% filter(
          local == input$local,
          ano == !!as.numeric(input$anolocal),
          variavel == "Cor do veículo Acumulado"
        ) %>% collect() %>% filter(!is.na(valor) &
                                     valor > 0) %>% arrange(valor)
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
      
      #--------------------------------------------------------------------------------------------------------------------------#
      # COMBUSTÍVEL - GRÁFICO
      titulo3 <- reactive({
        req(input$local, input$anolocal)
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin:0;'>Tipo de Combustível dos Veículos Registrados - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      })
      titulo3_clean <- reactive({
        req(input$local, input$anolocal)
        paste0("Combustivel_Veiculos_",
               input$local,
               "_",
               input$anolocal)
      })
      output$txtcombu <- renderText({
        titulo3()
      })
      
      dados_combu <- reactive({
        req(input$local, input$anolocal)
        db05_combustivel_acumulado %>% filter(
          local == input$local,
          ano == !!as.numeric(input$anolocal),
          variavel == "Tipo de combustível(s) utilizado(s) Acumulado"
        ) %>% collect() %>% filter(!is.na(valor) &
                                     valor > 0) %>% arrange(valor)
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
      
      #--------------------------------------------------------------------------------------------------------------------------#
      # ESPÉCIE - GRÁFICO
      titulo4 <- reactive({
        req(input$local, input$anolocal)
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin:0;'>Espécie dos Veículos Registrados - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      })
      titulo4_clean <- reactive({
        req(input$local, input$anolocal)
        paste0("Especie_Veiculos_", input$local, "_", input$anolocal)
      })
      output$txtesp <- renderText({
        titulo4()
      })
      
      dados_esp <- reactive({
        req(input$local, input$anolocal)
        db06_especie_veiculo_acumulado %>% filter(
          local == input$local,
          ano == !!as.numeric(input$anolocal),
          variavel == "Espécie de Veículo Acumulado"
        ) %>% collect() %>% filter(!is.na(valor) &
                                     valor > 0) %>% arrange(valor)
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
            borderColor = "#ffc107",
            textStyle = list(color = "#333"),
            formatter = htmlwidgets::JS(
              paste0(
                "
             function(params) {
               var val = Intl.NumberFormat('pt-BR').format(params.value[1]);
               var pct = ((params.value[1]/",
                total_esp,
                ")*100).toFixed(1).replace('.',',') + '%';
               return '<strong style=\"font-size:16px; color:#ffc107;\">' + params.name + '</strong><br/>Frota: <b>' + val + '</b><br/>Representatividade: <b>' + pct + '</b>';
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
# NACIONALIDADE - PIE
      titulo5 <- reactive({
        req(input$local, input$anolocal)
        HTML(
          paste0(
            "<h4 style='text-align:center; font-weight:bold; margin:0;'>Nacionalidade dos Veículos Registrados - ",
            input$local,
            " - ",
            input$anolocal,
            "</h4>"
          )
        )
      })
      titulo5_clean <- reactive({
        req(input$local, input$anolocal)
        paste0("Nacionalidade_Veiculos_",
               input$local,
               "_",
               input$anolocal)
      })
      output$txtnac <- renderText({
        titulo5()
      })
      
      dados_nac <- reactive({
        req(input$local, input$anolocal)
        db07_nacionalidade_acumulado %>% filter(
          local == input$local,
          ano == !!as.numeric(input$anolocal),
          variavel == "Nacionalidade do Veículo Acumulado"
        ) %>% collect() %>% filter(!is.na(valor) &
                                     valor > 0) %>% arrange(desc(valor))
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
          e_color(c("#1D44B8", "#FF7676", "#FF7676", "#1D44B8")) %>%
          e_tooltip(
            trigger = "item",
            backgroundColor = "rgba(255, 255, 255, 0.95)",
            borderColor = "#6c757d",
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
#ui = dashboardPage(header = dashboardHeader(),
#                   sidebar = dashboardSidebar(),
#                   body = dashboardBody(fluidPage(muni_ui("total"))))

#server <- function(input, output) {
#  muni_Server("total")
#}

#shinyApp(ui, server)