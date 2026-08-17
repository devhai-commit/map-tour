// Mirrors map-tour/server/src/lib/importTypes.ts — the contract for the
// admin Excel-import preview/confirm flow. Kept as a separate copy on this
// side of the API boundary, same convention as src/types.ts vs the server's
// SiteRow (see server/src/routes/sites.ts).

export interface VillageInput {
  name: string;
  aliases: string[];
  adminLocation: string | null;
  googleMapsLink: string | null;
  foundedPeriod: string | null;
  brandIdentity: string | null;
  nameMeaning: string | null;
  mainOccupations: string[];
  naturalFeatures: string | null;
  siteSelectionHistory: string | null;
  morphologyDescription: string | null;
}

export interface HistoryStoryInput {
  type: 'lich_su' | 'su_kien' | 'phong_tuc' | 'truyen_thuyet';
  title: string;
  bodyText: string;
}

export interface HeritageBuildingTechnicalDetailsInput {
  roofLayers: string | null;
  roofShape: string | null;
  roofMaterial: string | null;
  roofColor: string | null;
  facadeMaterial: string | null;
  facadeCondition: string | null;
  floorMaterial: string | null;
  floorPattern: string | null;
  structureMaterial: string | null;
  structureCondition: string | null;
  pedestalMaterial: string | null;
  pedestalSize: string | null;
  pedestalType: string | null;
}

export interface HeritageBuildingInput {
  tempId: string;
  name: string;
  address: string | null;
  function: string | null;
  ownership: string | null;
  landAreaM2: number | null;
  floorAreaM2: number | null;
  heritageRank: string | null;
  heritageRankYear: number | null;
  heritageStyleType: string | null;
  managingUnit: string | null;
  overallStructureDescription: string | null;
  culturalHistoricalValue: string | null;
  builtPeriod: string | null;
  technicalDetails: HeritageBuildingTechnicalDetailsInput;
}

export type DecorativeThemeGroup =
  | 'tin_nguong_ton_giao'
  | 'doi_song_sinh_hoat'
  | 'phong_thuy_cat_tuong'
  | 'hien_vat_co';

export interface DecorativeArtItemInput {
  themeGroup: DecorativeThemeGroup;
  subjectName: string;
  eraEstimate: string | null;
  description: string | null;
  buildingTempId: string;
}

export type ParticipationScope = 'mot_nhom_hoi' | 'nhieu_nhom_hoi' | 'toan_the_cong_dong';
export type TouristExperienceLevel = 'chi_xem' | 'trai_nghiem_mot_phan' | 'trai_nghiem_toan_bo';
export type RecognitionLevel = 'unesco' | 'quoc_gia' | 'tinh';

export interface IntangibleHeritageItemInput {
  name: string;
  recognitionLevel: RecognitionLevel | null;
  uniquenessDescription: string | null;
  participationScope: ParticipationScope | null;
  generationsTransmitted: string | null;
  touristExperienceLevel: TouristExperienceLevel | null;
  eventTiming: string | null;
  capacityNote: string | null;
}

export interface CraftProductInternalInput {
  averageOutputPerYear: string | null;
  averageRevenuePerYear: string | null;
  currentDifficulties: string | null;
  supportNeeds: string | null;
}

export interface CraftProductInput {
  name: string;
  productGroup: string | null;
  startPeriod: string | null;
  isTraditional: boolean | null;
  culturalLinkLevel: string | null;
  materials: string | null;
  productStory: string | null;
  processDescription: string | null;
  giftSuitability: string | null;
  hasExperienceActivity: boolean | null;
  experienceDuration: string | null;
  hasDemoSpace: boolean | null;
  hasDisplayArea: boolean | null;
  hasGuideStaff: boolean | null;
  salesChannels: string[];
  mainMarket: string | null;
  internal: CraftProductInternalInput;
}

export interface ParsedImport {
  sourceFileName: string;
  village: VillageInput | null;
  historyStories: HistoryStoryInput[];
  heritageBuildings: HeritageBuildingInput[];
  decorativeArtItems: DecorativeArtItemInput[];
  intangibleHeritageItems: IntangibleHeritageItemInput[];
  craftProducts: CraftProductInput[];
  warnings: string[];
}

export interface ImportCommitSummary {
  villageId: string | null;
  villageAction: 'created' | 'updated' | 'skipped';
  heritageBuildingCount: number;
  historyStoryCount: number;
  decorativeArtItemCount: number;
  intangibleHeritageItemCount: number;
  craftProductCount: number;
  warnings: string[];
}
