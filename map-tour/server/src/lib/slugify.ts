const VIETNAMESE_D = /[đĐ]/g;

// `đ`/`Đ` are precomposed codepoints, not base-letter + combining mark, so
// NFD normalization alone won't decompose them into a strippable diacritic —
// they need an explicit replacement before the generic mark-stripping pass.
export function slugifyVietnamese(input: string): string {
  return input
    .replace(VIETNAMESE_D, (match) => (match === 'đ' ? 'd' : 'D'))
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}
