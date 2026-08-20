// Photo import driver for "Lang Cuu.xlsx" — see scripts/lib/villagePhotoImport.ts.
// No sheet-role overrides needed: buildings (4.3–4.5), decorative sub-sheets
// (4.3.a etc.), and sheet 2 all follow the generalized regexes/defaults.
//
// Usage: npx tsx scripts/import-lang-cuu-photos.ts [--dry-run] [--limit=N]
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { pool } from '../src/db.js';
import { cleanSiteName, runPhotoImport, type VillagePhotoConfig } from './lib/villagePhotoImport.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const config: VillagePhotoConfig = {
  villageName: 'Làng Cựu',
  xlsxPath: path.resolve(__dirname, '../../../Lang Cuu.xlsx'),
  publicDir: path.resolve(__dirname, '../../public/lang-cuu'),
  publicUrlPrefix: '/lang-cuu',
  sourceFileName: 'Lang Cuu.xlsx',
  // Same 3 building sheets that need a forced header in importParse.ts (no
  // discoverable "Dữ liệu"/"Nội dung" header, or it's duplicated in both the
  // label and data columns) — see that file's FORCED_HEADER comment.
  forcedHeader: {
    '4.3. Nhà thờ họ': { headerRow: 1, dataCol: 3 },
    '4.4. Nhà bác Tứ': { headerRow: 1, dataCol: 3 },
    '4.5. Nhà Tây': { headerRow: 1, dataCol: 3 },
  },
  sheet2: {
    sheetName: '2. Bản đồ tổng thể của làng',
    categoryCol: 1,
    nameCols: [3],
    fieldTypeCol: 4,
    dataCol: 5,
    cleanName: cleanSiteName,
  },
  craftSheets: [
    { sheetName: '7. Sản phẩm nghề truyền thốn', productName: 'Complet - Veston — Hùng Luyến Comple Veston' },
    { sheetName: '7.1 Sản phẩm nghề truyền thốn', productName: 'Complet - Veston — Doanh nghiệp may Complet veston D&T' },
  ],
};

const dryRun = process.argv.includes('--dry-run');
const limitArg = process.argv.find((arg) => arg.startsWith('--limit='));
const limit = limitArg ? Number(limitArg.split('=')[1]) : Infinity;

runPhotoImport(pool, config, { dryRun, limit })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(() => pool.end());
