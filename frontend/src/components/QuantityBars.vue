<script setup>
import { computed } from "vue";
const props = defineProps({
  items: { type: Array, required: true },
  total: { type: Number, required: true },
  color: { type: String, default: "#5470c6" },
});
const maximum = computed(() =>
  Math.max(1, ...props.items.map((row) => row.quantity)),
);
const number = new Intl.NumberFormat("pt-BR");
</script>

<template>
  <div
    class="quantity-bars"
    role="list"
    aria-label="Distribuição das quantidades"
  >
    <div v-if="!items.length || !total" class="empty-state">
      Nenhuma quantidade para este recorte.
    </div>
    <div
      v-for="item in items"
      :key="item.name"
      class="quantity-bar-row"
      role="listitem"
    >
      <div class="quantity-bar-label">
        <span>{{ item.name }}</span
        ><strong>{{ number.format(item.quantity) }}</strong>
      </div>
      <div class="quantity-bar-track">
        <span
          :style="{
            width: `${(item.quantity / maximum) * 100}%`,
            background: color,
          }"
        ></span>
      </div>
    </div>
  </div>
</template>
