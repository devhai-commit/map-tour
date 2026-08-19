-- Thêm 70 bản ghi media cho ảnh thật của làng Ước Lễ đã tải về
-- map-tour/public/uoc-le/sites/ — dữ liệu này trước đó được ghi trực tiếp vào
-- CSDL đang chạy bởi map-tour/server/scripts/import-uoc-le-photos.ts (đọc
-- "Ước Lễ.xlsx" để lấy chú thích + site sở hữu cho từng ảnh), KHÔNG qua
-- migration SQL nào — nên nếu khởi tạo lại CSDL từ init/ + migrations/ (vd.
-- mất volume Docker) sẽ thiếu toàn bộ các dòng media này và các site dưới đây
-- sẽ còn giữ 5 cặp ảnh placeholder CC0 (Poly Haven) từ migrations/001 + 002.
-- Migration này chốt lại đúng trạng thái đã ghi bởi script trên thành SQL, để
-- việc khởi tạo lại CSDL từ đầu tái tạo được đầy đủ dữ liệu ảnh.
--
-- Khớp owner theo s.name (không hardcode uuid) — cùng nguyên tắc với
-- migrations/001, 002, 006, 007. Idempotent: mỗi INSERT có điều kiện NOT
-- EXISTS theo đúng url, chạy lại nhiều lần cho kết quả như nhau. Luôn
-- `bash scripts/backup.sh` (hoặc `pwsh scripts/backup.ps1`) trước khi áp dụng
-- lên dữ liệu thật.

-- ============================================================
-- Xoá ảnh placeholder CC0 cũ (migrations/001, 002) của 5 site được thay ảnh
-- thật ở dưới — chỉ null cover/panorama khi vẫn còn đúng là ảnh placeholder cũ
-- (không đụng nếu đã được người dùng đổi ảnh khác sau đó), rồi xoá dòng media
-- placeholder tương ứng. "Khu làng cổ" không có ảnh thật thay thế trong lần
-- import này nên giữ nguyên placeholder.
-- ============================================================

UPDATE sites SET cover_media_id = NULL WHERE name = 'Cổng làng Ước Lễ' AND cover_media_id = (SELECT id FROM media WHERE url = '/heritage/cong-lang.jpg');
UPDATE sites SET panorama_media_id = NULL WHERE name = 'Cổng làng Ước Lễ' AND panorama_media_id = (SELECT id FROM media WHERE url = '/panoramas/cong-lang-uoc-le.jpg');
UPDATE sites SET cover_media_id = NULL WHERE name = 'Đình làng Ước Lễ' AND cover_media_id = (SELECT id FROM media WHERE url = '/heritage/dinh-lang.jpg');
UPDATE sites SET panorama_media_id = NULL WHERE name = 'Đình làng Ước Lễ' AND panorama_media_id = (SELECT id FROM media WHERE url = '/panoramas/dinh-lang-uoc-le.jpg');
UPDATE sites SET cover_media_id = NULL WHERE name = 'Chùa Sùng Phúc' AND cover_media_id = (SELECT id FROM media WHERE url = '/heritage/chua-lang.jpg');
UPDATE sites SET panorama_media_id = NULL WHERE name = 'Chùa Sùng Phúc' AND panorama_media_id = (SELECT id FROM media WHERE url = '/panoramas/chua-lang-uoc-le.jpg');
UPDATE sites SET cover_media_id = NULL WHERE name = 'Giếng Ngõ Phát' AND cover_media_id = (SELECT id FROM media WHERE url = '/heritage/gieng-lang.jpg');
UPDATE sites SET panorama_media_id = NULL WHERE name = 'Giếng Ngõ Phát' AND panorama_media_id = (SELECT id FROM media WHERE url = '/panoramas/gieng-lang.jpg');
UPDATE sites SET cover_media_id = NULL WHERE name = 'Khu làng nghề giò chả' AND cover_media_id = (SELECT id FROM media WHERE url = '/heritage/khu-lang-gio-cha.jpg');
UPDATE sites SET panorama_media_id = NULL WHERE name = 'Khu làng nghề giò chả' AND panorama_media_id = (SELECT id FROM media WHERE url = '/panoramas/khu-lang-nghe-gio-cha.jpg');

DELETE FROM media WHERE url IN ('/heritage/cong-lang.jpg', '/panoramas/cong-lang-uoc-le.jpg', '/heritage/dinh-lang.jpg', '/panoramas/dinh-lang-uoc-le.jpg', '/heritage/chua-lang.jpg', '/panoramas/chua-lang-uoc-le.jpg', '/heritage/gieng-lang.jpg', '/panoramas/gieng-lang.jpg', '/heritage/khu-lang-gio-cha.jpg', '/panoramas/khu-lang-nghe-gio-cha.jpg');

-- ============================================================
-- sites — ảnh thật từ Ước Lễ.xlsx
-- ============================================================

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/quan-moi-1.jpg', 'anh', 'Quán mới', 'sites', (SELECT id FROM sites s WHERE s.name = 'Quán Mới' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/quan-moi-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/diem-tuan-1.jpg', 'anh', 'ảnh điếm', 'sites', (SELECT id FROM sites s WHERE s.name = 'Điếm Tuần' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/diem-tuan-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/cong-lang-uoc-le-1.jpg', 'anh', 'ảnh cổng mặt ngoài làng', 'sites', (SELECT id FROM sites s WHERE s.name = 'Cổng làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/cong-lang-uoc-le-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/cong-lang-uoc-le-2.jpg', 'anh', 'ảnh cổng mặt trong làng', 'sites', (SELECT id FROM sites s WHERE s.name = 'Cổng làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/cong-lang-uoc-le-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/cong-sau-lang-uoc-le-1.jpg', 'anh', 'ảnh cổng sau', 'sites', (SELECT id FROM sites s WHERE s.name = 'Cổng Sau Làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/cong-sau-lang-uoc-le-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-1.jpg', 'anh', 'đình làng ước lễ', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-1.jpg', 'anh', 'chùa Sổ', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-2.jpg', 'anh', 'Chùa Sùng Phúc', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-hau-1.jpg', 'anh', 'chùa Hậu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Hậu' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-hau-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/nha-tho-giao-ho-1.jpg', 'anh', 'nhà thờ giáo họ', 'sites', (SELECT id FROM sites s WHERE s.name = 'Nhà Thờ Giáo Họ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/nha-tho-giao-ho-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/den-ngo-ho-1.jpg', 'anh', 'miếu nằm cạnh nhà thờ giáo họ', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đền Ngõ Họ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/den-ngo-ho-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/den-cho-1.jpg', 'anh', 'Đền Chợ', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đền Chợ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/den-cho-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/nha-ba-van-sieu-co-1.jpg', 'anh', 'Nhà bà Vân', 'sites', (SELECT id FROM sites s WHERE s.name = 'Nhà Bà Vân siêu cổ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/nha-ba-van-sieu-co-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/nha-co-khum-biec-ten-1.jpg', 'anh', 'Nhà cổ không biết tên', 'sites', (SELECT id FROM sites s WHERE s.name = 'Nhà cổ khum biếc tên' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/nha-co-khum-biec-ten-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/nha-co-nha-cu-sam-1.jpg', 'anh', 'Nhà cụ Sẩm', 'sites', (SELECT id FROM sites s WHERE s.name = 'Nhà Cổ (nhà Cụ Sẩm)' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/nha-co-nha-cu-sam-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-3.jpg', 'anh', 'giếng chùa sùng phúc mới', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-3.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/nha-tho-giao-ho-2.jpg', 'anh', 'miếu thờ', 'sites', (SELECT id FROM sites s WHERE s.name = 'Nhà Thờ Giáo Họ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/nha-tho-giao-ho-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-hau-2.jpg', 'anh', 'giếng chùa Hậu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Hậu' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-hau-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-4.jpg', 'anh', 'Chùa Sổ', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-4.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/gieng-ngo-phat-1.jpg', 'anh', 'Giếng Ngõ Phát', 'sites', (SELECT id FROM sites s WHERE s.name = 'Giếng Ngõ Phát' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/gieng-ngo-phat-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-2.jpg', 'anh', 'Xếp hạng di tích gì — ảnh công nhận di tích', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-5.jpg', 'anh', 'Chụp thượng lương', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-5.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-6.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt bên công trình', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-6.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-7.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt đứng công trình', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-7.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-10.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-10.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-11.jpg', 'anh', 'Mái_cấu tạo — Mái', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-11.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-12.jpg', 'anh', 'Hình ảnh hiên — ẢNh hiên', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-12.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-13.jpg', 'panorama', 'Ảnh trong nhà', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-13.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-14.jpg', 'anh', 'Kết cấu ảnh — Tổng thể bộ vì', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-14.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-15.jpg', 'anh', 'Kết cấu ảnh — vì nóc', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-15.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-16.jpg', 'anh', 'Kết cấu ảnh — vì nách', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-16.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-17.jpg', 'anh', 'Chân tảng ảnh — chân tảng', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-17.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-18.jpg', 'anh', 'Chân tảng hoa văn — hoa văn chân tảng', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-18.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-19.jpg', 'anh', 'Chân tảng hoa văn — hoa văn chân tảng', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-19.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-20.png', 'anh', 'Linh vật: Rồng, Phượng, Lân, Long mã, nghê, rùa,…', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-20.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-21.jpg', 'anh', 'Tích xưa', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-21.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-22.jpg', 'anh', 'Đề tài cây cối: tre, trúc, tùng', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-22.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/dinh-lang-uoc-le-23.png', 'anh', 'Mây', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/dinh-lang-uoc-le-23.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-5.jpg', 'anh', 'Chụp thượng lương', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-5.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-6.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt đứng', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-6.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-7.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt bên', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-7.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-8.jpg', 'anh', 'Tam quan', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-8.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-9.jpg', 'anh', 'Tả vu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-9.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-10.jpg', 'anh', 'Hữu vu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-10.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-11.jpg', 'anh', 'Bia đá hữu vu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-11.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-12.jpg', 'anh', 'Bia đá tả vu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-12.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-13.jpg', 'anh', 'Hậu đường — Gác chuông', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-13.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-14.jpg', 'anh', 'Phía sau Hậu đường — Phía sau hậu đường', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-14.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-16.jpg', 'anh', 'Hình ảnh hiên — Hiên tiền đường', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-16.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-17.jpg', 'anh', 'Hiên tam quan', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-17.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-18.jpg', 'anh', 'Hiên gác chuông', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-18.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-19.jpg', 'anh', 'hiên thượng điện — Hiên thượng điện', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-19.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-20.jpg', 'anh', 'Nền hữu vu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-20.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-21.jpg', 'anh', 'Nền gác chuông', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-21.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-22.jpg', 'anh', 'Nền tả vu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-22.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-23.jpg', 'anh', 'Nền thượng điện', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-23.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-24.jpg', 'panorama', 'Ảnh trong nhà — Thượng điện,', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-24.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-25.jpg', 'anh', 'Ảnh trong nhà — Tả vu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-25.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-26.jpg', 'anh', 'Ảnh trong nhà — Hữu vu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-26.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-27.jpg', 'anh', 'Ảnh trong nhà — Tam quan', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-27.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-28.jpg', 'anh', 'Kết cấu ảnh — tổng thể bộ vì', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-28.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-29.jpg', 'anh', 'Kết cấu ảnh — vì nóc', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-29.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-30.jpg', 'anh', 'Kết cấu ảnh — vì nách', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-30.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-31.jpg', 'anh', 'Kết cấu ảnh — đầu dư', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-31.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-32.jpg', 'anh', 'Chân tảng ảnh — chân tảng thượng điện', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-32.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-33.png', 'anh', 'Chân tảng ảnh — chân tảng thượng điện', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-33.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-34.png', 'anh', 'Chân tảng hoa văn — Hoa văn chân tảng', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-34.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-35.png', 'anh', 'Chân tảng hoa văn — hoa văn chân tảng', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-35.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/chua-sung-phuc-36.png', 'anh', 'Chân tảng hoa văn — Chân tảng gác chuông', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Sùng Phúc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/chua-sung-phuc-36.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/uoc-le/sites/khu-lang-nghe-gio-cha-1.jpg', 'anh', 'Ảnh công nhận làng nghề', 'sites', (SELECT id FROM sites s WHERE s.name = 'Khu làng nghề giò chả' AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/uoc-le/sites/khu-lang-nghe-gio-cha-1.jpg');

-- ============================================================
-- cover_media_id cho sites — mỗi site nhận ảnh "-1" (ảnh đầu tiên xử lý cho
-- site đó) làm cover, đúng theo setCoverIfUnset của import-uoc-le-photos.ts
-- (chỉ set khi cover_media_id đang NULL, không ghi đè ảnh cover đã chọn tay).
-- ============================================================

UPDATE sites s
SET cover_media_id = m.id
FROM media m
WHERE m.owner_entity_type = 'sites'
  AND m.owner_entity_id = s.id
  AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le')
  AND s.cover_media_id IS NULL
  AND m.kind = 'anh'
  AND m.url ~ '^/uoc-le/sites/[a-z0-9-]+-1\.[a-z]+$';

-- ============================================================
-- panorama_media_id cho 2 site có ảnh 360 (Đình làng Ước Lễ, Chùa Sùng Phúc)
-- ============================================================

UPDATE sites s
SET panorama_media_id = m.id
FROM media m
WHERE m.owner_entity_type = 'sites'
  AND m.owner_entity_id = s.id
  AND s.village_id = (SELECT id FROM villages WHERE slug = 'lang-uoc-le')
  AND s.panorama_media_id IS NULL
  AND m.kind = 'panorama';
