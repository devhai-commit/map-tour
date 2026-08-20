-- Bổ sung ảnh làng Hạ Thái vào CSDL, chốt lại trạng thái đã ghi trực tiếp vào
-- CSDL đang chạy bởi map-tour/server/scripts/import-ha-thai-photos.ts (đọc
-- "Hạ Thái.xlsx" để tải ảnh Google Drive + lấy chú thích/owner cho từng ảnh)
-- — script này ghi thẳng vào CSDL đang chạy, KHÔNG qua migration SQL nào, nên
-- nếu khởi tạo lại CSDL từ init/ + migrations/ (vd. mất volume Docker) sẽ
-- thiếu toàn bộ các dòng media dưới đây. Cùng nguyên tắc với migrations/007,
-- 008, 013.
--
-- Khớp owner:
-- - sites: tham chiếu trực tiếp owner_entity_id (uuid cố định, giống hệt uuid
--   đã dùng trong migrations/014_add_ha_thai_sites.sql) thay vì khớp theo
--   s.name — vì tên site "Đường nhánh/ngõ" lặp lại 6 lần trong Hạ Thái (nhiều
--   ngõ khác nhau cùng tên chung), khớp theo tên sẽ không xác định được đúng
--   site.
-- - heritage_buildings: khớp theo tên công trình + village_id (đã kiểm tra
--   không có trùng tên công trình nào trong làng này).
-- - decorative_art_items: khớp theo tên công trình sở hữu + subject_name (đã
--   kiểm tra không có trùng subject_name trong cùng 1 công trình).
-- - craft_products: khớp theo tên sản phẩm + village_id.
--
-- Idempotent: mỗi INSERT có điều kiện NOT EXISTS theo đúng url, chạy lại
-- nhiều lần cho kết quả như nhau. Luôn `bash scripts/backup.sh` (hoặc
-- `pwsh scripts/backup.ps1`) trước khi áp dụng lên dữ liệu thật.

-- ============================================================
-- sites — ảnh thật từ Hạ Thái.xlsx
-- ============================================================

-- Ao
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/ao-e689ba8b-1.jpg', 'anh', NULL, NULL, 'sites', 'e689ba8b-cf6e-4826-a469-dfc732526f3b'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/ao-e689ba8b-1.jpg');

-- Chùa Duyên Trường
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/chua-duyen-truong-6e5fc28f-1.jpg', 'anh', NULL, NULL, 'sites', '6e5fc28f-9e4f-4290-8801-e97581ef232f'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/chua-duyen-truong-6e5fc28f-1.jpg');

-- Chùa Phúc Thái
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/chua-phuc-thai-f8687aff-1.jpg', 'anh', NULL, NULL, 'sites', 'f8687aff-58a8-4df9-bdb1-7fa8db6417d1'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/chua-phuc-thai-f8687aff-1.jpg');

-- Cây cổ thụ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/cay-co-thu-c28846f5-1.jpg', 'anh', NULL, NULL, 'sites', 'c28846f5-ea72-460b-aa45-d9c3d3bb15a6'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/cay-co-thu-c28846f5-1.jpg');

-- Cổng làng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/cong-lang-72157e2d-1.jpg', 'anh', NULL, NULL, 'sites', '72157e2d-8d22-4022-b4be-18e3b63f3e4f'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/cong-lang-72157e2d-1.jpg');

-- Cổng xóm Chu My
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/cong-xom-chu-my-4b9b87fb-1.jpg', 'anh', NULL, NULL, 'sites', '4b9b87fb-0c41-43b4-81a5-38678458a9db'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/cong-xom-chu-my-4b9b87fb-1.jpg');

-- Cổng xóm Mỹ Lộc
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/cong-xom-my-loc-6940e1f3-1.jpg', 'anh', NULL, NULL, 'sites', '6940e1f3-7220-4ad7-b51e-98b86692df7c'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/cong-xom-my-loc-6940e1f3-1.jpg');

-- Cổng Đình
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/cong-dinh-c2b27d51-1.jpg', 'anh', NULL, NULL, 'sites', 'c2b27d51-0c70-452a-b018-45cf6d7e9c56'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/cong-dinh-c2b27d51-1.jpg');

-- Giếng_Miếu Nghè
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/gieng-mieu-nghe-7ca23109-1.jpg', 'anh', NULL, NULL, 'sites', '7ca23109-cf2c-4020-97da-ba3c67033918'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/gieng-mieu-nghe-7ca23109-1.jpg');

-- Giếng_Miếu Trình
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/gieng-mieu-trinh-a2c635e8-1.jpg', 'anh', NULL, NULL, 'sites', 'a2c635e8-d3df-455e-bd55-f9aaa9e75507'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/gieng-mieu-trinh-a2c635e8-1.jpg');

-- Giếng_Đình Hạ Thái
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/gieng-dinh-ha-thai-9c831ce5-1.jpg', 'anh', NULL, NULL, 'sites', '9c831ce5-2e1e-4468-b09c-27ee3a032d5a'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/gieng-dinh-ha-thai-9c831ce5-1.jpg');

-- Kênh mương thủy lợi
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/kenh-muong-thuy-loi-5d6055d9-1.jpg', 'anh', NULL, NULL, 'sites', '5d6055d9-7ed7-4889-baf6-60b590360815'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/kenh-muong-thuy-loi-5d6055d9-1.jpg');

-- Miếu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/mieu-3b890288-1.jpg', 'anh', NULL, NULL, 'sites', '3b890288-8a15-4484-a53f-444775d8fd20'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/mieu-3b890288-1.jpg');

-- Miếu Nghè
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/mieu-nghe-0d0db01e-1.jpg', 'anh', NULL, NULL, 'sites', '0d0db01e-2bbf-4d28-a289-c9c2bdc9a3c7'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/mieu-nghe-0d0db01e-1.jpg');

-- Miếu Trình
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/mieu-trinh-60217152-1.jpg', 'anh', NULL, NULL, 'sites', '60217152-a88b-4f05-8ee9-593985d9fb23'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/mieu-trinh-60217152-1.jpg');

-- Nhà cổ bà Dịp
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/nha-co-ba-dip-cb162594-1.jpg', 'anh', NULL, NULL, 'sites', 'cb162594-8acc-419f-8e48-2ccf168f6288'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/nha-co-ba-dip-cb162594-1.jpg');

-- Nhà thờ họ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/nha-tho-ho-c7ed2238-1.jpg', 'anh', NULL, NULL, 'sites', 'c7ed2238-2c52-42ce-af48-c0dd241e6ef3'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/nha-tho-ho-c7ed2238-1.jpg');

-- Quán nước
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/quan-nuoc-b008170d-1.jpg', 'anh', NULL, NULL, 'sites', 'b008170d-a82b-4604-9220-5cc6f0f9e2a7'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/quan-nuoc-b008170d-1.jpg');

-- Sông Tô Lịch
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/song-to-lich-743a1c86-1.jpg', 'anh', NULL, NULL, 'sites', '743a1c86-b0f5-4d4b-a6d8-ed2fe6444edc'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/song-to-lich-743a1c86-1.jpg');

-- Văn chỉ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/van-chi-4182fd39-1.jpg', 'anh', NULL, NULL, 'sites', '4182fd39-6d5e-4a40-b050-4f141bc860a4'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/van-chi-4182fd39-1.jpg');

-- Đình - Không gian mở (ao, sông, đồng ruộng,…) - Cây đa/đề/si
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/dinh-khong-gian-mo-ao-song-dong-ruong-cay-da-de-si-2edf0cc8-1.jpg', 'anh', NULL, NULL, 'sites', '2edf0cc8-fdba-44ff-b83c-5aea246a11b9'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/dinh-khong-gian-mo-ao-song-dong-ruong-cay-da-de-si-2edf0cc8-1.jpg');

-- Đình làng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/dinh-lang-d813ed0d-1.jpg', 'anh', NULL, NULL, 'sites', 'd813ed0d-366c-4aff-b7b0-033dad2906d4'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/dinh-lang-d813ed0d-1.jpg');

-- Đường chính — Vạn Thọ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/duong-chinh-van-tho-297a57a6-1.jpg', 'anh', NULL, NULL, 'sites', '297a57a6-4bcc-40fd-8b3b-761f984ff0fd'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/duong-chinh-van-tho-297a57a6-1.jpg');

-- Đường chính — Đường Thái Bình
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/duong-chinh-duong-thai-binh-f27421bb-1.jpg', 'anh', NULL, NULL, 'sites', 'f27421bb-5b83-4c77-acdc-7d3c68f220af'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/duong-chinh-duong-thai-binh-f27421bb-1.jpg');

-- Đường chính — Đường Tràng Hạ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/duong-chinh-duong-trang-ha-50cc1810-1.jpg', 'anh', NULL, NULL, 'sites', '50cc1810-1a41-4d00-9bf6-d12465585123'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/duong-chinh-duong-trang-ha-50cc1810-1.jpg');

-- Đường nhánh/ngõ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/duong-nhanh-ngo-0556a156-1.jpg', 'anh', NULL, NULL, 'sites', '0556a156-a3e3-4d29-8885-91ac17dcecb9'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/duong-nhanh-ngo-0556a156-1.jpg');

-- Đường nhánh/ngõ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/duong-nhanh-ngo-0556a156-2.jpg', 'anh', NULL, NULL, 'sites', '0556a156-a3e3-4d29-8885-91ac17dcecb9'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/duong-nhanh-ngo-0556a156-2.jpg');

-- Đường nhánh/ngõ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/duong-nhanh-ngo-0556a156-3.jpg', 'anh', NULL, NULL, 'sites', '0556a156-a3e3-4d29-8885-91ac17dcecb9'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/duong-nhanh-ngo-0556a156-3.jpg');

-- Đường nhánh/ngõ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/duong-nhanh-ngo-0556a156-4.jpg', 'anh', NULL, NULL, 'sites', '0556a156-a3e3-4d29-8885-91ac17dcecb9'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/duong-nhanh-ngo-0556a156-4.jpg');

-- Đường nhánh/ngõ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/duong-nhanh-ngo-0556a156-5.jpg', 'anh', NULL, NULL, 'sites', '0556a156-a3e3-4d29-8885-91ac17dcecb9'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/duong-nhanh-ngo-0556a156-5.jpg');

-- Đường nhánh/ngõ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/sites/duong-nhanh-ngo-0556a156-6.jpg', 'anh', NULL, NULL, 'sites', '0556a156-a3e3-4d29-8885-91ac17dcecb9'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/sites/duong-nhanh-ngo-0556a156-6.jpg');

-- ============================================================
-- heritage_buildings — ảnh công trình kiến trúc từ Hạ Thái.xlsx
-- ============================================================

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-1.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 và ảnh chụp)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-10.jpg', 'anh', 'Mặt đứng công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-11.jpg', 'anh', 'Mặt bên công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-12.jpg', 'anh', 'Ảnh các góc chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-12.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-13.jpg', 'anh', 'Ảnh các góc chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-14.jpg', 'anh', 'Bờ nóc xây gạch hoa chanh, 2 đầu hồi có trang trí hoa văn đắp nổi, Diềm mái ngắt nước và đầu bảy khắc chữ Thọ vuông,', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-15.jpg', 'anh', 'Bờ nóc xây gạch hoa chanh, 2 đầu hồi có trang trí hoa văn đắp nổi, Diềm mái ngắt nước và đầu bảy khắc chữ Thọ vuông,', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-16.jpg', 'anh', 'Mái_vật liệu: Ngói nung, hình dạng ngói : loại ngói mũi hài', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-16.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-17.jpg', 'anh', 'Mái_cấu tạo: Mặt bằng mái hình chữ nhật với 2 mái dốc.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-17.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-18.jpg', 'anh', 'Hình ảnh hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-18.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-19.jpg', 'anh', 'Hình ảnh hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-19.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-2.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 và ảnh chụp)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-2.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-20.jpg', 'anh', 'Hình ảnh hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-20.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-21.jpg', 'anh', 'Nền (ảnh chụp): Nền sân, nền hiên, nền trong nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-21.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-22.jpg', 'anh', 'Nền (ảnh chụp): Nền sân, nền hiên, nền trong nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-22.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-23.jpg', 'anh', 'Nền (ảnh chụp): Nền sân, nền hiên, nền trong nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-23.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-24.pdf', 'ban_ve', 'Sơ đồ mặt bằng: Nhà có 5 gian — Bản vẽ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-24.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-25.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì: Bộ vì 4 hàng chân cột gỗ ( trốn 1 cột để lòng nhà rộng hơn) — Bản vẽ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-25.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-26.jpg', 'anh', 'Ảnh trong nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-26.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-27.jpg', 'anh', 'Ảnh trong nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-27.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-28.jpg', 'anh', '0-Vì các gian góc', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-28.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-29.jpg', 'anh', '0-Vì các gian góc', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-29.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-3.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 và ảnh chụp) — Bản vẽ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-3.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-30.jpg', 'anh', '0-Vì các gian góc', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-30.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-31.jpg', 'anh', '0-Vì các gian góc', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-31.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-32.jpg', 'anh', '1-Vì gian chính giữa:  Vì nóc kiểu Giá chiêng kết hợp kẻ ngồi, vì nách kiểu Kẻ ngồi. Trang trí đơn giản.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-32.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-33.jpg', 'anh', '1-Vì gian chính giữa:  Vì nóc kiểu Giá chiêng kết hợp kẻ ngồi, vì nách kiểu Kẻ ngồi. Trang trí đơn giản.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-33.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-34.jpg', 'anh', '1-Vì gian chính giữa:  Vì nóc kiểu Giá chiêng kết hợp kẻ ngồi, vì nách kiểu Kẻ ngồi. Trang trí đơn giản.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-34.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-35.jpg', 'anh', 'Câu đầu gian chính giữa và Thượng Lương', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-35.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-36.jpg', 'anh', '2-Vì gian 2 bên : Vì nóc kiểu Giá chiêng kết hợp chồng rường, vì nách kiểu Kẻ ngồi. Trang trí chạm nổi nhiều chi tiết.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-36.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-37.jpg', 'anh', '3-Vì gian biên: Vì gian biên làm đơn giản, không trang trí,  kiểu kẻ suốt (dầm xiên chạy hết các đầu cột)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-37.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-38.jpg', 'anh', 'Chân tảng ảnh', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-38.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-4.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 và ảnh chụp)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-5.pdf', 'ban_ve', 'Tổng mặt bằng: Bản vẽ TMB thể hiện các hạng mục thành phần của nhà. — Bản vẽ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-5.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-6.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-7.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-8.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/nha-co-afe0acd9-9.jpg', 'anh', 'Chụp thượng lương: Dịch dòng chữ Hán trên Thượng lương: " Vào ngày lành, giờ đẹp của tháng mùa đông, năm(bị mờ)... tiến hành dựng cột và cất nóc nhà, cầu mong muôn vàn điều tốt lành, đại cát đại lợi."', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/nha-co-afe0acd9-9.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-1.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 độ, các góc nhìn) — Ảnh 360', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-10.jpg', 'anh', 'Trụ Biểu 1: Trụ biểu mang phong cách thời Nguyễn', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-11.jpg', 'anh', 'Trụ Biểu 2: Trụ biểu mang phong cách thời Nguyễn', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-12.jpg', 'anh', 'Trụ biểu 3: Trụ biểu mang phong cách thời Nguyễn', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-12.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-13.jpg', 'anh', 'Tường bao: Tường bao xung quanh đình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-14.jpg', 'anh', 'Giếng làng: Giếng phía  trước đình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-15.jpg', 'anh', 'Bia đá: Bia đá đặt ở nhà bia giữa hồ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-16.jpg', 'anh', 'Mặt đứng: Đại đình có 5 gian và 2 chái. (Tổng là 7 gian)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-16.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-17.jpg', 'anh', 'Mặt bên: Mặt bên Đại đình có dạng đầu hồi bít đốc tức là mặt bên xây tường kín, không để hành lang.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-17.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-18.jpg', 'anh', 'Ảnh các góc chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-18.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-19.jpg', 'anh', 'Ảnh các góc chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-19.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-2.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 độ, các góc nhìn)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-2.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-20.jpg', 'anh', 'Bờ nóc trang trí hình song Long chầu mặt Nguyệt/ mặt Trời.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-20.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-21.jpg', 'anh', 'Đầu 2 bờ nóc trang trí 2 con Si vẫn. Si vẫn là con linh vật chống cháy trong công trình cổ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-21.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-22.jpg', 'anh', 'Vẽ chữ Thọ vuông (Thọ Triện) ở đầu Bẩy hiên.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-22.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-23.jpg', 'anh', 'Đắp nổi hình chim Phượng ở đầu hồi Đại đình, do Đình thờ vị nữ nhân thần, đây cũng là điểm đặc trưng của Đình thờ nữ thần.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-23.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-24.jpg', 'anh', 'Cửa sổ trang trí chữ Thọ vuông (Thọ Triện) ở 2 gian chái đình.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-24.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-25.jpg', 'anh', 'Mái_cấu tạo: Tuy đình có mặt bằng hình chữ Công nhưng mái của 3 khu vực đại Đình, ống muống, hậu cung tách rời, không nối liền sống mái với nhau.                                                            Đại Đình có 2 mái, kiểu đầu hồi bít đốc (đầu hồi xây tường kín). Hậu cung có 2 mái và đầu hồi bít đốc. Riêng mái  ống muống có kiểu 2 tầng mái nhỏ.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-25.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-26.jpg', 'anh', 'Mái_cấu tạo: Tuy đình có mặt bằng hình chữ Công nhưng mái của 3 khu vực đại Đình, ống muống, hậu cung tách rời, không nối liền sống mái với nhau.                                                            Đại Đình có 2 mái, kiểu đầu hồi bít đốc (đầu hồi xây tường kín). Hậu cung có 2 mái và đầu hồi bít đốc. Riêng mái  ống muống có kiểu 2 tầng mái nhỏ.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-26.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-27.jpg', 'anh', 'Mái_cấu tạo: Tuy đình có mặt bằng hình chữ Công nhưng mái của 3 khu vực đại Đình, ống muống, hậu cung tách rời, không nối liền sống mái với nhau.                                                            Đại Đình có 2 mái, kiểu đầu hồi bít đốc (đầu hồi xây tường kín). Hậu cung có 2 mái và đầu hồi bít đốc. Riêng mái  ống muống có kiểu 2 tầng mái nhỏ.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-27.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-28.jpg', 'anh', 'Mái_cấu tạo: Tuy đình có mặt bằng hình chữ Công nhưng mái của 3 khu vực đại Đình, ống muống, hậu cung tách rời, không nối liền sống mái với nhau.                                                            Đại Đình có 2 mái, kiểu đầu hồi bít đốc (đầu hồi xây tường kín). Hậu cung có 2 mái và đầu hồi bít đốc. Riêng mái  ống muống có kiểu 2 tầng mái nhỏ.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-28.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-29.jpg', 'anh', 'Mái_cấu tạo: Tuy đình có mặt bằng hình chữ Công nhưng mái của 3 khu vực đại Đình, ống muống, hậu cung tách rời, không nối liền sống mái với nhau.                                                            Đại Đình có 2 mái, kiểu đầu hồi bít đốc (đầu hồi xây tường kín). Hậu cung có 2 mái và đầu hồi bít đốc. Riêng mái  ống muống có kiểu 2 tầng mái nhỏ.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-29.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-3.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 độ, các góc nhìn)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-3.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-30.jpg', 'anh', 'Hình ảnh hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-30.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-31.jpg', 'anh', 'Hình ảnh hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-31.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-32.jpg', 'anh', 'Hình ảnh hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-32.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-33.jpg', 'anh', 'Nền (vật liệu): Lát gạch đỏ 30x30', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-33.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-34.jpg', 'anh', 'Nền (cách lát): Lát vuông, lát so le', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-34.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-35.jpg', 'anh', 'Nền (ảnh chụp)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-35.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-36.pdf', 'ban_ve', 'Sơ đồ mặt bằng: Đại đình có 7 gian, 1 gian ống muống nối với hậu cung. — Bản vẽ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-36.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-37.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì: Bộ vì có 4 hàng chân cột, không có cột hiên. — Bản vẽ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-37.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-38.jpg', 'panorama', 'Ảnh trong nhà: ảnh 360', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-38.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-39.jpg', 'panorama', 'Ảnh trong nhà: ảnh 360', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-39.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-4.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 độ, các góc nhìn)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-40.jpg', 'anh', 'Đại đình- Vì kèo các gian', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-40.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-41.jpg', 'anh', 'Vì nóc gian chính giữa  Đại đình: Tên gọi vì nóc Đại đình: Vì giá chiêng chồng rường con nhị. Vì được chạm hoa văn nổi đơn giản, thanh thoát.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-41.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-42.jpg', 'anh', 'Vì nách gian chính giữa  Đại đình: Vì nách gian chính giữa Đại đình: Tên gọi: Vì chồng rường, với các rường cụt. Các thanh rường được trang trí, chạm nổi, chạm lộng các hoa văn hình các con rồng dày đặc, các bờm tóc vuốt nhọn như hình mũi kiếm hay lưỡi thương rất đặc trưng của nghệ thuật thế kỷ 18.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-42.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-43.jpg', 'anh', 'Vì nách gian chính giữa  Đại đình: Vì nách gian chính giữa Đại đình: Tên gọi: Vì chồng rường, với các rường cụt. Các thanh rường được trang trí, chạm nổi, chạm lộng các hoa văn hình các con rồng dày đặc, các bờm tóc vuốt nhọn như hình mũi kiếm hay lưỡi thương rất đặc trưng của nghệ thuật thế kỷ 18.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-43.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-44.jpg', 'anh', 'Vì nóc gian biên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-44.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-45.jpg', 'anh', 'Vì gian Ống muống và Hậu cung: Vì gian ống muống và hậu cung làm rất đơn giản, không hoa văn.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-45.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-46.jpg', 'anh', 'Vì gian Ống muống và Hậu cung: Vì gian ống muống và hậu cung làm rất đơn giản, không hoa văn.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-46.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-47.jpg', 'anh', 'Vì gian Ống muống và Hậu cung: Vì gian ống muống và hậu cung làm rất đơn giản, không hoa văn.', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-47.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-48.jpg', 'anh', 'Gian Ống muống', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-48.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-49.jpg', 'anh', 'Chân tảng ảnh', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-49.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-5.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 độ, các góc nhìn)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-6.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 độ, các góc nhìn)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-7.jpg', 'panorama', 'Ảnh tổng thể từ cổng chính ( Ảnh 360 độ, các góc nhìn)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-8.pdf', 'ban_ve', 'Tổng mặt bằng (TMB): Bản vẽ TMB thể hiện các hạng mục thành phần của Đình. — Bản vẽ', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-8.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-9.jpg', 'anh', 'Nhà bia', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/heritage-buildings/dinh-ha-thai-con-co-ten-goi-la-dinh-ba-lay-09758e11-9.jpg');

-- ============================================================
-- decorative_art_items — ảnh hiện vật/mỹ thuật trang trí từ Hạ Thái.xlsx
-- ============================================================

-- Nhà cổ — Cửa Võng, Hoành phi : Vị trí: Gian thờ chính giữa nhà.
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/decorative/cua-vong-hoanh-phi-vi-tri-gian-tho-chinh-giua-nha-df0835cd-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà cổ' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'ha-thai') AND dai.subject_name = 'Cửa Võng, Hoành phi : Vị trí: Gian thờ chính giữa nhà.')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/decorative/cua-vong-hoanh-phi-vi-tri-gian-tho-chinh-giua-nha-df0835cd-1.jpg');

-- Nhà cổ — Trang trí thanh Câu đầu và Thượng lương, Quá giang
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/decorative/trang-tri-thanh-cau-dau-va-thuong-luong-qua-giang-7847b5e1-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà cổ' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'ha-thai') AND dai.subject_name = 'Trang trí thanh Câu đầu và Thượng lương, Quá giang')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/decorative/trang-tri-thanh-cau-dau-va-thuong-luong-qua-giang-7847b5e1-1.jpg');

-- Nhà cổ — Vì nóc gian biên:
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/decorative/vi-noc-gian-bien-bbd2f4b0-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà cổ' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'ha-thai') AND dai.subject_name = 'Vì nóc gian biên:')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/decorative/vi-noc-gian-bien-bbd2f4b0-1.jpg');

-- Đình Hạ Thái còn có tên gọi là Đình Bà Lạy — Linh vật: Phượng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/decorative/linh-vat-phuong-f181cdf3-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'ha-thai') AND dai.subject_name = 'Linh vật: Phượng')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/decorative/linh-vat-phuong-f181cdf3-1.jpg');

-- Đình Hạ Thái còn có tên gọi là Đình Bà Lạy — Linh vật: Rồng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/decorative/linh-vat-rong-1aa8e368-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'ha-thai') AND dai.subject_name = 'Linh vật: Rồng')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/decorative/linh-vat-rong-1aa8e368-1.jpg');

-- Đình Hạ Thái còn có tên gọi là Đình Bà Lạy — Linh vật: Rồng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/decorative/linh-vat-rong-1aa8e368-2.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'ha-thai') AND dai.subject_name = 'Linh vật: Rồng')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/decorative/linh-vat-rong-1aa8e368-2.jpg');

-- Đình Hạ Thái còn có tên gọi là Đình Bà Lạy — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc.
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-3911e738-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'ha-thai') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc.')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-3911e738-1.jpg');

-- Đình Hạ Thái còn có tên gọi là Đình Bà Lạy — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc.
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-3911e738-2.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'ha-thai') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc.')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-3911e738-2.jpg');

-- Đình Hạ Thái còn có tên gọi là Đình Bà Lạy — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc.
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-3911e738-3.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đình Hạ Thái còn có tên gọi là Đình Bà Lạy' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'ha-thai') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc.')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-3911e738-3.jpg');

-- ============================================================
-- craft_products — ảnh quy trình/sản phẩm nghề từ Hạ Thái.xlsx
-- ============================================================

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/craft-products/tranh-son-mai-cac-vat-dung-trang-tri-lo-hoa-dia-trung-bay-31f4e830-1.jpg', 'anh', 'Tranh khảm trứng đức phật', NULL, 'craft_products', (SELECT id FROM craft_products WHERE name = '- Tranh sơn mài
 - Các vật dụng trang trí: Lọ hoa, đĩa trưng bày' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/craft-products/tranh-son-mai-cac-vat-dung-trang-tri-lo-hoa-dia-trung-bay-31f4e830-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/craft-products/tranh-son-mai-cac-vat-dung-trang-tri-lo-hoa-dia-trung-bay-31f4e830-2.jpg', 'anh', 'Tranh sơn mài làng quê', NULL, 'craft_products', (SELECT id FROM craft_products WHERE name = '- Tranh sơn mài
 - Các vật dụng trang trí: Lọ hoa, đĩa trưng bày' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/craft-products/tranh-son-mai-cac-vat-dung-trang-tri-lo-hoa-dia-trung-bay-31f4e830-2.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/craft-products/tranh-son-mai-cac-vat-dung-trang-tri-lo-hoa-dia-trung-bay-van-dung-gia-dinh-43925cd7-1.jpg', 'anh', 'Tượng sơn mài', NULL, 'craft_products', (SELECT id FROM craft_products WHERE name = '- Tranh sơn mài
 - Các vật dụng trang trí: Lọ hoa, đĩa trưng bày
 - Vận dụng gia đình' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/craft-products/tranh-son-mai-cac-vat-dung-trang-tri-lo-hoa-dia-trung-bay-van-dung-gia-dinh-43925cd7-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/ha-thai/craft-products/tranh-son-mai-cac-vat-dung-trang-tri-lo-hoa-dia-trung-bay-van-dung-gia-dinh-43925cd7-2.jpg', 'anh', 'Đĩa trang chí phòng', NULL, 'craft_products', (SELECT id FROM craft_products WHERE name = '- Tranh sơn mài
 - Các vật dụng trang trí: Lọ hoa, đĩa trưng bày
 - Vận dụng gia đình' AND village_id = (SELECT id FROM villages WHERE slug = 'ha-thai'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/ha-thai/craft-products/tranh-son-mai-cac-vat-dung-trang-tri-lo-hoa-dia-trung-bay-van-dung-gia-dinh-43925cd7-2.jpg');
