// Photo import driver for "Hạ Thái.xlsx" — see scripts/lib/villagePhotoImport.ts
// for the shared logic. Sheet-role overrides mirror src/lib/importParse.ts's
// SHEET_ROLE_OVERRIDES for this same file (its second building sits at "5.1.",
// with the two buildings' decorative sub-sheets named unusually as "4.2."/"5.2").
//
// Usage: npx tsx scripts/import-ha-thai-photos.ts [--dry-run] [--limit=N]
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { pool } from '../src/db.js';
import { cleanSiteName, runPhotoImport, type VillagePhotoConfig } from './lib/villagePhotoImport.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const config: VillagePhotoConfig = {
  villageName: 'Hạ Thái',
  xlsxPath: path.resolve(__dirname, '../../../Hạ Thái.xlsx'),
  publicDir: path.resolve(__dirname, '../../public/ha-thai'),
  publicUrlPrefix: '/ha-thai',
  sourceFileName: 'Hạ Thái.xlsx',
  sheetRoleOverrides: {
    '4.2. Hiện vật- Mỹ thuật trang t': { role: 'decorative', buildingTempId: '4.1' },
    '5.1. Kiến trúc nhà cổ bà Dịp': { role: 'building' },
    '5.2 Hiện vật-Mỹ thuật trang trí': { role: 'decorative', buildingTempId: '5.1. Kiến trúc nhà cổ bà Dịp' },
  },
  sheet2: {
    sheetName: '2. Bản đồ tổng thể của làng',
    categoryCol: 1,
    nameCols: [2],
    fieldTypeCol: 3,
    dataCol: 4,
    cleanName: cleanSiteName,
  },
  craftSheets: [
    { sheetName: '7.1 SPNTT-Cô Hồi', productName: '- Tranh sơn mài\n - Các vật dụng trang trí: Lọ hoa, đĩa trưng bày' },
    {
      sheetName: '7.2 SPNTT-Cty SM Phúc Cường',
      productName: '- Tranh sơn mài\n - Các vật dụng trang trí: Lọ hoa, đĩa trưng bày\n - Vận dụng gia đình',
    },
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
