// Photo import driver for "Làng Chuông.xlsx" — see scripts/lib/villagePhotoImport.ts.
// Sheet 2 here has an extra sub-object name column (col 3) that overrides the
// broader col-2 label when filled (e.g. category "Điếm" + specific "Điếm
// Ngõa Kiều") — nameCols lists the fallback columns in outer-to-inner order.
//
// Usage: npx tsx scripts/import-lang-chuong-photos.ts [--dry-run] [--limit=N]
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { pool } from '../src/db.js';
import { cleanSiteName, runPhotoImport, type VillagePhotoConfig } from './lib/villagePhotoImport.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const config: VillagePhotoConfig = {
  villageName: 'làng Chuông',
  xlsxPath: path.resolve(__dirname, '../../../Làng Chuông.xlsx'),
  publicDir: path.resolve(__dirname, '../../public/lang-chuong'),
  publicUrlPrefix: '/lang-chuong',
  sourceFileName: 'Làng Chuông.xlsx',
  sheet2: {
    sheetName: '2. Bản đồ tổng thể của làng',
    categoryCol: 1,
    nameCols: [2, 3],
    fieldTypeCol: 4,
    dataCol: 5,
    cleanName: cleanSiteName,
  },
  craftSheets: [
    { sheetName: '7. Sản phẩm nghề truyền thốn', productName: 'Mây tre nón lá — Cơ sở sản xuất kinh doanh nón lá Lê Văn Tuy' },
    { sheetName: '7.1 Sản phẩm nghề truyền thốn', productName: 'Mây tre nón lá — Hợp tác xã mây tre nón lá Thu Hương' },
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
