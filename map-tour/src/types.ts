export type LatLng = [number, number]; // [lat, lng]

// GeoJSON/OSRM/MapLibre all expect [lng, lat] — the opposite order this app
// stores site coordinates in — so callers convert through this one helper
// rather than flipping tuples inline at each call site.
export function toLngLat([lat, lng]: LatLng): [number, number] {
  return [lng, lat];
}

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
  return polygonCentroid(site.boundary);
}

// Area-weighted polygon centroid (planar approximation — accurate enough at
// the sub-kilometer footprints this app renders) rather than a naive vertex
// average, so the marker lands at the shape's visual center instead of
// drifting toward whichever side happens to have more boundary points.
function polygonCentroid(points: LatLng[]): LatLng {
  let area = 0;
  let centroidLat = 0;
  let centroidLng = 0;
  for (let i = 0; i < points.length; i++) {
    const [lat1, lng1] = points[i];
    const [lat2, lng2] = points[(i + 1) % points.length];
    const cross = lng1 * lat2 - lng2 * lat1;
    area += cross;
    centroidLng += (lng1 + lng2) * cross;
    centroidLat += (lat1 + lat2) * cross;
  }
  area /= 2;
  if (area === 0) {
    const [latSum, lngSum] = points.reduce(
      ([lat, lng], [pointLat, pointLng]) => [lat + pointLat, lng + pointLng],
      [0, 0],
    );
    return [latSum / points.length, lngSum / points.length];
  }
  return [centroidLat / (6 * area), centroidLng / (6 * area)];
}
