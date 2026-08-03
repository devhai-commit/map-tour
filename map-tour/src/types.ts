export type LatLng = [number, number]; // [lat, lng]

interface SitePanorama {
  url: string;
  attribution?: string;
}

interface BaseSite {
  id: string;
  name: string;
  category: string;
  description: string;
  village: string;
  /** 360° equirectangular photo shown in the panorama viewer, if available. */
  panorama?: SitePanorama;
  /** Flat cover photo shown on cards (home, heritage list), if available. */
  cover?: SitePanorama;
}

export interface PointSite extends BaseSite {
  kind: 'point';
  position: LatLng;
}

export interface AreaSite extends BaseSite {
  /** Represents a large-footprint site as a polygon built from multiple boundary points. */
  kind: 'area';
  boundary: LatLng[];
}

export type TourSite = PointSite | AreaSite;

export function siteCenter(site: TourSite): LatLng {
  if (site.kind === 'point') return site.position;
  const [latSum, lngSum] = site.boundary.reduce(
    ([lat, lng], [pointLat, pointLng]) => [lat + pointLat, lng + pointLng],
    [0, 0],
  );
  return [latSum / site.boundary.length, lngSum / site.boundary.length];
}
