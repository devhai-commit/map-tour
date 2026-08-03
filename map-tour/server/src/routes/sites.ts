import { Router } from 'express';
import { pool } from '../db.js';

type LatLng = [number, number];

interface SitePanorama {
  url: string;
  attribution?: string;
}

interface SiteRow {
  id: string;
  kind: 'point' | 'area';
  name: string;
  category: string;
  short_description: string | null;
  village_name: string;
  position_lat: number | null;
  position_lng: number | null;
  boundary: LatLng[] | null;
  panorama_url: string | null;
  panorama_attribution: string | null;
  cover_url: string | null;
  cover_attribution: string | null;
}

const SITES_QUERY = `
  SELECT
    s.id,
    s.kind,
    s.name,
    s.category,
    s.short_description,
    v.name AS village_name,
    s.position_lat,
    s.position_lng,
    s.boundary,
    m.url AS panorama_url,
    m.attribution AS panorama_attribution,
    cover.url AS cover_url,
    cover.attribution AS cover_attribution
  FROM sites s
  JOIN villages v ON v.id = s.village_id
  LEFT JOIN media m ON m.id = s.panorama_media_id
  LEFT JOIN media cover ON cover.id = s.cover_media_id
  ORDER BY s.created_at
`;

function toPanorama(row: SiteRow): SitePanorama | undefined {
  if (!row.panorama_url) return undefined;
  return { url: row.panorama_url, attribution: row.panorama_attribution ?? undefined };
}

function toCover(row: SiteRow): SitePanorama | undefined {
  if (!row.cover_url) return undefined;
  return { url: row.cover_url, attribution: row.cover_attribution ?? undefined };
}

function toTourSite(row: SiteRow) {
  const base = {
    id: row.id,
    name: row.name,
    category: row.category,
    description: row.short_description ?? '',
    village: row.village_name,
    panorama: toPanorama(row),
    cover: toCover(row),
  };

  if (row.kind === 'point') {
    return { ...base, kind: 'point' as const, position: [row.position_lat, row.position_lng] as LatLng };
  }
  return { ...base, kind: 'area' as const, boundary: row.boundary ?? [] };
}

export const sitesRouter = Router();

sitesRouter.get('/sites', async (_req, res, next) => {
  try {
    const result = await pool.query<SiteRow>(SITES_QUERY);
    res.json(result.rows.map(toTourSite));
  } catch (error) {
    next(error);
  }
});
