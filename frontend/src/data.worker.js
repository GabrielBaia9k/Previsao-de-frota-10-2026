import { aggregateFleet, getMetadata, parseFleetCsv } from "./data.js";

let rows;
self.onmessage = async ({ data }) => {
  try {
    if (data.type === "load") {
      const response = await fetch(data.url, { cache: "no-cache" });
      if (!response.ok)
        throw new Error(
          `Nao foi possivel carregar o CSV (HTTP ${response.status}).`,
        );
      rows = parseFleetCsv(await response.text());
      self.postMessage({ type: "ready", metadata: getMetadata(rows) });
    } else if (data.type === "query") {
      if (!rows) throw new Error("A base ainda nao foi carregada.");
      self.postMessage({
        type: "result",
        id: data.id,
        result: aggregateFleet(rows, data.filters),
      });
    }
  } catch (error) {
    self.postMessage({ type: "error", message: error.message, id: data.id });
  }
};
