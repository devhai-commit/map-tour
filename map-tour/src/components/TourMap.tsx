import { useEffect, useRef } from 'react';
import {
  Map as MapLibreMap,
  Marker,
  NavigationControl,
  Popup,
  LngLatBounds,
  addProtocol,
  type MapLayerMouseEvent,
} from 'maplibre-gl';
import { Protocol } from 'pmtiles';
import type { StyleSpecification } from 'maplibre-gl';
import osmBrightStyle from '../assets/map/osm-bright-style.json';
import { siteCenter } from '../types';
import type { AreaSite, LatLng, PointSite, TourSite } from '../types';

// vietnam.pmtiles is built with the OpenMapTiles schema (Planetiler's default
// profile), not the Protomaps schema, so its layers/property names only match
// an OpenMapTiles-schema style like OSM Bright — not @protomaps/basemaps.
const PMTILES_SOURCE_ID = 'openmaptiles';
const AREA_SOURCE_ID = 'tour-areas';
const AREA_FILL_LAYER_ID = 'tour-areas-fill';
const AREA_LINE_LAYER_ID = 'tour-areas-line';
const POINT_LABEL_SOURCE_ID = 'tour-point-labels';
const POINT_LABEL_LAYER_ID = 'tour-point-labels';
const AREA_LABEL_SOURCE_ID = 'tour-area-labels';
const AREA_LABEL_LAYER_ID = 'tour-area-labels';
const ROUTE_SOURCE_ID = 'tour-route';
const ROUTE_LINE_LAYER_ID = 'tour-route-line';

// Ordered walking-tour stops — only the curated Ước Lễ sites (not the seeded
// random demo entries in sites.ts) get a real road/path route drawn between
// them, following the narrative order: gate -> đình -> chùa -> giếng ->
// old-village cluster -> craft-village cluster.
const TOUR_ROUTE_SITE_IDS = [
  'cong-lang-uoc-le',
  'dinh-lang-uoc-le',
  'chua-lang-uoc-le',
  'gieng-lang',
  'khu-lang-co',
  'khu-lang-nghe-gio-cha',
];

// Public, key-free OSRM demo instance (FOSSGIS) with a "foot" profile — a
// real production app should run its own routing backend instead.
const FOOT_ROUTING_ENDPOINT = 'https://routing.openstreetmap.de/routed-foot/route/v1/foot';

interface OsrmRouteResponse {
  code: string;
  routes?: Array<{ geometry: GeoJSON.LineString }>;
}

function isOsrmRouteResponse(value: unknown): value is OsrmRouteResponse {
  return typeof value === 'object' && value !== null && 'code' in value;
}

async function fetchFootRoute(coords: [number, number][]): Promise<GeoJSON.Feature<GeoJSON.LineString> | null> {
  const coordsParam = coords.map(([lng, lat]) => `${lng},${lat}`).join(';');
  const url = `${FOOT_ROUTING_ENDPOINT}/${coordsParam}?overview=full&geometries=geojson`;
  try {
    const response = await fetch(url);
    if (!response.ok) throw new Error(`Routing request failed: HTTP ${response.status}`);
    const body: unknown = await response.json();
    const geometry = isOsrmRouteResponse(body) ? body.routes?.[0]?.geometry : undefined;
    if (!geometry) throw new Error('Routing response missing route geometry');
    return { type: 'Feature', properties: {}, geometry };
  } catch (error: unknown) {
    console.error('Failed to fetch walking-tour route', error);
    return null;
  }
}

// PMTiles archives are read through a custom "pmtiles://" URL scheme; the
// protocol only needs to be registered with MapLibre once per page load.
let protocolRegistered = false;
function ensurePmtilesProtocol() {
  if (protocolRegistered) return;
  const protocol = new Protocol();
  addProtocol('pmtiles', protocol.tile);
  protocolRegistered = true;
}

function toLngLat([lat, lng]: LatLng): [number, number] {
  return [lng, lat];
}

function closedRing(boundary: LatLng[]): [number, number][] {
  const ring = boundary.map(toLngLat);
  const [firstLng, firstLat] = ring[0];
  const [lastLng, lastLat] = ring[ring.length - 1];
  if (firstLng !== lastLng || firstLat !== lastLat) ring.push(ring[0]);
  return ring;
}

function areasToFeatureCollection(areaSites: AreaSite[]): GeoJSON.FeatureCollection {
  return {
    type: 'FeatureCollection',
    features: areaSites.map((site) => ({
      type: 'Feature',
      properties: { id: site.id, name: site.name, description: site.description },
      geometry: { type: 'Polygon', coordinates: [closedRing(site.boundary)] },
    })),
  };
}

function labelFeatureCollection(entries: Array<{ id: string; name: string; center: LatLng }>): GeoJSON.FeatureCollection {
  return {
    type: 'FeatureCollection',
    features: entries.map(({ id, name, center }) => ({
      type: 'Feature',
      properties: { id, name },
      geometry: { type: 'Point', coordinates: toLngLat(center) },
    })),
  };
}

function siteBounds(sites: TourSite[]): LngLatBounds | null {
  if (sites.length === 0) return null;
  const bounds = new LngLatBounds();
  for (const site of sites) {
    const points = site.kind === 'point' ? [site.position] : site.boundary;
    for (const point of points) bounds.extend(toLngLat(point));
  }
  return bounds;
}

function popupHtml(site: TourSite): string {
  const name = escapeHtml(site.name);
  const description = escapeHtml(site.description);
  const panoramaButton = site.panorama
    ? `<button type="button" class="popup-panorama-btn" data-site-id="${escapeHtml(site.id)}">Xem 360°</button>`
    : '';
  return `<div class="map-popup"><strong>${name}</strong><p>${description}</p>${panoramaButton}</div>`;
}

function escapeHtml(value: string): string {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

interface TourMapProps {
  sites: TourSite[];
  selectedId: string | null;
  onSelect: (id: string) => void;
  onOpenPanorama: (id: string) => void;
}

export function TourMap({ sites, selectedId, onSelect, onOpenPanorama }: TourMapProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const mapRef = useRef<MapLibreMap | null>(null);
  const markersRef = useRef<Record<string, Marker>>({});

  useEffect(() => {
    if (!containerRef.current) return;

    let disposed = false;
    ensurePmtilesProtocol();

    const pmtilesUrl = new URL('/tiles/vietnam.pmtiles', window.location.origin).href;
    const style: StyleSpecification = {
      ...(osmBrightStyle as StyleSpecification),
      sources: {
        [PMTILES_SOURCE_ID]: {
          type: 'vector',
          url: `pmtiles://${pmtilesUrl}`,
          minzoom: 0,
          maxzoom: 14,
          attribution:
            '<a href="https://www.openmaptiles.org/">OpenMapTiles</a> © <a href="https://osm.org/copyright">OpenStreetMap</a>',
        },
      },
    };
    const map = new MapLibreMap({
      container: containerRef.current,
      style,
    });
    mapRef.current = map;
    map.addControl(new NavigationControl(), 'top-right');

    // Popup content is raw HTML outside the React tree, so the "Xem 360°"
    // button inside it is caught via delegation instead of a per-popup
    // listener (popups are re-created/destroyed frequently as they open/close).
    const handlePopupClick = (event: MouseEvent) => {
      const target = event.target;
      if (!(target instanceof Element)) return;
      const button = target.closest('.popup-panorama-btn');
      const id = button?.getAttribute('data-site-id');
      if (id) onOpenPanorama(id);
    };
    containerRef.current.addEventListener('click', handlePopupClick);

    const pointSites = sites.filter((site): site is PointSite => site.kind === 'point');
    const areaSites = sites.filter((site): site is AreaSite => site.kind === 'area');

    map.on('load', () => {
      for (const site of pointSites) {
        const marker = new Marker({ color: '#610000' })
          .setLngLat(toLngLat(site.position))
          .setPopup(new Popup({ offset: 24 }).setHTML(popupHtml(site)))
          .addTo(map);
        marker.getElement().addEventListener('click', () => onSelect(site.id));
        markersRef.current[site.id] = marker;
      }

      map.addSource(AREA_SOURCE_ID, {
        type: 'geojson',
        data: areasToFeatureCollection(areaSites),
      });
      map.addLayer({
        id: AREA_FILL_LAYER_ID,
        type: 'fill',
        source: AREA_SOURCE_ID,
        paint: { 'fill-color': '#fcd400', 'fill-opacity': 0.28 },
      });
      map.addLayer({
        id: AREA_LINE_LAYER_ID,
        type: 'line',
        source: AREA_SOURCE_ID,
        paint: { 'line-color': '#610000', 'line-width': 2 },
      });

      map.on('click', AREA_FILL_LAYER_ID, (event: MapLayerMouseEvent) => {
        const feature = event.features?.[0];
        const id = feature?.properties?.id;
        if (typeof id !== 'string') return;
        onSelect(id);
        new Popup({ offset: 12 })
          .setLngLat(event.lngLat)
          .setHTML(popupHtml(areaSites.find((site) => site.id === id)!))
          .addTo(map);
      });
      map.on('mouseenter', AREA_FILL_LAYER_ID, () => {
        map.getCanvas().style.cursor = 'pointer';
      });
      map.on('mouseleave', AREA_FILL_LAYER_ID, () => {
        map.getCanvas().style.cursor = '';
      });

      // Persistent name labels for every site (point markers get a label
      // above the pin; area polygons get one centered on their centroid).
      map.addSource(POINT_LABEL_SOURCE_ID, {
        type: 'geojson',
        data: labelFeatureCollection(pointSites.map((site) => ({ id: site.id, name: site.name, center: site.position }))),
      });
      map.addLayer({
        id: POINT_LABEL_LAYER_ID,
        type: 'symbol',
        source: POINT_LABEL_SOURCE_ID,
        layout: {
          'text-field': ['get', 'name'],
          'text-font': ['Noto Sans Regular'],
          'text-size': 12,
          'text-anchor': 'bottom',
          'text-offset': [0, -1.7],
          'text-optional': true,
        },
        paint: {
          'text-color': '#360f00',
          'text-halo-color': '#fff8f6',
          'text-halo-width': 1.4,
        },
      });

      map.addSource(AREA_LABEL_SOURCE_ID, {
        type: 'geojson',
        data: labelFeatureCollection(areaSites.map((site) => ({ id: site.id, name: site.name, center: siteCenter(site) }))),
      });
      map.addLayer({
        id: AREA_LABEL_LAYER_ID,
        type: 'symbol',
        source: AREA_LABEL_SOURCE_ID,
        layout: {
          'text-field': ['get', 'name'],
          'text-font': ['Noto Sans Bold'],
          'text-size': 13,
          'text-anchor': 'center',
          'text-optional': true,
        },
        paint: {
          'text-color': '#610000',
          'text-halo-color': '#fff8f6',
          'text-halo-width': 1.6,
        },
      });

      const bounds = siteBounds(sites);
      if (bounds) map.fitBounds(bounds, { padding: 48, duration: 0 });

      // Fetch the real walking route for the curated tour stops in the
      // background so it doesn't delay the rest of map setup above.
      const routeSites = TOUR_ROUTE_SITE_IDS.map((id) => sites.find((site) => site.id === id)).filter(
        (site): site is TourSite => Boolean(site),
      );
      if (routeSites.length >= 2) {
        const routeCoords = routeSites.map((site) => toLngLat(siteCenter(site)));
        void fetchFootRoute(routeCoords).then((routeFeature) => {
          if (disposed || !routeFeature) return;
          map.addSource(ROUTE_SOURCE_ID, {
            type: 'geojson',
            data: routeFeature,
            attribution: 'Routing: <a href="https://routing.openstreetmap.de/">FOSSGIS OSRM</a>',
          });
          map.addLayer(
            {
              id: ROUTE_LINE_LAYER_ID,
              type: 'line',
              source: ROUTE_SOURCE_ID,
              layout: { 'line-cap': 'round', 'line-join': 'round' },
              paint: {
                'line-color': '#354910',
                'line-width': 4,
                'line-opacity': 0.85,
                'line-dasharray': [0.2, 1.5],
              },
            },
            POINT_LABEL_LAYER_ID,
          );
        });
      }
    });

    return () => {
      disposed = true;
      markersRef.current = {};
      containerRef.current?.removeEventListener('click', handlePopupClick);
      map.remove();
      mapRef.current = null;
    };
    // Mount-only: `sites` is static demo data for this app's lifetime.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    const map = mapRef.current;
    if (!map) return;

    for (const [id, marker] of Object.entries(markersRef.current)) {
      marker.getElement().classList.toggle('tour-marker--active', id === selectedId);
    }

    if (map.getLayer(AREA_LINE_LAYER_ID)) {
      map.setPaintProperty(AREA_LINE_LAYER_ID, 'line-width', [
        'case',
        ['==', ['get', 'id'], selectedId ?? ''],
        4,
        2,
      ]);
    }
  }, [selectedId]);

  return <div ref={containerRef} style={{ height: '100%', width: '100%' }} />;
}
