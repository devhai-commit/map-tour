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
 WHERE id = ANY(ARRAY[
     '26cdf372-1676-460e-a701-d4ef78a2aa4c', -- Đình làng Cự Đà
     'd1bb8b84-46ae-4603-b27f-1bd9058f13c4', -- Nhà ông Mão
     '4f9067b2-4b9f-4376-8788-3178f157fcf0', -- Chùa Cự Đà _ Linh Minh Tự
     '0dcbc754-ab06-4144-b95c-909eddf28024'  -- Nhà ông Vũ Ngọc Giao
   ]::uuid[])
   AND village_id IS NULL;
