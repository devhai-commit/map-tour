-- Thêm 4 công trình kiến trúc (heritage_buildings) + hồ sơ kỹ thuật đi kèm
-- (heritage_building_technical_details) cho làng Ước Lễ, lấy nguyên văn từ 4
-- sheet "4.1. Kiến trúc đình Ước lễ", "4.2. Kiến trúc Chùa Sổ", "4.3. Kiến
-- trúc nhà cụ Khả " và "4.4. Kiến trúc nhà bà Bào" trong file "Ước Lễ.xlsx",
-- theo đúng các nhãn cột "Dữ liệu" mà bộ import Excel của ứng dụng nhận diện
-- (xem parseHeritageBuilding trong map-tour/server/src/lib/importParse.ts).
--
-- Làng Ước Lễ trước migration này chưa có công trình heritage_buildings nào —
-- khác với làng Cự Đà đã có đủ 4 công trình (nhập ở một phiên làm việc trước,
-- xem migrations/011 vừa backfill village_id cho 4 dòng đó). Nội dung ở đây
-- được lấy bằng cách chạy đúng pipeline nhập liệu hiện có của ứng dụng
-- (POST /api/admin/import/parse) trên file "Ước Lễ.xlsx" rồi chép lại y
-- nguyên kết quả — KHÔNG gọi thẳng /api/admin/import/commit vì bước đó còn
-- upsert village theo "name" và tên trong sheet 1 là "Ước Lễ" trong khi bản
-- ghi làng đang chạy tên là "Làng Ước Lễ" (lệch tên có từ trước, ngoài phạm vi
-- sửa ở migration này) — nếu commit thẳng sẽ tạo NHẦM một làng "Ước Lễ" trùng
-- lặp. Vì vậy village_id ở đây trỏ thẳng vào làng "Làng Ước Lễ" đã có sẵn
-- (id cố định '00000000-0000-0000-0000-000000000001').
--
-- title/tên công trình giữ nguyên văn kể cả hậu tố "(3)"/"(4)" trong ô "Tên"
-- của sheet 4.3/4.4 (đã soát lại tận ô gốc trong file Excel — đúng là surveyor
-- gõ vậy, không phải lỗi bóc tách dữ liệu).
--
-- Không nhập sheet "4.X.1 Hiện vật-Mỹ thuật" (decorative_art_items) ở đây —
-- ngoài phạm vi mục "Kiến trúc độc đáo" đang cần (chỉ lấy đúng sheet "4."),
-- để dành cho một migration/import riêng nếu cần sau này.
--
-- Idempotent: mỗi INSERT dùng id cố định + ON CONFLICT (id) DO NOTHING, chạy
-- lại nhiều lần cho kết quả như nhau.

INSERT INTO heritage_buildings (
  id, village_id, name, address, "function", ownership, land_area_m2, floor_area_m2,
  heritage_rank, heritage_rank_year, heritage_style_type, managing_unit,
  overall_structure_description, cultural_historical_value, built_period
)
VALUES
  ('44000000-0000-0000-0000-000000000001',
   '00000000-0000-0000-0000-000000000001', 'Đình làng Ước Lễ', 'làng Ước Lễ, xã Dân Hòa, Hà Nội',
   'Đình làng', NULL, 2500, NULL,
   'di tích cấp quốc gia', 2008, 'Kiến trúc nghệ thuật', NULL,
   $body$Đình làng là tổ hợp kiến trúc bao gồm Nghi môn, Tiền tế, Đại bái, Phương đình, Hậu cung và Tả hữu mạc. Trước 2 bên cửa Hậu cung là ngựa tế đỏ bên trái và ngựa tế trắng bên phải$body$,
   $body$Đình Ước Lễ thờ Tể tướng Lữ Gia làm thành hoàng làng, vị anh hùng trong cuộc chiến tranh chống quân Nam Hán xâm lược, với sự tích khi ngài chống quân Nam Hán đã bị chém đầu vẫn phi ngựa chạy về đến trước cổng làng Ước Lễ thì hóa. Tể tướng Lữ gia hy sinh ngày 12/9 âm lịch năm Canh ngọ (111 TCN). Hiện có trên 70 làng tôn Ngài là Đức Thành Hoàng làng (theo Tóm tắt lịch sử Việt Nam)$body$,
   'TK 17'),

  ('44000000-0000-0000-0000-000000000002',
   '00000000-0000-0000-0000-000000000001', 'Chùa Sổ', 'làng Ước Lễ, xã Dân Hòa, Hà Nội',
   'Chùa', NULL, 5000, NULL,
   'di tích cấp quốc gia', 1986, 'Kiến trúc nghệ thuật', NULL,
   $body$Chùa xây kiểu “Nội công ngoại quốc” với hai hành lang 26 gian, nối hai đầu tiền đường, cùng nhà hậu phía sau bao lấy tòa thượng điện.Kiến trúc “Chồng giường, giá chiêng, con nhị” với kết câu trên là hai xà ngân, đặt trên đầu hai cột con và tất cả đặt trên quá giang đội toàn bộ mái. Toàn bộ tượng trong chùa có tất cả 25 pho được làm vào thế kỷ 17 và 18, có giá trị lịch sử lớn.$body$,
   $body$Chùa Sổ hay còn gọi là Hội Linh quán, mang tinh thần tam giáo đồng nguyên. Ngoài hai bức đại tự "Hội Linh Quán" và "Đại La thiên" những phạm trù trong Đạo giáo, còn có bức "Từ Vân Pháp Vũ" ở thượng điện thể hiện sự giao hòa tín ngưỡng dân gian thờ bà Pháp Vũ của người Việt Nam. Tại văn bia Quán Hội Linh của chùa Sổ có ghi việc tu sửa quán Hội Linh, tô tạo tượng phạt, đúc chuông cùng bài tựa: “... Xã Ước Lễ huyện Thanh Oai phủ Ứng Thiên có quan Hội Linh nổi tiếng ở nước Nam ta. Bên trái có thanh long dẫn dòng đỗ đạt, sông Tô uốn quanh; bên phải có bạch hổ bày núi bút nghiên, bảng vàng chói lọi. Phía trước Chu Tước ôm ấp chính dòng nước, cuồn cuộn đổ về nguồn. Đằng sau huyền vũ thật chênh vênh, núi cao hơn đất. Bốn bề chung đúc khí thiêng, người tài vật quý, chư Phật thảy đều linh ứng, phúc đến lộc về.”

Chùa Sổ là một trong những ngôi chùa hiếm hoi còn giữ được dấu tích nền móng thời Mạc (1527), hệ thống di vật ở chùa cho thấy có sự giao thoa phát triển đặc sắc của điêu khắc, kiến trúc Mạc, Lê Trung Hưng và Nguyễn. Về kiến trúc, chùa kết cấu theo kiểu nội công - ngoại quốc. Từ cổng chùa vào là tam quan được xây kiểu chồng diêm, hai tầng tám mái, lợp ngói vảy cá. Giữa tam quan có quả chuông đồng lớn đề bốn chữ: “Quan Chung Linh tự”. Xung quanh chùa được xây thêm giếng nước và trồng nhiều cây xanh góp phần làm cho không gian thêm thanh bình êm ả.$body$,
   'TK 16'),

  ('44000000-0000-0000-0000-000000000003',
   '00000000-0000-0000-0000-000000000001', 'nhà cụ Khả (3)', 'làng Ước Lễ, xã Dân Hòa, Hà Nội',
   'nhà thờ họ', 'nhà cụ Khả', 415.5, 137.26,
   NULL, NULL, 'Kiến trúc nghệ thuật', NULL,
   'Nhà 5 gian',
   $body$Ngôi nhà truyền thống vùng đồng bằng Bắc Bộ với 5 gian gồm nhà chính phục vụ thờ cúng, tiếp khách; nhà phụ phục vụ sinh hoạt gia đình; khu bếp phục vụ nấu nướng; sân là không gian sinh hoạt chung; bể nước đảm bảo nhu cầu sử dụng nước và tiểu cảnh góp phần nâng cao giá trị cảnh quan.$body$,
   NULL),

  ('44000000-0000-0000-0000-000000000004',
   '00000000-0000-0000-0000-000000000001', 'Nhà bà Bào (4)', 'Làng Ước Lễ, xã Dân Hòa, Hà Nội',
   'Nhà ở', 'Nhà bà Bào', 489.25, 243.14,
   NULL, NULL, 'Kiến trúc', NULL,
   'Nhà 5 gian',
   $body$Ngôi nhà 5 gian truyền thống vùng đồng bằng Bắc Bộ còn giữ được các nét kiến trúc bản địa$body$,
   '1988')

ON CONFLICT (id) DO NOTHING;

INSERT INTO heritage_building_technical_details (
  id, building_id, roof_layers, roof_shape, roof_material, roof_color,
  facade_material, facade_condition, floor_material, floor_pattern,
  structure_material, structure_condition, pedestal_material, pedestal_size, pedestal_type
)
VALUES
  ('45000000-0000-0000-0000-000000000001', '44000000-0000-0000-0000-000000000001',
   '2 tầng mái', '2 mái', 'ngói vảy rồng', 'màu đỏ gạch nung',
   'gỗ', 'nguyên bản', 'lát gạch chỉ đỏ', 'lát theo kiểu xương cá',
   'gỗ', 'nguyên bản', 'đá xanh', NULL, 'tảng bồng'),

  ('45000000-0000-0000-0000-000000000002', '44000000-0000-0000-0000-000000000002',
   '1 tầng mái', '4 mái bít đốc', 'ngói vảy rồng', 'màu đỏ gạch đất nung',
   'Gạch đá', NULL, 'gạch lát', 'lát vuông',
   'hỗn hợp', NULL, 'Vật liệu đá', NULL, 'tảng bẹt'),

  ('45000000-0000-0000-0000-000000000003', '44000000-0000-0000-0000-000000000003',
   '1', '2 mái', 'ngói đất nung truyền thống', 'màu đỏ gạch nung',
   'gạch', 'nguyên bản', 'Nền lát gạch đất nung', 'Lát gạch theo hàng thẳng, mạch song song với trục công trình',
   'kết cấu vật liệu gỗ', 'nguyên bản', 'đá xanh', '355 x 355 mm', 'tảng bồng'),

  ('45000000-0000-0000-0000-000000000004', '44000000-0000-0000-0000-000000000004',
   '1 tầng mái', '2 mái', 'ngói đất nung truyền thống', 'mái màu đỏ',
   'trát vữa', 'nguyên bản', 'gạch đất nung', 'lát mạch thẳng',
   'khung gỗ', 'nguyên bản', 'đá xanh', '400 x 400mm', 'tảng bẹt')

ON CONFLICT (id) DO NOTHING;
