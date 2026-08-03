import { useEffect } from 'react';
import { createPortal } from 'react-dom';
import { PanoramaViewer } from './PanoramaViewer';
import type { TourSite } from '../types';

interface PanoramaModalProps {
  site: TourSite | null;
  onClose: () => void;
}

export function PanoramaModal({ site, onClose }: PanoramaModalProps) {
  const panorama = site?.panorama;

  useEffect(() => {
    if (!panorama) return;

    function handleKeyDown(event: KeyboardEvent) {
      if (event.key === 'Escape') onClose();
    }
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [panorama, onClose]);

  if (!site || !panorama) return null;

  return createPortal(
    <div className="panorama-modal__backdrop" onClick={onClose}>
      <div className="panorama-modal__content" onClick={(event) => event.stopPropagation()}>
        <div className="panorama-modal__header">
          <div>
            <h2 className="panorama-modal__title">{site.name}</h2>
            {panorama.attribution && <p className="panorama-modal__attribution">{panorama.attribution}</p>}
          </div>
          <button type="button" className="panorama-modal__close" onClick={onClose} aria-label="Đóng">
            ✕
          </button>
        </div>
        <PanoramaViewer url={panorama.url} className="panorama-modal__viewer" />
      </div>
    </div>,
    document.body,
  );
}
