# Usa a imagem base oficial estável 
FROM rocker/shiny:latest

USER root
WORKDIR /srv/shiny-server/

# 1. DEPENDÊNCIAS DO SISTEMA
# Adicionados pacotes necessários para compilação do Arrow, Leaflet e processamento de imagens 
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev libxml2-dev libssl-dev \
    gdal-bin libgdal-dev libproj-dev libgeos-dev libudunits2-dev \
    curl zip unzip \
    libfontconfig1-dev libharfbuzz-dev libfribidi-dev \
    libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. PACOTES R (Arquitetura Arrow + bs4Dash + echarts4r)
# Instalando versões estáveis e limpando o cache para reduzir o tamanho da imagem final
RUN Rscript -e "install.packages(c( \
    'shiny', 'bs4Dash', 'shinyWidgets', 'shinycssloaders', 'arrow', 'here', \
    'shinyjs', 'tidyverse', 'DT', 'janitor', 'reactable', 'scales', 'forcats', \
    'htmlwidgets', 'htmltools', 'openxlsx', 'readxl', 'echarts4r', \
    'data.table', 'gt', 'quarto', 'tinytex', 'leaflet', 'fontawesome', \
    'BAMMtools', 'classInt'), repos='https://cloud.r-project.org/')" \
    && rm -rf /tmp/downloaded_packages/

# Isolamos os espaciais para compilar localmente (Resolve erros de biblioteca compartilhada)
RUN Rscript -e "install.packages(c('sf', 'terra', 'geobr'), type='source', repos='https://cloud.r-project.org/')" \
    && rm -rf /tmp/downloaded_packages/

# 3. QUARTO CLI (Motor do PDF - Essencial para Podman/K8s)
RUN curl -fsSL -o quarto.tar.gz https://quarto.org/download/latest/quarto-linux-amd64.tar.gz \
    && mkdir -p /opt/quarto \
    && tar -xzf quarto.tar.gz --strip-components=1 -C /opt/quarto \
    && ln -s /opt/quarto/bin/quarto /usr/local/bin/quarto \
    && rm quarto.tar.gz

# 4. TINYTEX E PACOTES LATEX (Blindagem Offline)
# Instalamos todos os pacotes que o HEADER.tex e QUARTO_DOC.qmd utilizam
RUN Rscript -e "tinytex::install_tinytex(force = TRUE)"
RUN Rscript -e "tinytex::tlmgr_install(c('collection-langportuguese', \
    'background', 'parskip', 'fontawesome5', 'enumitem', 'xcolor', \
    'ragged2e', 'float', 'caption', 'fancyhdr', 'geometry', 'setspace', \
    'tools', 'graphics', 'psnfss', 'everypage', \
    'environ', 'trimspaces', 'booktabs', 'longtable'))"

# 5. CÓDIGO FONTE 
COPY . /srv/shiny-server/

# Permissão de escrita para o Feedback e propriedades para o usuário shiny operar arquivos temporários (Quarto PDF)
RUN touch /srv/shiny-server/feedback_data.csv && \
    chown shiny:shiny /srv/shiny-server/feedback_data.csv && \
    chmod 666 /srv/shiny-server/feedback_data.csv && \
    chown -R shiny:shiny /srv/shiny-server/

# 6. CONFIGURAÇÃO DE EXECUÇÃO 
EXPOSE 8180

# Comando otimizado para o Podman/Kubernetes expor corretamente a porta 
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/app.R', port=8180, host='0.0.0.0')"]