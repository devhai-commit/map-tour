-- Thêm các điểm (kind='point') cho làng Hạ Thái, lấy toạ độ từ các link
-- Google Maps (hyperlink ẩn dưới ô "Vị trí") trong sheet "2. Bản đồ tổng thể của
-- làng" của file "Hạ Thái.xlsx" — cùng cách đọc toạ độ đã ghi trong
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
-- 0. Bootstrap village "Hạ Thái" nếu chưa có
-- ============================================================

INSERT INTO villages (id, name, slug, admin_location, founded_period, main_occupations)
SELECT
  'fdd98e46-3b65-490d-aadc-dbb90eab321d',
  'Hạ Thái',
  'ha-thai',
  'Xã Hồng Vân, Hà Nội',
  'Khoảng thế kỷ XVII (nghề sơn) / Thế kỷ XVIII (làng)',
  ARRAY['Nghề sơn mài truyền thống', 'Nghề nông']
WHERE NOT EXISTS (SELECT 1 FROM villages WHERE slug = 'ha-thai');

-- ============================================================
-- 1. Thêm 32 điểm (point) từ các link Google Maps trong sheet "2."
-- ============================================================

INSERT INTO sites (id, village_id, kind, position_lat, position_lng, name, category, light_count_25m, history_culture_note)
VALUES
  ('297a57a6-4bcc-40fd-8b3b-761f984ff0fd',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.902029, 105.866041,
   'Đường chính — Vạn Thọ', 'Giao thông', NULL, NULL),

  ('50cc1810-1a41-4d00-9bf6-d12465585123',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.900851, 105.865889,
   'Đường chính — Đường Tràng Hạ', 'Giao thông', NULL, NULL),

  ('f27421bb-5b83-4c77-acdc-7d3c68f220af',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.905234, 105.865395,
   'Đường chính — Đường Thái Bình', 'Giao thông', NULL, NULL),

  ('0556a156-a3e3-4d29-8885-91ac17dcecb9',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.900913, 105.865586,
   'Đường nhánh/ngõ', 'Giao thông', NULL, NULL),

  ('c5d4ef45-3210-49b0-8f2e-7fbaeaebd61e',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.901443, 105.865894,
   'Đường nhánh/ngõ', 'Giao thông', NULL, NULL),

  ('d7830180-f2a8-4ebf-b0f9-0c20543696f6',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.90205, 105.866111,
   'Đường nhánh/ngõ', 'Giao thông', NULL, NULL),

  ('d6765528-4c3b-43fe-b26f-e31973f6dd64',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.902838, 105.866499,
   'Đường nhánh/ngõ', 'Giao thông', NULL, NULL),

  ('f2f810ef-9a50-4fab-9101-e206e07f9393',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.903645, 105.866822,
   'Đường nhánh/ngõ', 'Giao thông', NULL, NULL),

  ('fb4d84be-8723-4a04-be99-22d6651a40b5',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.904575, 105.867237,
   'Đường nhánh/ngõ', 'Giao thông', NULL, NULL),

  ('c2b27d51-0c70-452a-b018-45cf6d7e9c56',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.900121, 105.869208,
   'Cổng Đình', 'Công trình công cộng', NULL, NULL),

  ('6940e1f3-7220-4ad7-b51e-98b86692df7c',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.900852, 105.869467,
   'Cổng xóm Mỹ Lộc', 'Công trình công cộng', NULL, NULL),

  ('4b9b87fb-0c41-43b4-81a5-38678458a9db',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.90104, 105.868522,
   'Cổng xóm Chu My', 'Công trình công cộng', NULL, NULL),

  ('72157e2d-8d22-4022-b4be-18e3b63f3e4f',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.901426, 105.865912,
   'Cổng làng', 'Công trình công cộng', NULL, NULL),

  ('d813ed0d-366c-4aff-b7b0-033dad2906d4',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.9011793, 105.8691984,
   'Đình làng', 'Công trình công cộng', NULL, NULL),

  ('2edf0cc8-fdba-44ff-b83c-5aea246a11b9',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.900975, 105.86924,
   'Đình - Không gian mở (ao, sông, đồng ruộng,…) - Cây đa/đề/si', 'Công trình công cộng', 6, 'Thần phả ghi lại rằng: trước đây vùng đất này hoang vu, cây cối um tùm và dân cư thưa thớt. Lúc đó trong rừng có một con hổ dữ, dân làng gọi là hổ lang thường tìm về bắt người và gia súc ăn thịt. Không thể thu phục được con hổ đã thành tinh này nên hàng năm dân làng đành phải cống nạp cho hổ một người vào ngày 10/11. Trong làng có bà Lạy, một người đàn bà không chồng, không con, thấu hiểu nỗi đau và mất mát của dân làng, bà đã tự nguyện dâng mình cho hổ với mong muốn việc cống nạp này sẽ chấm dứt. Lời khấn cầu nguyện của bà trước trời đất có vẻ linh thiêng và ứng nghiệm, bởi kể từ ngày 10/11 năm đó khi hổ đến vồ bà Lạy và đưa đi mất, người dân không còn thấy hổ quay lại quấy phá nữa. Để tưởng nhớ công ơn của bà, người dân đã xây miếu thờ, sau này bà được tôn làm thành hoàng làng và miếu đó trở thành đình làng Hạ Thái và lấy ngày 10/11 hàng năm là ngày hội làng truyền thống. Đình làng Hạ Thái còn liên quan đến quan võ thời Lê Bùi Sĩ Lương (1544-1597), ông làm đến chức Thái sư kiêm Điện Tiền Chỉ Huy Sứ. Là người thông minh văn võ song toàn, ông có công lớn trong phò Lê, diệt Mạc. Khi đến Hạ Thái, nhận thấy vùng đất nơi này có thế rồng chầu hổ phục, ông đã chọn Hạ Thái để lập gia trang và dạy dân lập nghiệp, vì vậy sau khi mất, ông cũng được tôn là Thành hoàng làng. Lễ hội làng Hạ Thái diễn ra từ ngày 9 đến 11/11 âm lịch hàng năm và thu hút được đông đảo du khách thập phương về tham dự.'),

  ('6e5fc28f-9e4f-4290-8801-e97581ef232f',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.9003941, 105.8655111,
   'Chùa Duyên Trường', 'Công trình công cộng', NULL, NULL),

  ('f8687aff-58a8-4df9-bdb1-7fa8db6417d1',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.9011602, 105.8696279,
   'Chùa Phúc Thái', 'Công trình công cộng', NULL, NULL),

  ('60217152-a88b-4f05-8ee9-593985d9fb23',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.9087768, 105.867805,
   'Miếu Trình', 'Công trình công cộng', NULL, NULL),

  ('0d0db01e-2bbf-4d28-a289-c9c2bdc9a3c7',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.9052558, 105.8654909,
   'Miếu Nghè', 'Công trình công cộng', NULL, NULL),

  ('3b890288-8a15-4484-a53f-444775d8fd20',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.900917, 105.869563,
   'Miếu', 'Công trình công cộng', NULL, NULL),

  ('4182fd39-6d5e-4a40-b050-4f141bc860a4',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.9051203, 105.8668491,
   'Văn chỉ', 'Công trình công cộng', NULL, NULL),

  ('c7ed2238-2c52-42ce-af48-c0dd241e6ef3',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.9021227, 105.8682171,
   'Nhà thờ họ', 'Công trình công cộng', NULL, NULL),

  ('cb162594-8acc-419f-8e48-2ccf168f6288',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.900687, 105.870672,
   'Nhà cổ bà Dịp', 'Nhà ở', NULL, NULL),

  ('c28846f5-ea72-460b-aa45-d9c3d3bb15a6',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.908979, 105.867907,
   'Cây cổ thụ', 'Cây', NULL, NULL),

  ('743a1c86-b0f5-4d4b-a6d8-ed2fe6444edc',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.904621, 105.864434,
   'Sông Tô Lịch', 'Mặt nước', NULL, NULL),

  ('f700864d-34e3-4f85-b121-bacc5a117937',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.905378, 105.865474,
   'Sông - bến đò/ thuyền', 'Mặt nước', 10, NULL),

  ('e689ba8b-cf6e-4826-a469-dfc732526f3b',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.905378, 105.865474,
   'Ao', 'Mặt nước', NULL, NULL),

  ('9c831ce5-2e1e-4468-b09c-27ee3a032d5a',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.900985, 105.869229,
   'Giếng_Đình Hạ Thái', 'Mặt nước', NULL, NULL),

  ('7ca23109-cf2c-4020-97da-ba3c67033918',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.906198, 105.866174,
   'Giếng_Miếu Nghè', 'Mặt nước', NULL, NULL),

  ('a2c635e8-d3df-455e-bd55-f9aaa9e75507',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.908365, 105.867581,
   'Giếng_Miếu Trình', 'Mặt nước', NULL, NULL),

  ('5d6055d9-7ed7-4889-baf6-60b590360815',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.90453, 105.8674,
   'Kênh mương thủy lợi', 'Mặt nước', NULL, NULL),

  ('b008170d-a82b-4604-9220-5cc6f0f9e2a7',
   (SELECT id FROM villages WHERE slug = 'ha-thai'), 'point', 20.9020783, 105.8659023,
   'Quán nước', 'Tiện ích du lịch', NULL, NULL)
ON CONFLICT (id) DO NOTHING;
