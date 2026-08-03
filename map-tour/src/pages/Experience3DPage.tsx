import { useEffect, useState } from 'react';
import { PanoramaViewer } from '../components/PanoramaViewer';
import { useSites } from '../context/SitesContext';

export function Experience3DPage() {
  const { sites, isLoading, error } = useSites();
  const destinations = sites.filter((site) => site.panorama);
  const [activeId, setActiveId] = useState<string | null>(null);

  useEffect(() => {
    if (activeId === null && destinations.length > 0) {
      setActiveId(destinations[0].id);
    }
  }, [activeId, destinations]);

  const active = destinations.find((site) => site.id === activeId) ?? null;

  return (
    <div className="experience3d">
      <div className="experience3d__viewer-wrap">
        {isLoading ? (
          <div className="experience3d__empty">Đang tải dữ liệu...</div>
        ) : error ? (
          <div className="experience3d__empty">{error}</div>
        ) : active?.panorama ? (
          <PanoramaViewer key={active.id} url={active.panorama.url} className="experience3d__viewer" />
        ) : (
          <div className="experience3d__empty">Chưa có ảnh 360° để hiển thị.</div>
        )}
        {active && (
          <div className="experience3d__caption">
            <h2>{active.name}</h2>
            {active.panorama?.attribution && <p>{active.panorama.attribution}</p>}
          </div>
        )}
      </div>
      <aside className="experience3d__list">
        <div className="experience3d__list-header">
          <h2>Điểm đến 360°</h2>
          <p>
            Ảnh minh hoạ (Poly Haven, CC0) theo chủ đề — sẽ thay bằng ảnh chụp thực tế khi có dữ liệu khảo sát địa
            điểm.
          </p>
        </div>
        <ul>
          {destinations.map((site) => (
            <li key={site.id}>
              <button
                type="button"
                className={
                  site.id === activeId ? 'experience3d__dest experience3d__dest--active' : 'experience3d__dest'
                }
                onClick={() => setActiveId(site.id)}
              >
                <span className="experience3d__dest-name">{site.name}</span>
                <span className="experience3d__dest-category">{site.category}</span>
              </button>
            </li>
          ))}
        </ul>
      </aside>
    </div>
  );
}
