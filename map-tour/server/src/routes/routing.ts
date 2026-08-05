import { Router } from 'express';
import { env } from '../env.js';

// 2–8 "lng,lat" pairs — matches the curated tour route's 6 stops and the
// point-to-point directions feature's 2 stops, with headroom either way.
const COORDINATES_PATTERN =
  /^-?\d{1,3}(?:\.\d+)?,-?\d{1,3}(?:\.\d+)?(?:;-?\d{1,3}(?:\.\d+)?,-?\d{1,3}(?:\.\d+)?){1,7}$/;

// Loosely bounds coordinates to Vietnam's extent so obviously malformed or
// out-of-region input never reaches the routing engine.
const LNG_RANGE: [number, number] = [100, 111];
const LAT_RANGE: [number, number] = [5, 24];

interface LineStringGeometry {
  type: 'LineString';
  coordinates: [number, number][];
}

interface OsrmStep {
  distance: number;
  name: string;
  maneuver: { type: string; modifier?: string };
}

interface OsrmRoute {
  distance: number;
  duration: number;
  geometry: LineStringGeometry;
  legs: Array<{ steps: OsrmStep[] }>;
}

interface OsrmResponse {
  code: string;
  routes?: OsrmRoute[];
}

function parseCoordinates(raw: string): boolean {
  if (!COORDINATES_PATTERN.test(raw)) return false;
  return raw
    .split(';')
    .map((pair) => pair.split(',').map(Number))
    .every(
      ([lng, lat]) => lng >= LNG_RANGE[0] && lng <= LNG_RANGE[1] && lat >= LAT_RANGE[0] && lat <= LAT_RANGE[1],
    );
}

function toRouteResult(route: OsrmRoute) {
  return {
    geometry: route.geometry,
    distanceMeters: route.distance,
    durationSeconds: route.duration,
    steps: route.legs.flatMap((leg) =>
      leg.steps.map((step) => ({
        type: step.maneuver.type,
        modifier: step.maneuver.modifier ?? null,
        name: step.name,
        distanceMeters: step.distance,
      })),
    ),
  };
}

export const routingRouter = Router();

routingRouter.get('/route', async (req, res, next) => {
  try {
    const coordinates = req.query.coordinates;
    if (typeof coordinates !== 'string' || !parseCoordinates(coordinates)) {
      res.status(400).json({ error: 'Tham số coordinates không hợp lệ' });
      return;
    }

    const url = `${env.osrmUrl}/route/v1/foot/${coordinates}?overview=full&geometries=geojson&steps=true`;
    const response = await fetch(url);
    if (!response.ok) {
      res.status(502).json({ error: 'Dịch vụ định tuyến không phản hồi' });
      return;
    }

    const body = (await response.json()) as OsrmResponse;
    const route = body.routes?.[0];
    if (body.code !== 'Ok' || !route) {
      res.status(502).json({ error: 'Không tìm được tuyến đường phù hợp' });
      return;
    }

    res.json(toRouteResult(route));
  } catch (error) {
    next(error);
  }
});
