-- Cập nhật đủ 21 điểm (kind='point') trong làng Ước Lễ, lấy từ danh sách
-- Google My Maps "Làng Ước Lễ" (chủ sở hữu: Nga Duong, "21 địa điểm — Danh
-- sách chung"), mở qua link:
-- https://www.google.com/maps/@20.8259091,105.810058,18z/data=!4m7!1m3!11m2!2sjpLI3iBBzukCSruUSvgBAg!3e3!11m2!2sjpLI3iBBzukCSruUSvgBAg!3e3!5m2!1e4!1e1
--
-- Trước migration này, init/04_seed_sample.sql chỉ có 4 điểm với toạ độ ước
-- lượng gần đúng quanh cổng làng (xem chú thích trong file đó và trong
-- migrations/003_update_coordinates.sql). Migration này:
--   1. Sửa toạ độ 4 điểm đã có về đúng vị trí thật lấy từ danh sách Google Maps.
--   2. Đổi tên 2 điểm cho khớp với tên thật trong danh sách (Giếng làng ->
--      Giếng Ngõ Phát; Chùa làng Ước Lễ -> Chùa Sùng Phúc, vì danh sách có
--      2 chùa riêng biệt — chùa còn lại "Chùa Hậu" được thêm mới ở bước 3).
--   3. Thêm 17 điểm còn thiếu để đủ 21 điểm.
-- Khớp theo s.name khi UPDATE (không dùng id, theo đúng quy ước của migration
-- 003) vì id có thể không cố định giữa các lần seed khác nhau.
--
-- Ghi chú độ chính xác toạ độ: 13/21 điểm đọc trực tiếp từ nhãn toạ độ
-- (DMS) Google hiển thị trong danh sách; 8 điểm còn lại (ghim thả tay,
-- không có nhãn toạ độ inline) đọc từ tham số !3d/!4d của URL trang địa
-- điểm sau khi bấm vào từng ghim — độ chính xác tương đương.
-- "Nhà Bà Vân siu cổ" -> sửa lỗi chính tả thành "siêu cổ" khi lưu vào CSDL;
-- các tên khác giữ nguyên đúng như trong danh sách nguồn dù có thể không
-- chuẩn chính tả, để không tự suy diễn thêm thông tin không có trong nguồn.
-- Điểm #14 trong danh sách nguồn là ghim không đặt tên, không có mô tả —
-- lưu với tên tạm "Điểm chưa đặt tên (gần đình)" dựa theo vị trí thực tế.
--
-- Idempotent: UPDATE luôn set về giá trị đích cố định (không cộng dồn theo
-- delta); INSERT dùng ON CONFLICT (id) DO NOTHING nên chạy lại nhiều lần
-- cho kết quả như nhau. Luôn `bash scripts/backup.sh` trước khi áp dụng lên
-- dữ liệu thật (xem docs/trien-khai.md mục 5).

-- ============================================================
-- 1-2. Sửa toạ độ + tên 4 điểm đã có
-- ============================================================

UPDATE sites SET position_lat = 20.827635, position_lng = 105.810083
WHERE name = 'Cổng làng Ước Lễ' AND kind = 'point';

UPDATE sites SET position_lat = 20.827225, position_lng = 105.810244
WHERE name = 'Đình làng Ước Lễ' AND kind = 'point';

UPDATE sites SET name = 'Chùa Sùng Phúc', position_lat = 20.827972, position_lng = 105.811889
WHERE name = 'Chùa làng Ước Lễ' AND kind = 'point';

UPDATE sites SET name = 'Giếng Ngõ Phát', position_lat = 20.826889, position_lng = 105.812278
WHERE name = 'Giếng làng' AND kind = 'point';

-- ============================================================
-- 3. Thêm 17 điểm còn thiếu (đủ 21 điểm point trong làng)
-- ============================================================

INSERT INTO sites (id, village_id, kind, position_lat, position_lng, name, category, short_description)
VALUES
  ('20000000-0000-0000-0000-000000000007',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.824639, 105.811861,
   'Chùa Hậu', 'Di tích tín ngưỡng',
   'Ngôi chùa của làng, nằm ở phía sau khu dân cư, phân biệt với Chùa Sùng Phúc.'),

  ('20000000-0000-0000-0000-000000000008',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.824306, 105.813056,
   'Cổng Sau Làng Ước Lễ', 'Di tích kiến trúc',
   'Cổng sau của làng, lối ra vào phụ bên cạnh cổng chính (Cổng làng Ước Lễ).'),

  ('20000000-0000-0000-0000-000000000009',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.826333, 105.812278,
   'Nhà Dân', 'Nhà cổ',
   'Nhà dân trong khu dân cư truyền thống của làng.'),

  ('20000000-0000-0000-0000-000000000010',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.823861, 105.810306,
   'Quán Mới', 'Công trình công cộng',
   'Quán của làng, điểm sinh hoạt cộng đồng.'),

  ('20000000-0000-0000-0000-000000000011',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.826306, 105.811333,
   'Điếm Tuần', 'Công trình công cộng',
   'Điếm tuần (chốt canh gác) cổ của làng, gắn với hoạt động tuần phòng truyền thống.'),

  ('20000000-0000-0000-0000-000000000012',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.826139, 105.810306,
   'Nhà Cổ (nhà Cụ Sẩm)', 'Nhà cổ',
   'Nhà cổ của gia đình cụ Sẩm, một trong những nhà cổ còn giữ được kiến trúc truyền thống.'),

  ('20000000-0000-0000-0000-000000000013',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.826417, 105.809639,
   'Đền Ngõ Họ', 'Di tích tín ngưỡng',
   'Đền nhỏ nằm trong ngõ họ của làng.'),

  ('20000000-0000-0000-0000-000000000014',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.826472, 105.809778,
   'Nhà Thờ Giáo Họ', 'Di tích tín ngưỡng',
   'Nhà thờ giáo họ, nơi sinh hoạt tôn giáo của cộng đồng Công giáo trong làng.'),

  ('20000000-0000-0000-0000-000000000015',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.826806, 105.811083,
   'Ngõ 3', 'Cảnh quan',
   'Ngõ xóm số 3 trong làng, một trong các tuyến đường nội bộ mang đặc trưng làng cổ.'),

  ('20000000-0000-0000-0000-000000000016',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.827222, 105.810694,
   'Đền Chợ', 'Di tích tín ngưỡng',
   'Đền nằm gần khu vực chợ làng.'),

  ('20000000-0000-0000-0000-000000000017',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.827250, 105.810537,
   'Điểm chưa đặt tên (gần đình)', 'Cảnh quan',
   'Điểm ghi nhận trên bản đồ khảo sát, chưa xác định tên/công năng cụ thể, nằm gần đình làng.'),

  ('20000000-0000-0000-0000-000000000018',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.826235, 105.812898,
   'Đường gạch khá đẹp', 'Cảnh quan',
   'Đoạn đường lát gạch còn giữ được nét kiến trúc làng cổ.'),

  ('20000000-0000-0000-0000-000000000019',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.826252, 105.813035,
   'Nhà cổ khum biếc tên', 'Nhà cổ',
   'Nhà cổ được ghi nhận trong khảo sát bản đồ làng.'),

  ('20000000-0000-0000-0000-000000000020',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.826024, 105.812371,
   'Nhà Bà Vân siêu cổ', 'Nhà cổ',
   'Nhà cổ của gia đình bà Vân, được ghi nhận là một trong những nhà rất cổ còn lại trong làng.'),

  ('20000000-0000-0000-0000-000000000021',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.826742, 105.811062,
   'Ngõ nhà đẹp', 'Cảnh quan',
   'Ngõ xóm có kiến trúc nhà đẹp, đáng chú ý trong khảo sát bản đồ làng.'),

  ('20000000-0000-0000-0000-000000000022',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.827057, 105.811544,
   'Nhà cổ số 4', 'Nhà cổ',
   'Nhà cổ số 4 theo đánh số khảo sát, còn giữ kiến trúc truyền thống.'),

  ('20000000-0000-0000-0000-000000000023',
   (SELECT id FROM villages WHERE name = 'Làng Ước Lễ'), 'point', 20.827482, 105.811424,
   'Nhà có cổng cổ', 'Nhà cổ',
   'Nhà dân có cổng cổ, một trong các điểm kiến trúc cổng nhà đáng chú ý của làng.')
ON CONFLICT (id) DO NOTHING;
