import type { TourSite, VillageDetails } from '../types';

const API_BASE_URL = import.meta.env.VITE_API_URL ?? '/api';

export async function fetchSites(): Promise<TourSite[]> {
  const response = await fetch(`${API_BASE_URL}/sites`);
  if (!response.ok) {
    throw new Error(`Không tải được dữ liệu điểm tham quan (HTTP ${response.status})`);
  }
  return response.json();
}

export async function fetchVillageDetails(slug: string, signal?: AbortSignal): Promise<VillageDetails> {
  const response = await fetch(`${API_BASE_URL}/villages/${encodeURIComponent(slug)}`, { signal });
  if (!response.ok) {
    if (response.status === 404) throw new Error('Không tìm thấy thông tin Làng Ước Lễ.');
    throw new Error(`Không tải được thông tin làng (HTTP ${response.status})`);
  }
  return response.json();
}
