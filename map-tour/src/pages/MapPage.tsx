import { useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { TourMap } from '../components/TourMap';
import { SiteList } from '../components/SiteList';
import { useSites } from '../context/SitesContext';
import { usePanorama } from '../context/PanoramaContext';

export function MapPage() {
  const [searchParams] = useSearchParams();
  const [selectedId, setSelectedId] = useState<string | null>(() => searchParams.get('site'));
  const { openPanorama } = usePanorama();
  const { sites, isLoading, error } = useSites();

  return (
    <div className="map-page">
      <aside className="app__sidebar">
        <div className="app__sidebar-header">
          <h2>Điểm tham quan</h2>
          <p>Di tích &amp; khu vực di sản trong làng</p>
        </div>
        <div className="app__sidebar-list">
          {isLoading && <p className="app__sidebar-status">Đang tải dữ liệu...</p>}
          {error && <p className="app__sidebar-status app__sidebar-status--error">{error}</p>}
          <SiteList sites={sites} selectedId={selectedId} onSelect={setSelectedId} onOpenPanorama={openPanorama} />
        </div>
      </aside>
      <main className="app__map">
        <TourMap sites={sites} selectedId={selectedId} onSelect={setSelectedId} onOpenPanorama={openPanorama} />
      </main>
    </div>
  );
}
