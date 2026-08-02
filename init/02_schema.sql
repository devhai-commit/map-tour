-- Schema CSDL Làng Ước Lễ (di sản & du lịch — độc lập, không thuộc project map-tour)
-- Nguồn thiết kế: docs/thiet-ke-csdl.md và docs/thiet-ke-csdl.docx
--
-- Ghi chú triển khai (khác biệt nhỏ so với tài liệu thiết kế gốc):
--   - Quan hệ sites <-> heritage_buildings: tài liệu gốc mô tả cả hai chiều
--     (sites.heritage_building_id VÀ heritage_buildings.site_id). Khi cài đặt
--     thật, chỉ giữ MỘT chiều để tránh vòng FK dư thừa — dùng đúng chiều mà
--     tài liệu gốc gọi là "cầu nối duy nhất": sites.heritage_building_id.
--   - Các cột enum (kind, category, theme_group...) dùng TEXT + CHECK constraint
--     thay vì PostgreSQL ENUM type, để sau này mở rộng danh sách giá trị chỉ cần
--     ALTER ... DROP/ADD CONSTRAINT, không cần ALTER TYPE (vốn có nhiều hạn chế
--     trong transaction).
--   - Các cột "*_media_ids" (mảng FK) không có ràng buộc FK thật ở mức DB vì
--     PostgreSQL không hỗ trợ FK trên từng phần tử của array — toàn vẹn dữ liệu
--     cho các cột này cần được đảm bảo ở tầng ứng dụng.
--   - Thêm created_at/updated_at cho mọi bảng (không có trong tài liệu thiết kế
--     gốc) — thực hành tiêu chuẩn cho một CSDL vận hành thật, phục vụ audit/debug.

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- media — bảng dùng chung cho ảnh/bản vẽ/panorama/video (polymorphic)
-- ============================================================
CREATE TABLE media (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  url              text NOT NULL,
  kind             text NOT NULL CHECK (kind IN ('anh', 'ban_ve', 'panorama', 'video')),
  attribution      text,
  caption          text,
  owner_entity_type text NOT NULL CHECK (owner_entity_type IN (
                     'villages', 'sites', 'heritage_buildings', 'history_stories',
                     'decorative_art_items', 'intangible_heritage_items', 'craft_products'
                   )),
  owner_entity_id  uuid NOT NULL,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_media_owner ON media (owner_entity_type, owner_entity_id);

CREATE TRIGGER trg_media_updated_at
  BEFORE UPDATE ON media
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- villages — hồ sơ làng (sheet 1)
-- ============================================================
CREATE TABLE villages (
  id                          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name                        text NOT NULL,
  aliases                     text[],
  admin_location              text,
  google_maps_link            text,
  founded_period              text,
  brand_identity              text,
  name_meaning                text,
  main_occupations            text[],
  natural_features            text,
  site_selection_history      text,
  morphology_description      text,
  morphology_diagram_media_id uuid REFERENCES media (id) ON DELETE SET NULL,
  created_at                  timestamptz NOT NULL DEFAULT now(),
  updated_at                  timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_villages_updated_at
  BEFORE UPDATE ON villages
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- heritage_buildings — hồ sơ công trình di sản, phần editorial (sheet 4.1-4.4)
-- ============================================================
CREATE TABLE heritage_buildings (
  id                             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name                           text NOT NULL,
  address                        text,
  "function"                     text,
  ownership                      text,
  land_area_m2                   numeric,
  floor_area_m2                  numeric,
  heritage_rank                  text,
  heritage_rank_year             integer,
  heritage_style_type            text,
  managing_unit                  text,
  overall_structure_description  text,
  cultural_historical_value      text,
  built_period                   text,
  restoration_note               text,
  gallery_media_ids              uuid[],
  created_at                     timestamptz NOT NULL DEFAULT now(),
  updated_at                     timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_heritage_buildings_updated_at
  BEFORE UPDATE ON heritage_buildings
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- heritage_building_technical_details — hồ sơ đo đạc kỹ thuật (1-1, tùy chọn)
-- ============================================================
CREATE TABLE heritage_building_technical_details (
  id                          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id                 uuid NOT NULL UNIQUE REFERENCES heritage_buildings (id) ON DELETE CASCADE,
  roof_layers                 text,
  roof_shape                  text,
  roof_material               text,
  roof_color                  text,
  facade_material              text,
  facade_condition             text,
  floor_material               text,
  floor_pattern                text,
  structure_material           text,
  structure_condition          text,
  column_height_cm             numeric,
  column_diameter_cm           numeric,
  pedestal_material            text,
  pedestal_size                text,
  pedestal_type                text,
  floor_plan_drawing_media_id  uuid REFERENCES media (id) ON DELETE SET NULL,
  section_drawing_media_id     uuid REFERENCES media (id) ON DELETE SET NULL,
  created_at                   timestamptz NOT NULL DEFAULT now(),
  updated_at                   timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_heritage_building_technical_details_updated_at
  BEFORE UPDATE ON heritage_building_technical_details
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- sites — điểm/khu vực trên bản đồ, mở rộng TourSite hiện tại (sheet 2)
-- ============================================================
CREATE TABLE sites (
  id                     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  village_id             uuid NOT NULL REFERENCES villages (id) ON DELETE CASCADE,
  kind                   text NOT NULL CHECK (kind IN ('point', 'area')),
  position_lat           double precision,
  position_lng           double precision,
  boundary               jsonb,
  name                   text NOT NULL,
  category               text NOT NULL,
  sub_category           text,
  short_description      text,
  light_count_25m        integer,
  history_culture_note   text,
  cover_media_id         uuid REFERENCES media (id) ON DELETE SET NULL,
  panorama_media_id      uuid REFERENCES media (id) ON DELETE SET NULL,
  heritage_building_id   uuid UNIQUE REFERENCES heritage_buildings (id) ON DELETE SET NULL,
  created_at             timestamptz NOT NULL DEFAULT now(),
  updated_at             timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT chk_sites_geometry CHECK (
    (kind = 'point' AND position_lat IS NOT NULL AND position_lng IS NOT NULL AND boundary IS NULL)
    OR
    (kind = 'area' AND boundary IS NOT NULL AND position_lat IS NULL AND position_lng IS NULL)
  )
);

CREATE INDEX idx_sites_village_id ON sites (village_id);
CREATE INDEX idx_sites_category ON sites (category, sub_category);

CREATE TRIGGER trg_sites_updated_at
  BEFORE UPDATE ON sites
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- history_stories — lịch sử/sự kiện/phong tục/truyền thuyết (sheet 3)
-- ============================================================
CREATE TABLE history_stories (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  village_id  uuid NOT NULL REFERENCES villages (id) ON DELETE CASCADE,
  site_id     uuid REFERENCES sites (id) ON DELETE SET NULL,
  type        text NOT NULL CHECK (type IN ('lich_su', 'su_kien', 'phong_tuc', 'truyen_thuyet')),
  title       text NOT NULL,
  body_text   text,
  media_ids   uuid[],
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_history_stories_village_id ON history_stories (village_id);
CREATE INDEX idx_history_stories_site_id ON history_stories (site_id);

CREATE TRIGGER trg_history_stories_updated_at
  BEFORE UPDATE ON history_stories
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- decorative_art_items — đề tài mỹ thuật trang trí & hiện vật cổ (sheet 5)
-- ============================================================
CREATE TABLE decorative_art_items (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id  uuid NOT NULL REFERENCES heritage_buildings (id) ON DELETE CASCADE,
  theme_group  text NOT NULL CHECK (theme_group IN (
                 'tin_nguong_ton_giao', 'doi_song_sinh_hoat', 'phong_thuy_cat_tuong', 'hien_vat_co'
               )),
  subject_name text NOT NULL,
  era_estimate text,
  description  text,
  media_ids    uuid[],
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_decorative_art_items_building_id ON decorative_art_items (building_id);

CREATE TRIGGER trg_decorative_art_items_updated_at
  BEFORE UPDATE ON decorative_art_items
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- intangible_heritage_items — di sản văn hóa phi vật thể (sheet 6)
-- ============================================================
CREATE TABLE intangible_heritage_items (
  id                       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  village_id               uuid NOT NULL REFERENCES villages (id) ON DELETE CASCADE,
  name                     text NOT NULL,
  recognition_level        text CHECK (recognition_level IN ('unesco', 'quoc_gia', 'tinh')),
  uniqueness_description   text,
  participation_scope      text CHECK (participation_scope IN (
                             'mot_nhom_hoi', 'nhieu_nhom_hoi', 'toan_the_cong_dong'
                           )),
  generations_transmitted  text,
  tourist_experience_level text CHECK (tourist_experience_level IN (
                             'chi_xem', 'trai_nghiem_mot_phan', 'trai_nghiem_toan_bo'
                           )),
  event_timing             text,
  capacity_note            text,
  media_ids                uuid[],
  created_at               timestamptz NOT NULL DEFAULT now(),
  updated_at               timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_intangible_heritage_items_village_id ON intangible_heritage_items (village_id);

CREATE TRIGGER trg_intangible_heritage_items_updated_at
  BEFORE UPDATE ON intangible_heritage_items
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- craft_products — sản phẩm nghề truyền thống, phần hướng khách (sheet 7)
-- ============================================================
CREATE TABLE craft_products (
  id                     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  village_id             uuid NOT NULL REFERENCES villages (id) ON DELETE CASCADE,
  name                   text NOT NULL,
  product_group          text,
  start_period           text,
  is_traditional         boolean,
  cultural_link_level    text,
  materials              text,
  product_story          text,
  process_description    text,
  process_media_ids      uuid[],
  gift_suitability       text,
  has_experience_activity boolean,
  experience_duration     text,
  has_demo_space          boolean,
  has_display_area        boolean,
  has_guide_staff         boolean,
  sales_channels          text[],
  main_market             text,
  created_at              timestamptz NOT NULL DEFAULT now(),
  updated_at              timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_craft_products_village_id ON craft_products (village_id);

CREATE TRIGGER trg_craft_products_updated_at
  BEFORE UPDATE ON craft_products
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- craft_products_internal — số liệu kinh doanh nhạy cảm (1-1, tách riêng)
-- ============================================================
CREATE TABLE craft_products_internal (
  id                        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id                uuid NOT NULL UNIQUE REFERENCES craft_products (id) ON DELETE CASCADE,
  average_output_per_year   text,
  average_revenue_per_year  text,
  current_difficulties      text,
  support_needs             text,
  created_at                timestamptz NOT NULL DEFAULT now(),
  updated_at                timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_craft_products_internal_updated_at
  BEFORE UPDATE ON craft_products_internal
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();
