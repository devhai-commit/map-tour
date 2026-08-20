import type { Cell, Worksheet } from 'exceljs';

// Every survey sheet (see docs/thiet-ke-csdl.md) is a key-value form with a
// header row somewhere in the first few rows containing a "Dữ liệu" column —
// that column holds the actual answer, everything left of it is a (possibly
// multi-level, fill-down-merged) label, and everything right of it is
// metadata for the human filling the form (type hint, instructions, example)
// that we don't store as content.
export interface LabeledRow {
  rowNumber: number;
  labelPath: string[];
  value: string;
}

const HEADER_LABEL = 'dữ liệu';
const HEADER_SCAN_ROWS = 6;

function cellTextFromValue(value: unknown): string {
  if (value === null || value === undefined) return '';
  if (typeof value === 'string') return value.trim();
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  if (value instanceof Date) return value.toISOString();
  return '';
}

function cellText(cell: Cell | undefined): string {
  if (!cell) return '';
  const raw = cell.value as unknown;
  if (raw === null || raw === undefined) return '';
  if (typeof raw === 'string') return raw.trim();
  if (typeof raw === 'number' || typeof raw === 'boolean') return String(raw);
  if (raw instanceof Date) return raw.toISOString();
  if (typeof raw === 'object') {
    const obj = raw as { richText?: Array<{ text: string }>; text?: string; result?: unknown; hyperlink?: string };
    if (Array.isArray(obj.richText)) return obj.richText.map((part) => part.text).join('').trim();
    if (typeof obj.text === 'string') return obj.text.trim();
    if (obj.result !== undefined) return cellTextFromValue(obj.result);
    if (typeof obj.hyperlink === 'string') return obj.hyperlink.trim();
  }
  return '';
}

const FALLBACK_HEADER_LABEL = 'nội dung';

function findDataColumn(worksheet: Worksheet): { headerRow: number; dataCol: number } | null {
  // Most sheets label the answer column "Dữ liệu". The "hiện vật/mỹ thuật"
  // sub-sheets (Cự Đà style, one per building) instead call it "Nội dung" —
  // but "Nội dung" is also the LABEL column header everywhere else, so it's
  // only trusted here as a fallback, and only past column 1.
  let fallback: { headerRow: number; dataCol: number } | null = null;
  for (let r = 1; r <= Math.min(HEADER_SCAN_ROWS, worksheet.rowCount); r++) {
    const row = worksheet.getRow(r);
    for (let c = 1; c <= worksheet.columnCount; c++) {
      const text = cellText(row.getCell(c)).toLowerCase();
      if (text === HEADER_LABEL) return { headerRow: r, dataCol: c };
      if (!fallback && c > 1 && text === FALLBACK_HEADER_LABEL) fallback = { headerRow: r, dataCol: c };
    }
  }
  return fallback;
}

// The source template pre-fills the answer cell with the expected data-type
// name (e.g. "Mô tả", "Ảnh", "Vị trí") before the surveyor overwrites it with
// a real answer — many rows across both sample files were never overwritten,
// so the placeholder itself is left behind looking like real content.
const PLACEHOLDER_VALUES = new Set([
  'mô tả',
  'ảnh',
  'anh',
  'niên đại',
  'text',
  'number',
  'bản đồ',
  'bản vẽ',
  'hình ảnh',
  'link',
  'video',
  'mymap',
  'vị trí',
]);

function isPlaceholderValue(value: string): boolean {
  return PLACEHOLDER_VALUES.has(value.trim().toLowerCase());
}

// Walks every row after the header, carrying forward each label column's
// last non-empty value (like a merged/grouped Excel section) so a row whose
// only new information is the data-column answer still inherits the
// section/field label from the rows above it.
//
// `forcedHeader` bypasses auto-detection entirely — needed for the rare
// sheet whose header row has no "Dữ liệu"/"Nội dung" text at all, or (Lang
// Cuu's building sheets) repeats "Nội dung" in BOTH the label and data
// columns, which defeats findDataColumn's single-fallback assumption.
export function extractLabeledRows(
  worksheet: Worksheet,
  forcedHeader?: { headerRow: number; dataCol: number },
): LabeledRow[] {
  const header = forcedHeader ?? findDataColumn(worksheet);
  if (!header) return [];
  const { headerRow, dataCol } = header;
  const carry: string[] = new Array(dataCol).fill('');
  const rows: LabeledRow[] = [];

  for (let r = headerRow + 1; r <= worksheet.rowCount; r++) {
    const row = worksheet.getRow(r);
    for (let c = 1; c < dataCol; c++) {
      const text = cellText(row.getCell(c));
      if (text) {
        carry[c] = text;
        for (let clear = c + 1; clear < dataCol; clear++) carry[clear] = '';
      }
    }
    const labelPath = carry.slice(1, dataCol).filter((part) => part.length > 0);
    const rawValue = cellText(row.getCell(dataCol));
    const value = isPlaceholderValue(rawValue) ? '' : rawValue;
    if (labelPath.length === 0 && !value) continue;
    rows.push({ rowNumber: r, labelPath: [...labelPath], value });
  }
  return rows;
}

export function lastSegment(row: LabeledRow): string {
  return row.labelPath[row.labelPath.length - 1] ?? '';
}

export function findByLastSegment(rows: LabeledRow[], label: string): LabeledRow | undefined {
  const target = label.trim().toLowerCase();
  return rows.find((row) => lastSegment(row).trim().toLowerCase() === target);
}

export function valueByLastSegment(rows: LabeledRow[], label: string): string | null {
  const row = findByLastSegment(rows, label);
  return row && row.value ? row.value : null;
}

export function splitList(value: string | null): string[] {
  if (!value) return [];
  return value
    .split(/[,;\/]/)
    .map((part) => part.trim())
    .filter(Boolean);
}

export function toNumber(value: string | null): number | null {
  if (!value) return null;
  const match = value.replace(/,/g, '.').match(/-?\d+(\.\d+)?/);
  if (!match) return null;
  const num = Number(match[0]);
  return Number.isFinite(num) ? num : null;
}

export function toInteger(value: string | null): number | null {
  const num = toNumber(value);
  return num === null ? null : Math.round(num);
}

const TRUE_WORDS = ['có', 'yes', 'true'];
const FALSE_WORDS = ['không', 'no', 'false'];

export function toBoolean(value: string | null): boolean | null {
  if (!value) return null;
  const normalized = value.trim().toLowerCase();
  if (TRUE_WORDS.some((word) => normalized.startsWith(word))) return true;
  if (FALSE_WORDS.some((word) => normalized.startsWith(word))) return false;
  return null;
}

export function looksLikeUrl(value: string | null): string | null {
  if (!value) return null;
  return /https?:\/\/|maps\.google|google\.com\/maps/i.test(value) ? value : null;
}
