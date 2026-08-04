import { useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { TourMap } from '../components/TourMap';
import { SiteList } from '../components/SiteList';
import { DirectionsPanel } from '../components/DirectionsPanel';
import { fetchRoute } from '../lib/api';
import type { RouteResult } from '../lib/routing';
import { siteCenter, toLngLat } from '../types';
import { useSites } from '../context/SitesContext';
import { usePanorama } from '../context/PanoramaContext';

interface DirectionsState {
  isLoading: boolean;
  error: string | null;
  result: RouteResult | null;
}

const EMPTY_DIRECTIONS: DirectionsState = { isLoading: false, error: null, result: null };

export function MapPage() {
  const [searchParams] = useSearchParams();
  const [selectedId, setSelectedId] = useState<string | null>(() => searchParams.get('site'));
  const [directions, setDirections] = useState<DirectionsState>(EMPTY_DIRECTIONS);
  const { openPanorama } = usePanorama();
  const { sites, isLoading, error } = useSites();

  async function handleDirectionsSubmit(fromId: string, toId: string) {
    const fromSite = sites.find((site) => site.id === fromId);
    const toSite = sites.find((site) => site.id === toId);
    if (!fromSite || !toSite) return;

    setDirections({ isLoading: true, error: null, result: null });
    try {
      const result = await fetchRoute([toLngLat(siteCenter(fromSite)), toLngLat(siteCenter(toSite))]);
      setDirections({ isLoading: false, error: null, result });
    } catch (fetchError: unknown) {
      const message = fetchError instanceof Error ? fetchError.message : 'Không tìm được tuyến đường';
      setDirections({ isLoading: false, error: message, result: null });
    }
  }

  const directionsRoute: GeoJSON.Feature<GeoJSON.LineString> | null = directions.result
    ? { type: 'Feature', properties: {}, geometry: directions.result.geometry }
    : null;

  return (
    <div className="map-page">
      <aside className="app__sidebar">
        <div className="app__sidebar-header">
          <h2>Điểm tham quan</h2>
          <p>Di tích &amp; khu vực di sản trong làng</p>
        </div>
        <DirectionsPanel
          sites={sites}
          onSubmit={handleDirectionsSubmit}
          isLoading={directions.isLoading}
          error={directions.error}
          result={directions.result}
        />
        <div className="app__sidebar-list">
          {isLoading && (
            <p className="app__sidebar-status" role="status">
              Đang tải dữ liệu...
            </p>
          )}
          {error && (
            <p className="app__sidebar-status app__sidebar-status--error" role="alert">
              {error}
            </p>
          )}
          <SiteList sites={sites} selectedId={selectedId} onSelect={setSelectedId} onOpenPanorama={openPanorama} />
        </div>
      </aside>
      <div className="app__map">
        <TourMap
          sites={sites}
          selectedId={selectedId}
          onSelect={setSelectedId}
          onOpenPanorama={openPanorama}
          directionsRoute={directionsRoute}
        />
      </div>
    </div>
  );
}
