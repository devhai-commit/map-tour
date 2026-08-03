// MapLibre paint properties require literal color values, not CSS custom
// properties, so these must be kept in sync by hand with the matching
// tokens in src/index.css (--color-primary, --color-secondary-container,
// --color-tertiary-container).
export const MAP_COLORS = {
  primary: '#610000',
  secondaryContainer: '#fcd400',
  tertiaryContainer: '#354910',
} as const;
