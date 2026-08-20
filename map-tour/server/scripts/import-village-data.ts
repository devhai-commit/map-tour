// Reusable text-data importer for any village survey workbook that follows
// the sheet-numbering convention handled by parseWorkbook()/commitImport()
// (village profile, history stories, heritage buildings + technical details,
// decorative art items, intangible heritage, craft products). Does NOT touch
// site GPS pins (sheet "2.") or photos (Google Drive links) — those still
// need the per-village migration SQL / photo script, same as Cự Đà/Ước Lễ.
//
// Usage: npx tsx scripts/import-village-data.ts "<Tên file>.xlsx"
//   Path is resolved relative to the project root (lang-uoc-le-db/) unless
//   already absolute.
import ExcelJS from 'exceljs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { pool } from '../src/db.js';
import { parseWorkbook } from '../src/lib/importParse.js';
import { commitImport } from '../src/lib/importCommit.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PROJECT_ROOT = path.resolve(__dirname, '../../../');

async function main(): Promise<void> {
  const arg = process.argv[2];
  if (!arg) {
    console.error('Usage: npx tsx scripts/import-village-data.ts "<Tên file>.xlsx"');
    process.exitCode = 1;
    return;
  }
  const xlsxPath = path.isAbsolute(arg) ? arg : path.join(PROJECT_ROOT, arg);
  const sourceFileName = path.basename(xlsxPath);

  console.log(`Đọc workbook: ${xlsxPath}`);
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.readFile(xlsxPath);

  const parsed = parseWorkbook(workbook, sourceFileName);

  console.log('\n--- Kết quả phân tích ---');
  console.log('Làng:', parsed.village?.name ?? '(không tìm thấy)');
  console.log('Số câu chuyện lịch sử:', parsed.historyStories.length);
  console.log('Số công trình di sản:', parsed.heritageBuildings.length, parsed.heritageBuildings.map((b) => `${b.tempId} ${b.name}`));
  console.log('Số hiện vật mỹ thuật:', parsed.decorativeArtItems.length);
  console.log('Số di sản phi vật thể:', parsed.intangibleHeritageItems.length);
  console.log('Số sản phẩm nghề:', parsed.craftProducts.length, parsed.craftProducts.map((p) => p.name));
  if (parsed.warnings.length > 0) {
    console.log('\n--- Cảnh báo (từ parse) ---');
    for (const warning of parsed.warnings) console.log(' -', warning);
  }

  if (process.argv.includes('--dry-run')) {
    console.log('\n(chế độ --dry-run: không ghi CSDL)');
    await pool.end();
    return;
  }

  const summary = await commitImport(pool, parsed);
  console.log('\n--- Kết quả commit ---');
  console.log(summary);
  await pool.end();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
