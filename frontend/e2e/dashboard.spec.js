import { test, expect } from "@playwright/test";

const csv =
  "LOCAL,ANO,MES,TIPO_VEICULO,QTD_VEICULO\nBELEM,2024,1,AUTOMOVEL,10\nBELEM,2024,3,MOTOCICLETA,5\nMARABA,2025,2,AUTOMOVEL,7\n";

async function navigate(page, name) {
  const menu = page.getByRole("button", { name: "Menu", exact: true });
  if (page.viewportSize().width <= 760) await menu.click();
  if (name === "Município" || name === "Tipo de Veículo") {
    const group = page.getByRole("button", {
      name: "Análise Detalhada",
      exact: true,
    });
    if ((await group.getAttribute("aria-expanded")) === "false")
      await group.click();
  }
  await page
    .getByRole("navigation")
    .getByRole("button", { name, exact: true })
    .click();
}

test("real CSV loads without browser errors and fits the viewport", async ({
  page,
}) => {
  const errors = [];
  page.on("pageerror", (error) => errors.push(error.message));
  await page.goto("/");
  await expect(page.locator(".metric.featured strong")).toHaveText(/[\d.]+/);
  await expect(page.locator(".source-date>span")).toHaveText(
    /\(.+ de \d{1,4}\)/,
  );
  await expect(page.locator(".metric.blue")).toHaveCSS(
    "background-color",
    "rgb(0, 123, 255)",
  );
  await expect(page.locator(".sidebar")).toHaveCSS(
    "background-color",
    "rgb(52, 58, 64)",
  );
  await expect(page.locator(".metric-grid .metric")).toHaveCount(4);
  await expect(page.locator(".unavailable-nav")).toBeDisabled();
  await expect(page.getByRole("alert")).toHaveCount(0);
  const sizes = await page.evaluate(() => ({
    scroll: document.documentElement.scrollWidth,
    viewport: window.innerWidth,
  }));
  expect(sizes.scroll).toBeLessThanOrEqual(sizes.viewport);
  expect(errors).toEqual([]);
  await page.screenshot({
    path: test.info().outputPath("dashboard.png"),
    fullPage: true,
  });
  await navigate(page, "Município");
  await expect(page.locator(".metric-grid .metric")).toHaveCount(3);
  await expect(page.locator(".metric.featured strong")).toHaveText(/[\d.]+/);
  await page.screenshot({
    path: test.info().outputPath("municipality-real.png"),
    fullPage: true,
  });
});

test("filters, empty states, reset, search, export and source navigation work", async ({
  page,
}) => {
  await page.route("**/data/veiculos_por_mes_municipio.csv", (route) =>
    route.fulfill({ body: csv, contentType: "text/csv" }),
  );
  await page.goto("/");
  await expect(page.locator(".metric.featured strong")).toHaveText("7");
  await page
    .getByRole("combobox", { name: "Ano inicial", exact: true })
    .selectOption("2024");
  await expect(page.locator(".metric.featured strong")).toHaveText("22");
  await page
    .getByRole("combobox", { name: "Município", exact: true })
    .selectOption("BELEM");
  await expect(page.locator(".metric.featured strong")).toHaveText("15");
  await page
    .getByRole("combobox", { name: "Tipo de veículo", exact: true })
    .selectOption("AUTOMOVEL");
  await expect(page.locator(".metric.featured strong")).toHaveText("10");
  await page
    .getByRole("combobox", { name: "Ano inicial", exact: true })
    .selectOption("2025");
  await expect(page.locator(".metric.featured strong")).toHaveText("0");
  await expect(
    page.getByText("Nenhuma quantidade para este recorte.").first(),
  ).toBeVisible();
  await page.getByRole("button", { name: "Limpar filtros" }).click();
  await expect(page.locator(".metric.featured strong")).toHaveText("7");
  await page.getByRole("searchbox").fill("not a municipality");
  await expect(
    page.getByRole("button", { name: "Exportar CSV" }),
  ).toBeDisabled();
  await page.getByRole("searchbox").fill("maraba");
  const downloadEvent = page.waitForEvent("download");
  await page.getByRole("button", { name: "Exportar CSV" }).click();
  expect((await downloadEvent).suggestedFilename()).toBe(
    "frota-municipios-2025-2025.csv",
  );
  await navigate(page, "Sobre os dados");
  await expect(
    page.getByRole("heading", {
      name: "Mesmo padrão visual. Uma única fonte de dados.",
    }),
  ).toBeVisible();
  await navigate(page, "Município");
  await expect(
    page.getByRole("heading", { name: /Tabela - Resumo de Veículos por Tipo/ }),
  ).toBeVisible();
  await expect(page.locator(".metric-grid .metric")).toHaveCount(3);
  await page.screenshot({
    path: test.info().outputPath("municipality.png"),
    fullPage: true,
  });
  await navigate(page, "Tipo de Veículo");
  await expect(
    page.getByRole("heading", { name: "Filtros por Tipo de Veículo" }),
  ).toBeVisible();
});

test("panels collapse and expand, and the desktop sidebar can be minimized", async ({
  page,
}) => {
  await page.route("**/data/veiculos_por_mes_municipio.csv", (route) =>
    route.fulfill({ body: csv, contentType: "text/csv" }),
  );
  await page.goto("/");
  const title = "Filtros de Análise Geral";
  await page
    .getByRole("button", { name: `Recolher painel: ${title}`, exact: true })
    .click();
  await expect(
    page.getByRole("combobox", { name: "Ano inicial", exact: true }),
  ).not.toBeVisible();
  await page
    .getByRole("button", { name: `Expandir painel: ${title}`, exact: true })
    .click();
  await expect(
    page.getByRole("combobox", { name: "Ano inicial", exact: true }),
  ).toBeVisible();
  if (page.viewportSize().width > 760) {
    const maximize = page.getByRole("button", {
      name: `Maximizar painel: ${title}`,
      exact: true,
    });
    await maximize.click();
    await expect
      .poll(() =>
        page.evaluate(() =>
          document.fullscreenElement?.getAttribute("aria-label"),
        ),
      )
      .toBe(title);
    await maximize.click();
    await expect
      .poll(() => page.evaluate(() => document.fullscreenElement === null))
      .toBe(true);
    await page.getByRole("button", { name: "Menu", exact: true }).click();
    await expect(page.locator(".sidebar")).toHaveCSS("width", "72px");
    await page.getByRole("button", { name: "Menu", exact: true }).click();
    await expect(page.locator(".sidebar")).toHaveCSS("width", "250px");
  }
});

test("malformed CSV displays an error and supports retry", async ({ page }) => {
  let broken = true;
  await page.route("**/data/veiculos_por_mes_municipio.csv", (route) =>
    route.fulfill({
      body: broken ? "LOCAL,ANO\nA,2024" : csv,
      contentType: "text/csv",
    }),
  );
  await page.goto("/");
  await expect(page.getByRole("alert")).toContainText("O CSV deve conter");
  broken = false;
  await page.getByRole("button", { name: "Tentar novamente" }).click();
  await expect(page.locator(".metric.featured strong")).toHaveText("7");
  await expect(page.getByRole("alert")).toHaveCount(0);
});
