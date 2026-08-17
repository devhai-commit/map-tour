import type { TourSite, Village } from '../types';
import type { RouteResult } from './routing';

const API_BASE_URL = import.meta.env.VITE_API_URL ?? '/api';

export async function fetchVillages(): Promise<Village[]> {
  const response = await fetch(`${API_BASE_URL}/villages`);
  if (!response.ok) {
    throw new Error(`Không tải được danh sách làng (HTTP ${response.status})`);
  }
  return response.json();
}

export async function fetchVillage(villageSlug: string): Promise<Village> {
  const response = await fetch(`${API_BASE_URL}/villages/${villageSlug}`);
  if (!response.ok) {
    throw new Error(`Không tải được thông tin làng (HTTP ${response.status})`);
  }
  return response.json();
}

export async function fetchSites(villageSlug: string): Promise<TourSite[]> {
  const response = await fetch(`${API_BASE_URL}/villages/${villageSlug}/sites`);
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
