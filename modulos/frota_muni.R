#===============================================================================================================#
# Funções de módulo de Infraestrutura - Municipal
# Função de UI
#===============================================================================================================#
frotamuni_ui <- function(id) {
  
  ns <- NS(id)
  
  # Injetar as variáveis globais DIRETAMENTE na UI elimina o tempo de tela em branco/NULL
  municipios_validos <- lista_municipios[lista_municipios != "Pará"]
  
  fluidPage(
    #------------------------------------------------------------------------------#
    ## 1. VALUE BOXES ----
    fluidRow(
      bs4InfoBoxOutput(ns("vb_total_frota"), width = 4),
      bs4InfoBoxOutput(ns("vb_frota_licenciada"), width = 4),
      bs4InfoBoxOutput(ns("vb_frota_nao_licenciada"), width = 4)
    ),
    
    tags$br(),
    
    #------------------------------------------------------------------------------#
    ## 2. Painel de Filtros Modernizado ----
    fluidRow(
      bs4Dash::box(
        title = tagList(icon("filter"), "Filtros de Situação da Frota Municipal"),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        collapsible = TRUE,
        width = 12,
        fluidRow(
          column(
            3,
            selectInput(
              inputId = ns("muni"),
              label = "MUNICÍPIO",
              choices = municipios_validos,
              selected = "Belém",
              width = "100%"
            )
          ),
          column(
            3,
            selectInput(
              inputId = ns("ano"),
              label = "ANO DE REFERÊNCIA",
              choices = lista_anos_acumulado,
              selected = ano_maximo_global,
              width = "100%"
            )
          ),
          column(4),
          column(
            2,
            tags$label(HTML("&nbsp;")), # Alinhamento perfeito
            actionBttn(
              inputId = ns("reset_frotamuni"),
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
      #------------------------------------------------------------------------------#
      ## 3. Gráfico - Total da Frota (Licenciados vs Não Licenciados) ----
      bs4Dash::box(
        title = htmlOutput(ns("txtbar")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsible = FALSE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        fluidRow(
          column(4,
                 selectInput(
                   inputId = ns("municomp1"),
                   label = "Comparar com outro Município:",
                   choices = c("Selecione um Município", municipios_validos), 
                   selected = "Selecione um Município",
                   width = "100%"
                 )
          )
        ),
        withSpinner(
          echarts4rOutput(ns("grafbar"), height = "400px"),
          type = 8,
          color = "#1D44B8",
          size = 0.8
        ),
        footer = list(
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(tags$b("Fonte:", style = 'font-family: sans-serif;'), "DTI/DETRAN-PA", style = "margin-bottom: 0;"),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(
              style = "display: flex; justify-content: center; align-items: center;",
              downset_ui(ns("grafdow"))
            )
          )
        )
      ),
      
      #------------------------------------------------------------------------------#
      ## 4. Tabela - Histórico de Frota (Reactable) ----
      bs4Dash::box(
        title = htmlOutput(ns("txttab")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsible = FALSE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        withSpinner(
          reactableOutput(ns("tab")),
          type = 8,
          color = "#17a2b8",
          size = 0.8
        ),
        footer = list(
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(tags$b("Fonte:", style = 'font-family: sans-serif;'), "DTI/DETRAN-PA", style = "margin-bottom: 0;"),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(
              style = "display: flex; justify-content: center; align-items: center;",
              downset_ui(ns("tabdow"))
            )
          )
        )
      ),
      
      #------------------------------------------------------------------------------#
      ## 5. Gráfico - Evolução Cruzada (Linha) EXPANDIDO ----
      bs4Dash::box(
        title = htmlOutput(ns("txtline")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsible = FALSE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
        fluidRow(
          column(4,
                 selectInput(
                   inputId = ns("municomp2"),
                   label = "Comparar Histórico com Município:",
                   choices = c("Selecione um Município", municipios_validos),
                   selected = "Selecione um Município",
                   width = "100%"
                 )
          )
        ),
        withSpinner(
          echarts4rOutput(ns("grafline"), height = "500px"), # Gráfico maior para acomodar melhor
          type = 8,
          color = "#28a745",
          size = 0.8
        ),
        footer = list(
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(tags$b("Fonte:", style = 'font-family: sans-serif;'), "DTI/DETRAN-PA", style = "margin-bottom: 0;"),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(
              style = "display: flex; justify-content: center; align-items: center;",
              downset_ui(ns("linedow"))
            )
          )
        )
      )
    )
  )
}

#===============================================================================================================#
# Função do modulo servidor
#===============================================================================================================#
frotamuni_Server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    municipios_validos <- lista_municipios[lista_municipios != "Pará"]
    
    #------------------------------------------------------------------------------
    # 1. BOTÃO DE LIMPAR
    observeEvent(input$reset_frotamuni, {
      freezeReactiveValue(input, "muni")
      freezeReactiveValue(input, "ano")
      updateSelectInput(session, "muni", selected = "Belém")
      updateSelectInput(session, "ano", selected = ano_maximo_global)
      updateSelectInput(session, "municomp1", selected = "Selecione um Município")
      updateSelectInput(session, "municomp2", selected = "Selecione um Município")
    })
    
    # Atualização da caixa de Comparação 
    observeEvent(input$muni, {
      req(input$muni)
      x <- municipios_validos[municipios_validos != input$muni]
      updateSelectInput(session, "municomp1", choices = c("Selecione um Município", x))
      updateSelectInput(session, "municomp2", choices = c("Selecione um Município", x))
    })
    
    #------------------------------------------------------------------------------#
    # 2. HUB REATIVO PARA OS VALUE BOXES
    hub_vb <- reactive({
      muni_sel <- input$muni
      ano_sel  <- as.numeric(input$ano)
      req(muni_sel, ano_sel)
      
      frota2 %>%
        filter(municipio == !!muni_sel, ano == !!ano_sel, categoria == "Licenciados" | categoria == "Frota") %>%
        group_by(categoria) %>% 
        summarise(total = sum(valor, na.rm = TRUE), .groups = "drop") %>%
        collect()
    })
    
    #-------------------------------------------------------------------------------     
    # Valueboxes Otimizados   
    output$vb_total_frota <- renderInfoBox({
      tot <- hub_vb() %>% filter(categoria == "Frota") %>% pull(total)
      total <- if(length(tot) == 0 || is.na(tot[1])) 0 else tot[1]
      
      bs4InfoBox(
        title = tags$strong("FROTA GERAL"),
        value = tags$h2(tags$strong(prettyNum(total, big.mark = ".", decimal.mark = ","))),
        subtitle = paste0("Frota em - ", input$muni),
        fill = TRUE, gradient = TRUE, iconElevation = 2, icon = icon("car"), color = "primary"
      )
    }) 
    
    output$vb_frota_licenciada <- renderInfoBox({
      dados <- hub_vb()
      lic <- dados %>% filter(categoria == "Licenciados") %>% pull(total)
      tot <- dados %>% filter(categoria == "Frota") %>% pull(total)
      
      licenciados <- if(length(lic) == 0 || is.na(lic[1])) 0 else lic[1]
      total_frota <- if(length(tot) == 0 || is.na(tot[1]) || tot[1] == 0) 1 else tot[1]
      perc <- format(round((licenciados / total_frota) * 100, 2), nsmall=2, decimal.mark=",")
      
      bs4InfoBox(
        title = tags$strong("FROTA REGULAR (LICENCIADA)"),
        value = tags$h2(tags$strong(paste0(prettyNum(licenciados, big.mark = ".", decimal.mark = ","), " (", perc, "%)"))),
        subtitle = paste0("Veículos Regulares em ", input$ano),
        fill = TRUE, gradient = TRUE, iconElevation = 2, icon = icon("check-circle"), color = "success"
      )
    })   
    
    output$vb_frota_nao_licenciada <- renderInfoBox({
      dados <- hub_vb()
      lic <- dados %>% filter(categoria == "Licenciados") %>% pull(total)
      tot <- dados %>% filter(categoria == "Frota") %>% pull(total)
      
      licenciados <- if(length(lic) == 0 || is.na(lic[1])) 0 else lic[1]
      total_frota <- if(length(tot) == 0 || is.na(tot[1]) || tot[1] == 0) 1 else tot[1]
      
      nao_lic <- total_frota - licenciados
      perc <- format(round((nao_lic / total_frota) * 100, 2), nsmall=2, decimal.mark=",")
      
      bs4InfoBox(
        title = tags$strong("FROTA INADIMPLENTE"),
        value = tags$h2(tags$strong(paste0(prettyNum(nao_lic, big.mark = ".", decimal.mark = ","), " (", perc, "%)"))),
        subtitle = paste0("Licenciamento Pendente em ", input$ano),
        fill = TRUE, gradient = TRUE, iconElevation = 2, icon = icon("exclamation-triangle"), color = "danger"
      )
    })
    
    #-------------------------------------------------------------------------------   
    ## 3. Gráfico de barras - Licenciados e Não Licenciados
    titulo1 <- reactive({
      muni_txt <- input$muni
      ano_txt <- input$ano
      comp1_txt <- input$municomp1
      req(muni_txt, ano_txt)
      
      if (is.null(comp1_txt) || comp1_txt == "Selecione um Município") {
        titulo_texto <- paste0("Situação da Frota: Licenciados vs Não Licenciados, ", muni_txt, " - ", ano_txt)
      } else {
        titulo_texto <- paste0("Situação da Frota: Licenciados vs Não Licenciados, ", muni_txt, " x ", comp1_txt, " - ", ano_txt)
      }
      HTML(paste0("<h4 style='text-align:center; font-weight:bold; margin: 0;'>", titulo_texto, "</h4>"))
    })
    
    titulo1_clean <- reactive({
      muni_txt <- input$muni
      ano_txt <- input$ano
      comp1_txt <- input$municomp1
      req(muni_txt, ano_txt)
      if (is.null(comp1_txt) || comp1_txt == "Selecione um Município") {
        paste0("Situacao_Frota_", muni_txt, "_", ano_txt)
      } else {
        paste0("Situacao_Frota_", muni_txt, "_x_", comp1_txt, "_", ano_txt)
      }
    })
    
    output$txtbar <- renderText({ titulo1() })
    
    frotabardown <- reactive({
      muni_sel <- input$muni
      ano_sel <- as.numeric(input$ano)
      comp1_sel <- input$municomp1
      req(muni_sel, ano_sel)
      
      if (is.null(comp1_sel) || comp1_sel == "Selecione um Município") {
        frota2 %>% 
          filter(municipio == !!muni_sel, ano == !!ano_sel, categoria != "Frota") %>% 
          collect() %>% mutate(valor = replace_na(valor, 0))
      } else {
        frota2 %>% 
          filter((municipio == !!muni_sel | municipio == !!comp1_sel), ano == !!ano_sel, categoria != "Frota") %>% 
          collect() %>% mutate(valor = replace_na(valor, 0))
      }
    })
    
    downset_Server("grafdow", frotabardown, titulo1_clean)
    
    output$grafbar <- renderEcharts4r({
      base_grafico <- frotabardown() 
      validate(need(nrow(base_grafico) > 0, "Sem dados para o gráfico de barras."))
      
      comp1_sel <- input$municomp1
      
      js_tooltip <- htmlwidgets::JS("
        function(params) {
          var html = '<strong style=\"font-size:15px;\">' + params[0].name + '</strong><br/>';
          for (var i = 0; i < params.length; i++) {
            var val = params[i].value[1] !== undefined ? params[i].value[1] : params[i].value;
            html += params[i].marker + ' ' + params[i].seriesName + ': <b>' + Intl.NumberFormat('pt-BR').format(val) + '</b><br/>';
          }
          return html;
        }
      ")
      
      js_label <- htmlwidgets::JS("function(params){ var v = params.value[1] !== undefined ? params.value[1] : params.value; return Intl.NumberFormat('pt-BR').format(v); }")
      
      if (is.null(comp1_sel) || comp1_sel == "Selecione um Município") {
        
        base_grafico %>%
          e_charts(categoria, renderer = "svg") %>%
          e_bar(
            serie = valor, color = "#1D44B8", name = input$muni, legend = FALSE, barWidth = "35%", 
            itemStyle = list(borderRadius = c(5, 5, 0, 0)),
            label = list(show = TRUE, position = "top", fontSize = 14, fontWeight = "bold", color = "#1D44B8", formatter = js_label)
          ) %>%
          e_tooltip(trigger = "axis", axisPointer = list(type = "shadow"), formatter = js_tooltip) %>%
          e_x_axis(name = "", axisLabel = list(show = TRUE, fontSize = 14, fontWeight = "bold")) %>%
          e_y_axis(name = "Quantidade", scale = TRUE, splitLine = list(lineStyle = list(type = "dashed")), axisLine = list(show = FALSE), axisTick = list(show = FALSE), axisLabel = list(formatter = htmlwidgets::JS("function(value){ return value >= 1000 ? (value/1000) + 'k' : value; }"))) %>%
          e_locale("pt-BR") %>% e_grid(show = TRUE, bottom = "15%", top = "15%") %>% e_toolbox_feature("saveAsImage")
        
      } else {
        a <- base_grafico %>% filter(municipio == input$muni)
        b <- base_grafico %>% filter(municipio == input$municomp1)
        
        a %>%
          e_charts(categoria, renderer = "svg") %>%
          e_bar(
            serie = valor, name = input$muni, color = "#1D44B8", barWidth = "30%", itemStyle = list(borderRadius = c(5, 5, 0, 0)),
            label = list(show = TRUE, position = "top", fontSize = 13, fontWeight = "bold", color = "#1D44B8", formatter = js_label)
          ) %>%
          e_data(b, categoria) %>%
          e_bar(
            serie = valor, name = input$municomp1, color = "#FF7676", barWidth = "30%", itemStyle = list(borderRadius = c(5, 5, 0, 0)),
            label = list(show = TRUE, position = "top", fontSize = 13, fontWeight = "bold", color = "#FF7676", formatter = js_label)
          ) %>%
          e_legend(orient = "vertical", right = "2%", top = "center", textStyle = list(fontSize = 15, fontWeight = "bold", color = "#444")) %>%
          e_tooltip(trigger = "axis", axisPointer = list(type = "shadow"), formatter = js_tooltip) %>%
          e_x_axis(name = "", axisLabel = list(show = TRUE, fontSize = 14, fontWeight = "bold")) %>%
          e_y_axis(name = "Quantidade", scale = TRUE, splitLine = list(lineStyle = list(type = "dashed")), axisLine = list(show = FALSE), axisTick = list(show = FALSE), axisLabel = list(formatter = htmlwidgets::JS("function(value){ return value >= 1000 ? (value/1000) + 'k' : value; }"))) %>%
          e_locale("pt-BR") %>% e_grid(show = TRUE, bottom = "15%", top = "15%", right = "20%") %>% e_toolbox_feature("saveAsImage")
      }
    })   
    
    #-------------------------------------------------------------------------------   
    ## 4. Tabela Reactable - Historico de Frota
    titulo2 <- reactive({
      muni_txt <- input$muni
      req(muni_txt)
      min_ano <- min(lista_anos_acumulado, na.rm=TRUE)
      max_ano <- max(lista_anos_acumulado, na.rm=TRUE)
      HTML(paste0("<h4 style='text-align:center; font-weight:bold; margin: 0;'>Histórico da Frota de Veículos: ", muni_txt, " (", min_ano, " a ", max_ano, ")</h4>"))
    })
    
    titulo2_clean <- reactive({
      muni_txt <- input$muni
      req(muni_txt)
      paste0("Historico_Frota_", muni_txt)
    })
    
    output$txttab <- renderText({ titulo2() })
    
    frotatabdow <- reactive({
      muni_sel <- input$muni
      req(muni_sel)
      
      frota2 %>%
        filter(municipio == !!muni_sel) %>%
        collect() %>% 
        pivot_wider(names_from = categoria, values_from = valor, values_fill = 0) %>%
        arrange(desc(ano))
    })
    
    downset_Server("tabdow", frotatabdow, titulo2_clean)
    
    
 #--------------------------------------------------------------------------------   
    output$tab <- renderReactable({
      x <- frotatabdow() %>% select(-any_of(c("ri", "municipio"))) 
      validate(need(nrow(x) > 0, "Sem dados para esta localidade."))
      
      x %>% reactable(
        height = 400, 
        defaultSorted = list(ano = "desc"), 
        defaultPageSize = 10, 
        pagination = FALSE, 
        highlight = TRUE, 
        borderless = TRUE, 
        theme = reactableTheme(
          headerStyle = list(backgroundColor = "white", color = "black", fontWeight = "bold", fontSize = "14px"),
          cellStyle = list(fontSize = "14px", verticalAlign = "middle")
        ),
        columns = list(
          ano = colDef(
            name = "ANO", 
            align = "center", 
            maxWidth = 100,
            style = list(fontWeight = "bold", fontSize = "15px", color = "#444"),
            header = function(value) {
              tags$div(tags$i(class = "fa fa-calendar-alt", style = "margin-right: 5px;"), value)
            }
          ),
          
          Frota = colDef(
            name = "FROTA GERAL", 
            align = "center", 
            minWidth = 140,
            format = colFormat(separators = TRUE, locales = "pt-BR"),
            style = list(fontWeight = "bold", fontSize = "15px", color = "black"),
            header = function(value) {
              tags$div(tags$i(class = "fa fa-car", style = "margin-right: 5px;"), value)
            }
          ),
          
          Licenciados = colDef(
            name = "LICENCIADOS (Regulares)", 
            align = "center",
            minWidth = 200,
            format = colFormat(separators = TRUE, locales = "pt-BR"),
            header = function(value) {
              tags$div(tags$i(class = "fa fa-check-circle", 
                              style = "margin-right: 5px; color: #6EE7B7;"), value)
            },
            cell = function(value, index) {
              # Calcula o percentual em relação à frota daquele ano
              total <- x$Frota[index]
              pct <- if (is.na(total) || total == 0) 0 else (value / total) * 100
              
              val_fmt <- formatC(value, format = "d", big.mark = ".", decimal.mark = ",")
              pct_fmt <- paste0(formatC(pct, format = "f", digits = 1, dec = ","), "%")
              css_width <- paste0(gsub(",", ".", as.character(pct)), "%") # Conserta o bug do CSS
              
              bar <- tags$div(style = paste0("background: #28a745; width: ", css_width, "; height: 6px; border-radius: 2px;"))
              
              tags$div(
                tags$div(
                  style = "display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 4px;",
                  tags$span(style = "font-weight: bold; color: #28a745; font-size: 15px;", val_fmt),
                  tags$span(style = "color: #666; font-size: 12px; font-weight: bold;", pct_fmt)
                ),
                tags$div(style = "background: #e9ecef; border-radius: 2px; width: 100%;", bar)
              )
            }
          ),
          
          `Não Licenciados` = colDef(
            name = "NÃO LICENCIADOS (Pendentes)", 
            minWidth = 200,
            align = "center",
            style = list(fontWeight = "bold", fontSize = "15px", color = "black"),
            header = function(value) {
              tags$div(tags$i(class = "fa fa-exclamation-triangle", style = "margin-right: 5px; color: #FF7676;"), value)
            },
            cell = function(value, index) {
              # Calcula o percentual em relação à frota daquele ano
              total <- x$Frota[index]
              pct <- if (is.na(total) || total == 0) 0 else (value / total) * 100
              
              val_fmt <- formatC(value, format = "d", big.mark = ".", decimal.mark = ",")
              pct_fmt <- paste0(formatC(pct, format = "f", digits = 1, dec = ","), "%")
              css_width <- paste0(gsub(",", ".", as.character(pct)), "%") # Conserta o bug do CSS
              
              bar <- tags$div(style = paste0("background: #dc3545; width: ", css_width, "; height: 6px; border-radius: 2px;"))
              
              tags$div(
                tags$div(
                  style = "display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 4px;",
                  tags$span(style = "font-weight: bold; color: #dc3545; font-size: 15px;", val_fmt),
                  tags$span(style = "color: #666; font-size: 12px; font-weight: bold;", pct_fmt)
                ),
                tags$div(style = "background: #e9ecef; border-radius: 2px; width: 100%;", bar)
              )
            }
          )
        ),
        defaultColDef = colDef(na = "-", headerStyle = list(background = "#f7f7f8")), 
        language = reactableLang(noData = "Sem informação")
      )
    })
#--------------------------------------------------------------------------------    
    
    
    
#-------------------------------------------------------------------------------   
    ## 5. Gráfico de Linha (Evolução Cruzada Otimizada e 100% CORRIGIDA)
    titulo3 <- reactive({
      muni_txt <- input$muni
      comp2_txt <- input$municomp2
      req(muni_txt)
      min_ano <- min(lista_anos_acumulado, na.rm=T)
      max_ano <- max(lista_anos_acumulado, na.rm=T)
      
      if (is.null(comp2_txt) || comp2_txt == "Selecione um Município") {
        titulo_texto <- paste0("Evolução Histórica da Frota Geral, ", muni_txt, " (", min_ano, " a ", max_ano, ")")
      } else {
        titulo_texto <- paste0("Evolução Histórica da Frota Geral, ", muni_txt, " x ", comp2_txt, " (", min_ano, " a ", max_ano, ")")
      }
      HTML(paste0("<h4 style='text-align:center; font-weight:bold; margin: 0;'>", titulo_texto, "</h4>"))
    })
    
    titulo3_clean <- reactive({
      muni_txt <- input$muni
      comp2_txt <- input$municomp2
      req(muni_txt)
      if (is.null(comp2_txt) || comp2_txt == "Selecione um Município") {
        paste0("Evolucao_Frota_", muni_txt)
      } else {
        paste0("Evolucao_Frota_", muni_txt, "_x_", comp2_txt)
      }
    })
    
    output$txtline <- renderText({ titulo3() })
    
    inf1_3 <- reactive({
      muni_sel <- input$muni
      comp2_sel <- input$municomp2
      req(muni_sel)
      
      # A MÁGICA ANTI-EMARANHADO: Forçar Ano para Texto e Completar Buracos
      if (is.null(comp2_sel) || comp2_sel == "Selecione um Município") {
        frota2 %>% 
          filter(municipio == !!muni_sel, categoria == "Frota") %>% 
          collect() %>% 
          mutate(
            valor = replace_na(valor, 0),
            ano = as.character(ano) # Transforma Ano em Categoria
          ) %>%
          arrange(ano) 
      } else {
        frota2 %>% 
          filter(municipio %in% c(!!muni_sel, !!comp2_sel), categoria == "Frota") %>% 
          collect() %>% 
          mutate(
            valor = replace_na(valor, 0),
            ano = as.character(ano) # Transforma Ano em Categoria
          ) %>%
          # O "complete" garante que as duas cidades tenham a mesma linha do tempo perfeitamente alinhada
          tidyr::complete(ano, municipio, fill = list(valor = 0)) %>% 
          arrange(ano) %>%
          mutate(municipio = factor(municipio, levels = c(!!muni_sel, !!comp2_sel))) # Garante a ordem da legenda
      }
    })
    
    downset_Server("linedow", inf1_3, titulo3_clean)
    
    output$grafline <- renderEcharts4r({
      base_graf <- inf1_3()
      validate(need(nrow(base_graf) > 0, "Sem histórico para exibição."))
      
      comp2_sel <- input$municomp2
      
      if (is.null(comp2_sel) || comp2_sel == "Selecione um Município") {
        base_graf %>%
          e_charts(ano, renderer = "svg") %>%
          e_line(
            serie = valor, name = input$muni, color = "#1D44B8", symbol = "circle", 
            symbolSize = 8, smooth = TRUE, lineStyle = list(width = 4), 
            areaStyle = list(opacity = 0.2), 
            endLabel = list(show = TRUE, formatter = "{a}", fontSize = 14, fontWeight = "bold", color = "inherit")
          ) %>%
          e_legend(show = FALSE) %>% 
          e_tooltip(
            trigger = "axis", 
            formatter = htmlwidgets::JS("function(params){ var v = params[0].value[1] !== undefined ? params[0].value[1] : params[0].value; return '<strong>' + params[0].name + '</strong><br/>' + params[0].marker + params[0].seriesName + ': <b>' + Intl.NumberFormat('pt-BR').format(v) + '</b>'; }")
          ) %>%
          e_x_axis(name = "Ano", type = "category", axisLabel = list(show = TRUE, fontSize = 13, fontWeight = "bold")) %>%
          e_y_axis(name = "Quantidade", scale = TRUE, axisLabel = list(formatter = htmlwidgets::JS("function(value){ return value >= 1000 ? (value/1000) + 'k' : value; }"))) %>%
          e_locale("pt-BR") %>% 
          # MÁGICA DO ESPAÇO: Margens reduzidas para o gráfico crescer!
          e_grid(show = TRUE, left = "5%", right = "15%", top = "10%", bottom = "15%") %>% 
          e_toolbox_feature("saveAsImage")
        
      } else {
        base_graf %>%
          group_by(municipio) %>%
          e_charts(ano, renderer = "svg") %>%
          e_line(
            serie = valor, symbol = "circle", symbolSize = 8, smooth = TRUE, 
            lineStyle = list(width = 4), areaStyle = list(opacity = 0.2), 
            endLabel = list(show = TRUE, formatter = "{a}", fontSize = 14, fontWeight = "bold", color = "inherit")
          ) %>%
          e_color(c("#1D44B8", "#FF7676")) %>% 
          e_legend(show = FALSE) %>% 
          e_tooltip(
            trigger = "axis", 
            formatter = htmlwidgets::JS("
              function(params) {
                var html = '<strong>' + params[0].name + '</strong><br/>';
                for (var i = 0; i < params.length; i++) {
                  var val = params[i].value[1] !== undefined ? params[i].value[1] : params[i].value;
                  html += params[i].marker + ' ' + params[i].seriesName + ': <b>' + Intl.NumberFormat('pt-BR').format(val) + '</b><br/>';
                }
                return html;
              }
            ")
          ) %>%
          e_x_axis(name = "Ano", type = "category", axisLabel = list(show = TRUE, fontSize = 13, fontWeight = "bold")) %>%
          e_y_axis(name = "Quantidade", scale = TRUE, axisLabel = list(formatter = htmlwidgets::JS("function(value){ return value >= 1000 ? (value/1000) + 'k' : value; }"))) %>%
          e_locale("pt-BR") %>% 
          # MÁGICA DO ESPAÇO AQUI TAMBÉM:
          e_grid(show = TRUE, left = "5%", right = "15%", top = "10%", bottom = "15%") %>% 
          e_toolbox_feature("saveAsImage")
      }
    })   
    
  })
}







#=====================================================#
# Play do Módulo (COMENTADO PARA PRODUÇÃO)
#=====================================================#
#ui <- dashboardPage(header = dashboardHeader(),
#                    sidebar = dashboardSidebar(),
#                    body = dashboardBody(fluidPage(frotamuni_ui("frotamuni"))))

#server <- function(input, output) {
#  frotamuni_Server("frotamuni")
#}

#shinyApp(ui, server)