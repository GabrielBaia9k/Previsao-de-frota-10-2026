# Dashboard_Modulo_Frota_Veiculos_2024
Criação de DashBoard sobre Módulo Frota Veicular Registradas no DETRAN-PA.
Essa versão é a oficial sem falhas e com alguns dados até 2025

## New Vue Frontend

The standalone dashboard is in [`frontend/`](frontend/README.md). It uses only
`data/veiculos_por_mes_municipio.csv`; it does not require Shiny, R, or the prediction algorithms.
The original R application is preserved separately.

```sh
cd frontend
npm install
npm run dev
```

See the frontend documentation for the CSV contract, tests, static deployment, and data-publication considerations.
