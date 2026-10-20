import { test } from "node:test";
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import Papa from "papaparse";
import {
  aggregateFleet,
  exportMunicipalities,
  getMetadata,
  parseFleetCsv,
} from "../src/data.js";

const header = '"LOCAL","ANO","MES","TIPO_VEICULO","QTD_VEICULO"\n';
const csv =
  header +
  [
    '"BELEM",2024,1,"AUTOMOVEL",10',
    '"BELEM",2024,1,"MOTOCICLETA",5',
    '"BELEM",2024,3,"AUTOMOVEL",3',
    '"MARABA",2024,1,"AUTOMOVEL",12',
    '"MARABA",2025,2,"AUTOMOVEL",7',
  ].join("\n");

test("parses quoted fields, BOM, CRLF, blank lines, commas and escaped quotes", () => {
  const rows = parseFleetCsv(
    "\uFEFF" + header + '"LOCAL, ""A""",2024,1,"AUTO",0\r\n\r\n',
  );
  assert.deepEqual(rows, [
    { local: 'LOCAL, "A"', year: 2024, month: 1, type: "AUTO", quantity: 0 },
  ]);
});

test("rejects missing columns, malformed CSV, empty data and invalid values", () => {
  assert.throws(() => parseFleetCsv("LOCAL,ANO\nA,2024"), /conter/);
  assert.throws(() => parseFleetCsv(header), /nao contem/);
  assert.throws(() => parseFleetCsv(header + '"unclosed'), /invalido/);
  for (const row of [
    '"A",2024,13,"AUTO",2',
    '"A",2024,0,"AUTO",2',
    '"A",2024,1,"AUTO",-2',
    '"A",2024,1,"AUTO",1.5',
    '"A",2024,1,"AUTO",abc',
    '"A",2024,1,"AUTO",',
    '"A",2024,1,"AUTO",9007199254740992',
    '"",2024,1,"AUTO",2',
    '"A",2024,1,"",2',
    '"A",,1,"AUTO",2',
    '"A",2024.5,1,"AUTO",2',
  ])
    assert.throws(() => parseFleetCsv(header + row), /linha 2/);
});

test("metadata reports sorted distinct dimensions and latest observed month", () => {
  assert.deepEqual(getMetadata(parseFleetCsv(csv)), {
    years: [2024, 2025],
    municipalities: ["BELEM", "MARABA"],
    types: ["AUTOMOVEL", "MOTOCICLETA"],
    latestYear: 2025,
    latestMonth: 2,
    rowCount: 5,
  });
});

test("aggregates quantities, not row counts, and zero-fills monthly gaps", () => {
  const result = aggregateFleet(parseFleetCsv(csv), { from: 2024, to: 2024 });
  assert.equal(result.total, 30);
  assert.equal(result.rowCount, 4);
  assert.equal(result.monthly.length, 12);
  assert.equal(result.monthly[0].quantity, 27);
  assert.equal(result.monthly[1].quantity, 0);
  assert.equal(result.monthly[2].quantity, 3);
  assert.deepEqual(result.municipalities, [
    { name: "BELEM", quantity: 18 },
    { name: "MARABA", quantity: 12 },
  ]);
  assert.deepEqual(result.types, [
    { name: "AUTOMOVEL", quantity: 25 },
    { name: "MOTOCICLETA", quantity: 5 },
  ]);
});

test("combines year range, municipality and vehicle-type filters", () => {
  const result = aggregateFleet(parseFleetCsv(csv), {
    from: 2024,
    to: 2025,
    municipality: "MARABA",
    type: "AUTOMOVEL",
  });
  assert.equal(result.total, 19);
  assert.equal(result.statewideTotal, 32);
  assert.equal(result.monthly.length, 14);
  assert.equal(result.monthly[13].quantity, 7);
  assert.equal(result.rowCount, 2);
});

test("municipality share uses the statewide denominator for the same period and vehicle type", () => {
  const rows = parseFleetCsv(csv);
  const result = aggregateFleet(rows, {
    from: 2024,
    to: 2024,
    municipality: "BELEM",
    type: "AUTOMOVEL",
  });
  assert.equal(result.total, 13);
  assert.equal(result.statewideTotal, 25);
  assert.equal(result.total / result.statewideTotal, 0.52);
  assert.equal(
    aggregateFleet(rows, { from: 2024, to: 2024 }).statewideTotal,
    30,
  );
});

test("ends the chart at the latest source month, not invented future zeroes", () => {
  const result = aggregateFleet(parseFleetCsv(csv), { from: 2025, to: 2025 });
  assert.deepEqual(result.monthly, [
    { date: "2025-01", quantity: 0 },
    { date: "2025-02", quantity: 7 },
  ]);
});

test("handles no matching rows without fabricated values", () => {
  const result = aggregateFleet(parseFleetCsv(csv), {
    from: 2024,
    to: 2024,
    municipality: "MISSING",
  });
  assert.equal(result.total, 0);
  assert.equal(result.rowCount, 0);
  assert.deepEqual(result.types, []);
  assert.deepEqual(result.municipalities, []);
  assert.ok(result.monthly.every((row) => row.quantity === 0));
  assert.throws(() => aggregateFleet([], { from: 2025, to: 2024 }), /Periodo/);
});

test("CSV export includes a BOM, escapes quoted names and neutralizes formulas", () => {
  const output = exportMunicipalities([
    { name: 'A, "B"', quantity: 10 },
    { name: "=SUM(1)", quantity: 3 },
  ]);
  assert.equal(output.charCodeAt(0), 0xfeff);
  const parsed = Papa.parse(output, { header: true }).data;
  assert.equal(parsed[0].MUNICIPIO, 'A, "B"');
  assert.equal(parsed[1].MUNICIPIO, "'=SUM(1)");
  assert.equal(parsed[0].QTD_VEICULO, "10");
});

test("repository CSV validates and reconciles across all aggregations", async (context) => {
  let text;
  try {
    text = await readFile(
      new URL("../../data/veiculos_por_mes_municipio.csv", import.meta.url),
      "utf8",
    );
  } catch (error) {
    if (error.code !== "ENOENT") throw error;
    context.skip("Local source CSV is not present; fixture tests still run.");
    return;
  }
  const rows = parseFleetCsv(text);
  const metadata = getMetadata(rows);
  const result = aggregateFleet(rows, {
    from: metadata.years[0],
    to: metadata.latestYear,
  });
  assert.equal(result.rowCount, rows.length);
  assert.equal(
    result.total,
    rows.reduce((sum, row) => sum + row.quantity, 0),
  );
  for (const dimension of ["monthly", "municipalities", "types"]) {
    assert.equal(
      result[dimension].reduce((sum, row) => sum + row.quantity, 0),
      result.total,
    );
  }
  context.diagnostic(
    JSON.stringify({
      ...metadata,
      municipalities: metadata.municipalities.length,
      types: metadata.types.length,
      total: result.total,
    }),
  );
});
