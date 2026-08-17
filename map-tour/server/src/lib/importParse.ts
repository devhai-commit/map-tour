import type { Workbook, Worksheet } from 'exceljs';
import {
  extractLabeledRows,
  lastSegment,
  splitList,
  toBoolean,
  toInteger,
  toNumber,
  valueByLastSegment,
  looksLikeUrl,
  type LabeledRow,
} from './excelExtract.js';
import type {
  CraftProductInput,
  DecorativeArtItemInput,
  DecorativeThemeGroup,
  HeritageBuildingInput,
  HistoryStoryInput,
  IntangibleHeritageItemInput,
  ParsedImport,
  ParticipationScope,
  RecognitionLevel,
  TouristExperienceLevel,
  VillageInput,
} from './importTypes.js';

const BUILDING_SHEET = /^4\.(\d+)\.\s/;
const DECORATIVE_SUB_SHEET = /^4\.(\d+)\.(\d+)/;

function findRow(rows: LabeledRow[], predicate: (row: LabeledRow) => boolean): LabeledRow | undefined {
  return rows.find(predicate);
}

function orNull(value: string | undefined): string | null {
  return value ? value : null;
}

function pickSelectedOption(
  rows: LabeledRow[],
  fieldPredicate: (segment: string) => boolean,
): LabeledRow | undefined {
  const candidates = rows.filter((row) => row.labelPath.length >= 2 && fieldPredicate(row.labelPath[1]));
  return candidates.find((row) => row.value.length > 0);
}

function parseVillage(rows: LabeledRow[]): VillageInput | null {
  const name = valueByLastSegment(rows, 'Tên làng');
  if (!name) return null;
  return {
    name,
    aliases: splitList(valueByLastSegment(rows, 'Tên khác (nếu có)')),
    adminLocation: valueByLastSegment(rows, 'Hành chính'),
    googleMapsLink: looksLikeUrl(valueByLastSegment(rows, 'google map')),
    foundedPeriod: valueByLastSegment(rows, 'Thời điểm hình thành'),
    brandIdentity: valueByLastSegment(rows, 'Định danh thương hiệu (nếu có)'),
    nameMeaning: valueByLastSegment(rows, 'Ý nghĩa của tên'),
    mainOccupations: splitList(valueByLastSegment(rows, 'Nghề nghiệp chính của người dân trong làng')),
    naturalFeatures: valueByLastSegment(rows, 'Đặc điểm tự nhiên'),
    siteSelectionHistory: valueByLastSegment(rows, 'Lựa chọn địa điểm làng'),
    morphologyDescription: valueByLastSegment(rows, 'Sơ đồ khắc họa ý tưởng hình thái làng'),
  };
}

const HISTORY_TYPES: Array<{ label: string; type: HistoryStoryInput['type'] }> = [
  { label: 'Lịch sử làng', type: 'lich_su' },
  { label: 'Sự kiện lịch sử đã diễn ra', type: 'su_kien' },
  { label: 'Phong tục', type: 'phong_tuc' },
  { label: 'Truyền thuyết', type: 'truyen_thuyet' },
];

function parseHistoryStories(rows: LabeledRow[]): HistoryStoryInput[] {
  const stories: HistoryStoryInput[] = [];
  for (const { label, type } of HISTORY_TYPES) {
    const bodyText = valueByLastSegment(rows, label);
    if (bodyText) stories.push({ type, title: label, bodyText });
  }
  return stories;
}

function parseHeritageBuilding(rows: LabeledRow[], tempId: string): HeritageBuildingInput | null {
  const name = valueByLastSegment(rows, 'Tên');
  if (!name) return null;
  return {
    tempId,
    name,
    address: valueByLastSegment(rows, 'Địa chỉ'),
    function: valueByLastSegment(rows, 'Chức năng'),
    ownership: valueByLastSegment(rows, 'Sở hữu'),
    landAreaM2: toNumber(valueByLastSegment(rows, 'Diện tích đất')),
    floorAreaM2: toNumber(valueByLastSegment(rows, 'Diện tích xây dựng')),
    heritageRank: valueByLastSegment(rows, 'Xếp hạng di tích gì'),
    heritageRankYear: toInteger(valueByLastSegment(rows, 'Năm xếp hạng')),
    heritageStyleType: valueByLastSegment(rows, 'Kiểu loại được xếp hạng'),
    managingUnit: valueByLastSegment(rows, 'Thông tin đơn vị quản lý/ sở hữu'),
    overallStructureDescription: valueByLastSegment(rows, 'Cấu trúc chung'),
    culturalHistoricalValue: valueByLastSegment(rows, 'Giá trị văn hóa lịch sử'),
    builtPeriod: valueByLastSegment(rows, 'Thời điểm khởi dựng'),
    technicalDetails: {
      roofLayers: valueByLastSegment(rows, 'Công trình có mấy tầng mái'),
      roofShape: valueByLastSegment(rows, 'Hình dạng mái'),
      roofMaterial: valueByLastSegment(rows, 'Mái_vật liệu'),
      roofColor: valueByLastSegment(rows, 'Mái_màu sắc'),
      facadeMaterial: valueByLastSegment(rows, 'Vỏ công trình (vật liệu)'),
      facadeCondition: valueByLastSegment(rows, 'Vỏ công trình (tính chất)'),
      floorMaterial: valueByLastSegment(rows, 'Nền (vật liệu)'),
      floorPattern: valueByLastSegment(rows, 'Nền (cách lát)'),
      structureMaterial: valueByLastSegment(rows, 'Kết cấu vật liệu'),
      structureCondition: valueByLastSegment(rows, 'Kết cấu tính chất'),
      pedestalMaterial: valueByLastSegment(rows, 'Chân tảng vật liệu'),
      pedestalSize: valueByLastSegment(rows, 'Chân tảng kích thước'),
      pedestalType: valueByLastSegment(rows, 'Chân tảng kiểu loại'),
    },
  };
}

const DECORATIVE_META_SUBJECTS = new Set(['sở hữu']);

function themeGroupFromLabels(top: string, subgroup: string): DecorativeThemeGroup {
  const normalizedTop = top.toLowerCase();
  if (normalizedTop.includes('hiện vật cổ')) return 'hien_vat_co';
  const normalizedSub = subgroup.toLowerCase();
  if (normalizedSub.includes('tín ngưỡng')) return 'tin_nguong_ton_giao';
  if (normalizedSub.includes('phong thủy')) return 'phong_thuy_cat_tuong';
  return 'doi_song_sinh_hoat';
}

// Sheet "5." (Ước Lễ) and each "4.X.1" sub-sheet (Cự Đà) share the same
// 3-level label shape: [top category, theme/subgroup, subject name].
function parseDecorativeArtItems(rows: LabeledRow[], buildingTempId: string): DecorativeArtItemInput[] {
  const groups = new Map<string, { top: string; subgroup: string; subject: string; values: string[] }>();
  for (const row of rows) {
    if (row.labelPath.length < 3) continue;
    const [top, subgroup, subject] = row.labelPath;
    if (DECORATIVE_META_SUBJECTS.has(subject.trim().toLowerCase()) || subject.trim().toLowerCase().startsWith('tên (')) {
      continue;
    }
    const key = `${top}|${subgroup}|${subject}`;
    const entry = groups.get(key) ?? { top, subgroup, subject, values: [] };
    if (row.value) entry.values.push(row.value);
    groups.set(key, entry);
  }

  const items: DecorativeArtItemInput[] = [];
  for (const { top, subgroup, subject, values } of groups.values()) {
    const description = [...new Set(values)].join('\n\n');
    if (!description) continue;
    items.push({
      themeGroup: themeGroupFromLabels(top, subgroup),
      subjectName: subject,
      eraEstimate: null,
      description,
      buildingTempId,
    });
  }
  return items;
}

function mapParticipationScope(text: string): ParticipationScope {
  const normalized = text.toLowerCase();
  if (normalized.includes('toàn thể')) return 'toan_the_cong_dong';
  if (normalized.includes('2 nhóm')) return 'nhieu_nhom_hoi';
  return 'mot_nhom_hoi';
}

function mapTouristExperienceLevel(text: string): TouristExperienceLevel {
  const normalized = text.toLowerCase();
  if (normalized.includes('toàn bộ')) return 'trai_nghiem_toan_bo';
  if (normalized.includes('1 phần')) return 'trai_nghiem_mot_phan';
  return 'chi_xem';
}

function mapRecognitionLevel(text: string | null): RecognitionLevel | null {
  if (!text) return null;
  const normalized = text.toLowerCase();
  if (normalized.includes('unesco')) return 'unesco';
  if (normalized.includes('quốc gia')) return 'quoc_gia';
  if (normalized.includes('tỉnh')) return 'tinh';
  return null;
}

// Sheet "6." lists each item's answer as a small set of candidate rows (one
// per possible choice) where only the chosen option's data cell is filled —
// closer to a set of radio buttons flattened into rows than a plain form.
function parseIntangibleHeritageItems(rows: LabeledRow[]): IntangibleHeritageItemInput[] {
  const groupNames = [...new Set(rows.map((row) => row.labelPath[0]).filter(Boolean))];
  const items: IntangibleHeritageItemInput[] = [];

  for (const name of groupNames) {
    const groupRows = rows.filter((row) => row.labelPath[0] === name);
    const uniquenessDescription = orNull(
      findRow(groupRows, (row) => lastSegment(row).toLowerCase().startsWith('chi tiết nào đặc trưng'))?.value,
    );
    const recognitionRow = findRow(groupRows, (row) => lastSegment(row) === 'Được ghi nhận');
    const participationRow = pickSelectedOption(groupRows, (segment) =>
      segment.startsWith('% người dân địa phương tham gia'),
    );
    const generationsRow = pickSelectedOption(groupRows, (segment) =>
      segment.startsWith('Thực hành được truyền đời'),
    );
    const experienceRow = pickSelectedOption(groupRows, (segment) =>
      segment.startsWith('Cho phép sự tham gia trải nghiệm'),
    );
    const eventTimingRow = pickSelectedOption(groupRows, (segment) => segment.startsWith('Thời gian tổ chức'));
    const capacityRow = findRow(groupRows, (row) =>
      lastSegment(row).toLowerCase().startsWith('không gian thực hành đủ rộng'),
    );

    const generationsOption = generationsRow?.labelPath[2];
    const generationsTransmitted = generationsOption
      ? `${generationsOption}${generationsRow?.value ? ` — ${generationsRow.value}` : ''}`
      : null;

    if (!uniquenessDescription && !generationsTransmitted && !eventTimingRow?.value && !capacityRow?.value) {
      continue;
    }

    items.push({
      name,
      recognitionLevel: mapRecognitionLevel(orNull(recognitionRow?.value)),
      uniquenessDescription,
      participationScope: participationRow ? mapParticipationScope(participationRow.labelPath[2] ?? '') : null,
      generationsTransmitted,
      touristExperienceLevel: experienceRow ? mapTouristExperienceLevel(experienceRow.labelPath[2] ?? '') : null,
      eventTiming: orNull(eventTimingRow?.value),
      capacityNote: orNull(capacityRow?.value),
    });
  }
  return items;
}

function parseCraftProduct(rows: LabeledRow[], fallbackName: string): CraftProductInput | null {
  const name = valueByLastSegment(rows, 'Tên sản phẩm') ?? fallbackName;
  if (!name) return null;
  const traditionalRaw = valueByLastSegment(rows, 'Sản phẩm truyền thống hay mới phát triển');
  const isTraditional = traditionalRaw
    ? /truyền thống/i.test(traditionalRaw)
      ? true
      : /mới/i.test(traditionalRaw)
        ? false
        : null
    : null;

  return {
    name,
    productGroup: valueByLastSegment(rows, 'Nhóm sản phẩm'),
    startPeriod: valueByLastSegment(rows, 'Năm bắt đầu sản xuất'),
    isTraditional,
    culturalLinkLevel: valueByLastSegment(rows, 'Mức độ gắn với giá trị văn hóa, Bản sắc địa phương'),
    materials: valueByLastSegment(rows, 'Nguyên liệu'),
    productStory: valueByLastSegment(rows, 'Câu chuyện sản phẩm'),
    processDescription: valueByLastSegment(rows, 'Quy trình sản xuất, chế biến'),
    giftSuitability: valueByLastSegment(rows, 'Mức độ phù hợp làm quà tặng, quà lưu niệm'),
    hasExperienceActivity: toBoolean(valueByLastSegment(rows, 'Có khả năng tổ chức trải nghiệm làm sản phẩm')),
    experienceDuration: valueByLastSegment(rows, 'Thời gian trải nghiệm'),
    hasDemoSpace: toBoolean(valueByLastSegment(rows, 'Có không gian trình diễn nghề')),
    hasDisplayArea: toBoolean(valueByLastSegment(rows, 'Có khu trưng bày giới thiệu sản phẩm')),
    hasGuideStaff: toBoolean(valueByLastSegment(rows, 'Có nhân sự hướng dẫn khách')),
    salesChannels: splitList(valueByLastSegment(rows, 'Kênh tiêu thụ')),
    mainMarket: valueByLastSegment(rows, 'Thị trường chính'),
    internal: {
      averageOutputPerYear: valueByLastSegment(rows, 'Sản lượng bình quân/năm'),
      averageRevenuePerYear: valueByLastSegment(rows, 'Doanh thu bình quân/năm'),
      currentDifficulties: valueByLastSegment(rows, 'Khó khăn hiện nay'),
      supportNeeds: valueByLastSegment(rows, 'Nhu cầu hỗ trợ'),
    },
  };
}

export function parseWorkbook(workbook: Workbook, sourceFileName: string): ParsedImport {
  const warnings: string[] = [];
  let village: VillageInput | null = null;
  const historyStories: HistoryStoryInput[] = [];
  const heritageBuildings: HeritageBuildingInput[] = [];
  const decorativeArtItems: DecorativeArtItemInput[] = [];
  const intangibleHeritageItems: IntangibleHeritageItemInput[] = [];
  const craftProducts: CraftProductInput[] = [];
  const combinedDecorativeSheets: Worksheet[] = [];

  for (const worksheet of workbook.worksheets) {
    const name = worksheet.name.trim();

    if (/^1\./.test(name)) {
      const rows = extractLabeledRows(worksheet);
      const parsed = parseVillage(rows);
      if (parsed) village = parsed;
      else warnings.push(`Sheet "${worksheet.name}": không tìm thấy "Tên làng", bỏ qua thông tin làng.`);
      continue;
    }

    if (/^2\./.test(name)) {
      // Danh mục điểm/POI trên bản đồ tổng thể — không có tọa độ GPS trong
      // template này nên không tự động tạo `sites` được; cần bổ sung thủ công.
      warnings.push(`Sheet "${worksheet.name}": danh mục điểm trên bản đồ không có tọa độ, cần bổ sung thủ công.`);
      continue;
    }

    if (/^3\./.test(name)) {
      const rows = extractLabeledRows(worksheet);
      historyStories.push(...parseHistoryStories(rows));
      continue;
    }

    const decorativeSubMatch = name.match(DECORATIVE_SUB_SHEET);
    if (decorativeSubMatch) {
      const rows = extractLabeledRows(worksheet);
      const buildingTempId = `4.${decorativeSubMatch[1]}`;
      decorativeArtItems.push(...parseDecorativeArtItems(rows, buildingTempId));
      continue;
    }

    const buildingMatch = name.match(BUILDING_SHEET);
    if (buildingMatch) {
      const rows = extractLabeledRows(worksheet);
      const tempId = `4.${buildingMatch[1]}`;
      const building = parseHeritageBuilding(rows, tempId);
      if (building) heritageBuildings.push(building);
      else warnings.push(`Sheet "${worksheet.name}": không tìm thấy "Tên" công trình, bỏ qua.`);
      continue;
    }

    if (/^5\./.test(name)) {
      combinedDecorativeSheets.push(worksheet);
      continue;
    }

    if (/^6\./.test(name)) {
      const rows = extractLabeledRows(worksheet);
      intangibleHeritageItems.push(...parseIntangibleHeritageItems(rows));
      continue;
    }

    if (/^7\./.test(name)) {
      const rows = extractLabeledRows(worksheet);
      const fallbackName = name.replace(/^7(\.\d+)?\.?\s*/, '').trim();
      const product = parseCraftProduct(rows, fallbackName);
      if (product) craftProducts.push(product);
      else warnings.push(`Sheet "${worksheet.name}": không tìm thấy "Tên sản phẩm", bỏ qua.`);
      continue;
    }

    // Sheet "8." (điều tra xã hội học) and anything unrecognized: no schema
    // mapping exists for this yet (see docs/thiet-ke-csdl.md §5) — skipped.
  }

  // Sheet 5 doesn't record which building each decorative item belongs to —
  // default to the first parsed building; the review UI lets an admin
  // reassign before commit.
  if (combinedDecorativeSheets.length > 0) {
    const defaultBuildingTempId = heritageBuildings[0]?.tempId ?? '';
    if (!defaultBuildingTempId) {
      warnings.push('Sheet "5.": có đề tài mỹ thuật nhưng chưa có công trình di sản nào để gán — bỏ qua.');
    } else {
      for (const worksheet of combinedDecorativeSheets) {
        const rows = extractLabeledRows(worksheet);
        decorativeArtItems.push(...parseDecorativeArtItems(rows, defaultBuildingTempId));
      }
      warnings.push(
        `Đề tài mỹ thuật trang trí (sheet "5.") được gán mặc định vào công trình đầu tiên — kiểm tra lại trước khi xác nhận.`,
      );
    }
  }

  return {
    sourceFileName,
    village,
    historyStories,
    heritageBuildings,
    decorativeArtItems,
    intangibleHeritageItems,
    craftProducts,
    warnings,
  };
}
