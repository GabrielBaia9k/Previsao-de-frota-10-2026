<script setup>
import { computed, onMounted, onUnmounted, ref } from "vue";

const props = defineProps({ points: { type: Array, required: true } });
const active = ref(null);
const number = new Intl.NumberFormat("pt-BR");
const compact = new Intl.NumberFormat("pt-BR", {
  notation: "compact",
  maximumFractionDigits: 1,
});
const container = ref(null);
const width = ref(900);
let observer;
const height = 260;
const left = 65;
const right = 20;
const top = 20;
const bottom = 40;
const maximum = computed(() =>
  Math.max(1, ...props.points.map((p) => p.quantity)),
);
const coordinates = computed(() =>
  props.points.map((point, index) => ({
    ...point,
    x:
      left +
      (index / Math.max(1, props.points.length - 1)) *
        (width.value - left - right),
    y:
      height -
      bottom -
      (point.quantity / maximum.value) * (height - top - bottom),
  })),
);
const line = computed(() =>
  coordinates.value.map((p) => `${p.x},${p.y}`).join(" "),
);
const area = computed(
  () =>
    `${left},${height - bottom} ${line.value} ${width.value - right},${height - bottom}`,
);
const labels = computed(() =>
  coordinates.value.filter(
    (_, i) =>
      i === 0 ||
      i === props.points.length - 1 ||
      i %
        Math.max(
          1,
          Math.ceil(
            props.points.length / Math.max(2, Math.floor(width.value / 110)),
          ),
        ) ===
        0,
  ),
);
const selected = computed(() =>
  active.value === null ? null : coordinates.value[active.value],
);
function move(event) {
  const bounds = event.currentTarget.getBoundingClientRect();
  const x = ((event.clientX - bounds.left) / bounds.width) * width.value;
  active.value = Math.max(
    0,
    Math.min(
      props.points.length - 1,
      Math.round(
        ((x - left) / (width.value - left - right)) * (props.points.length - 1),
      ),
    ),
  );
}
onMounted(() => {
  observer = new ResizeObserver(([entry]) => {
    width.value = Math.max(280, entry.contentRect.width);
  });
  observer.observe(container.value);
});
onUnmounted(() => observer?.disconnect());
</script>

<template>
  <div ref="container" class="trend-chart">
    <div class="chart-readout" aria-live="polite">
      <template v-if="selected"
        >{{ selected.date.slice(5) }}/{{ selected.date.slice(0, 4) }}
        <strong
          >{{ number.format(selected.quantity) }} veiculos</strong
        ></template
      >
      <template v-else
        >Quantidade mensal
        <span>Passe sobre o grafico para explorar</span></template
      >
    </div>
    <svg
      :viewBox="`0 0 ${width} ${height}`"
      role="img"
      aria-label="Evolucao mensal da quantidade de veiculos no periodo selecionado"
      @pointermove="move"
      @pointerleave="active = null"
    >
      <defs>
        <linearGradient id="trend-fill" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stop-color="#5470c6" stop-opacity="0.22" />
          <stop offset="100%" stop-color="#5470c6" stop-opacity="0.01" />
        </linearGradient>
      </defs>
      <g v-for="tick in [0, 0.25, 0.5, 0.75, 1]" :key="tick">
        <line
          :x1="left"
          :x2="width - right"
          :y1="height - bottom - tick * (height - top - bottom)"
          :y2="height - bottom - tick * (height - top - bottom)"
          stroke="#e5e9e5"
          stroke-dasharray="4 5"
        />
        <text
          :x="left - 12"
          :y="height - bottom - tick * (height - top - bottom) + 4"
          text-anchor="end"
        >
          {{ compact.format(maximum * tick) }}
        </text>
      </g>
      <polygon :points="area" fill="url(#trend-fill)" />
      <polyline
        :points="line"
        fill="none"
        stroke="#5470c6"
        stroke-width="3"
        stroke-linejoin="round"
      />
      <text
        v-for="point in labels"
        :key="point.date"
        :x="point.x"
        :y="height - 10"
        text-anchor="middle"
      >
        {{ point.date.slice(5) }}/{{ point.date.slice(0, 4) }}
      </text>
      <g v-if="selected">
        <line
          :x1="selected.x"
          :x2="selected.x"
          :y1="top"
          :y2="height - bottom"
          stroke="#5470c6"
          stroke-dasharray="3 4"
        />
        <circle
          :cx="selected.x"
          :cy="selected.y"
          r="5"
          fill="#5470c6"
          stroke="white"
          stroke-width="3"
        />
      </g>
    </svg>
    <details class="chart-accessible">
      <summary>Ver valores mensais em tabela</summary>
      <div class="monthly-scroll">
        <table>
          <thead>
            <tr>
              <th scope="col">Mes</th>
              <th scope="col">Quantidade</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="point in points" :key="point.date">
              <td>{{ point.date }}</td>
              <td>{{ number.format(point.quantity) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </details>
  </div>
</template>
