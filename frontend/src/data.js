import Papa from "papaparse";

const columns = ["LOCAL", "ANO", "MES", "TIPO_VEICULO", "QTD_VEICULO"];

export function parseFleetCsv(text) {
  const parsed = Papa.parse(text, {
    header: true,
    skipEmptyLines: "greedy",
    transformHeader: (value) => value.trim(),
  });
  if (parsed.errors.length)
    throw new Error("CSV invalido: " + parsed.errors[0].message);
  if (!columns.every((column) => parsed.meta.fields?.includes(column))) {
    throw new Error("O CSV deve conter: " + columns.join(", "));
  }
  if (!parsed.data.length) throw new Error("O CSV nao contem dados.");
  return parsed.data.map((row, index) => {
    const local = row.LOCAL?.trim();
    const type = row.TIPO_VEICULO?.trim();
    const year = Number(row.ANO);
    const month = Number(row.MES);
    const quantity = Number(row.QTD_VEICULO);
    if (
      !local ||
      !type ||
      !row.ANO?.trim() ||
      !row.MES?.trim() ||
      !row.QTD_VEICULO?.trim() ||
      !Number.isInteger(year) ||
      year < 1 ||
      year > 9999 ||
      !Number.isInteger(month) ||
      month < 1 ||
      month > 12 ||
      !Number.isSafeInteger(quantity) ||
      quantity < 0
    ) {
      throw new Error(`Dados invalidos na linha ${index + 2}.`);
    }
    return { local, year, month, type, quantity };
  });
}

export function getMetadata(rows) {
  const years = new Set();
  const municipalities = new Set();
  const types = new Set();
  let latest = 0;
  for (const row of rows) {
    years.add(row.year);
    municipalities.add(row.local);
    types.add(row.type);
    latest = Math.max(latest, row.year * 100 + row.month);
  }
  return {
    years: [...years].sort((a, b) => a - b),
    municipalities: [...municipalities].sort((a, b) =>
      a.localeCompare(b, "pt-BR"),
    ),
    types: [...types].sort((a, b) => a.localeCompare(b, "pt-BR")),
    latestYear: Math.floor(latest / 100),
    latestMonth: latest % 100,
    rowCount: rows.length,
  };
}

export function aggregateFleet(
  rows,
  { from, to, municipality = "", type = "" },
) {
  if (
    !Number.isInteger(from) ||
    !Number.isInteger(to) ||
    from > to ||
    to - from > 9999
  ) {
    throw new Error("Periodo invalido.");
  }
  const monthly = new Map();
  const municipalities = new Map();
  const types = new Map();
  let total = 0;
  let statewideTotal = 0;
  let rowCount = 0;
  let latest = 0;
  // Zero-fill missing months so the chart never connects across an invisible gap.
  for (let year = from; year <= to; year++) {
    for (let month = 1; month <= 12; month++)
      monthly.set(`${year}-${String(month).padStart(2, "0")}`, 0);
  }
  for (const row of rows) {
    latest = Math.max(latest, row.year * 100 + row.month);
    if (row.year < from || row.year > to || (type && row.type !== type))
      continue;
    // The comparison denominator must not shrink with the municipality filter.
    statewideTotal += row.quantity;
    if (municipality && row.local !== municipality) continue;
    total += row.quantity;
    rowCount++;
    const key = `${row.year}-${String(row.month).padStart(2, "0")}`;
    monthly.set(key, monthly.get(key) + row.quantity);
    municipalities.set(
      row.local,
      (municipalities.get(row.local) || 0) + row.quantity,
    );
    types.set(row.type, (types.get(row.type) || 0) + row.quantity);
  }
  const descending = (map) =>
    [...map]
      .map(([name, quantity]) => ({ name, quantity }))
      .sort(
        (a, b) =>
          b.quantity - a.quantity || a.name.localeCompare(b.name, "pt-BR"),
      );
  return {
    total,
    statewideTotal,
    rowCount,
    monthly: [...monthly]
      .filter(([date]) => Number(date.replace("-", "")) <= latest)
      .map(([date, quantity]) => ({ date, quantity })),
    municipalities: descending(municipalities),
    types: descending(types),
  };
}

export function exportMunicipalities(rows) {
  return (
    "\uFEFF" +
    Papa.unparse(
      rows.map((row) => ({
        MUNICIPIO: row.name,
        QTD_VEICULO: row.quantity,
      })),
      { escapeFormulae: true },
    )
  );
}
