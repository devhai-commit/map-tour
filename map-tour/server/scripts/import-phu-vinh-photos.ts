// Photo import driver for "Phú Vinh.xlsx" — see scripts/lib/villagePhotoImport.ts.
// Buildings 4.1–4.5 and combined decorative sheets 5.1/5.2 (-> buildings
// 4.1/4.2 via FIVE_DOT_SHEET_RE) all follow the generalized defaults.
//
// Usage: npx tsx scripts/import-phu-vinh-photos.ts [--dry-run] [--limit=N]
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { pool } from '../src/db.js';
import { cleanSiteName, runPhotoImport, type VillagePhotoConfig } from './lib/villagePhotoImport.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const config: VillagePhotoConfig = {
  villageName: 'Phú Vinh',
  xlsxPath: path.resolve(__dirname, '../../../Phú Vinh.xlsx'),
  publicDir: path.resolve(__dirname, '../../public/phu-vinh'),
  publicUrlPrefix: '/phu-vinh',
  sourceFileName: 'Phú Vinh.xlsx',
  sheet2: {
    sheetName: '2. Bản đồ tổng thể của làng',
    categoryCol: 1,
    nameCols: [2],
    fieldTypeCol: 3,
    dataCol: 4,
    cleanName: cleanSiteName,
  },
  craftSheets: [{ sheetName: '7. Sản phẩm nghề truyền thống', productName: 'Mây tre đan' }],
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
