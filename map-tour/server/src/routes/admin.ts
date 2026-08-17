import { Router } from 'express';
import multer from 'multer';
import ExcelJS from 'exceljs';
import { env } from '../env.js';
import { pool } from '../db.js';
import { parseWorkbook } from '../lib/importParse.js';
import { commitImport } from '../lib/importCommit.js';
import type { ParsedImport } from '../lib/importTypes.js';

const MAX_UPLOAD_BYTES = 25 * 1024 * 1024; // survey workbooks run a few hundred KB; generous headroom for embedded images
const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: MAX_UPLOAD_BYTES } });

export const adminRouter = Router();

adminRouter.use((req, res, next) => {
  if (!env.adminImportKey) {
    res.status(503).json({ error: 'Chức năng nhập dữ liệu chưa được bật (thiếu ADMIN_IMPORT_KEY trên server)' });
    return;
  }
  const providedKey = req.header('x-admin-key');
  if (providedKey !== env.adminImportKey) {
    res.status(401).json({ error: 'Sai khóa quản trị' });
    return;
  }
  next();
});

adminRouter.post('/admin/import/parse', upload.single('file'), async (req, res, next) => {
  try {
    if (!req.file) {
      res.status(400).json({ error: 'Thiếu file Excel (field "file")' });
      return;
    }
    const workbook = new ExcelJS.Workbook();
    // exceljs pulls in a transitively older @types/node (via @fast-csv) whose
    // `Buffer` shape structurally conflicts with the project's — same value
    // at runtime, so route the cast through exceljs's own expected param type.
    await workbook.xlsx.load(req.file.buffer as unknown as Parameters<typeof workbook.xlsx.load>[0]);
    const parsed = parseWorkbook(workbook, req.file.originalname);
    res.json(parsed);
  } catch (error) {
    next(error);
  }
});

adminRouter.post('/admin/import/commit', async (req, res, next) => {
  try {
    const parsed = req.body as ParsedImport;
    if (!parsed || typeof parsed !== 'object') {
      res.status(400).json({ error: 'Thiếu dữ liệu đã phân tích để nhập' });
      return;
    }
    const summary = await commitImport(pool, parsed);
    res.json(summary);
  } catch (error) {
    next(error);
  }
});
