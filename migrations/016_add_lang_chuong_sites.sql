-- Thêm các điểm (kind='point') cho làng Làng Chuông, lấy toạ độ từ các link
-- Google Maps (hyperlink ẩn dưới ô "Vị trí") trong sheet "2. Bản đồ tổng thể của
-- làng" của file "Làng Chuông.xlsx" — cùng cách đọc toạ độ đã ghi trong
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
-- 0. Bootstrap village "Làng Chuông" nếu chưa có
-- ============================================================

INSERT INTO villages (id, name, slug, admin_location, founded_period, main_occupations)
SELECT
  '09ee09b0-41f2-429c-a515-0cd2592edc44',
  'Làng Chuông',
  'lang-chuong',
  'Xã Thanh Oai, TP. Hà Nội (trước xã Phương Trung, huyện Thanh Oai, Hà Nội)',
  'thế kỷ thứ 8 (cụ thể là vào năm 791 - năm Tân Mùi)',
  ARRAY[]::text[]
WHERE NOT EXISTS (SELECT 1 FROM villages WHERE slug = 'lang-chuong');

-- ============================================================
-- 1. Thêm 25 điểm (point) từ các link Google Maps trong sheet "2."
-- ============================================================

INSERT INTO sites (id, village_id, kind, position_lat, position_lng, name, category, light_count_25m, history_culture_note)
VALUES
  ('1d8169b9-ba0f-4f00-b00a-eee0a512c7ad',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.82881, 105.76242,
   'Đường chính', 'Giao thông', NULL, NULL),

  ('d5b7ab2f-ca77-44f3-abfc-bbf37260bc50',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.829, 105.76212,
   'Đường nhánh/ngõ', 'Giao thông', NULL, NULL),

  ('495a71f9-99a3-418f-98ad-eff84975c53f',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.829, 105.76212,
   'Đường theo vật liệu', 'Giao thông', NULL, NULL),

  ('05777db9-c92b-4da6-9f66-2833674f6ad5',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.8271, 105.76814,
   'Điếm Ngõa Kiều', 'Giao thông', NULL, NULL),

  ('d30f9f94-feed-4c29-9d7d-9eae85b19a33',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.82906, 105.75746,
   'Điếm xóm 2 thôn Liên Tân', 'Giao thông', NULL, NULL),

  ('5e1d7cfb-ad82-4bc9-99ab-dee66e8f0911',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.8291667, 105.7608611,
   'Chợ', 'Giao thông', NULL, NULL),

  ('8322ba72-4b66-4d0d-911b-61ea10332a97',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.82921, 105.76127,
   'Chợ - Chùa', 'Giao thông', NULL, NULL),

  ('bffd491e-5b22-49d1-b77b-377edd25664a',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.8241944, 105.7727778,
   'Cổng làng', 'Giao thông', NULL, NULL),

  ('b052b7f7-f771-4f18-8457-f4acc92c9b8d',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.8292222, 105.7612778,
   'Đình làng', 'Giao thông', NULL, NULL),

  ('15d48e54-3790-4900-9e87-df730349392f',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.8292222, 105.7612778,
   'Đình - Không gian mở (ao, sông, đồng ruộng,…) - Cây đa/đề/si', 'Giao thông', NULL, NULL),

  ('225152ae-cf96-485a-8fb4-5956bbd9bcff',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.8301389, 105.76175,
   'Chùa', 'Giao thông', NULL, NULL),

  ('78cb2d2e-69b3-42f3-8b28-5c5b9031961f',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.83304, 105.76194,
   'Nhà thờ', 'Giao thông', NULL, NULL),

  ('ceb78e41-82e6-4d87-8155-7ea70ec1a83e',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.8248611, 105.7638333,
   'Đền Ông', 'Giao thông', NULL, NULL),

  ('60353b9d-c4e4-4d1e-a186-5b75ba80984a',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.82704, 105.76013,
   'Đền Thượng', 'Giao thông', NULL, NULL),

  ('e39832de-c992-4295-b9e4-302aff37cbca',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.83334, 105.76584,
   'Đền Quán Trung', 'Giao thông', NULL, NULL),

  ('1c2471bb-ae76-43fa-a3bf-97fdd76e5ce4',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.82406, 105.77167,
   'Văn chỉ', 'Giao thông', NULL, NULL),

  ('50800f73-2fe4-483f-8b4a-4177688cd00a',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.83159, 105.76333,
   'Nhà thờ họ', 'Giao thông', NULL, NULL),

  ('5ebaa055-99e0-4897-97c3-0170cbb6d381',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.82528, 105.76135,
   'Nhà cổ', 'Nhà ở', NULL, NULL),

  ('67a60076-5af3-4f6c-89d8-69e21342b36d',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.82896, 105.75708,
   'Lũy tre', 'Cây', NULL, NULL),

  ('616bf014-5516-44ce-80c3-7d52190f1da3',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.8236, 105.77252,
   'Đất nông nghiệp', 'Cây', NULL, NULL),

  ('d198a4db-d65d-4136-88d7-fe4692f03199',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.8291944, 105.75675,
   'Sông', 'Mặt nước', NULL, NULL),

  ('fafa82e9-5d72-42aa-a059-1cdcce1ba4ea',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.82997, 105.76195,
   'Giếng chùa Chuông', 'Mặt nước', NULL, NULL),

  ('de1a0d7d-37f8-4134-b172-1a739c3fa419',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.82485, 105.76383,
   'Giếng đền Ông', 'Mặt nước', NULL, NULL),

  ('106ce802-8e72-434c-9868-3d31349edf42',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.83105, 105.76204,
   'Giếng xóm 8 Trung Khu', 'Mặt nước', NULL, NULL),

  ('9ec04fb9-9aef-4c12-9f47-bfc19872c0b2',
   (SELECT id FROM villages WHERE slug = 'lang-chuong'), 'point', 20.8248611, 105.7638333,
   'Giếng - sân - miếu/ban thờ', 'Mặt nước', NULL, NULL)
ON CONFLICT (id) DO NOTHING;
