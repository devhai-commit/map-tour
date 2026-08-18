import { useEffect, useRef } from 'react';
import {
  Map as MapLibreMap,
  Marker,
  NavigationControl,
  Popup,
  LngLatBounds,
  addProtocol,
  setWorkerUrl,
  type GeoJSONSource,
  type MapLayerMouseEvent,
} from 'maplibre-gl';
import mapLibreWorkerUrl from 'maplibre-gl/dist/maplibre-gl-worker.mjs?url';
import { Protocol } from 'pmtiles';
import type { StyleSpecification } from 'maplibre-gl';
import osmBrightStyle from '../assets/map/osm-bright-style.json';
import { fetchRoute } from '../lib/api';
import { MAP_COLORS } from '../lib/mapColors';
import { getCategoryStyle } from '../lib/siteCategories';
import { siteCenter, toLngLat } from '../types';
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
// Separate source/layer for the on-demand point-to-point "chỉ đường" feature
// (DirectionsPanel) — kept independent of the curated tour route above so
// both can be visible at once without one overwriting the other's data.
const DIRECTIONS_SOURCE_ID = 'tour-directions';
const DIRECTIONS_LINE_LAYER_ID = 'tour-directions-line';

// MapLibre v6 loads its module worker as a sibling of the application bundle
// by default. Importing it as a Vite URL makes the worker part of the
// production artifact and gives MapLibre the hashed deploy URL explicitly.
setWorkerUrl(mapLibreWorkerUrl);

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
// Must match .tour-marker--compact/.tour-marker--compact .tour-marker__badge
// (18px) in index.css — used for the same collision math once markers switch
// to compact mode below MARKER_LABEL_MIN_ZOOM.
const MARKER_BADGE_SIZE_COMPACT = 18;
const MARKER_LABEL_LEFT_OFFSET = 40;
const MARKER_LABEL_GAP = 6;

// Ordered walking-tour stops — only the curated Ước Lễ sites (not the seeded
// random demo entries in sites.ts) get a real road/path route drawn between
// them, following the narrative order: gate -> đình -> chùa -> giếng ->
// old-village cluster -> craft-village cluster.
const TOUR_ROUTE_SITE_IDS = [
  '20000000-0000-0000-0000-000000000001',
  '20000000-0000-0000-0000-000000000002',
  '20000000-0000-0000-0000-000000000003',
  '20000000-0000-0000-0000-000000000004',
  '20000000-0000-0000-0000-000000000005',
  '20000000-0000-0000-0000-000000000006',
];

// Wraps the API's shaped route response (map-tour/server/src/routes/routing.ts,
// proxying a self-hosted OSRM instance) as a GeoJSON feature ready to hand
// to a MapLibre source; returns null on any failure so callers can skip
// drawing rather than crash the rest of map setup.
async function fetchRouteFeature(coords: [number, number][]): Promise<GeoJSON.Feature<GeoJSON.LineString> | null> {
  try {
    const result = await fetchRoute(coords);
    return { type: 'Feature', properties: {}, geometry: result.geometry };
  } catch (error: unknown) {
    console.error('Failed to fetch walking route', error);
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
    <span class="tour-marker__count" aria-hidden="true"></span>
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

function badgeBox(centerX: number, centerY: number, badgeSize: number = MARKER_BADGE_SIZE): MarkerBox {
  const half = badgeSize / 2;
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

function setMarkerCount(element: HTMLElement, count: number) {
  const countElement = element.querySelector<HTMLElement>('.tour-marker__count');
  if (!countElement) return;
  countElement.textContent = count > 0 ? `+${count}` : '';
  countElement.classList.toggle('tour-marker__count--visible', count > 0);
}

// DOM markers don't get MapLibre's native symbol-layer collision detection
// (that only applies between GL-rendered symbol layers), so two independent
// markers whose real-world positions are close together (this village packs
// 21 points into ~400m, several only 10-50m apart) can collide on screen at
// ordinary zoom levels. A marker's label pill is much wider than its badge,
// so checking "does my badge overlap another badge" and "does my label
// overlap another label" as two separate passes misses the case where a
// lower-priority marker's *badge* lands inside an earlier marker's already-
// placed *label* — the badge pass alone would let it through, since it only
// ever compared badges to badges. This single greedy pass in priority order
// ("currently selected first, then original site order") avoids that: each
// marker is checked against the ACTUAL rendered extent (label pill, or bare
// badge if the label didn't fit) of every already-placed marker before it,
// with two shrinking fallbacks:
//   1. Try to show badge + label — if that full extent is clear, place it.
//   2. Else try badge-only — if just the badge is clear, place it with its
//      label hidden.
//   3. Else hide the marker entirely and "absorb" it into whichever
//      already-placed marker it collided with, which gets a "+N" count
//      bubble so it's visible that more points sit there instead of
//      silently vanishing. As the user zooms in, points spread apart on
//      screen and re-emerge on their own.
function resolveMarkerLayout(
  map: MapLibreMap,
  markers: Record<string, Marker>,
  orderedSiteIds: string[],
  labelSizes: Record<string, { width: number; height: number }>,
  selectedId: string | null,
  badgeSize: number,
) {
  const prioritized = [...orderedSiteIds].sort((a, b) => {
    if (a === selectedId) return -1;
    if (b === selectedId) return 1;
    return 0;
  });

  const placed: Array<{ siteId: string; box: MarkerBox }> = [];
  const absorbedCounts: Record<string, number> = {};

  for (const siteId of prioritized) {
    const marker = markers[siteId];
    if (!marker) continue;
    const element = marker.getElement();
    const point = map.project(marker.getLngLat());
    const size = labelSizes[siteId];
    const badgeOnlyBox = badgeBox(point.x, point.y, badgeSize);
    const fullBox = size ? labelBox(point.x, point.y, size) : badgeOnlyBox;

    if (!placed.some((entry) => boxesOverlap(fullBox, entry.box))) {
      element.classList.remove('tour-marker--hidden', 'tour-marker--label-hidden');
      setMarkerCount(element, 0);
      placed.push({ siteId, box: fullBox });
      continue;
    }

    if (!placed.some((entry) => boxesOverlap(badgeOnlyBox, entry.box))) {
      element.classList.remove('tour-marker--hidden');
      element.classList.add('tour-marker--label-hidden');
      setMarkerCount(element, 0);
      placed.push({ siteId, box: badgeOnlyBox });
      continue;
    }

    const absorbingEntry = placed.find((entry) => boxesOverlap(badgeOnlyBox, entry.box));
    if (absorbingEntry) absorbedCounts[absorbingEntry.siteId] = (absorbedCounts[absorbingEntry.siteId] ?? 0) + 1;
    element.classList.add('tour-marker--hidden');
  }

  for (const [siteId, count] of Object.entries(absorbedCounts)) {
    const marker = markers[siteId];
    if (marker) setMarkerCount(marker.getElement(), count);
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
  /** Point-to-point "chỉ đường" result to draw, or null to clear it. */
  directionsRoute?: GeoJSON.Feature<GeoJSON.LineString> | null;
}

export function TourMap({ sites, selectedId, onSelect, onOpenPanorama, directionsRoute = null }: TourMapProps) {
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
        const badgeSize = compact ? MARKER_BADGE_SIZE_COMPACT : MARKER_BADGE_SIZE;
        resolveMarkerLayout(map, markersRef.current, orderedSiteIds, labelSizes, selectedIdRef.current, badgeSize);
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
        void fetchRouteFeature(routeCoords).then((routeFeature) => {
          if (disposed || !routeFeature) return;
          map.addSource(ROUTE_SOURCE_ID, {
            type: 'geojson',
            data: routeFeature,
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
    // Sites arrive asynchronously from the active village API. Recreate the
    // map when that dataset changes so markers and fitBounds are not frozen
    // to the empty array from the first render.
  }, [sites]);

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

  useEffect(() => {
    const map = mapRef.current;
    if (!map) return;

    const applyDirectionsRoute = () => {
      const source = map.getSource<GeoJSONSource>(DIRECTIONS_SOURCE_ID);
      if (!directionsRoute) {
        source?.setData({ type: 'FeatureCollection', features: [] });
        return;
      }
      if (source) {
        source.setData(directionsRoute);
        return;
      }
      map.addSource(DIRECTIONS_SOURCE_ID, { type: 'geojson', data: directionsRoute });
      map.addLayer({
        id: DIRECTIONS_LINE_LAYER_ID,
        type: 'line',
        source: DIRECTIONS_SOURCE_ID,
        layout: { 'line-cap': 'round', 'line-join': 'round' },
        paint: { 'line-color': MAP_COLORS.primaryContainer, 'line-width': 5, 'line-opacity': 0.9 },
      });
    };

    // The map's own "load" event (mount-time setup above) may not have fired
    // yet the first time this effect runs, e.g. if a directions request
    // resolves before markers/areas finish loading.
    if (map.isStyleLoaded()) applyDirectionsRoute();
    else map.once('load', applyDirectionsRoute);
  }, [directionsRoute]);

  return <div ref={containerRef} style={{ height: '100%', width: '100%' }} />;
}
