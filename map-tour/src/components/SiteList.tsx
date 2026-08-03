import type { TourSite } from '../types';

interface SiteListProps {
  sites: TourSite[];
  selectedId: string | null;
  onSelect: (id: string) => void;
  onOpenPanorama: (id: string) => void;
}

export function SiteList({ sites, selectedId, onSelect, onOpenPanorama }: SiteListProps) {
  return (
    <ul className="site-list">
      {sites.map((site) => (
        <li className="site-list__row" key={site.id}>
          <button
            type="button"
            className={site.id === selectedId ? 'site-list__item site-list__item--active' : 'site-list__item'}
            onClick={() => onSelect(site.id)}
          >
            <span className="site-list__name">{site.name}</span>
            <span className="site-list__meta">
              <span className={`site-list__badge site-list__badge--${site.kind}`}>
                {site.kind === 'point' ? 'Điểm' : 'Khu vực'}
              </span>
              <span className="site-list__category">{site.category}</span>
            </span>
          </button>
          {site.panorama && (
            <button type="button" className="site-list__panorama-btn" onClick={() => onOpenPanorama(site.id)}>
              Xem 360°
            </button>
          )}
        </li>
      ))}
    </ul>
  );
}
