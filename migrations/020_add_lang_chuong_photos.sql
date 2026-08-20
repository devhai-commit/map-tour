-- Bổ sung ảnh làng Chuông vào CSDL, chốt lại trạng thái đã ghi trực tiếp vào
-- CSDL đang chạy bởi map-tour/server/scripts/import-lang-chuong-photos.ts
-- (đọc "Làng Chuông.xlsx" để tải ảnh Google Drive + lấy chú thích/owner cho
-- từng ảnh) — script này ghi thẳng vào CSDL đang chạy, KHÔNG qua migration
-- SQL nào, nên nếu khởi tạo lại CSDL từ init/ + migrations/ (vd. mất volume
-- Docker) sẽ thiếu toàn bộ các dòng media dưới đây. Cùng nguyên tắc với
-- migrations/007, 008, 013, 018.
--
-- Khớp owner:
-- - sites: tham chiếu trực tiếp owner_entity_id (uuid cố định, giống hệt uuid
--   đã dùng trong migrations/016_add_lang_chuong_sites.sql).
-- - heritage_buildings: khớp theo tên công trình + village_id.
-- - decorative_art_items: khớp theo tên công trình sở hữu + subject_name.
-- - Làng Chuông không có ảnh craft_products (2 sheet sản phẩm nghề chỉ có
--   dữ liệu văn bản, không có link ảnh Google Drive).
--
-- Idempotent: mỗi INSERT có điều kiện NOT EXISTS theo đúng url, chạy lại
-- nhiều lần cho kết quả như nhau. Luôn `bash scripts/backup.sh` (hoặc
-- `pwsh scripts/backup.ps1`) trước khi áp dụng lên dữ liệu thật.

-- ============================================================
-- sites — ảnh thật từ Làng Chuông.xlsx
-- ============================================================

-- Chùa
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/chua-225152ae-1.jpg', 'anh', NULL, NULL, 'sites', '225152ae-cf96-485a-8fb4-5956bbd9bcff'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/chua-225152ae-1.jpg');

-- Chợ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/cho-5e1d7cfb-1.jpg', 'anh', NULL, NULL, 'sites', '5e1d7cfb-ad82-4bc9-99ab-dee66e8f0911'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/cho-5e1d7cfb-1.jpg');

-- Chợ - Chùa
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/cho-chua-8322ba72-1.jpg', 'anh', NULL, NULL, 'sites', '8322ba72-4b66-4d0d-911b-61ea10332a97'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/cho-chua-8322ba72-1.jpg');

-- Cổng làng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/cong-lang-bffd491e-1.jpg', 'anh', NULL, NULL, 'sites', 'bffd491e-5b22-49d1-b77b-377edd25664a'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/cong-lang-bffd491e-1.jpg');

-- Giếng - sân - miếu/ban thờ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/gieng-san-mieu-ban-tho-9ec04fb9-1.jpg', 'anh', NULL, NULL, 'sites', '9ec04fb9-9aef-4c12-9f47-bfc19872c0b2'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/gieng-san-mieu-ban-tho-9ec04fb9-1.jpg');

-- Giếng chùa Chuông
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/gieng-chua-chuong-fafa82e9-1.jpg', 'anh', NULL, NULL, 'sites', 'fafa82e9-5d72-42aa-a059-1cdcce1ba4ea'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/gieng-chua-chuong-fafa82e9-1.jpg');

-- Giếng xóm 8 Trung Khu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/gieng-xom-8-trung-khu-106ce802-1.jpg', 'anh', NULL, NULL, 'sites', '106ce802-8e72-434c-9868-3d31349edf42'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/gieng-xom-8-trung-khu-106ce802-1.jpg');

-- Giếng đền Ông
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/gieng-den-ong-de1a0d7d-1.jpg', 'anh', NULL, NULL, 'sites', 'de1a0d7d-37f8-4134-b172-1a739c3fa419'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/gieng-den-ong-de1a0d7d-1.jpg');

-- Lũy tre
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/luy-tre-67a60076-1.jpg', 'anh', NULL, NULL, 'sites', '67a60076-5af3-4f6c-89d8-69e21342b36d'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/luy-tre-67a60076-1.jpg');

-- Nhà cổ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/nha-co-5ebaa055-1.jpg', 'anh', NULL, NULL, 'sites', '5ebaa055-99e0-4897-97c3-0170cbb6d381'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/nha-co-5ebaa055-1.jpg');

-- Nhà thờ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/nha-tho-78cb2d2e-1.jpg', 'anh', NULL, NULL, 'sites', '78cb2d2e-69b3-42f3-8b28-5c5b9031961f'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/nha-tho-78cb2d2e-1.jpg');

-- Nhà thờ họ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/nha-tho-ho-50800f73-1.jpg', 'anh', NULL, NULL, 'sites', '50800f73-2fe4-483f-8b4a-4177688cd00a'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/nha-tho-ho-50800f73-1.jpg');

-- Sông
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/song-d198a4db-1.jpg', 'anh', NULL, NULL, 'sites', 'd198a4db-d65d-4136-88d7-fe4692f03199'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/song-d198a4db-1.jpg');

-- Văn chỉ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/van-chi-1c2471bb-1.jpg', 'anh', NULL, NULL, 'sites', '1c2471bb-ae76-43fa-a3bf-97fdd76e5ce4'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/van-chi-1c2471bb-1.jpg');

-- Điếm Ngõa Kiều
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/diem-ngoa-kieu-05777db9-1.jpg', 'anh', NULL, NULL, 'sites', '05777db9-c92b-4da6-9f66-2833674f6ad5'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/diem-ngoa-kieu-05777db9-1.jpg');

-- Điếm xóm 2 thôn Liên Tân
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/diem-xom-2-thon-lien-tan-d30f9f94-1.jpg', 'anh', NULL, NULL, 'sites', 'd30f9f94-feed-4c29-9d7d-9eae85b19a33'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/diem-xom-2-thon-lien-tan-d30f9f94-1.jpg');

-- Đình - Không gian mở (ao, sông, đồng ruộng,…) - Cây đa/đề/si
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/dinh-khong-gian-mo-ao-song-dong-ruong-cay-da-de-si-15d48e54-1.jpg', 'anh', NULL, NULL, 'sites', '15d48e54-3790-4900-9e87-df730349392f'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/dinh-khong-gian-mo-ao-song-dong-ruong-cay-da-de-si-15d48e54-1.jpg');

-- Đình làng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/dinh-lang-b052b7f7-1.jpg', 'anh', NULL, NULL, 'sites', 'b052b7f7-f771-4f18-8457-f4acc92c9b8d'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/dinh-lang-b052b7f7-1.jpg');

-- Đường chính
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/duong-chinh-1d8169b9-1.jpg', 'anh', NULL, NULL, 'sites', '1d8169b9-ba0f-4f00-b00a-eee0a512c7ad'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/duong-chinh-1d8169b9-1.jpg');

-- Đường nhánh/ngõ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/duong-nhanh-ngo-d5b7ab2f-1.jpg', 'anh', NULL, NULL, 'sites', 'd5b7ab2f-ca77-44f3-abfc-bbf37260bc50'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/duong-nhanh-ngo-d5b7ab2f-1.jpg');

-- Đường theo vật liệu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/duong-theo-vat-lieu-495a71f9-1.jpg', 'anh', NULL, NULL, 'sites', '495a71f9-99a3-418f-98ad-eff84975c53f'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/duong-theo-vat-lieu-495a71f9-1.jpg');

-- Đất nông nghiệp
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/dat-nong-nghiep-616bf014-1.jpg', 'anh', NULL, NULL, 'sites', '616bf014-5516-44ce-80c3-7d52190f1da3'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/dat-nong-nghiep-616bf014-1.jpg');

-- Đền Quán Trung
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/den-quan-trung-e39832de-1.jpg', 'anh', NULL, NULL, 'sites', 'e39832de-c992-4295-b9e4-302aff37cbca'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/den-quan-trung-e39832de-1.jpg');

-- Đền Thượng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/den-thuong-60353b9d-1.jpg', 'anh', NULL, NULL, 'sites', '60353b9d-c4e4-4d1e-a186-5b75ba80984a'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/den-thuong-60353b9d-1.jpg');

-- Đền Ông
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/sites/den-ong-ceb78e41-1.jpg', 'anh', NULL, NULL, 'sites', 'ceb78e41-82e6-4d87-8155-7ea70ec1a83e'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/sites/den-ong-ceb78e41-1.jpg');

-- ============================================================
-- heritage_buildings — ảnh công trình kiến trúc từ Làng Chuông.xlsx
-- ============================================================

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — ảnh chụp chính diện công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-10.jpg', 'anh', 'Nền (ảnh chụp) — ảnh nền', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-11.pdf', 'ban_ve', 'Sơ đồ mặt bằng — sơ đồ mặt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-11.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-12.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — sơ đồ mặt cắt và bộ vì kèo', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-12.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-13.jpg', 'anh', 'Kết cấu ảnh — ảnh vì kèo', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-14.jpg', 'anh', 'Chân tảng ảnh — ảnh chân tảng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-2.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — ảnh chụp phối cảnh góc công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-2.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-3.pdf', 'ban_ve', 'Tổng mặt bằng — ảnh tổng mặt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-3.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-4.jpg', 'anh', 'Chụp thượng lương — ảnh chụp thượng lương', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-5.jpg', 'panorama', 'Ảnh các góc chính — ảnh chụp 360 khuôn viên công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-6.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — ảnh chụp chi tiết đầu hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-7.jpg', 'anh', 'Mái_cấu tạo — ảnh chính diện mái', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-8.jpg', 'anh', 'Mái_cấu tạo — ảnh tổng thể mái', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-9.jpg', 'anh', 'Hình ảnh hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Lê Văn Trường' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/nha-ong-le-van-truong-d1ca37e2-9.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — ảnh tổng thể cổng chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-10.jpg', 'anh', 'Nền (ảnh chụp) — ảnh chụp nền công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-11.pdf', 'ban_ve', 'Sơ đồ mặt bằng — sơ đồ mặt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-11.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-12.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — sơ đồ mặt cắt và vì kèo', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-12.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-13.jpg', 'anh', 'Kết cấu tính chất', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-2.pdf', 'ban_ve', 'Tổng mặt bằng — ảnh tổng mặt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-2.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-4.jpg', 'anh', 'Mặt đứng, mặt bên công trình — ảnh chụp công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-5.jpg', 'anh', 'Mặt đứng, mặt bên công trình — ảnh chụp chính diện công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-6.jpg', 'panorama', 'Ảnh các góc chính — ảnh 360 chính diện khuôn viên công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-7.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — ảnh chụp chi tiết đầu đao', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-8.jpg', 'anh', 'Mái_vật liệu — ảnh chụp chính diện cấu tạo mái', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-9.jpg', 'anh', 'Hình ảnh hiên — ảnh hiên công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đền Thượng' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/den-thuong-a5d82e99-9.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — ảnh tổng thể', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-10.jpg', 'anh', 'hình ảnh hiên — ảnh dọc theo hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-11.jpg', 'anh', 'Nền (ảnh chụp) — ảnh chụp nền', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-12.pdf', 'ban_ve', 'Sơ đồ mặt bằng — măt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-12.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-13.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — mặt cắt', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-13.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-14.jpg', 'panorama', 'Ảnh trong nhà — ảnh 360 trong nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-15.jpg', 'anh', 'Kết cấu ảnh — ảnh vì kèo mái', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-16.jpg', 'anh', 'Kết cấu ảnh — ảnh chụp cận vì kèo', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-16.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-17.jpg', 'anh', 'Chân tảng ảnh — ảnh chân tảng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-17.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-2.pdf', 'ban_ve', 'Tổng mặt bằng — ảnh tổng mặt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-2.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-3.jpg', 'panorama', 'Ảnh chụp đối tượng phụ trợ (nếu có) — ảnh 360', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-3.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-4.jpg', 'anh', 'Cảm nhận của người quan sát về không gian khuôn viên — ảnh khuôn viên đình làng chuông', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-5.jpg', 'anh', 'Mặt đứng, mặt bên công trình — ảnh chụp mặt đứng công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-6.jpg', 'panorama', 'Ảnh các góc chính — ảnh 360 khuôn viên công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-7.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — chi tiết đầu đao', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-8.jpg', 'anh', 'Mái_cấu tạo — ảnh chụp mái công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-9.jpg', 'anh', 'hình ảnh hiên — ảnh từ trong ra', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'đình làng chuông' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/heritage-buildings/dinh-lang-chuong-da2779ab-9.jpg');

-- ============================================================
-- decorative_art_items — ảnh hiện vật/mỹ thuật trang trí từ Làng Chuông.xlsx
-- ============================================================

-- nhà ông Lê Văn Trường — Linh vật: Rồng, Phượng, Lân, Long mã, nghê, rùa,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-5db2dd96-1.jpg', 'anh', 'ảnh rồng được điêu khắc trên hương án', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'nhà ông Lê Văn Trường' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Linh vật: Rồng, Phượng, Lân, Long mã, nghê, rùa,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-5db2dd96-1.jpg');

-- nhà ông Lê Văn Trường — Mây
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/may-fa43f669-1.jpg', 'anh', 'ảnh mây điêu khắc trên gỗ', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'nhà ông Lê Văn Trường' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Mây')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/may-fa43f669-1.jpg');

-- nhà ông Lê Văn Trường — Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-40e6e4fa-1.jpg', 'anh', 'ảnh ngũ quả được điêu khắc ở vì kèo hiên', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'nhà ông Lê Văn Trường' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-40e6e4fa-1.jpg');

-- nhà ông Lê Văn Trường — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-7f877366-1.jpg', 'anh', 'ảnh chụp câu đối', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'nhà ông Lê Văn Trường' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-7f877366-1.jpg');

-- nhà ông Lê Văn Trường — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-7f877366-2.jpg', 'anh', 'ảnh chụp câu đối', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'nhà ông Lê Văn Trường' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-7f877366-2.jpg');

-- nhà ông Lê Văn Trường — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-7f877366-3.jpg', 'anh', 'ảnh chụp hoành phi', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'nhà ông Lê Văn Trường' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-7f877366-3.jpg');

-- nhà ông Lê Văn Trường — Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-df378ea3-1.jpg', 'anh', 'ảnh chụp tổng thể đồ thờ tự', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'nhà ông Lê Văn Trường' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-df378ea3-1.jpg');

-- nhà ông Lê Văn Trường — Đồ tự khí: hương án, khám, ngai, bài vị
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-21b41f67-1.jpg', 'anh', 'ảnh chụp hương án', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'nhà ông Lê Văn Trường' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-21b41f67-1.jpg');

-- Đền Thượng — Biểu tượng thiêng và Biểu tượng tôn giáo
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/bieu-tuong-thieng-va-bieu-tuong-ton-giao-e9897981-1.jpg', 'anh', 'ảnh bà voi', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đền Thượng' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Biểu tượng thiêng và Biểu tượng tôn giáo')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/bieu-tuong-thieng-va-bieu-tuong-ton-giao-e9897981-1.jpg');

-- Đền Thượng — Biểu tượng thiêng và Biểu tượng tôn giáo
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/bieu-tuong-thieng-va-bieu-tuong-ton-giao-e9897981-2.jpg', 'anh', 'ảnh ông voi', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đền Thượng' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Biểu tượng thiêng và Biểu tượng tôn giáo')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/bieu-tuong-thieng-va-bieu-tuong-ton-giao-e9897981-2.jpg');

-- Đền Thượng — Long quấn thủy
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/long-quan-thuy-f44d00fc-1.jpg', 'anh', 'ảnh rồng quấn mây', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đền Thượng' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Long quấn thủy')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/long-quan-thuy-f44d00fc-1.jpg');

-- Đền Thượng — Mây
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/may-f54776cb-1.jpg', 'anh', 'ảnh mây được khắc họa trên tường', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đền Thượng' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Mây')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/may-f54776cb-1.jpg');

-- Đền Thượng — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-8a60c130-1.jpg', 'anh', 'ảnh câu đối', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đền Thượng' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-8a60c130-1.jpg');

-- Đền Thượng — Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-face3097-1.jpg', 'anh', 'ảnh bát hương, đài', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đền Thượng' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-face3097-1.jpg');

-- Đền Thượng — Đồ tự khí: hương án, khám, ngai, bài vị
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-8addac9f-1.jpg', 'anh', 'ảnh hương án', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đền Thượng' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-8addac9f-1.jpg');

-- đình làng chuông — Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-5856bdb6-1.jpg', 'anh', 'ảnh ngựa được chmja khắc trên tường', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'đình làng chuông' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-5856bdb6-1.jpg');

-- đình làng chuông — Mây
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/may-867183ee-1.jpg', 'anh', 'ảnh chụp điêu khắc mây', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'đình làng chuông' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Mây')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/may-867183ee-1.jpg');

-- đình làng chuông — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1ab4ca76-1.jpg', 'anh', 'ảnh chụp cửa võng', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'đình làng chuông' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1ab4ca76-1.jpg');

-- đình làng chuông — Đồ tự khí: hương án, khám, ngai, bài vị
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-chuong/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-b4b7be4f-1.jpg', 'anh', 'ảnh chụp bài vị', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'đình làng chuông' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-chuong') AND dai.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-chuong/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-b4b7be4f-1.jpg');
