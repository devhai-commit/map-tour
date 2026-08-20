-- Thêm cột village_id vào heritage_buildings để công trình kiến trúc (sheet
-- "4.X. Kiến trúc ..." của mỗi file khảo sát) có thể được truy vấn trực tiếp
-- theo làng. Trước migration này, quan hệ duy nhất giữa heritage_buildings và
-- villages đi qua sites.heritage_building_id (xem comment "cầu nối duy nhất"
-- ở đầu init/02_schema.sql) — nhưng cột đó chưa từng được set cho bất kỳ site
-- nào (rà soát: SELECT count(*) FROM sites WHERE heritage_building_id IS NOT
-- NULL = 0), nên 4 công trình đã nhập của Cự Đà không thể lọc theo village_id
-- được — cần cho mục "Kiến trúc độc đáo" mới trên trang giới thiệu làng.
--
-- Backfill 4 công trình Cự Đà hiện có về đúng làng Cự Đà (id lấy trực tiếp từ
-- CSDL đang chạy: SELECT id, name FROM heritage_buildings).
--
-- Idempotent: ADD COLUMN IF NOT EXISTS; UPDATE giới hạn theo danh sách id cụ
-- thể CỘNG điều kiện village_id IS NULL — chạy lại nhiều lần cho kết quả như
-- nhau. Đã pg_dump --data-only heritage_buildings trước khi áp dụng lên CSDL
-- đang chạy.

ALTER TABLE heritage_buildings
  ADD COLUMN IF NOT EXISTS village_id uuid REFERENCES villages (id) ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_heritage_buildings_village_id ON heritage_buildings (village_id);

UPDATE heritage_buildings SET village_id = (SELECT id FROM villages WHERE slug = 'cu-da')
 WHERE name IN (
     'Đình làng Cự Đà',
     'Nhà ông Mão',
     'nhà ông Mão',
     'Chùa Cự Đà _ Linh Minh Tự',
     'Nhà ông Vũ Ngọc Giao'
   )
   AND village_id IS NULL;

DO $$
BEGIN
  IF (SELECT count(*) FROM heritage_buildings hb
      JOIN villages v ON v.id = hb.village_id
      WHERE v.slug = 'cu-da'
        AND hb.name IN ('Đình làng Cự Đà', 'Nhà ông Mão', 'nhà ông Mão',
                        'Chùa Cự Đà _ Linh Minh Tự', 'Nhà ông Vũ Ngọc Giao')) <> 4 THEN
    RAISE EXCEPTION 'Expected exactly four Cu Da heritage buildings after backfill';
  END IF;
END $$;
