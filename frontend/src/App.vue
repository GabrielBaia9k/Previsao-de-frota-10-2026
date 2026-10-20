<script setup>
import { computed, onMounted, onUnmounted, ref, watch } from "vue";
import TrendChart from "./components/TrendChart.vue";
import DashboardIcon from "./components/DashboardIcon.vue";
import DashboardPanel from "./components/DashboardPanel.vue";
import QuantityBars from "./components/QuantityBars.vue";
import { exportMunicipalities } from "./data.js";
import logo from "../../www/detran1.jpeg";

const metadata = ref(null);
const result = ref(null);
const error = ref("");
const busy = ref(true);
const from = ref(0);
const to = ref(0);
const municipality = ref("");
const type = ref("");
const search = ref("");
const page = ref(1);
const pageSize = ref(15);
const menuOpen = ref(false);
const desktopCollapsed = ref(false);
const mobileQuery = window.matchMedia("(max-width: 760px)");
const smallScreen = ref(mobileQuery.matches);
const detailsOpen = ref(false);
const section = ref("overview");
const sort = ref("quantity");
const number = new Intl.NumberFormat("pt-BR");
const percent = new Intl.NumberFormat("pt-BR", {
  style: "percent",
  maximumFractionDigits: 2,
});
const months = [
  "Janeiro",
  "Fevereiro",
  "Março",
  "Abril",
  "Maio",
  "Junho",
  "Julho",
  "Agosto",
  "Setembro",
  "Outubro",
  "Novembro",
  "Dezembro",
];
let worker;
let requestId = 0;

const normalize = (value) =>
  value
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLocaleLowerCase("pt-BR");
const filteredMunicipalities = computed(() => {
  const rows = (result.value?.municipalities ?? []).filter((row) =>
    normalize(row.name).includes(normalize(search.value)),
  );
  return sort.value === "name"
    ? rows.sort((a, b) => a.name.localeCompare(b.name, "pt-BR"))
    : rows;
});
const pageCount = computed(() =>
  Math.max(1, Math.ceil(filteredMunicipalities.value.length / pageSize.value)),
);
const tableRows = computed(() =>
  filteredMunicipalities.value.slice(
    (page.value - 1) * pageSize.value,
    page.value * pageSize.value,
  ),
);
const period = computed(() =>
  from.value === to.value ? String(from.value) : `${from.value}–${to.value}`,
);
const locality = computed(() => municipality.value || "Pará");
const leadingCity = computed(() => result.value?.municipalities[0]);
const leadingType = computed(() => result.value?.types[0]);
const isMunicipal = computed(() => section.value === "municipalities");
const metrics = computed(() => {
  if (!result.value) return [];
  const primary = {
    color: "blue",
    icon: "car",
    label: locality.value,
    value: number.format(result.value.total),
    description: `QUANTIDADE NO CSV — ${period.value}`,
    primary: true,
  };
  if (isMunicipal.value)
    return [
      primary,
      {
        color: "cyan",
        icon: "pie",
        label: "PESO NO RECORTE ESTADUAL",
        value: percent.format(
          result.value.statewideTotal
            ? result.value.total / result.value.statewideTotal
            : 0,
        ),
        description: "PARTICIPAÇÃO NO MESMO PERÍODO E TIPO",
      },
      {
        color: "green",
        icon: "trophy",
        label: "MAIOR VOLUME",
        value: leadingType.value?.name || "Sem dados",
        description: `${number.format(leadingType.value?.quantity ?? 0)} unidades`,
        text: true,
      },
    ];
  return [
    primary,
    {
      color: "red",
      icon: "calendar",
      label: "MUNICÍPIOS NO RECORTE",
      value: number.format(result.value.municipalities.length),
      description: `COM REGISTROS EM ${period.value}`,
    },
    {
      color: "green",
      icon: "globe",
      label: leadingCity.value?.name || "Sem dados",
      value: number.format(leadingCity.value?.quantity ?? 0),
      description: "MUNICÍPIO DE DESTAQUE NO RECORTE",
    },
    {
      color: "purple",
      icon: "bars",
      label: leadingType.value?.name || "Sem dados",
      value: number.format(leadingType.value?.quantity ?? 0),
      description: `TIPO PREDOMINANTE — ${period.value}`,
    },
  ];
});

function query() {
  if (!metadata.value || !worker) return;
  busy.value = true;
  error.value = "";
  worker.postMessage({
    type: "query",
    id: ++requestId,
    filters: {
      from: from.value,
      to: to.value,
      municipality: municipality.value,
      type: type.value,
    },
  });
}
function load() {
  worker?.terminate();
  metadata.value = null;
  result.value = null;
  error.value = "";
  busy.value = true;
  worker = new Worker(new URL("./data.worker.js", import.meta.url), {
    type: "module",
  });
  worker.onmessage = ({ data }) => {
    if (data.type === "ready") {
      from.value = data.metadata.latestYear;
      to.value = data.metadata.latestYear;
      municipality.value = isMunicipal.value
        ? defaultMunicipality(data.metadata)
        : "";
      type.value = "";
      metadata.value = data.metadata;
      query();
    } else if (data.type === "result" && data.id === requestId) {
      result.value = data.result;
      busy.value = false;
      page.value = 1;
    } else if (
      data.type === "error" &&
      (data.id === undefined || data.id === requestId)
    ) {
      error.value = data.message;
      busy.value = false;
    }
  };
  worker.onerror = () => {
    error.value =
      "Não foi possível processar os dados. Tente recarregar a base.";
    busy.value = false;
  };
  worker.postMessage({
    type: "load",
    url: new URL(
      `${import.meta.env.BASE_URL}data/veiculos_por_mes_municipio.csv`,
      window.location.href,
    ).href,
  });
}
function defaultMunicipality(data) {
  return (
    data.municipalities.find((name) => normalize(name) === "belem") ||
    data.municipalities[0]
  );
}
function reset() {
  from.value = metadata.value.latestYear;
  to.value = metadata.value.latestYear;
  municipality.value = isMunicipal.value
    ? defaultMunicipality(metadata.value)
    : "";
  type.value = "";
  search.value = "";
}
function download() {
  const blob = new Blob([exportMunicipalities(filteredMunicipalities.value)], {
    type: "text/csv;charset=utf-8",
  });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = `frota-municipios-${from.value}-${to.value}.csv`;
  link.click();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
}
function navigate(value) {
  if (value === "municipalities" && metadata.value && !municipality.value)
    municipality.value = defaultMunicipality(metadata.value);
  if (section.value === "municipalities" && value === "overview")
    municipality.value = "";
  section.value = value;
  if (value === "municipalities" || value === "vehicles")
    detailsOpen.value = true;
  menuOpen.value = false;
  search.value = "";
}
function toggleMenu() {
  if (smallScreen.value) menuOpen.value = !menuOpen.value;
  else desktopCollapsed.value = !desktopCollapsed.value;
}
async function fullscreen() {
  if (document.fullscreenElement) await document.exitFullscreen();
  else if (document.documentElement.requestFullscreen)
    await document.documentElement.requestFullscreen();
}
watch([from, to, municipality, type], query);
watch([search, pageSize, sort], () => {
  page.value = 1;
});
function viewportChanged(event) {
  smallScreen.value = event.matches;
  desktopCollapsed.value = false;
  menuOpen.value = false;
}
onMounted(() => {
  mobileQuery.addEventListener("change", viewportChanged);
  load();
});
onUnmounted(() => {
  mobileQuery.removeEventListener("change", viewportChanged);
  worker?.terminate();
});
</script>

<template>
  <a class="skip-link" href="#main">Ir para o conteúdo</a>
  <div class="app-shell" :class="{ 'sidebar-collapsed': desktopCollapsed }">
    <aside id="mobile-navigation" class="sidebar" :class="{ open: menuOpen }">
      <a class="brand" href="#" @click.prevent="navigate('overview')"
        ><img :src="logo" alt="" /><span>Detran - PA</span></a
      >
      <nav aria-label="Navegação principal">
        <div class="nav-heading">ANÁLISE DA FROTA</div>
        <button
          class="nav-item"
          :class="{ active: section === 'overview' }"
          :aria-current="section === 'overview' ? 'page' : undefined"
          @click="navigate('overview')"
        >
          <DashboardIcon name="monitor" /><span>Painel Resumo</span>
        </button>
        <button
          class="nav-item"
          :class="{ active: ['municipalities', 'vehicles'].includes(section) }"
          :aria-expanded="detailsOpen"
          aria-controls="detail-navigation"
          @click="detailsOpen = !detailsOpen"
        >
          <DashboardIcon name="search" /><span>Análise Detalhada</span
          ><DashboardIcon
            class="nav-chevron"
            :class="{ rotated: detailsOpen }"
            name="chevron"
          />
        </button>
        <div id="detail-navigation" v-show="detailsOpen" class="submenu">
          <button
            class="nav-item"
            disabled
            title="O CSV não contém regiões de integração."
          >
            <DashboardIcon name="globe" /><span>Localidade (Estado/RI)</span>
          </button>
          <button
            class="nav-item"
            :class="{ selected: isMunicipal }"
            :aria-current="isMunicipal ? 'page' : undefined"
            @click="navigate('municipalities')"
          >
            <DashboardIcon name="location" /><span>Município</span>
          </button>
          <button
            class="nav-item"
            :class="{ selected: section === 'vehicles' }"
            :aria-current="section === 'vehicles' ? 'page' : undefined"
            @click="navigate('vehicles')"
          >
            <DashboardIcon name="car" /><span>Tipo de Veículo</span>
          </button>
          <button
            class="nav-item"
            disabled
            title="O CSV não contém situação de licenciamento."
          >
            <DashboardIcon name="chevron" /><span>Licenciamento/PA</span>
          </button>
          <button
            class="nav-item"
            disabled
            title="O CSV não contém situação de licenciamento."
          >
            <DashboardIcon name="chevron" /><span>Licenciamento/Município</span>
          </button>
        </div>
        <button
          class="nav-item unavailable-nav"
          disabled
          title="Previsões e modelos R não são usados por este frontend."
        >
          <DashboardIcon name="chart" /><span>Projeções</span
          ><span class="csv-badge">SEM DADOS</span>
        </button>
        <div class="nav-heading about-heading">SOBRE O PROJETO</div>
        <button
          class="nav-item"
          :class="{ active: section === 'source' }"
          :aria-current="section === 'source' ? 'page' : undefined"
          @click="navigate('source')"
        >
          <DashboardIcon name="book" /><span>Sobre os dados</span>
        </button>
        <div class="nav-heading about-heading">FERRAMENTAS</div>
        <button
          class="nav-item"
          :disabled="
            !result ||
            busy ||
            section === 'source' ||
            !filteredMunicipalities.length
          "
          @click="download"
        >
          <DashboardIcon name="download" /><span>Exportar dados CSV</span>
        </button>
      </nav>
      <div v-if="metadata" class="sidebar-update source-date">
        <strong>ÚLTIMO MÊS NA BASE</strong
        ><span
          >({{ months[metadata.latestMonth - 1] }} de
          {{ metadata.latestYear }})</span
        ><small>Fonte exclusiva: CSV mensal</small>
      </div>
    </aside>

    <div class="workspace">
      <header class="topbar">
        <button
          class="menu-toggle icon-button"
          aria-label="Menu"
          :aria-expanded="smallScreen ? menuOpen : !desktopCollapsed"
          aria-controls="mobile-navigation"
          @click="toggleMenu"
        >
          <DashboardIcon name="menu" /></button
        ><span class="toolbar-title">Dashboard de Frota Veicular</span>
        <div class="toolbar-actions">
          <span class="frontend-label">Vue · CSV</span
          ><button
            class="icon-button"
            aria-label="Tela cheia"
            title="Tela cheia"
            @click="fullscreen"
          >
            <DashboardIcon name="expand" /></button
          ><button
            class="icon-button"
            aria-label="Informações sobre os dados"
            title="Informações sobre os dados"
            @click="navigate('source')"
          >
            <DashboardIcon name="info" />
          </button>
        </div>
      </header>
      <main id="main">
        <h1 class="sr-only">
          {{
            section === "overview"
              ? "Painel Resumo"
              : section === "municipalities"
                ? "Análise Municipal"
                : section === "vehicles"
                  ? "Análise por Tipo de Veículo"
                  : "Sobre os Dados"
          }}
        </h1>
        <div v-if="error" class="notice error" role="alert">
          <strong>Não foi possível carregar a visualização.</strong>
          <p>{{ error }}</p>
          <button class="primary-button" @click="load">Tentar novamente</button>
        </div>
        <div v-if="!metadata && busy" class="loading-state" role="status">
          <span class="loader"></span>
          <h2>Carregando o painel de frota</h2>
          <p>Lendo e validando veiculos_por_mes_municipio.csv...</p>
        </div>

        <template v-if="metadata">
          <DashboardPanel
            v-if="section === 'source'"
            title="Sobre os Dados e a Migração do Painel"
            icon="book"
            class="source-panel"
          >
            <h3>Mesmo padrão visual. Uma única fonte de dados.</h3>
            <p>
              A apresentação reproduz o padrão do painel Shiny: navegação
              lateral, indicadores coloridos, filtros e caixas com borda azul.
              Este aplicativo Vue utiliza exclusivamente
              <code>veiculos_por_mes_municipio.csv</code> e não executa R, Shiny
              ou modelos de previsão.
            </p>
            <dl class="source-facts">
              <div>
                <dt>Linhas na base</dt>
                <dd>{{ number.format(metadata.rowCount) }}</dd>
              </div>
              <div>
                <dt>Cobertura temporal</dt>
                <dd>{{ metadata.years[0] }}–{{ metadata.latestYear }}</dd>
              </div>
              <div>
                <dt>Municípios</dt>
                <dd>{{ metadata.municipalities.length }}</dd>
              </div>
              <div>
                <dt>Tipos de veículo</dt>
                <dd>{{ metadata.types.length }}</dd>
              </div>
            </dl>
            <h3>O que pode ser comparado com o painel antigo?</h3>
            <p>
              As quantidades são somas de <code>QTD_VEICULO</code> no período
              selecionado. Os painéis de município, tipo de veículo, evolução
              mensal e distribuição territorial utilizam os campos disponíveis
              no CSV. A participação estadual usa o mesmo período e tipo de
              veículo, antes do filtro de município.
            </p>
            <div class="notice">
              <strong
                >Os números não equivalem à frota ativa acumulada do
                Shiny.</strong
              >
              <p>
                A base CSV é diferente das bases Parquet do painel original.
                Somar seus registros não comprova frota ativa, novos
                licenciamentos ou previsão. Por isso, esses rótulos não foram
                reutilizados nos indicadores.
              </p>
            </div>
            <h3>Limitações da fonte</h3>
            <p>
              O CSV não inclui limites geográficos, regiões de integração, cor,
              combustível, categoria, nacionalidade, situação de licenciamento
              ou previsões. O mapa foi substituído por um gráfico de
              distribuição por município. Recursos sem dados aparecem
              desabilitados, e não com valores simulados.
            </p>
            <h3>Campos disponíveis</h3>
            <div class="schema-grid">
              <code
                v-for="field in [
                  'LOCAL',
                  'ANO',
                  'MES',
                  'TIPO_VEICULO',
                  'QTD_VEICULO',
                ]"
                :key="field"
                >{{ field }}</code
              >
            </div>
            <h3>Atualização e publicação</h3>
            <p>
              Último mês presente: {{ months[metadata.latestMonth - 1] }} de
              {{ metadata.latestYear }}. O último ano pode estar incompleto.
              Meses sem registros são exibidos como zero até o último mês da
              fonte; isso não comprova ausência real de veículos.
            </p>
            <p>
              Em produção, o CSV é copiado durante o build. Substituir a base
              exige um novo build e publicação. Todo visitante com acesso ao
              site pode baixar o arquivo completo.
            </p>
          </DashboardPanel>

          <template v-else>
            <div
              v-if="result"
              class="metric-grid"
              :class="{ 'three-metrics': isMunicipal, updating: busy }"
              :aria-busy="busy"
              aria-label="Indicadores do período"
            >
              <article
                v-for="metric in metrics"
                :key="metric.color"
                class="metric"
                :class="[metric.color, { featured: metric.primary }]"
              >
                <div class="metric-icon">
                  <DashboardIcon :name="metric.icon" />
                </div>
                <div class="metric-content">
                  <div class="metric-label">{{ metric.label }}</div>
                  <strong :class="{ 'text-value': metric.text }">{{
                    metric.value
                  }}</strong
                  ><span>{{ metric.description }}</span>
                </div>
              </article>
            </div>

            <DashboardPanel
              :title="
                isMunicipal
                  ? 'Filtros de Análise Municipal'
                  : section === 'vehicles'
                    ? 'Filtros por Tipo de Veículo'
                    : 'Filtros de Análise Geral'
              "
              icon="filter"
              class="filter-panel"
            >
              <div class="filters">
                <label
                  ><span>MUNICÍPIO</span
                  ><select v-model="municipality" aria-label="Município">
                    <option v-if="!isMunicipal" value="">
                      Pará (todos os municípios)
                    </option>
                    <option
                      v-for="local in metadata.municipalities"
                      :key="local"
                    >
                      {{ local }}
                    </option>
                  </select></label
                ><label
                  ><span>TIPOS DE VEÍCULOS</span
                  ><select v-model="type" aria-label="Tipo de veículo">
                    <option value="">Todos os tipos</option>
                    <option v-for="vehicle in metadata.types" :key="vehicle">
                      {{ vehicle }}
                    </option>
                  </select></label
                >
                <div class="year-range">
                  <label
                    ><span>ANO INICIAL</span
                    ><select v-model.number="from" aria-label="Ano inicial">
                      <option
                        v-for="year in metadata.years"
                        :key="year"
                        :value="year"
                        :disabled="year > to"
                      >
                        {{ year }}
                      </option>
                    </select></label
                  ><label
                    ><span>ANO FINAL</span
                    ><select v-model.number="to" aria-label="Ano final">
                      <option
                        v-for="year in metadata.years"
                        :key="year"
                        :value="year"
                        :disabled="year < from"
                      >
                        {{ year }}
                      </option>
                    </select></label
                  >
                </div>
                <button
                  class="reset-button"
                  aria-label="Limpar filtros"
                  @click="reset"
                >
                  <DashboardIcon name="reset" /> LIMPAR
                </button>
              </div>
            </DashboardPanel>
            <div class="result-caption" role="status">
              {{
                busy
                  ? "Atualizando indicadores..."
                  : `Quantidades no CSV · ${locality} · ${period}`
              }}<span
                >Último mês na fonte: {{ months[metadata.latestMonth - 1] }}/{{
                  metadata.latestYear
                }}</span
              >
            </div>

            <div v-if="result" :class="{ updating: busy }" :aria-busy="busy">
              <div v-if="section === 'overview'" class="overview-grid">
                <DashboardPanel
                  :title="`Distribuição de Veículos por Município - ${locality} - ${period}`"
                  source
                  class="distribution-panel"
                  ><div class="map-source-note">
                    <DashboardIcon name="info" /><span
                      >O CSV não contém limites geográficos. A distribuição por
                      município é apresentada em gráfico, em lugar do mapa do
                      Shiny.</span
                    >
                  </div>
                  <QuantityBars
                    :items="result.municipalities.slice(0, 12)"
                    :total="result.total"
                    color="#2878c8"
                  />
                  <div
                    v-if="result.municipalities.length > 12"
                    class="chart-note"
                  >
                    12 maiores quantidades no período selecionado.
                  </div></DashboardPanel
                >
                <DashboardPanel
                  :title="`Tabela de Veículos por Município - ${locality} - ${period}`"
                  source
                  class="municipality-panel"
                  ><div class="table-tools">
                    <label
                      >Exibir
                      <select
                        v-model.number="pageSize"
                        aria-label="Resultados por página"
                      >
                        <option
                          v-for="size in [15, 30, 50, 100]"
                          :key="size"
                          :value="size"
                        >
                          {{ size }}
                        </option>
                      </select></label
                    ><label class="search-field"
                      >Pesquisar
                      <input
                        v-model="search"
                        type="search"
                        aria-label="Buscar município"
                    /></label>
                  </div>
                  <div class="table-scroll ranking-scroll">
                    <table>
                      <thead>
                        <tr>
                          <th
                            scope="col"
                            :aria-sort="sort === 'name' ? 'ascending' : 'none'"
                          >
                            <button class="sort-button" @click="sort = 'name'">
                              Município <span aria-hidden="true">↕</span>
                            </button>
                          </th>
                          <th
                            scope="col"
                            class="numeric"
                            :aria-sort="
                              sort === 'quantity' ? 'descending' : 'none'
                            "
                          >
                            <button
                              class="sort-button"
                              @click="sort = 'quantity'"
                            >
                              Quantidade <span aria-hidden="true">↓</span>
                            </button>
                          </th>
                          <th scope="col" class="numeric">(%)</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-for="row in tableRows" :key="row.name">
                          <td>{{ row.name }}</td>
                          <td class="numeric">
                            {{ number.format(row.quantity) }}
                          </td>
                          <td class="numeric">
                            {{
                              percent.format(
                                result.total ? row.quantity / result.total : 0,
                              )
                            }}
                          </td>
                        </tr>
                        <tr v-if="!tableRows.length">
                          <td colspan="3" class="empty-state">
                            Nenhum município encontrado para os filtros
                            selecionados.
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                  <div class="pagination">
                    <span
                      >Página {{ page }} de {{ pageCount }} ·
                      {{ filteredMunicipalities.length }} municípios</span
                    >
                    <div>
                      <button
                        :disabled="page <= 1"
                        aria-label="Página anterior"
                        @click="page--"
                      >
                        Anterior</button
                      ><button
                        :disabled="page >= pageCount"
                        aria-label="Próxima página"
                        @click="page++"
                      >
                        Próximo
                      </button>
                    </div>
                  </div>
                  <template #footer
                    ><button
                      class="download-button"
                      aria-label="Exportar CSV"
                      :disabled="busy || !filteredMunicipalities.length"
                      @click="download"
                    >
                      <DashboardIcon name="download" /> Download
                    </button></template
                  ></DashboardPanel
                >
              </div>

              <DashboardPanel
                v-if="isMunicipal"
                :title="`Tabela - Resumo de Veículos por Tipo - ${locality} - ${period}`"
                source
                ><div class="table-scroll">
                  <table class="summary-table">
                    <thead>
                      <tr>
                        <th scope="col">TIPO DE VEÍCULO</th>
                        <th scope="col" class="numeric">QUANTIDADE</th>
                        <th scope="col">REPRESENTATIVIDADE (%)</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr
                        v-for="(vehicle, index) in result.types"
                        :key="vehicle.name"
                      >
                        <td>{{ vehicle.name }}</td>
                        <td class="numeric">
                          {{ number.format(vehicle.quantity) }}
                        </td>
                        <td>
                          <div class="share-cell">
                            <span class="share-track"
                              ><span
                                :style="{
                                  width: `${result.total ? (vehicle.quantity / result.total) * 100 : 0}%`,
                                  background: [
                                    '#17a2b8',
                                    '#dc3545',
                                    '#28a745',
                                    '#ffc107',
                                    '#6c757d',
                                  ][index % 5],
                                }"
                              ></span></span
                            ><strong>{{
                              percent.format(
                                result.total
                                  ? vehicle.quantity / result.total
                                  : 0,
                              )
                            }}</strong>
                          </div>
                        </td>
                      </tr>
                      <tr v-if="!result.types.length">
                        <td colspan="3" class="empty-state">
                          Nenhuma quantidade para este recorte.
                        </td>
                      </tr>
                    </tbody>
                    <tfoot>
                      <tr>
                        <th scope="row">TOTAL NO PERÍODO</th>
                        <td class="numeric">
                          {{ number.format(result.total) }}
                        </td>
                        <td>{{ percent.format(result.total ? 1 : 0) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div></DashboardPanel
              >

              <div class="analysis-grid">
                <DashboardPanel
                  :title="`Evolução Mensal dos Veículos - ${locality} - ${period}`"
                  source
                  ><TrendChart :points="result.monthly" /></DashboardPanel
                ><DashboardPanel
                  :title="`Quantidade de Veículos por Tipo - ${locality} - ${period}`"
                  source
                  ><QuantityBars
                    :items="result.types"
                    :total="result.total"
                    color="#5470c6"
                /></DashboardPanel>
              </div>
              <div class="data-footnote">
                <DashboardIcon name="info" />
                <p>
                  As quantidades são somas dos registros do CSV, não a frota
                  ativa acumulada, licenciamentos ou previsões do painel Shiny.
                  <button @click="navigate('source')">
                    Entenda as diferenças entre as bases.
                  </button>
                </p>
              </div>
            </div>
          </template>
        </template>
      </main>
      <footer class="page-footer">
        <strong>DETRAN-PA</strong><strong>BELÉM · Vue / CSV</strong>
      </footer>
    </div>
  </div>
</template>
