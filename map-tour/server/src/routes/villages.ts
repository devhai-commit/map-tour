import { Router } from 'express';
import { pool } from '../db.js';

interface VillageListRow {
  id: string;
  slug: string;
  name: string;
  admin_location: string | null;
  main_occupations: string[] | null;
  founded_period: string | null;
  cover_url: string | null;
}

interface VillageDetailRow extends VillageListRow {
  aliases: string[] | null;
  google_maps_link: string | null;
  brand_identity: string | null;
  name_meaning: string | null;
  natural_features: string | null;
  site_selection_history: string | null;
  morphology_description: string | null;
}

const VILLAGE_COVER_SUBQUERY = `(
  SELECT m.url FROM sites s
  JOIN media m ON m.id = s.cover_media_id
  WHERE s.village_id = v.id AND s.cover_media_id IS NOT NULL
  ORDER BY s.created_at
  LIMIT 1
) AS cover_url`;

const VILLAGE_LIST_QUERY = `
  SELECT v.id, v.slug, v.name, v.admin_location, v.main_occupations, v.founded_period, ${VILLAGE_COVER_SUBQUERY}
  FROM villages v
  ORDER BY v.name
`;

const VILLAGE_DETAIL_QUERY = `
  SELECT
    v.id, v.slug, v.name, v.admin_location, v.main_occupations, v.founded_period, ${VILLAGE_COVER_SUBQUERY},
    v.aliases, v.google_maps_link, v.brand_identity, v.name_meaning,
    v.natural_features, v.site_selection_history, v.morphology_description
  FROM villages v
  WHERE v.slug = $1
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
    const result = await pool.query<VillageDetailRow>(VILLAGE_DETAIL_QUERY, [req.params.slug]);
    if (result.rows.length === 0) {
      res.status(404).json({ error: 'Không tìm thấy làng.' });
      return;
    }
    const row = result.rows[0];
    res.json({
      ...toVillageSummary(row),
      aliases: row.aliases ?? [],
      googleMapsLink: row.google_maps_link,
      brandIdentity: row.brand_identity,
      nameMeaning: row.name_meaning,
      naturalFeatures: row.natural_features,
      siteSelectionHistory: row.site_selection_history,
      morphologyDescription: row.morphology_description,
    });
  } catch (error) {
    next(error);
  }
});
