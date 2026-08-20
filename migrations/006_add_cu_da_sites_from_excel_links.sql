-- Thêm các điểm (kind='point') cho làng Cự Đà, lấy toạ độ từ các link Google
-- Maps (dạng rút gọn maps.app.goo.gl) gắn kèm (hyperlink) trên các ô "Vị trí"
-- trong nhiều sheet của file "Làng Cự Đà.xlsx":
--   - Sheet "2. Bản đồ tổng thể của làng " — 24 link riêng biệt, mỗi link ở
--     cột "Dữ liệu" của một dòng "Vị trí" (không phải text hiển thị, mà là
--     hyperlink ẩn sau chữ "vị trí"/"Vị trí"/"Bản đồ" trong ô).
--   - Sheet "4.1. Kiến trúc đình Cự Đà" (C6), "4.2. Kiến trúc chùa Cự Đà" (C5),
--     "4.3. KT nhà ông Vũ ngọc Giao" (C6), "4.4. KT nhà ông Đinh Văn mão" (C6)
--     — link vị trí riêng của từng công trình di sản, dùng để đối chiếu (đều
--     lệch dưới 5m so với điểm cùng tên ở sheet "2.", nên KHÔNG thêm point
--     riêng cho 4 công trình này, tránh trùng lặp — xem ghi chú "đối chiếu"
--     bên dưới mỗi INSERT liên quan).
--
-- Cách đọc toạ độ (giống nguyên tắc đã ghi trong migration 004, áp dụng cho
-- link *.xlsx lần này thay vì danh sách Google My Maps thủ công): mở từng
-- link maps.app.goo.gl, lấy toạ độ ghim thật từ tham số !3d/!4d (hoặc từ
-- dạng /maps/search/<lat>,+<lng> khi Google trả redirect kiểu tìm kiếm thay
-- vì kiểu địa điểm) của URL đích sau khi resolve redirect. Không dùng toạ độ
-- tâm bản đồ trong @lat,lng,zoom vì đó là điểm nhìn của khung bản đồ, không
-- phải vị trí ghim.
--
-- Gộp nhãn: 3 dòng trong sheet "2." dùng LẠI đúng link của một điểm khác vì
-- đó là nhãn mô tả cụm ảnh/góc chụp, không phải một địa điểm khác:
--   - "Đình - cổng làng- không gian mặt nước" dùng chung link với "Cổng làng"
--     -> gộp vào 1 điểm, đặt tên theo đối tượng cụ thể hơn: "Cổng làng Cự Đà".
--   - "Chùa Cự Đà - Miếu - Sông" và "Giếng - sông - Chùa" đều dùng chung link
--     với "Chùa Cự Đà" -> gộp cả hai ghi chú vào 1 điểm "Chùa Cự Đà".
-- "Cây muỗm" và "Cây Nhãn 2" trỏ tới đúng cùng 1 ghim (khác với "Cây nhãn")
-- — giữ nguyên là 2 điểm riêng vì là 2 tên cây khác nhau trong khảo sát gốc,
-- không tự suy diễn đây là lỗi hay là cùng một cây.
--
-- Tên/mô tả giữ theo đúng nhãn và ghi chú (cột "Ghi chú") có trong file khảo
-- sát, không tự thêm thông tin ngoài nguồn — theo đúng nguyên tắc của migration
-- 004. Riêng ghi chú ở dòng "Cột cờ" trong file nguồn ("Đánh dấu vị trí quán
-- trên bản đồ") rõ ràng là ghi chú còn sót lại từ mẫu template (nói về "quán"
-- trong khi đối tượng là cột cờ) nên KHÔNG đưa vào short_description.
--
-- Bootstrap: nếu village "Làng Cự Đà" chưa tồn tại (chưa chạy Admin Import
-- cho sheet "1.Giới thiệu về làng"), tạo trước một bản ghi villages tối
-- thiểu từ đúng dữ liệu đã có ở sheet đó, để migration này có thể chạy độc
-- lập. Nếu village đã tồn tại (do đã Admin Import), KHÔNG ghi đè — giữ đúng
-- dữ liệu đã có.
--
-- Idempotent: INSERT dùng id cố định + ON CONFLICT (id) DO NOTHING, chạy lại
-- nhiều lần cho kết quả như nhau. Luôn `bash scripts/backup.sh` (hoặc
-- `pwsh scripts/backup.ps1`) trước khi áp dụng lên dữ liệu thật — xem
-- docs/trien-khai.md mục 5.

-- ============================================================
-- 0. Bootstrap village "Làng Cự Đà" nếu chưa có
-- ============================================================

-- slug 'cu-da' tính tay theo đúng quy tắc slugifyVietnamese() trong
-- map-tour/server/src/lib/slugify.ts (bỏ dấu, đ/Đ -> d, hạ chữ thường), vì
-- cột này NOT NULL + UNIQUE từ migration 005 và không có hàm slug ở tầng DB.
INSERT INTO villages (id, name, slug, aliases, admin_location, google_maps_link, founded_period, main_occupations)
SELECT
  '01000000-0000-0000-0000-000000000001',
  'Cự Đà',
  'cu-da',
  ARRAY['làng Ngô Khê'],
  'Xã Bình Minh, Hà Nội (trước là xã Cự Khê, huyện Thanh Oai, Hà Nội)',
  'https://maps.app.goo.gl/PHsLhJtDrLmiW9i2A',
  'TK1',
  ARRAY['Nghề làm miến', 'Nghề làm tương']
WHERE NOT EXISTS (SELECT 1 FROM villages WHERE slug = 'cu-da');

-- ============================================================
-- 1. Thêm 23 điểm (point) từ các link Google Maps trong sheet "2."
-- ============================================================

INSERT INTO sites (id, village_id, kind, position_lat, position_lng, name, category, short_description)
VALUES
  ('21000000-0000-0000-0000-000000000001',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.931050, 105.797169,
   'Đường chính', 'Cảnh quan',
   'Đường chính của làng Cự Đà.'),

  ('21000000-0000-0000-0000-000000000002',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.931994, 105.796477,
   'Đường nhánh/ngõ', 'Cảnh quan',
   'Làng có 16 ngõ xóm, đường làng, đường xóm lát gạch vỉa nghiêng, dài nhỏ hẹp vuông góc đâm ra bờ sông. Đầu ngõ thường là bến sông.'),

  ('21000000-0000-0000-0000-000000000003',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.933549, 105.798093,
   'Đường làng gắn với hoạt động sản xuất (miến)', 'Làng nghề',
   'Đoạn đường làng gắn với hoạt động sản xuất miến, một trong hai nghề truyền thống chính của làng (miến, tương).'),

  -- Đối chiếu: link vị trí riêng ở sheet "4.1." cho đúng công trình này trỏ tới
  -- 20.934197,105.798651 — lệch ~1m so với điểm dưới đây, không thêm point riêng.
  ('21000000-0000-0000-0000-000000000004',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934205, 105.798660,
   'Đình làng Cự Đà', 'Di tích tín ngưỡng',
   'Đình làng Cự Đà.'),

  -- Gộp nhãn "Đình - cổng làng- không gian mặt nước" (cùng link) vào điểm này.
  ('21000000-0000-0000-0000-000000000005',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934584, 105.801517,
   'Cổng làng Cự Đà', 'Di tích kiến trúc',
   'Trước làng có 3 cổng, hiện cổng trước và cổng sau đã bị phá hủy, chỉ còn lại cổng giữa làng (cùng chòi canh và không gian mặt nước xung quanh).'),

  ('21000000-0000-0000-0000-000000000006',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934632, 105.799064,
   'Cột cờ', 'Di tích kiến trúc',
   'Cột cờ của làng Cự Đà.'),

  ('21000000-0000-0000-0000-000000000007',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934771, 105.799912,
   'Miếu Cự Đà', 'Di tích tín ngưỡng',
   'Miếu của làng Cự Đà.'),

  ('21000000-0000-0000-0000-000000000008',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934738, 105.799838,
   'Đàn Xã tắc', 'Di tích tín ngưỡng',
   'Đàn Xã tắc của làng Cự Đà, nằm gần Miếu Cự Đà.'),

  -- Đối chiếu: link vị trí riêng ở sheet "4.2." cho đúng công trình này trỏ tới
  -- 20.935161,105.800020 — lệch <1m so với điểm dưới đây, không thêm point riêng.
  -- Gộp nhãn "Chùa Cự Đà - Miếu - Sông" và "Giếng - sông - Chùa" (cùng link) vào điểm này.
  ('21000000-0000-0000-0000-000000000009',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.935161, 105.800020,
   'Chùa Cự Đà', 'Di tích tín ngưỡng',
   'Chùa Cự Đà, nằm trong cụm cảnh quan chùa - miếu - sông - giếng của làng.'),

  ('21000000-0000-0000-0000-000000000010',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934568, 105.800004,
   'Giếng', 'Cảnh quan',
   'Giếng nước của làng Cự Đà, nằm gần khu vực chùa.'),

  -- "Cổng xóm Hiếu Đễ" (ghi chú liệt kê cả 4 tên cổng xóm ghi nhận trong khảo sát:
  -- Quang Trung 1, Quang Trung 2, Hiếu Đễ, Lễ Nghĩa).
  ('21000000-0000-0000-0000-000000000011',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.932499, 105.798092,
   'Cổng xóm Hiếu Đễ', 'Di tích kiến trúc',
   'Một trong các cổng xóm của làng Cự Đà (cùng với cổng xóm Quang Trung 1, Quang Trung 2, Lễ Nghĩa).'),

  ('21000000-0000-0000-0000-000000000012',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.933069, 105.798287,
   'Cổng xóm Quang Trung', 'Di tích kiến trúc',
   'Cổng xóm Quang Trung của làng Cự Đà.'),

  ('21000000-0000-0000-0000-000000000013',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.932150, 105.798013,
   'Cổng xóm - đường làng - nhà cổ', 'Di tích kiến trúc',
   'Cụm cổng xóm, đường làng và nhà cổ được ghi nhận cùng vị trí trong khảo sát bản đồ làng.'),

  ('21000000-0000-0000-0000-000000000014',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934744, 105.799083,
   'Nhà thờ họ', 'Di tích tín ngưỡng',
   'Nhà thờ họ Trịnh Giáp Thượng, Trịnh Giáp Hạ, Vũ Giáp Nam.'),

  ('21000000-0000-0000-0000-000000000015',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.932271, 105.797935,
   'Nhà cổ 31', 'Nhà cổ',
   'Nhà cổ số 31 theo đánh số khảo sát của làng Cự Đà.'),

  -- Đối chiếu: link vị trí riêng ở sheet "4.3." cho đúng công trình này trỏ tới
  -- 20.932312,105.797834 (giống hệt điểm dưới đây), không thêm point riêng.
  ('21000000-0000-0000-0000-000000000016',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.932312, 105.797834,
   'Nhà cổ ông Giao', 'Nhà cổ',
   'Nhà cổ của ông Vũ Ngọc Giao.'),

  -- Đối chiếu: link vị trí riêng ở sheet "4.4." (nhà ông Đinh Văn Mão) trỏ tới
  -- 20.931945,105.797863 — lệch <1m so với điểm dưới đây (cùng một nhà, "cụ Mão"
  -- = "ông Đinh Văn Mão"), không thêm point riêng.
  ('21000000-0000-0000-0000-000000000017',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.931945, 105.797863,
   'Nhà cổ cụ Mão', 'Nhà cổ',
   'Nhà cổ của cụ (ông) Đinh Văn Mão.'),

  ('21000000-0000-0000-0000-000000000018',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.931987, 105.797602,
   'Nhà cổ 216', 'Nhà cổ',
   'Nhà cổ số 216 theo đánh số khảo sát của làng Cự Đà.'),

  ('21000000-0000-0000-0000-000000000019',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934781, 105.799733,
   'Cây nhãn', 'Cảnh quan',
   'Cây nhãn cổ của làng Cự Đà.'),

  -- "Cây muỗm" và "Cây Nhãn 2" (điểm #21 dưới đây) dùng đúng cùng 1 ghim vị trí
  -- trong file nguồn — giữ nguyên là 2 tên/2 điểm riêng, không tự gộp.
  ('21000000-0000-0000-0000-000000000020',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934704, 105.799775,
   'Cây muỗm', 'Cảnh quan',
   'Cây muỗm cổ của làng Cự Đà.'),

  ('21000000-0000-0000-0000-000000000021',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934704, 105.799775,
   'Cây Nhãn 2', 'Cảnh quan',
   'Cây nhãn thứ hai được ghi nhận trong khảo sát bản đồ làng (cùng vị trí ghim với Cây muỗm trong file nguồn).'),

  ('21000000-0000-0000-0000-000000000022',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934537, 105.801427,
   'Quán ăn', 'Công trình công cộng',
   'Quán ăn của làng Cự Đà.'),

  ('21000000-0000-0000-0000-000000000023',
   (SELECT id FROM villages WHERE slug = 'cu-da'), 'point', 20.934705, 105.800086,
   'Quán nước', 'Công trình công cộng',
   'Quán nước của làng Cự Đà.')

ON CONFLICT (id) DO NOTHING;
