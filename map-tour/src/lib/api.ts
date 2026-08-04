import type { TourSite } from '../types';
import type { RouteResult } from './routing';

const API_BASE_URL = import.meta.env.VITE_API_URL ?? '/api';

export async function fetchSites(): Promise<TourSite[]> {
  const response = await fetch(`${API_BASE_URL}/sites`);
  if (!response.ok) {
    throw new Error(`Không tải được dữ liệu điểm tham quan (HTTP ${response.status})`);
  }
  return response.json();
}

// `coords` are `[lng, lat]` pairs (OSRM/GeoJSON order) — convert with
// `toLngLat` from ../types before calling this.
export async function fetchRoute(coords: [number, number][]): Promise<RouteResult> {
  const coordinatesParam = coords.map(([lng, lat]) => `${lng},${lat}`).join(';');
  const response = await fetch(`${API_BASE_URL}/route?coordinates=${coordinatesParam}`);
  if (!response.ok) {
    throw new Error(`Không tìm được tuyến đường (HTTP ${response.status})`);
  }
  return response.json();
}
