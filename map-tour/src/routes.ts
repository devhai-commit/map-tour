// Relative to the active `/lang/:villageSlug` layout route — resolved by
// react-router against whatever village is currently in context.
export const APP_ROUTES = {
  home: '.',
  villageIntroduction: 'gioi-thieu',
  map: 'map',
  heritage: 'di-san',
  panorama: '360',
} as const;
