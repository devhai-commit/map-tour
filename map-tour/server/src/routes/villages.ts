import { Router } from 'express';
import { pool } from '../db.js';
import { findVillageDetailsBySlug } from '../services/villages.js';

interface VillageListRow {
  id: string;
  slug: string;
  name: string;
  admin_location: string | null;
  main_occupations: string[] | null;
  founded_period: string | null;
  cover_url: string | null;
}

const VILLAGE_LIST_QUERY = `
  SELECT v.id, v.slug, v.name, v.admin_location, v.main_occupations, v.founded_period, (
    SELECT m.url FROM sites s
    JOIN media m ON m.id = s.cover_media_id
    WHERE s.village_id = v.id AND s.cover_media_id IS NOT NULL AND m.kind = 'anh'
    ORDER BY s.created_at
    LIMIT 1
  ) AS cover_url
  FROM villages v
  ORDER BY v.name
`;

function toVillageSummary(row: VillageListRow) {
  return {
    id: row.id,
    slug: row.slug,
    name: row.name,
    adminLocation: row.admin_location,
    mainOccupations: row.main_occupations ?? [],
    foundedPeriod: row.founded_period,
    coverUrl: row.cover_url,
  };
}

export const villagesRouter = Router();

villagesRouter.get('/villages', async (_req, res, next) => {
  try {
    const result = await pool.query<VillageListRow>(VILLAGE_LIST_QUERY);
    res.json(result.rows.map(toVillageSummary));
  } catch (error) {
    next(error);
  }
});

villagesRouter.get('/villages/:slug', async (req, res, next) => {
  try {
    const village = await findVillageDetailsBySlug(req.params.slug);
    if (!village) {
      res.status(404).json({ error: 'Không tìm thấy làng.' });
      return;
    }
    res.json(village);
  } catch (error) {
    next(error);
  }
});
