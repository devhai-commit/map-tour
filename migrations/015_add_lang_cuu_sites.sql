-- Thêm các điểm (kind='point') cho làng Làng Cựu, lấy toạ độ từ các link
-- Google Maps (hyperlink ẩn dưới ô "Vị trí") trong sheet "2. Bản đồ tổng thể của
-- làng" của file "Làng Cựu.xlsx" — cùng cách đọc toạ độ đã ghi trong
-- migration 006 (resolve redirect maps.app.goo.gl, lấy toạ độ ghim thật từ
-- !3d/!4d hoặc từ dạng /maps/search/<lat>,+<lng>).
--
-- Tên/mô tả giữ đúng nhãn có trong file khảo sát, không tự thêm thông tin
-- ngoài nguồn. short_description để trống (NULL) vì cột "Ghi chú" của sheet
-- "2." ở các file này là hướng dẫn khảo sát chung, không phải mô tả riêng cho
-- từng điểm; light_count_25m/history_culture_note chỉ điền khi sheet có ghi
-- rõ ("Kiểm đếm đèn trong bán kính 25m"/"Thông tin lịch sử - văn hóa").
--
-- Idempotent: INSERT dùng id cố định + ON CONFLICT (id) DO NOTHING.
-- Luôn backup (scripts/backup.sh) trước khi áp dụng lên dữ liệu thật.

-- ============================================================
-- 0. Bootstrap village "Làng Cựu" nếu chưa có
-- ============================================================

INSERT INTO villages (id, name, slug, admin_location, founded_period, main_occupations)
SELECT
  'c33319de-4845-41bf-94c1-3fa501e5e867',
  'Làng Cựu',
  'lang-cuu',
  'Xã Chuyên Mỹ, TP. Hà Nội (trước xã Vân Từ, huyện Phú Xuyên, TP. Hà Nội)',
  'khoảng thế kỷ XIII',
  ARRAY[]::text[]
WHERE NOT EXISTS (SELECT 1 FROM villages WHERE slug = 'lang-cuu');

-- ============================================================
-- 1. Thêm 16 điểm (point) từ các link Google Maps trong sheet "2."
-- ============================================================

INSERT INTO sites (id, village_id, kind, position_lat, position_lng, name, category, light_count_25m, history_culture_note)
VALUES
  ('4c9de4f0-3b78-4ad2-b856-a6b635f3514b',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70865, 105.88935,
   'Đường chính', 'Giao thông', NULL, NULL),

  ('b22e7458-33f4-46d7-a833-fa949d15fed0',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.708413265372698, 105.89088423009412,
   'Đường nhánh/ngõ', 'Giao thông', NULL, NULL),

  ('9b2adb32-b607-419d-a5c3-69894a2d5c66',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70842, 105.89017,
   'Đường đá', 'Giao thông', NULL, NULL),

  ('7d904c2e-ee19-480f-a93a-62c2f2810b6a',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.708038, 105.89195,
   'Đường gạch', 'Giao thông', NULL, NULL),

  ('aca31262-bb0a-47ee-8543-b7b8003ead58',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.708113, 105.891659,
   'Đường nửa đá nửa gạch', 'Giao thông', NULL, NULL),

  ('889cf51e-4283-401e-bef4-78bef4e0f992',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70822, 105.89377,
   'Cổng làng', 'Giao thông', NULL, NULL),

  ('53fa7c45-dac2-49cc-a4c1-11f6a7db5c24',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70866, 105.88913,
   'Đình làng', 'Giao thông', NULL, NULL),

  ('03111ee1-5fca-41d0-888e-9bb7f58a31b2',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70866, 105.88913,
   'Đình - Không gian mở (ao, sông, đồng ruộng,…) - Cây đa/đề/si', 'Giao thông', NULL, 'Đầu thế kỷ XVI'),

  ('2d807452-23ae-46f0-9d24-753bea18f1f1',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70461, 105.88849,
   'Chùa', 'Giao thông', NULL, NULL),

  ('1cc62aa3-f869-4470-92fe-2a4d62c366a8',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70868, 105.88979,
   'Nhà thờ họ', 'Giao thông', NULL, NULL),

  ('78ba5481-fe5f-41a4-b64c-ca81e771ce53',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.708126, 105.891735,
   'Nhà Tây', 'Nhà ở', NULL, NULL),

  ('6e4bdb96-4631-4af9-80d2-ff2a3f29bf8c',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70818, 105.89277,
   'Nhà cổ bác tứ', 'Nhà ở', NULL, NULL),

  ('2c84ff41-5bbe-4314-b600-a89f0735e9d0',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.708618, 105.889015,
   'Cây cổ thụ đầu làng', 'Cây', NULL, NULL),

  ('0b8904ea-3cca-4609-9d61-fdeb8c753881',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70798, 105.89152,
   'Cây cổ thụ giữa làng', 'Cây', NULL, NULL),

  ('66cf0b99-c24b-447c-b3f4-7d2d2a506cb7',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70773, 105.88983,
   'ao', 'Mặt nước', NULL, NULL),

  ('010f644d-0f9d-4977-b357-138f306501e2',
   (SELECT id FROM villages WHERE slug = 'lang-cuu'), 'point', 20.70774, 105.89141,
   'giếng', 'Mặt nước', NULL, NULL)
ON CONFLICT (id) DO NOTHING;
