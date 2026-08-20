-- Thêm các điểm (kind='point') cho làng Phú Vinh, lấy toạ độ từ các link
-- Google Maps (hyperlink ẩn dưới ô "Vị trí") trong sheet "2. Bản đồ tổng thể của
-- làng" của file "Phú Vinh.xlsx" — cùng cách đọc toạ độ đã ghi trong
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
-- 0. Bootstrap village "Phú Vinh" nếu chưa có
-- ============================================================

INSERT INTO villages (id, name, slug, admin_location, founded_period, main_occupations)
SELECT
  '8216fe86-f66d-4b19-904b-cbdee0bf1eba',
  'Phú Vinh',
  'phu-vinh',
  'Xã Phú Nghĩa, TP Hà Nội (trước là xã Phú Nghĩa, huyện Chương Mỹ, thành phố Hà Nội)',
  'Từ năm 1700 (đầu TK 17)',
  ARRAY[]::text[]
WHERE NOT EXISTS (SELECT 1 FROM villages WHERE slug = 'phu-vinh');

-- ============================================================
-- 1. Thêm 13 điểm (point) từ các link Google Maps trong sheet "2."
-- ============================================================

INSERT INTO sites (id, village_id, kind, position_lat, position_lng, name, category, light_count_25m, history_culture_note)
VALUES
  ('a8c52c9f-dd7e-4ae6-904b-d65e844579c6',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.932731, 105.652192,
   'Đường chính', 'GIAO THÔNG', NULL, NULL),

  ('2fb52b97-503f-4f3f-8ed0-26595709db20',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.933313, 105.649686,
   'Đường nhánh/ngõ', 'GIAO THÔNG', NULL, NULL),

  ('6b618c65-7d7c-4287-accc-1845babb35cc',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.931248, 105.649379,
   'Đường theo vật liệu', 'GIAO THÔNG', NULL, NULL),

  ('8987a84a-b2d7-4423-86b9-94d27953c155',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.932659, 105.65099,
   'Quán', 'NHÀ CÔNG CỘNG', 15, NULL),

  ('f06f841f-b468-4f92-b6c6-72dd66815c99',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.932581, 105.651633,
   'Chợ', 'NHÀ CÔNG CỘNG', 10, NULL),

  ('7cf72fe0-3aa2-4c0e-9c57-e926d04db3ba',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.93417, 105.651406,
   'Đình làng', 'NHÀ CÔNG CỘNG', NULL, NULL),

  ('f15021e9-5cee-4574-8b56-6d22a288dcf1',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.933464, 105.648107,
   'Chùa Hạ Phú Vinh', 'NHÀ CÔNG CỘNG', NULL, NULL),

  ('41033f55-90ea-4539-aba1-1ea4ed330048',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.930722, 105.6494877,
   'Chùa Cổ Ngỗng', 'NHÀ CÔNG CỘNG', NULL, NULL),

  ('5b519f6e-5d64-4d9b-9623-cb4e78f666cb',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.933209, 105.654957,
   'Nhà cổ Nguyễn Hưu Bật', 'NHÀ Ở', NULL, NULL),

  ('b7a1677b-f9ea-4a8d-9d1d-5c73ab4ba178',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.9331838, 105.6550042,
   'Nhà cổ Nguyễn Hữu Kí', 'NHÀ Ở', NULL, NULL),

  ('d3802314-f819-40eb-9447-8d6f23b2a7b6',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.9330857, 105.6495636,
   'Nhà cổ Hoàng Hạnh', 'NHÀ Ở', NULL, NULL),

  ('d49c5ca9-4e36-4c36-b31d-417f813d6dcc',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.929908, 105.648962,
   'Đất nông nghiệp', 'CÂY', NULL, NULL),

  ('c1ed694a-3a3d-4eab-bd63-18c619cd15be',
   (SELECT id FROM villages WHERE slug = 'phu-vinh'), 'point', 20.929834, 105.651204,
   'Giếng', 'MẶT NƯỚC', NULL, NULL)
ON CONFLICT (id) DO NOTHING;
