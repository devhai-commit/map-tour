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
import { MAP_COLORS } from '../lib/mapColors';
import { getCategoryStyle } from '../lib/siteCategories';
import { siteCenter } from '../types';
import type { AreaSite, LatLng, PointSite, TourSite } from '../types';

// vietnam.pmtiles is built with the OpenMapTiles schema (Planetiler's default
// profile), not the Protomaps schema, so its layers/property names only match
// an OpenMapTiles-schema style like OSM Bright — not @protomaps/basemaps.
const PMTILES_SOURCE_ID = 'openmaptiles';
const AREA_SOURCE_ID = 'tour-areas';
const AREA_FILL_LAYER_ID = 'tour-areas-fill';
const AREA_LINE_LAYER_ID = 'tour-areas-line';
const ROUTE_SOURCE_ID = 'tour-route';
const ROUTE_LINE_LAYER_ID = 'tour-route-line';

// Icon badges and their label pills are a fixed screen-pixel size, so below
// this zoom a small area polygon can shrink to fewer screen-pixels than the
// badge itself, making the marker look like it "spills outside" the shape it
// marks even though its lat/lng anchor is exactly correct. Collapsing to an
// icon-only dot below this threshold keeps the marker visually proportionate
// to the shrunk geometry instead of looking misplaced.
const MARKER_LABEL_MIN_ZOOM = 16;

// Must match the non-compact .tour-marker/.tour-marker__badge box (32px) and
// the .tour-marker__label left offset (40px) in index.css — used to compute
// each marker's on-screen bounding box for collision detection below.
const MARKER_BADGE_SIZE = 32;
const MARKER_LABEL_LEFT_OFFSET = 40;
const MARKER_LABEL_GAP = 6;

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

// Marker label sits beside the icon badge (not stacked above it), so nearby
// markers never have their name text covered by a neighboring pin. The
// wrapper element keeps a fixed 32x32 box (matching the badge) so MapLibre's
// center-anchor math stays exact even though the label overflows it visually.
function createMarkerElement(site: TourSite, onSelect: (id: string) => void): HTMLDivElement {
  const style = getCategoryStyle(site.category);
  const element = document.createElement('div');
  element.className = 'tour-marker';
  element.style.setProperty('--tour-marker-color', style.color);
  element.innerHTML = `
    <span class="tour-marker__badge">${style.icon}</span>
    <span class="tour-marker__label">${escapeHtml(site.name)}</span>
  `;
  element.setAttribute('role', 'button');
  element.setAttribute('tabindex', '0');
  element.setAttribute('aria-label', site.name);
  element.addEventListener('click', () => onSelect(site.id));
  element.addEventListener('keydown', (event: KeyboardEvent) => {
    if (event.key !== 'Enter' && event.key !== ' ') return;
    event.preventDefault();
    onSelect(site.id);
  });
  return element;
}

// Label width/height only depend on the site's name and the (static) marker
// CSS, so they're measured once right after the marker is added to the DOM
// and reused on every collision pass — reading offsetWidth/offsetHeight on
// every map "move" event would otherwise force a layout reflow per marker.
function cacheLabelSize(marker: Marker, siteId: string, labelSizes: Record<string, { width: number; height: number }>) {
  const labelElement = marker.getElement().querySelector<HTMLElement>('.tour-marker__label');
  if (!labelElement) return;
  labelSizes[siteId] = { width: labelElement.offsetWidth, height: labelElement.offsetHeight };
}

interface MarkerBox {
  left: number;
  right: number;
  top: number;
  bottom: number;
}

function badgeBox(centerX: number, centerY: number): MarkerBox {
  const half = MARKER_BADGE_SIZE / 2;
  return { left: centerX - half, right: centerX + half, top: centerY - half, bottom: centerY + half };
}

function labelBox(centerX: number, centerY: number, size: { width: number; height: number }): MarkerBox {
  const badge = badgeBox(centerX, centerY);
  const left = centerX - MARKER_BADGE_SIZE / 2 + MARKER_LABEL_LEFT_OFFSET;
  return {
    left: badge.left,
    right: left + size.width,
    top: Math.min(badge.top, centerY - size.height / 2),
    bottom: Math.max(badge.bottom, centerY + size.height / 2),
  };
}

function boxesOverlap(a: MarkerBox, b: MarkerBox): boolean {
  return (
    a.left - MARKER_LABEL_GAP < b.right &&
    a.right + MARKER_LABEL_GAP > b.left &&
    a.top - MARKER_LABEL_GAP < b.bottom &&
    a.bottom + MARKER_LABEL_GAP > b.top
  );
}

// DOM markers don't get MapLibre's native symbol-layer collision detection
// (that only applies between GL-rendered symbol layers), so two independent
// markers whose real-world positions are close together can end up with
// overlapping label pills at some zoom levels even though each marker's own
// icon+label pair is correctly laid out. This greedily hides the label of
// any lower-priority marker that would overlap an already-placed one —
// priority is "currently selected first, then original site order".
function resolveLabelCollisions(
  map: MapLibreMap,
  markers: Record<string, Marker>,
  orderedSiteIds: string[],
  labelSizes: Record<string, { width: number; height: number }>,
  selectedId: string | null,
) {
  const prioritized = [...orderedSiteIds].sort((a, b) => {
    if (a === selectedId) return -1;
    if (b === selectedId) return 1;
    return 0;
  });
  const placedBoxes: MarkerBox[] = [];
  for (const siteId of prioritized) {
    const marker = markers[siteId];
    const size = labelSizes[siteId];
    if (!marker || !size) continue;
    const point = map.project(marker.getLngLat());
    const candidate = labelBox(point.x, point.y, size);
    const hidden = placedBoxes.some((box) => boxesOverlap(candidate, box));
    marker.getElement().classList.toggle('tour-marker--label-hidden', hidden);
    placedBoxes.push(hidden ? badgeBox(point.x, point.y) : candidate);
  }
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
  const selectedIdRef = useRef<string | null>(selectedId);

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
    // Points before areas, matching creation order below — the order this
    // array is built in is also the tie-break priority used by
    // updateLabelCollisions when two markers' labels would overlap.
    const orderedSiteIds = [...pointSites, ...areaSites].map((site) => site.id);
    const labelSizes: Record<string, { width: number; height: number }> = {};

    map.on('load', () => {
      for (const site of pointSites) {
        const marker = new Marker({ element: createMarkerElement(site, onSelect) })
          .setLngLat(toLngLat(site.position))
          .setPopup(new Popup({ offset: 24 }).setHTML(popupHtml(site)))
          .addTo(map);
        markersRef.current[site.id] = marker;
        cacheLabelSize(marker, site.id, labelSizes);
      }

      map.addSource(AREA_SOURCE_ID, {
        type: 'geojson',
        data: areasToFeatureCollection(areaSites),
      });
      map.addLayer({
        id: AREA_FILL_LAYER_ID,
        type: 'fill',
        source: AREA_SOURCE_ID,
        paint: { 'fill-color': MAP_COLORS.secondaryContainer, 'fill-opacity': 0.28 },
      });
      map.addLayer({
        id: AREA_LINE_LAYER_ID,
        type: 'line',
        source: AREA_SOURCE_ID,
        paint: { 'line-color': MAP_COLORS.primary, 'line-width': 2 },
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

      // Area polygons get the same icon+label marker as points, centered on
      // their centroid, so every category reads consistently on the map.
      for (const site of areaSites) {
        const marker = new Marker({ element: createMarkerElement(site, onSelect) })
          .setLngLat(toLngLat(siteCenter(site)))
          .setPopup(new Popup({ offset: 24 }).setHTML(popupHtml(site)))
          .addTo(map);
        markersRef.current[site.id] = marker;
        cacheLabelSize(marker, site.id, labelSizes);
      }

      const updateMarkers = () => {
        const compact = map.getZoom() < MARKER_LABEL_MIN_ZOOM;
        for (const marker of Object.values(markersRef.current)) {
          marker.getElement().classList.toggle('tour-marker--compact', compact);
        }
        if (!compact) resolveLabelCollisions(map, markersRef.current, orderedSiteIds, labelSizes, selectedIdRef.current);
      };
      updateMarkers();
      map.on('move', updateMarkers);

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
          map.addLayer({
            id: ROUTE_LINE_LAYER_ID,
            type: 'line',
            source: ROUTE_SOURCE_ID,
            layout: { 'line-cap': 'round', 'line-join': 'round' },
            paint: {
              'line-color': MAP_COLORS.tertiaryContainer,
              'line-width': 4,
              'line-opacity': 0.85,
              'line-dasharray': [0.2, 1.5],
            },
          });
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
    selectedIdRef.current = selectedId;
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

    // Re-run the same collision pass registered on the map's "move" event so
    // selecting a site immediately gives its label priority, instead of
    // waiting for the next pan/zoom to re-resolve overlaps.
    map.fire('move');
  }, [selectedId]);

  return <div ref={containerRef} style={{ height: '100%', width: '100%' }} />;
}
