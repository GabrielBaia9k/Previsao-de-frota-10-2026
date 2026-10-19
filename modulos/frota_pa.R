# ==============================================================================#
# Funções de módulo de Demografia Estadual (Pará e Regiões de Integração)
# Arquivo: modulos/frota_pa.R
# ==============================================================================#

# ==============================================================================#
# Função de UI
# ==============================================================================#
frotapa_ui <- function(id) {
  ns <- NS(id)  
  
  fluidPage(
    #------------------------------------------------------------------------------#
    # 1. Linha de Indicadores (VALUE BOXES) ----
    fluidRow(
      bs4InfoBoxOutput(ns("vb_total_frota"), width = 4),
      bs4InfoBoxOutput(ns("vb_frota_licenciada"), width = 4),
      bs4InfoBoxOutput(ns("vb_frota_nao_licenciada"), width = 4)
    ),
    
    tags$br(),
    
    #------------------------------------------------------------------------------#
    # 2. Painel de Filtros Modernizado ----
    fluidRow(
      bs4Dash::box(
        title = tagList(icon("filter"), "Filtros de Situação da Frota Estadual / R.I"),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        collapsible = TRUE,
        width = 12,
        fluidRow(
          column(3,
                 selectInput(
                   inputId = ns("ri"),
                   label = "LOCALIDADE (ESTADO/RI)",
                   choices = NULL, # Atualizado via Cache Global
                   width = "100%"
                 )
          ),
          column(3,
                 selectInput(
                   inputId = ns("cat"),
                   label = "CATEGORIA DA FROTA",
                   choices = NULL, # Atualizado via Cache Global
                   width = "100%"
                 )
          ),
          column(3,
                 selectInput(
                   inputId = ns("ano"),
                   label = "ANO DE REFERÊNCIA",
                   choices = NULL, # Atualizado via Cache Global
                   width = "100%"
                 )
          ),
          column(3,
                 tags$label(HTML("&nbsp;")), # Alinhamento perfeito
                 actionBttn(
                   inputId = ns("reset_frotapa"),
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
      ## 3. Mapa - Espacialização da Frota Licenciada/Não Licenciada ----
      bs4Dash::box(
        title = htmlOutput(ns("txtmap")),
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
          div(
            style = "display: flex; justify-content: space-between; align-items: center;",
            div(
              tags$h6(tags$b("Fonte:", style = 'font-family: sans-serif;'), "DTI/DETRAN-PA", style = "margin-bottom: 0;"),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            )
          )
        )
      ),
      
      #------------------------------------------------------------------------------#
      ## 4. Tabela (Reactable) - Listagem da Frota nos Municípios ----
      bs4Dash::box(
        title = htmlOutput(ns("txttab")),
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
              downset_ui(ns("tabdown"))
            )
          )
        )
      ),
      
      #------------------------------------------------------------------------------#
      ## 5. Gráfico de Evolução Cruzada - Geral Pará ----
      bs4Dash::box(
        title = htmlOutput(ns("txtgraf")),
        status = "primary",
        solidHeader = FALSE,
        elevation = 2,
        maximizable = TRUE,
        collapsed = FALSE,
        headerBorder = TRUE,
        width = 12,
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
              tags$h6(tags$b("Fonte:", style = 'font-family: sans-serif;'), "DTI/DETRAN-PA", style = "margin-bottom: 0;"),
              tags$h6(tags$b("Elaboração:"), "CNP/DETRAN-PA", style = "margin-bottom: 0;")
            ),
            div(
              style = "display: flex; justify-content: center; align-items: center;",
              downset_ui(ns("grafdown"))
            )
          )
        )
      )
    )
  )
}

# ==============================================================================#
# Função do modulo servidor
# ==============================================================================#
frotapa_Server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    #------------------------------------------------------------------------------#
    # 0. INICIALIZAÇÃO DE INPUTS (CACHE RÁPIDO)
    #------------------------------------------------------------------------------#
    updateSelectInput(session, "ri", choices = c("Pará", lista_regioes[lista_regioes != "Pará"]), selected = "Pará")
    
    # A base frota2 tem como categorias: "Frota", "Licenciados", "Não Licenciados"
    cats <- frota2 %>% select(categoria) %>% distinct() %>% collect() %>% pull(categoria)
    updateSelectInput(session, "cat", choices = cats, selected = "Frota")
    updateSelectInput(session, "ano", choices = lista_anos_acumulado, selected = ano_maximo_global)
    
    #------------------------------------------------------------------------------#    
    # 1. BOTÃO DE LIMPAR OTIMIZADO
    observeEvent(input$reset_frotapa, {
      freezeReactiveValue(input, "ri")
      freezeReactiveValue(input, "cat")
      freezeReactiveValue(input, "ano")
      
      updateSelectInput(session, "ri", selected = "Pará")
      updateSelectInput(session, "cat", selected = "Frota")
      updateSelectInput(session, "ano", selected = ano_maximo_global)
    })
    
    #------------------------------------------------------------------------------#
    # 2. HUB REATIVO PARA OS VALUE BOXES (Lê 1 vez e distribui)
    hub_vb_pa <- reactive({
      req(input$ri, input$ano)
      frota2 %>%
        filter(ri == input$ri, ano == !!as.numeric(input$ano), categoria %in% c("Licenciados", "Frota")) %>%
        group_by(categoria) %>% 
        summarise(total = sum(valor, na.rm = TRUE), .groups = "drop") %>%
        collect()
    })
    
    #------------------------------------------------------------------------------#
    # ValueBox Frota Total
    output$vb_total_frota <- renderInfoBox({
      tot <- hub_vb_pa() %>% filter(categoria == "Frota") %>% pull(total)
      total <- if(length(tot) == 0 || is.na(tot[1])) 0 else tot[1]
      
      bs4InfoBox(
        title = tags$strong("FROTA GERAL"),
        value = tags$h2(tags$strong(prettyNum(total, big.mark = ".", decimal.mark = ","))),
        subtitle = paste0("Frota em - ", input$ri),
        fill = TRUE, gradient = TRUE, iconElevation = 2, icon = icon("car"), color = "primary"
      )
    })   
    
    # ValueBox Frota Licenciada
    output$vb_frota_licenciada <- renderInfoBox({
      dados <- hub_vb_pa()
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
    
    # ValueBox Frota Não Licenciada
    output$vb_frota_nao_licenciada <- renderInfoBox({
      dados <- hub_vb_pa()
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
    
    #------------------------------------------------------------------------------#
    # Mapa - Total da Frota de Veículos
    titulo1 <- reactive({
      req(input$ri, input$cat, input$ano)
      titulo_texto <- if (input$ri == "Pará") {
        paste0("Frota de Veículos: ", input$cat, ", ", input$ri, " - ", input$ano)
      } else {
        paste0("Frota de Veículos: ", input$cat, ", Região de Integração ", input$ri, " - ", input$ano)
      }
      HTML(paste0("<h4 style='text-align:center; font-weight:bold; margin: 0;'>", titulo_texto, "</h4>"))
    })
    
    output$txtmap <- renderText({ titulo1() })
    
    output$map <- renderLeaflet({
      req(input$ri, input$cat, input$ano)
      
      # Otimização da junção do mapa
      df <- frota2 %>%
        filter(ri != "Pará", ano == !!as.numeric(input$ano), categoria == !!input$cat) %>%
        select(ri, municipio, ano, valor) %>% 
        collect()
      
      x <- geopa %>% left_join(df, by = c("name_muni" = "municipio")) %>%
        mutate(valor = replace_na(valor, 0))
      
      if (input$ri != "Pará") {
        x <- x %>% filter(ri == input$ri)
      }
      
      validate(need(nrow(x) > 0 && sum(x$valor, na.rm = TRUE) > 0, "Dados insuficientes para criar o mapa desta região."))
      
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
      
      conteudo <- sprintf(
        "<div style='padding: 2px; font-family: sans-serif;'>
           <strong style='font-size: 15px; color: #1D44B8;'>%s</strong><br/>
           <span style='color: #666;'>%s:</span> <strong>%s</strong><br/>
           <span style='color: #666;'>Representatividade:</span> <strong>%s</strong>
         </div>",
        x$name_muni, input$cat,
        ifelse(is.na(x$valor), "Não disponível", format(round(x$valor), big.mark = ".", decimal.mark = ",", nsmall = 0)),
        ifelse(is.na(x$percentual) | x$percentual == 0, "N/A", paste0(format(round(x$percentual, 1), nsmall = 1, decimal.mark = ","), "%"))
      ) %>% lapply(htmltools::HTML)
      
      leaflet(x, options = leafletOptions(minZoom = 0, maxZoom = 15, zoomControl = FALSE)) %>%
        addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
        addPolygons(
          weight = 1.5, opacity = 1, color = "black", fillOpacity = 0.9, fillColor = ~ pal(valor), dashArray = "1", smoothFactor = 1.5,
          highlightOptions = highlightOptions(weight = 3, color = "white", dashArray = "", fillOpacity = 1, bringToFront = TRUE),
          label = conteudo,
          labelOptions = labelOptions(style = list("box-shadow" = "0 3px 14px rgba(0,0,0,0.4)", "border-radius" = "5px", padding = "6px 10px"), textsize = "14px", direction = "auto")
        ) %>%
        addLegend(
          pal = pal, values = ~ valor, opacity = 0.7, title = input$cat, position = "bottomright",
          na.label = "Não disponível", labFormat = labelFormat_decimal(big.mark = ".", decimal.mark = ",", digits = 2)
        )
    })
    
    #------------------------------------------------------------------------------#
    # Tabela Reactable - Frota Detalhada com Mini Barras
    texto2 <- reactive({
      req(input$ri, input$ano)
      titulo_texto <- if (input$ri == "Pará") {
        paste0("Distribuição Municipal: Licenciados vs Não Licenciados - ", input$ri, " - ", input$ano)
      } else {
        paste0("Distribuição Municipal: Licenciados vs Não Licenciados - Região de Integração ", input$ri, " - ", input$ano)
      }
      HTML(paste0("<h4 style='text-align:center; font-weight:bold; margin: 0;'>", titulo_texto, "</h4>"))
    })
    
    texto2_clean <- reactive({
      req(input$ri, input$ano)
      if (input$ri == "Pará") {
        paste0("Distribuicao_Muni_Licenciamento_", input$ri, "_", input$ano)
      } else {
        paste0("Distribuicao_Muni_Licenciamento_RI_", input$ri, "_", input$ano)
      }
    })
    
    output$txttab <- renderText({ texto2() })
    
    frotatabdow <- reactive({
      req(input$ri, input$ano)
      
      query <- frota2 %>% filter(ano == !!as.numeric(input$ano))
      
      if (input$ri == "Pará") {
        query <- query %>% filter(ri != "Pará")
      } else {
        query <- query %>% filter(ri == !!input$ri)
      }
      
      query %>%
        select(ri, municipio, categoria, valor) %>%
        collect() %>% 
        pivot_wider(names_from = categoria, values_from = valor, values_fill = 0)
    })
    
    # Download Limpo
    downset_Server("tabdown", frotatabdow, texto2_clean)
    
    # Render Reactable com Mini Barras de Progresso
    output$tab <- renderReactable({
      x <- frotatabdow() 
      validate(need(nrow(x) > 0, "Sem dados para esta tabela."))
      
      agrupamento <- if (input$ri == "Pará") "ri" else NULL
      
      x %>% reactable(
        groupBy = agrupamento,
        defaultPageSize = 15, pagination = TRUE, highlight = TRUE, borderless = TRUE, 
        theme = reactableTheme(
          headerStyle = list(backgroundColor = "white", color = "black", fontWeight = "bold", fontSize = "14px"),
          cellStyle = list(fontSize = "14px", verticalAlign = "middle")
        ),
        columns = list(
          ri = colDef(name = "REGIÃO DE INTEGRAÇÃO", minWidth = 200, style = list(fontWeight = "bold", color = "#444")),
          municipio = colDef(name = "MUNICÍPIOS", minWidth = 150),
          
          Frota = colDef(
            name = "FROTA GERAL", 
            aggregate = "sum", 
            minWidth = 130,
            align = "center",
            format = colFormat(separators = TRUE, locales = "pt-BR"), 
            style = list(fontWeight = "bold", color = "black", fontSize = "15px")
          ),
          
          Licenciados = colDef(
            name = "LICENCIADOS (Regulares)", 
            aggregate = "sum",
            minWidth = 200,
            align = "center",
            format = colFormat(separators = TRUE, locales = "pt-BR"), 
            header = function(value) {
              tags$div(tags$i(class = "fa fa-check-circle", style = "margin-right: 5px; color: #6EE7B7;"), value)
            },
            cell = function(value, index) {
              # Se for uma linha agregada de Região (quando ri == Pará), não tenta desenhar a barra, só mostra o número
              if(is.na(x$Frota[index])) return(formatC(value, format = "d", big.mark = ".", decimal.mark = ","))
              
              total <- x$Frota[index]
              pct <- if (is.na(total) || total == 0) 0 else (value / total) * 100
              
              val_fmt <- formatC(value, format = "d", big.mark = ".", decimal.mark = ",")
              pct_fmt <- paste0(formatC(pct, format = "f", digits = 1, dec = ","), "%")
              css_width <- paste0(gsub(",", ".", as.character(pct)), "%")
              
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
            aggregate = "sum",
            minWidth = 200,
            align = "center",
            format = colFormat(separators = TRUE, locales = "pt-BR"), 
            header = function(value) {
              tags$div(tags$i(class = "fa fa-exclamation-triangle", style = "margin-right: 5px; color: #FF7676;"), value)
            },
            cell = function(value, index) {
              if(is.na(x$Frota[index])) return(formatC(value, format = "d", big.mark = ".", decimal.mark = ","))
              
              total <- x$Frota[index]
              pct <- if (is.na(total) || total == 0) 0 else (value / total) * 100
              
              val_fmt <- formatC(value, format = "d", big.mark = ".", decimal.mark = ",")
              pct_fmt <- paste0(formatC(pct, format = "f", digits = 1, dec = ","), "%")
              css_width <- paste0(gsub(",", ".", as.character(pct)), "%")
              
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
        language = reactableLang(noData = "Sem informação", pagePrevious = "Anterior", pageNext = "Próximo", pageInfo = "{rowStart} a {rowEnd} de {rows} linhas")
      )
    })
    
    #------------------------------------------------------------------------------#
    # Gráfico Evolutivo de Linhas - Comparativo Geral Pará
    texto3 <- reactive({
      min_ano <- min(lista_anos_acumulado, na.rm=T)
      max_ano <- max(lista_anos_acumulado, na.rm=T)
      HTML(paste0("<h4 style='text-align:center; font-weight:bold; margin: 0;'>Evolução da Frota de Veículos: Licenciados vs Não Licenciados (Pará) - ", min_ano, " a ", max_ano, "</h4>"))
    })
    
    texto3_clean <- reactive({
      paste0("Evolucao_Licenciamento_Para")
    })
    
    output$txtgraf <- renderText({ texto3() })
    
    frotagrafdow <- reactive({
      frota2 %>% 
        filter(municipio == "Pará") %>% 
        collect() %>% 
        pivot_wider(names_from = categoria, values_from = valor, values_fill = 0) %>%
        arrange(ano) # Ordena cronologicamente
    })
    
    # Download Limpo
    downset_Server("grafdown", frotagrafdow, texto3_clean)
    
    output$graf <- renderEcharts4r({
      base_graf <- frotagrafdow()
      validate(need(nrow(base_graf) > 0, "Sem histórico para exibição."))
      
      base_graf %>% 
        # AQUI ESTÁ A CORREÇÃO DO EMARANHADO: type = 'category'
        e_chart(x = ano, renderer = "svg") %>%
        e_line(serie = Licenciados, name = "LICENCIADOS", color = "#059669", symbol = "circle", symbolSize = 8, smooth = TRUE, lineStyle = list(width = 4), areaStyle = list(opacity = 0.2), endLabel = list(show = TRUE, formatter = "{a}", fontSize = 14, fontWeight = "bold", color = "inherit")) %>%
        e_line(serie = `Não Licenciados`, name = "NÃO LICENCIADOS", color = "#C92A2A", symbol = "circle", symbolSize = 8, smooth = TRUE, lineStyle = list(width = 4), areaStyle = list(opacity = 0.2), endLabel = list(show = TRUE, formatter = "{a}", fontSize = 14, fontWeight = "bold", color = "inherit")) %>%
        e_line(serie = Frota, name = "FROTA GERAL", color = "#1D44B8", symbol = "circle", symbolSize = 8, smooth = TRUE, lineStyle = list(width = 4), areaStyle = list(opacity = 0.2), endLabel = list(show = TRUE, formatter = "{a}", fontSize = 14, fontWeight = "bold", color = "inherit")) %>%
        e_legend(show = FALSE) %>% 
        e_tooltip(trigger = "axis", formatter = e_tooltip_pointer_formatter("decimal", digits = 0, locale = "pt-BR"), axisPointer = list(type = "shadow")) %>%
        e_x_axis(type = "category", axisLabel = list(show = TRUE, fontSize = 14, fontWeight = "bold"), name = "Ano", splitLine = list(show = FALSE), nameTextStyle = list(fontWeight = "bold", fontSize = 14)) %>%
        e_y_axis(name = "Quantidade", nameTextStyle = list(fontWeight = "bold", fontSize = 14), scale = TRUE, axisLabel = list(formatter = htmlwidgets::JS("function(value){ return value >= 1000 ? (value/1000) + 'k' : value; }"))) %>%
        e_locale("pt-Br") %>%
        e_datazoom(toolbox = FALSE, fillerColor = "#E5F5F9") %>%
        e_grid(show = TRUE, right = "15%", bottom = "15%") %>% 
        e_animation(duration = 600) %>%
        e_toolbox_feature("saveAsImage") %>% e_toolbox_feature("dataZoom") 
    })    
  })
}

#------------------------------------------------------------------------------#
# Play do Módulo (Comentado para produção)
#------------------------------------------------------------------------------#
# ui <- dashboardPage(header = dashboardHeader(),
#                     sidebar = dashboardSidebar(),
#                     body = dashboardBody(fluidPage(
#                       frotapa_ui("frotapa")
#                     )))
 
# server <- function(input, output) {
#   frotapa_Server("frotapa")
# }
 
# shinyApp(ui, server)