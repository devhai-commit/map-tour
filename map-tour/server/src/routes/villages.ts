import { Router } from 'express';
import { findVillageDetailsBySlug } from '../services/villages.js';

export const villagesRouter = Router();

villagesRouter.get('/villages/:slug', async (req, res, next) => {
  try {
    const village = await findVillageDetailsBySlug(req.params.slug);
    if (!village) {
      res.status(404).json({ error: 'Không tìm thấy thông tin làng.' });
      return;
    }
    res.json(village);
  } catch (error) {
    next(error);
  }
});
