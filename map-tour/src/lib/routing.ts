// Shapes match the API's shaped OSRM response (map-tour/server/src/routes/routing.ts)
// — the raw OSRM envelope never reaches the frontend.
export interface RouteStep {
  type: string;
  modifier: string | null;
  name: string;
  distanceMeters: number;
}

export interface RouteResult {
  geometry: GeoJSON.LineString;
  distanceMeters: number;
  durationSeconds: number;
  steps: RouteStep[];
}

const MODIFIER_TEXT: Record<string, string> = {
  left: 'rẽ trái',
  right: 'rẽ phải',
  straight: 'đi thẳng',
  'slight left': 'rẽ nhẹ trái',
  'slight right': 'rẽ nhẹ phải',
  'sharp left': 'rẽ gắt trái',
  'sharp right': 'rẽ gắt phải',
  uturn: 'quay đầu',
};

function capitalize(text: string): string {
  return text.charAt(0).toUpperCase() + text.slice(1);
}

function describeManeuver(step: RouteStep): string {
  const name = step.name || null;
  switch (step.type) {
    case 'depart':
      return name ? `Bắt đầu đi trên ${name}` : 'Bắt đầu đi bộ';
    case 'arrive':
      return 'Bạn đã đến nơi';
    case 'roundabout':
    case 'rotary':
      return name ? `Đi vào vòng xuyến, ra ở ${name}` : 'Đi vào vòng xuyến';
    case 'new name':
    case 'continue':
      return name ? `Tiếp tục trên ${name}` : 'Tiếp tục đi thẳng';
    case 'merge':
      return name ? `Nhập vào ${name}` : 'Nhập vào đường chính';
    default: {
      const modifierText = step.modifier ? MODIFIER_TEXT[step.modifier] : undefined;
      const action = modifierText ? capitalize(modifierText) : 'Tiếp tục';
      return name ? `${action} vào ${name}` : action;
    }
  }
}

export function formatDistance(meters: number): string {
  if (meters < 1000) return `${Math.round(meters)}m`;
  return `${(meters / 1000).toFixed(1)}km`;
}

export function formatDuration(seconds: number): string {
  const minutes = Math.round(seconds / 60);
  if (minutes < 60) return `${Math.max(minutes, 1)} phút`;
  return `${Math.floor(minutes / 60)} giờ ${minutes % 60} phút`;
}

// OSRM's maneuver vocabulary (`type`/`modifier`) is a small, fixed set, so a
// direct lookup table covers turn-by-turn text without a general-purpose
// i18n/routing-instruction library.
export function describeStep(step: RouteStep): string {
  const maneuver = describeManeuver(step);
  if (step.type === 'arrive' || step.distanceMeters <= 0) return maneuver;
  return `${maneuver} · ${formatDistance(step.distanceMeters)}`;
}
