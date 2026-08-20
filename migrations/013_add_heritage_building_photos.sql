-- Bổ sung ảnh còn thiếu cho "Kiến trúc độc đáo" (heritage_buildings), chốt lại
-- trạng thái đã ghi trực tiếp vào CSDL đang chạy bởi
-- map-tour/server/scripts/import-cu-da-photos.ts và import-uoc-le-photos.ts
-- trong phiên làm việc này — cùng nguyên tắc với migrations/007, 008: nếu
-- khởi tạo lại CSDL từ init/ + migrations/ sẽ thiếu các dòng media dưới đây.
--
-- Bối cảnh: 6 ảnh 360° trong 2 file Excel nguồn ("Cự Đà.xlsx", "Ước Lễ.xlsx")
-- được Google Drive trả về với phần mở rộng ".insp" (định dạng riêng của máy
-- ảnh Insta360) trong header Content-Disposition — map-tour/server/scripts/
-- lib/drivePhoto.ts trước đây tin phần mở rộng này hơn nội dung byte thật,
-- nên coi đây là định dạng không nhận diện được và bỏ qua toàn bộ, dù dữ
-- liệu ảnh thật sự là JPEG hình cầu hợp lệ (đã xác nhận qua sharp: đúng tỉ lệ
-- 2:1). Đã sửa drivePhoto.ts ưu tiên đọc magic bytes thay vì tin tên file,
-- nên các ảnh này tải lại thành công.
--
-- 1) Làng Cự Đà: 5 dòng heritage_buildings media hoàn toàn mới (ảnh 360 mà
--    lần chạy trước migrations/007 bị lỗi .insp nên chưa từng có trong CSDL).
-- 2) 1 dòng đã có sẵn từ migrations/007 (kind cũ = 'anh') được sửa lại thành
--    'panorama' — ảnh này từng tải thành công (Content-Disposition tình cờ
--    trả về ".jpg") nhưng chưa được nhận diện là ảnh 360 ở thời điểm đó.
-- 3) Làng Ước Lễ: 89 dòng heritage_buildings media hoàn toàn mới — trước
--    migration này, cả 4 công trình kiến trúc của Ước Lễ (thêm ở
--    migrations/012) chưa có ảnh nào gắn trực tiếp vào heritage_buildings
--    (ảnh sheet 4.1/4.2 trước đó chỉ gắn vào `sites`, sheet 4.3/4.4 chưa
--    từng được nhập vì không có site tương ứng — xem import-uoc-le-photos.ts).
--    Không gồm 3 ảnh raw dual-fisheye chưa ghép (chụp ở chế độ thô của máy
--    Insta360, không phải ảnh phẳng cũng không phải ảnh cầu hợp lệ) đã được
--    loại bỏ khỏi CSDL sau khi phát hiện.
--
-- Khớp owner theo heritage_buildings.name (+ village_id với Ước Lễ, vì tên
-- công trình không cần unique toàn hệ thống) — cùng nguyên tắc với
-- migrations/007, 008, 012. Idempotent: mỗi INSERT có điều kiện NOT EXISTS
-- theo đúng url, UPDATE có điều kiện theo kind cũ, chạy lại nhiều lần cho kết
-- quả như nhau. Luôn `bash scripts/backup.sh` (hoặc `pwsh scripts/backup.ps1`)
-- trước khi áp dụng lên dữ liệu thật.

-- ============================================================
-- 1) Cự Đà — 5 ảnh 360 còn thiếu (lỗi .insp ở migrations/007)
-- ============================================================

DO $$
BEGIN
  IF EXISTS (
    SELECT expected.name
    FROM (VALUES ('Đình làng Cự Đà'), ('Chùa Cự Đà _ Linh Minh Tự'),
                 ('Nhà ông Vũ Ngọc Giao'), ('Nhà ông Mão')) expected(name)
    WHERE NOT EXISTS (
      SELECT 1 FROM heritage_buildings hb
      JOIN villages v ON v.id = hb.village_id
      WHERE v.slug = 'cu-da' AND hb.name = expected.name
    )
  ) THEN
    RAISE EXCEPTION 'Missing Cu Da heritage building owner required by migration 013';
  END IF;
END $$;

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-16.jpg', 'panorama', 'Ảnh trong nhà — Ảnh 360', 'heritage_buildings', (SELECT hb.id FROM heritage_buildings hb JOIN villages v ON v.id=hb.village_id WHERE v.slug='cu-da' AND hb.name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-16.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-20.jpg', 'panorama', 'Ảnh trong nhà — Ảnh 360 tam bảo', 'heritage_buildings', (SELECT hb.id FROM heritage_buildings hb JOIN villages v ON v.id=hb.village_id WHERE v.slug='cu-da' AND hb.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-20.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-10.jpg', 'panorama', 'Ảnh trong nhà — ảnh 360 nhà chính', 'heritage_buildings', (SELECT hb.id FROM heritage_buildings hb JOIN villages v ON v.id=hb.village_id WHERE v.slug='cu-da' AND hb.name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-10.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-11.jpg', 'panorama', 'Ảnh trong nhà — ảnh 360 nhà phụ', 'heritage_buildings', (SELECT hb.id FROM heritage_buildings hb JOIN villages v ON v.id=hb.village_id WHERE v.slug='cu-da' AND hb.name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-11.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-5.jpg', 'panorama', 'Ảnh các góc chính — Ảnh góc chính 360', 'heritage_buildings', (SELECT hb.id FROM heritage_buildings hb JOIN villages v ON v.id=hb.village_id WHERE v.slug='cu-da' AND hb.name = 'Nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-5.jpg');

-- ============================================================
-- 2) Cự Đà — sửa kind cho 1 ảnh 360 đã nhập từ migrations/007 nhưng còn
--    mang kind cũ 'anh' (thời điểm đó chưa nhận diện được đây là ảnh 360)
-- ============================================================

UPDATE media SET kind = 'panorama'
 WHERE owner_entity_type = 'heritage_buildings' AND kind = 'anh'
   AND url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-11.jpg'
   AND caption = 'Ảnh các góc chính — Ảnh 360';

-- ============================================================
-- 3) Ước Lễ — 89 ảnh/bản vẽ mới cho 4 công trình kiến trúc (heritage_buildings)
-- ============================================================

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-1.jpg', 'anh', 'Chụp thượng lương', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-2.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt đứng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-3.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt bên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-3.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-4.jpg', 'anh', 'Tam quan', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-4.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-5.jpg', 'anh', 'Tả vu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-5.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-6.jpg', 'anh', 'Hữu vu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-6.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-7.jpg', 'anh', 'Bia đá hữu vu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-7.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-8.jpg', 'anh', 'Bia đá tả vu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-8.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-9.jpg', 'anh', 'Hậu đường — Gác chuông', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-9.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-10.jpg', 'anh', 'Phía sau Hậu đường — Phía sau hậu đường', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-10.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-11.jpg', 'panorama', 'Ảnh360 — Ảnh 360', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-11.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-12.jpg', 'anh', 'Hình ảnh hiên — Hiên tiền đường', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-12.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-13.jpg', 'anh', 'Hiên tam quan', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-13.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-14.jpg', 'anh', 'Hiên gác chuông', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-14.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-15.jpg', 'anh', 'hiên thượng điện — Hiên thượng điện', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-15.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-16.jpg', 'anh', 'Nền hữu vu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-16.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-17.jpg', 'anh', 'Nền gác chuông', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-17.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-18.jpg', 'anh', 'Nền tả vu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-18.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-19.jpg', 'anh', 'Nền thượng điện', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-19.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-20.jpg', 'anh', 'Ảnh trong nhà — Thượng điện,', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-20.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-21.jpg', 'anh', 'Ảnh trong nhà — Tả vu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-21.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-22.jpg', 'anh', 'Ảnh trong nhà — Hữu vu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-22.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-23.jpg', 'anh', 'Ảnh trong nhà — Tam quan', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-23.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-24.jpg', 'anh', 'Kết cấu ảnh — tổng thể bộ vì', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-24.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-25.jpg', 'anh', 'Kết cấu ảnh — vì nóc', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-25.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-26.jpg', 'anh', 'Kết cấu ảnh — vì nách', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-26.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-27.jpg', 'anh', 'Kết cấu ảnh — đầu dư', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-27.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-28.jpg', 'anh', 'Chân tảng ảnh — chân tảng thượng điện', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-28.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-29.png', 'anh', 'Chân tảng ảnh — chân tảng thượng điện', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-29.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-30.png', 'anh', 'Chân tảng hoa văn — Hoa văn chân tảng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-30.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-31.png', 'anh', 'Chân tảng hoa văn — hoa văn chân tảng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-31.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/chua-so-44000000-32.png', 'anh', 'Chân tảng hoa văn — Chân tảng gác chuông', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Sổ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/chua-so-44000000-32.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — ảnh tổng thể từ nhà chính', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-2.pdf', 'ban_ve', 'Tổng mặt bằng — TMB nhà bà Bào', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-2.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-3.jpg', 'anh', 'Chụp thượng lương', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-3.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-4.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt đứng mặt bên công trình', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-4.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-5.jpg', 'anh', 'Ảnh các góc chính — Ảnh góc chính diện', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-5.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-6.jpg', 'panorama', 'Ảnh các góc chính — Ảnh 360', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-6.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-7.jpg', 'anh', 'Nền (ảnh chụp) — nền', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-7.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-8.pdf', 'ban_ve', 'Sơ đồ mặt bằng — sơ đồ mặt bằng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-8.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-9.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — sơ đồ mặt cắt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-9.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-10.jpg', 'anh', 'Ảnh trong nhà — gian1', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-10.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-11.jpg', 'anh', 'Ảnh trong nhà — gian2', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-11.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-12.jpg', 'anh', 'Ảnh trong nhà — gian3', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-12.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-13.jpg', 'anh', 'Ảnh trong nhà — gian4', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-13.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-14.jpg', 'anh', 'Kết cấu ảnh — kết cấu gian1', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-14.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-15.jpg', 'anh', 'Kết cấu ảnh — kết cấu gian2', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-15.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-16.jpg', 'anh', 'Kết cấu ảnh — kết cấu gian4', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-16.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-17.jpg', 'anh', 'Chân tảng ảnh — Chân tảng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bà Bào (4)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-ba-bao-4-44000000-17.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-2.pdf', 'ban_ve', 'Tổng mặt bằng — TMB cụ Khả', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-2.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-3.jpg', 'anh', 'Chụp thượng lương', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-3.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-4.jpg', 'anh', 'Mặt đứng, mặt bên công trình — mặt đứng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-4.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-5.jpg', 'anh', 'Ảnh các góc chính — ảnh chính diện các góc', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-5.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-6.jpg', 'anh', 'Ảnh các góc chính — ảnh góc phải', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-6.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-7.jpg', 'anh', 'Ảnh các góc chính — ảnh góc trái', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-7.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-8.jpg', 'anh', 'Ảnh các góc chính — ảnh nhìn từ nhà ra sân', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-8.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-9.jpg', 'panorama', 'Ảnh các góc chính — ảnh 360', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-9.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-10.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — cột trang trí', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-10.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-11.jpg', 'anh', 'Mái_cấu tạo — Mái', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-11.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-12.jpg', 'anh', 'Hình ảnh hiên — Ảnh hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-12.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-13.jpg', 'anh', 'Nền (ảnh chụp) — Ảnh nền', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-13.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-14.pdf', 'ban_ve', 'Sơ đồ mặt bằng — sơ đồ mặt bằng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-14.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-15.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — sơ đồ mặt cắt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-15.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-16.jpg', 'anh', 'Ảnh trong nhà — ảnh gian2', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-16.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-17.jpg', 'anh', 'Ảnh trong nhà — ảnh gian3', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-17.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-18.jpg', 'anh', 'Ảnh trong nhà — ảnh gian4', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-18.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-19.jpg', 'anh', 'Ảnh trong nhà — ảnh gian5', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-19.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-20.jpg', 'anh', 'Kết cấu ảnh — Kết cấu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-20.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-21.jpg', 'anh', 'Kết cấu ảnh — Kết cấu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-21.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-22.jpg', 'anh', 'Kết cấu ảnh — Kết cấu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-22.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-23.jpg', 'anh', 'Kết cấu ảnh — kết cấu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-23.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-24.jpg', 'anh', 'Chân tảng ảnh — ảnh chân tảng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-24.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-25.png', 'anh', 'Chân tảng hoa văn — ảnh cận', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà cụ Khả (3)' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/nha-cu-kha-3-44000000-25.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-1.jpg', 'anh', 'Xếp hạng di tích gì — ảnh công nhận di tích', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-4.jpg', 'anh', 'Chụp thượng lương', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-4.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-5.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt bên công trình', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-5.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-6.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt đứng công trình', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-6.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-7.jpg', 'panorama', 'Ảnh các góc chính — Ảnh 360 từ cạnh bên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-7.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-8.jpg', 'panorama', 'Ảnh các góc chính — Ảnh 360 mặt trước', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-8.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-9.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-9.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-10.jpg', 'anh', 'Mái_cấu tạo — Mái', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-10.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-11.jpg', 'anh', 'Hình ảnh hiên — ẢNh hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-11.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-12.jpg', 'anh', 'Ảnh trong nhà', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-12.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-13.jpg', 'anh', 'Kết cấu ảnh — Tổng thể bộ vì', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-13.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-14.jpg', 'anh', 'Kết cấu ảnh — vì nóc', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-14.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-15.jpg', 'anh', 'Kết cấu ảnh — vì nách', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-15.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-16.jpg', 'anh', 'Chân tảng ảnh — chân tảng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-16.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-17.jpg', 'anh', 'Chân tảng hoa văn — hoa văn chân tảng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-17.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-18.jpg', 'anh', 'Chân tảng hoa văn — hoa văn chân tảng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Ước Lễ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/heritage-buildings/dinh-lang-uoc-le-44000000-18.jpg');
