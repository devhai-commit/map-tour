import { useEffect, useRef } from 'react';
import { Viewer } from '@photo-sphere-viewer/core';
import '@photo-sphere-viewer/core/index.css';

interface PanoramaViewerProps {
  url: string;
  className?: string;
}

export function PanoramaViewer({ url, className }: PanoramaViewerProps) {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!containerRef.current) return;

    const viewer = new Viewer({
      container: containerRef.current,
      panorama: url,
      navbar: ['zoom', 'fullscreen'],
    });

    return () => {
      viewer.destroy();
    };
  }, [url]);

  return <div ref={containerRef} className={className} />;
}
