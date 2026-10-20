import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import { copyFile, mkdir, stat } from "node:fs/promises";
import { createReadStream } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const csvPath = fileURLToPath(
  new URL("../data/veiculos_por_mes_municipio.csv", import.meta.url),
);
const csvRoute = "/data/veiculos_por_mes_municipio.csv";

// Expose only this source file, never the rest of the legacy data directory.
function csvSource() {
  let outputDirectory;
  let building;
  const middleware = (req, res, next) => {
    if (req.url?.split("?")[0] !== csvRoute) return next();
    stat(csvPath)
      .then((info) => {
        res.setHeader("Content-Type", "text/csv; charset=utf-8");
        res.setHeader("Content-Length", info.size);
        res.setHeader("Cache-Control", "no-cache");
        const stream = createReadStream(csvPath);
        stream.on("error", () => res.destroy());
        res.on("close", () => stream.destroy());
        stream.pipe(res);
      })
      .catch(() => {
        res.statusCode = 404;
        res.end("CSV source not found");
      });
  };
  return {
    name: "fleet-csv-source",
    configResolved(config) {
      outputDirectory = path.resolve(config.root, config.build.outDir);
      building = config.command === "build";
    },
    configureServer(server) {
      server.middlewares.use(middleware);
    },
    async closeBundle() {
      if (!building) return;
      await mkdir(path.join(outputDirectory, "data"), { recursive: true });
      await copyFile(csvPath, path.join(outputDirectory, csvRoute.slice(1)));
    },
  };
}

export default defineConfig({
  base: "./",
  plugins: [vue(), csvSource()],
});
