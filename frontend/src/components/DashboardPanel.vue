<script setup>
import { ref, useId } from "vue";
import DashboardIcon from "./DashboardIcon.vue";

defineProps({
  title: { type: String, required: true },
  icon: { type: String, default: "" },
  source: Boolean,
});
const collapsed = ref(false);
const element = ref(null);
const contentId = useId();
async function maximize() {
  if (document.fullscreenElement === element.value)
    await document.exitFullscreen();
  else if (element.value.requestFullscreen)
    await element.value.requestFullscreen();
}
</script>

<template>
  <section
    ref="element"
    class="panel"
    :class="{ collapsed }"
    :aria-label="title"
  >
    <header class="panel-header">
      <h2><DashboardIcon v-if="icon" :name="icon" />{{ title }}</h2>
      <div class="panel-tools">
        <button
          :aria-label="`${collapsed ? 'Expandir' : 'Recolher'} painel: ${title}`"
          :aria-expanded="!collapsed"
          :aria-controls="contentId"
          @click="collapsed = !collapsed"
        >
          <DashboardIcon :name="collapsed ? 'plus' : 'minus'" />
        </button>
        <button :aria-label="`Maximizar painel: ${title}`" @click="maximize">
          <DashboardIcon name="expand" />
        </button>
      </div>
    </header>
    <div :id="contentId" v-show="!collapsed" class="panel-content">
      <div class="panel-body"><slot /></div>
      <footer v-if="source || $slots.footer" class="panel-footer">
        <div v-if="source">
          <div><strong>Fonte:</strong> veiculos_por_mes_municipio.csv</div>
          <div><strong>Referência:</strong> DTI/DETRAN-PA</div>
        </div>
        <slot name="footer" />
      </footer>
    </div>
  </section>
</template>
