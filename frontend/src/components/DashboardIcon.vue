<script setup>
defineProps({ name: { type: String, default: "chart" } });
const paths = {
  monitor: "M3 3h18v13H3z M8 21h8 M12 16v5",
  car: "M3 16v-5l3-7h12l3 7v5H3z M3 11h18 M6 16v4 M18 16v4 M6 13h2 M16 13h2",
  location:
    "M20 10c0 6-8 12-8 12S4 16 4 10a8 8 0 1 1 16 0z M15 10a3 3 0 1 1-6 0 3 3 0 0 1 6 0",
  chart: "M4 3v17h17 M8 15l4-5 4 3 5-7",
  bars: "M4 3v18h17 M8 6h10 M8 11h6 M8 16h12",
  globe:
    "M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0 M3 12h18 M12 3c5 5 5 13 0 18-5-5-5-13 0-18",
  search: "M16 10a6 6 0 1 1-12 0 6 6 0 0 1 12 0 M15 15l6 6",
  calendar: "M4 5h16v16H4z M8 2v6 M16 2v6 M4 11h16 M8 15h2 M14 15h2",
  trophy:
    "M7 3h10v7a5 5 0 0 1-10 0V3z M7 5H3v3a5 5 0 0 0 5 5 M17 5h4v3a5 5 0 0 1-5 5 M12 15v6 M8 21h8",
  pie: "M12 3v9h9 M8 4a9 9 0 1 0 12 12 M16 3v5h5",
  filter: "M3 4h18l-7 8v8l-4-2v-6z",
  menu: "M4 6h16 M4 12h16 M4 18h16",
  reset: "M4 11a8 8 0 1 1 1 6 M4 4v7h7",
  download: "M12 3v12 M7 10l5 5 5-5 M4 17v4h16v-4",
  expand:
    "M8 3H3v5 M16 3h5v5 M3 16v5h5 M21 16v5h-5 M3 3l6 6 M21 3l-6 6 M3 21l6-6 M21 21l-6-6",
  minus: "M5 12h14",
  plus: "M5 12h14 M12 5v14",
  chevron: "M9 5l7 7-7 7",
  book: "M3 4h7l2 2 2-2h7v16h-7l-2 2-2-2H3z M12 6v16",
  info: "M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0 M12 11v6 M12 7v1",
  document: "M5 3h9l5 5v13H5z M14 3v6h5 M8 13h8 M8 17h8",
};
</script>

<template>
  <svg
    class="dashboard-icon"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    stroke-width="2"
    stroke-linecap="round"
    stroke-linejoin="round"
    aria-hidden="true"
  >
    <path :d="paths[name] || paths.chart" />
  </svg>
</template>
