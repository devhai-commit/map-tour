import type { TourSite } from '../types';

const API_BASE_URL = import.meta.env.VITE_API_URL ?? '/api';

export async function fetchSites(): Promise<TourSite[]> {
  const response = await fetch(`${API_BASE_URL}/sites`);
  if (!response.ok) {
    throw new Error(`Không tải được dữ liệu điểm tham quan (HTTP ${response.status})`);
  }
  return response.json();
}
