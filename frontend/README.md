# Vue Fleet Observatory

Standalone Vue 3 + Vite dashboard. The only integration with the legacy R project is `../data/veiculos_por_mes_municipio.csv`. No R runtime, Shiny server, prediction models, Parquet files, or API is used by this application.

## Run Locally

Requirements: Node.js 22.12+ and npm. Run these commands from `frontend/`:

```sh
npm install
npm run dev
```

Open the local URL printed by Vite. The dev server exposes only the named CSV from the parent data folder, not the full legacy data directory. Parsing, validation, and aggregation happen in a Web Worker so the main UI remains responsive.

## Source Contract

Place the input at `data/veiculos_por_mes_municipio.csv` in the repository root. This local data directory is ignored by Git. Required headers:

```csv
"LOCAL","ANO","MES","TIPO_VEICULO","QTD_VEICULO"
"EXAMPLE MUNICIPALITY",2025,1,"AUTOMOVEL",100
```

- UTF-8 CSV with a header; quoted values and a UTF-8 BOM are supported.
- `LOCAL` and `TIPO_VEICULO`: nonempty strings.
- `ANO`: integer from 1 to 9999; `MES`: integer from 1 to 12.
- `QTD_VEICULO`: nonnegative safe integer. Invalid rows stop loading instead of silently altering totals.
- Repeated dimension combinations are summed, not deduplicated.
- The default filter selects the latest observed year, which may be incomplete.
- Indicators sum quantities for the selected period. They do not imply active accumulated fleet, new registrations, licensing status, or forecasts.
- Months without matching rows display zero. A missing row is not proof of zero real-world activity.
- The monthly chart stops at the latest month in the source; later months are not fabricated as zero.
- Municipality search filters the ranking and its export, not the dashboard totals or the percentage denominator.

## Build And Publish

```sh
npm test
npm run build
npm run preview
```

Publish the contents of `frontend/dist/` to a static web host. No backend or SPA route rewrites are required. Assets use a relative base so the site can also be deployed under a subdirectory.

The build copies the CSV to `dist/data/veiculos_por_mes_municipio.csv`. The preview server serves this built snapshot, not the live source. Replace the source CSV, rebuild, and redeploy to update production data. Reload the page to fetch the deployed file; the app does not poll for changes. Configure the static host with short/no caching for the CSV if updates must appear immediately.

**Publication warning:** every site visitor can download the complete CSV, even when a filter hides rows in the UI. Only publish an approved dataset. Do not deploy this client-only architecture if row-level access controls are required. There is no telemetry, CSV upload, external font request, or external map request.

## Features

- Year-range, municipality, and vehicle-type filters.
- Legacy-style blue, red, green, and purple quantity/coverage/leading-municipality/leading-type indicators.
- Municipality detail view with quantity, statewide share, leading type, and a type-composition table.
- Vehicle-type analysis view.
- Monthly trend chart with a keyboard-accessible alternative data table.
- Vehicle composition, municipality ranking, accent-insensitive search, pagination, and filtered CSV export.
- Source documentation, validation errors, empty states, retry, and mobile layout.
- Collapsible and fullscreen panels, sidebar minimization, and original DETRAN branding.

## Comparison With Shiny

The Vue layout follows the rendered legacy `bs4Dash` presentation rather than the earlier green redesign:

| Element | Legacy Shiny | Vue |
| --- | --- | --- |
| Navigation | 250px dark-gray sidebar, gray brand header, blue selection | Same proportions, colors, hierarchy, and original logo |
| Page layout | White toolbar, gray canvas, colored KPI cards above filters | Same order and visual treatment |
| Content | White panels, blue top borders, shadows, collapse/maximize tools | Same visual treatment with working collapse/fullscreen controls |
| Overview | Municipality map beside a ranking table | Municipality distribution chart beside a ranking table |
| Municipality | Three KPI cards, filters, summaries and charts | Three KPI cards, filters, vehicle-type summary and charts |
| Data | Multiple Parquet sources, geometry, and precomputed predictions | Only quantities in the monthly CSV |

The CSV has no geometry, integration-region mapping, licensing status, color, fuel, nationality, or forecasts. A choropleth map and those analyses cannot be faithfully recreated from this file alone. Missing navigation features are disabled with explanations rather than showing fabricated values. The distribution chart explicitly explains why it replaces the map.

Card labels intentionally say quantities in the CSV, not active accumulated fleet or new registrations. The old dashboard's numbers cannot be used as validation targets for a different source. The municipality's statewide share is computed over the same year range and vehicle-type filter before filtering by municipality.

Tests cover CSV parsing/validation, metadata, filtering, missing months, aggregation, and safe CSV export. An integration test also validates and reconciles the actual dataset when it is present locally.

Browser tests run against the production build on desktop and mobile Chromium:

```sh
npx playwright install chromium
npm run build
npm run test:e2e
```

These check real-data loading, browser errors, viewport overflow, filter combinations, empty states, search, downloads, navigation, and invalid-data recovery.

If a corporate proxy returns HTTP 407 for the local test server, exclude loopback addresses before running the browser tests. In PowerShell: `$env:NO_PROXY = 'localhost,127.0.0.1'`.

The original R files and legacy Dockerfile are intentionally unchanged. That Dockerfile still starts Shiny and does not serve this frontend.
