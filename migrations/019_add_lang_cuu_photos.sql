-- Bổ sung ảnh làng Làng Cựu vào CSDL, chốt lại trạng thái đã ghi trực tiếp vào
-- CSDL đang chạy bởi map-tour/server/scripts/import-lang-cuu-photos.ts (đọc
-- "Lang Cuu.xlsx" để tải ảnh Google Drive + lấy chú thích/owner cho từng ảnh)
-- — script này ghi thẳng vào CSDL đang chạy, KHÔNG qua migration SQL nào, nên
-- nếu khởi tạo lại CSDL từ init/ + migrations/ (vd. mất volume Docker) sẽ
-- thiếu toàn bộ các dòng media dưới đây. Cùng nguyên tắc với migrations/007,
-- 008, 013, 018.
--
-- Khớp owner:
-- - sites: tham chiếu trực tiếp owner_entity_id (uuid cố định, giống hệt uuid
--   đã dùng trong migrations/015_add_lang_cuu_sites.sql).
-- - heritage_buildings: khớp theo tên công trình + village_id.
-- - decorative_art_items: khớp theo tên công trình sở hữu + subject_name.
-- - craft_products: khớp theo tên sản phẩm + village_id (2 sản phẩm cùng tên
--   gốc "Complet - Veston" đã được phân biệt bằng tên hộ kinh doanh ngay từ
--   lúc nhập dữ liệu văn bản, nên tên trong CSDL đã là duy nhất).
--
-- Idempotent: mỗi INSERT có điều kiện NOT EXISTS theo đúng url, chạy lại
-- nhiều lần cho kết quả như nhau. Luôn `bash scripts/backup.sh` (hoặc
-- `pwsh scripts/backup.ps1`) trước khi áp dụng lên dữ liệu thật.

-- ============================================================
-- sites — ảnh thật từ Làng Cựu.xlsx
-- ============================================================

-- Chùa
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/chua-2d807452-1.jpg', 'anh', NULL, NULL, 'sites', '2d807452-23ae-46f0-9d24-753bea18f1f1'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/chua-2d807452-1.jpg');

-- Cây cổ thụ giữa làng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/cay-co-thu-giua-lang-0b8904ea-1.jpg', 'anh', NULL, NULL, 'sites', '0b8904ea-3cca-4609-9d61-fdeb8c753881'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/cay-co-thu-giua-lang-0b8904ea-1.jpg');

-- Cây cổ thụ đầu làng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/cay-co-thu-dau-lang-2c84ff41-1.jpg', 'anh', NULL, NULL, 'sites', '2c84ff41-5bbe-4314-b600-a89f0735e9d0'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/cay-co-thu-dau-lang-2c84ff41-1.jpg');

-- Cổng làng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/cong-lang-889cf51e-1.jpg', 'anh', NULL, NULL, 'sites', '889cf51e-4283-401e-bef4-78bef4e0f992'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/cong-lang-889cf51e-1.jpg');

-- Nhà Tây
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/nha-tay-78ba5481-1.jpg', 'anh', NULL, NULL, 'sites', '78ba5481-fe5f-41a4-b64c-ca81e771ce53'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/nha-tay-78ba5481-1.jpg');

-- Nhà cổ bác tứ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/nha-co-bac-tu-6e4bdb96-1.jpg', 'anh', NULL, NULL, 'sites', '6e4bdb96-4631-4af9-80d2-ff2a3f29bf8c'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/nha-co-bac-tu-6e4bdb96-1.jpg');

-- Nhà thờ họ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/nha-tho-ho-1cc62aa3-1.jpg', 'anh', NULL, NULL, 'sites', '1cc62aa3-f869-4470-92fe-2a4d62c366a8'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/nha-tho-ho-1cc62aa3-1.jpg');

-- ao
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/ao-66cf0b99-1.jpg', 'anh', NULL, NULL, 'sites', '66cf0b99-c24b-447c-b3f4-7d2d2a506cb7'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/ao-66cf0b99-1.jpg');

-- giếng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/gieng-010f644d-1.png', 'anh', NULL, NULL, 'sites', '010f644d-0f9d-4977-b357-138f306501e2'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/gieng-010f644d-1.png');

-- Đình - Không gian mở (ao, sông, đồng ruộng,…) - Cây đa/đề/si
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/dinh-khong-gian-mo-ao-song-dong-ruong-cay-da-de-si-03111ee1-1.jpg', 'anh', NULL, NULL, 'sites', '03111ee1-5fca-41d0-888e-9bb7f58a31b2'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/dinh-khong-gian-mo-ao-song-dong-ruong-cay-da-de-si-03111ee1-1.jpg');

-- Đình làng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/dinh-lang-53fa7c45-1.jpg', 'anh', NULL, NULL, 'sites', '53fa7c45-dac2-49cc-a4c1-11f6a7db5c24'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/dinh-lang-53fa7c45-1.jpg');

-- Đường chính
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/duong-chinh-4c9de4f0-1.jpg', 'anh', NULL, NULL, 'sites', '4c9de4f0-3b78-4ad2-b856-a6b635f3514b'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/duong-chinh-4c9de4f0-1.jpg');

-- Đường gạch
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/duong-gach-7d904c2e-1.jpg', 'anh', NULL, NULL, 'sites', '7d904c2e-ee19-480f-a93a-62c2f2810b6a'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/duong-gach-7d904c2e-1.jpg');

-- Đường nhánh/ngõ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/duong-nhanh-ngo-b22e7458-1.jpg', 'anh', NULL, NULL, 'sites', 'b22e7458-33f4-46d7-a833-fa949d15fed0'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/duong-nhanh-ngo-b22e7458-1.jpg');

-- Đường nửa đá nửa gạch
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/duong-nua-da-nua-gach-aca31262-1.jpg', 'anh', NULL, NULL, 'sites', 'aca31262-bb0a-47ee-8543-b7b8003ead58'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/duong-nua-da-nua-gach-aca31262-1.jpg');

-- Đường đá
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/sites/duong-da-9b2adb32-1.jpg', 'anh', NULL, NULL, 'sites', '9b2adb32-b607-419d-a5c3-69894a2d5c66'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/sites/duong-da-9b2adb32-1.jpg');

-- ============================================================
-- heritage_buildings — ảnh công trình kiến trúc từ Làng Cựu.xlsx
-- ============================================================

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — ảnh từ cổng chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-10.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — ảnh đèn treo', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-11.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — ảnh cửa chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-12.jpg', 'anh', 'Mái_cấu tạo', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-12.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-13.jpg', 'anh', 'Hình ảnh hiên — ảnh ngoài nhìn vào hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-14.jpg', 'anh', 'Hình ảnh hiên — ảnh dọc hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-15.jpg', 'anh', 'Nền (ảnh chụp)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-16.pdf', 'ban_ve', 'Sơ đồ mặt bằng — sơ đồ mặt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-16.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-17.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — sơ đồ mặt cắt và bộ vi', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-17.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-18.jpg', 'panorama', 'Ảnh trong nhà — ảnh 360 trong nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-18.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-19.jpg', 'anh', 'Kết cấu ảnh', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-19.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-2.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — ảnh các công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-2.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-20.jpg', 'anh', 'Kết cấu ảnh', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-20.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-3.pdf', 'ban_ve', 'Tổng mặt bằng — tổng mặt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-3.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-4.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — ảnh·', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-5.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — ảnh·', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-6.jpg', 'anh', 'Chụp thượng lương — ảnh thượng lương', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-7.jpg', 'anh', 'Mặt đứng, mặt bên công trình — ảnh mặt đứng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-8.jpg', 'anh', 'Ảnh các góc chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tay-0b7290de-9.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — ảnh bàn thờ có các chi tiết đặc biệt', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà Tây' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tay-0b7290de-9.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-10.jpg', 'anh', 'Ảnh các góc chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-11.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-12.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-12.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-13.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-14.jpg', 'anh', 'Hình ảnh hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-15.jpg', 'anh', 'Nền (ảnh chụp)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-16.pdf', 'ban_ve', 'Sơ đồ mặt bằng — mặt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-16.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-17.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — sơ đồ mặt cắt và bộ vi', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-17.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-18.jpg', 'panorama', 'Ảnh trong nhà — ảnh 360 trong nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-18.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-19.jpg', 'anh', 'Kết cấu ảnh', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-19.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-2.pdf', 'ban_ve', 'Tổng mặt bằng — tổng mặt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-2.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-20.jpg', 'anh', 'Chân tảng ảnh', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-20.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-3.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — ảnh sân', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-3.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-4.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — ảnh chân tảng của cổng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-5.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — ảnh vòm cổng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-6.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — ảnh chi tiết hoa văn của cổng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-7.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có)', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-8.jpg', 'anh', 'Chụp thượng lương', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-9.jpg', 'anh', 'Mặt đứng, mặt bên công trình', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà bác Tứ' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-bac-tu-cb7c90d6-9.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-10.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — ảnh chi tiết đầu rồng được tái hiện lại trên mái nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-11.jpg', 'anh', 'Hình ảnh hiên — ảnh từ bên ngoài', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-12.jpg', 'anh', 'Hình ảnh hiên — ảnh từ trong ra', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-12.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-13.jpg', 'anh', 'Hình ảnh hiên — ảnh dọc theo hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-14.jpg', 'anh', 'Nền (ảnh chụp) — vật liệu bâc hiên', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-15.jpg', 'anh', 'Nền (ảnh chụp) — vật liệu nền trong nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-16.jpg', 'anh', 'Nền (ảnh chụp) — ảnh vật liệu nền sân', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-16.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-17.pdf', 'ban_ve', 'Sơ đồ mặt bằng — sơ đồ mặt bằng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-17.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-18.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — sơ đồ mặt cắt và bộ vi', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-18.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-19.jpg', 'panorama', 'Ảnh trong nhà — ảnh 360 trong nhà', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-19.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-2.jpg', 'anh', 'Ảnh tổng thể từ cổng chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-2.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-20.jpg', 'anh', 'Kết cấu ảnh — ảnh kết cấu', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-20.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-21.jpg', 'anh', 'Kết cấu ảnh', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-21.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-22.jpg', 'anh', 'Kết cấu ảnh', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-22.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-23.jpg', 'anh', 'Kết cấu ảnh', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-23.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-24.jpg', 'anh', 'Chân tảng ảnh — Chân tảng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-24.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-3.jpg', 'anh', 'Ảnh tổng thể từ cổng chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-3.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-4.pdf', 'ban_ve', 'Tổng mặt bằng — TMB', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-4.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-5.jpg', 'anh', 'Chụp thượng lương — ảnh thượng lương', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-6.jpg', 'anh', 'Mặt đứng, mặt bên công trình — ảnh mặt đứng', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-7.jpg', 'anh', 'Ảnh các góc chính', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-8.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-9.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — ảnh hoạt cảnh đời sống con người được tái hiện lại', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà thờ họ Trần' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/heritage-buildings/nha-tho-ho-tran-715f4f9c-9.jpg');

-- ============================================================
-- decorative_art_items — ảnh hiện vật/mỹ thuật trang trí từ Làng Cựu.xlsx
-- ============================================================

-- Nhà Tây — Linh vật: Rồng, Phượng, Lân, Long mã, nghê, rùa,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-89ae3295-1.jpg', 'anh', 'ảnh chi tiết bàn thờ tự có các linh vật', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà Tây' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Linh vật: Rồng, Phượng, Lân, Long mã, nghê, rùa,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-89ae3295-1.jpg');

-- Nhà Tây — Mây
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/may-8da829fe-1.jpg', 'anh', 'ảnh chi tiết mây quấn rồng', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà Tây' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Mây')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/may-8da829fe-1.jpg');

-- Nhà Tây — Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-998509e2-1.jpg', 'anh', 'ảnh chụp chi tiét cổng chính ( cây mai)', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà Tây' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-998509e2-1.jpg');

-- Nhà Tây — Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-998509e2-2.jpg', 'anh', 'ảnh hoa sen trên bàn thờ tự', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà Tây' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-998509e2-2.jpg');

-- Nhà Tây — Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-998509e2-3.jpg', 'anh', 'ảnh hoa hồng ở sạp cúng bái', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà Tây' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-998509e2-3.jpg');

-- Nhà Tây — Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-998509e2-4.jpg', 'anh', 'ảnh đầy đủ của bàn thờ có các chi tiết cây', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà Tây' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-998509e2-4.jpg');

-- Nhà bác Tứ — Linh vật: Rồng, Phượng, Lân, Long mã, nghê, rùa,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-eb186d6a-1.jpg', 'anh', 'ảnh thờ tự có các linh vật', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà bác Tứ' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Linh vật: Rồng, Phượng, Lân, Long mã, nghê, rùa,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-eb186d6a-1.jpg');

-- Nhà bác Tứ — Long quấn thủy
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/long-quan-thuy-a469e054-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà bác Tứ' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Long quấn thủy')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/long-quan-thuy-a469e054-1.jpg');

-- Nhà bác Tứ — Mây
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/may-5895fd7a-1.jpg', 'anh', 'https://drive.google.com/file/d/1eSSJfynlQtkjeCxoIO_H3_Q4CmlCXDZx/view?usp=sharing', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà bác Tứ' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Mây')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/may-5895fd7a-1.jpg');

-- Nhà bác Tứ — Đề tài cây cối: tre, trúc, tùng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/de-tai-cay-coi-tre-truc-tung-c1aa233e-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà bác Tứ' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đề tài cây cối: tre, trúc, tùng')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/de-tai-cay-coi-tre-truc-tung-c1aa233e-1.jpg');

-- Nhà bác Tứ — Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-a1834ac4-1.jpg', 'anh', 'https://drive.google.com/file/d/1MOE1u5R_TBm8fkfyf0Xm4-LutUL3eWJY/view?usp=sharing', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà bác Tứ' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-a1834ac4-1.jpg');

-- Nhà thờ họ Trần — Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-73a8a9eb-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-73a8a9eb-1.jpg');

-- Nhà thờ họ Trần — Mây
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/may-572dfdd0-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Mây')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/may-572dfdd0-1.jpg');

-- Nhà thờ họ Trần — Đề tài cây cối: tre, trúc, tùng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/de-tai-cay-coi-tre-truc-tung-a08b9c2e-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đề tài cây cối: tre, trúc, tùng')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/de-tai-cay-coi-tre-truc-tung-a08b9c2e-1.jpg');

-- Nhà thờ họ Trần — Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-1b708e56-1.jpg', 'anh', NULL, NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-1b708e56-1.jpg');

-- Nhà thờ họ Trần — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1136edae-1.jpg', 'anh', 'ảnh hoành phi', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1136edae-1.jpg');

-- Nhà thờ họ Trần — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1136edae-2.jpg', 'anh', 'ảnh cửa võng', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1136edae-2.jpg');

-- Nhà thờ họ Trần — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1136edae-3.jpg', 'anh', 'ảnh y môn', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1136edae-3.jpg');

-- Nhà thờ họ Trần — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1136edae-4.jpg', 'anh', 'ảnh câu đối', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1136edae-4.jpg');

-- Nhà thờ họ Trần — Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-d2cd2f6b-1.jpg', 'anh', 'ảnh y môn', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-d2cd2f6b-1.jpg');

-- Nhà thờ họ Trần — Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-d2cd2f6b-2.jpg', 'anh', 'ảnh đỉnh đồng', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-d2cd2f6b-2.jpg');

-- Nhà thờ họ Trần — Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-d2cd2f6b-3.jpg', 'anh', 'ảnh chân nến', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-d2cd2f6b-3.jpg');

-- Nhà thờ họ Trần — Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-d2cd2f6b-4.jpg', 'anh', 'ảnh hạc chầu', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-d2cd2f6b-4.jpg');

-- Nhà thờ họ Trần — Đồ tự khí: hương án, khám, ngai, bài vị
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-4ba9cfb4-1.jpg', 'anh', 'ảnh ngai', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Nhà thờ họ Trần' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu') AND dai.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-4ba9cfb4-1.jpg');

-- ============================================================
-- craft_products — ảnh quy trình/sản phẩm nghề từ Làng Cựu.xlsx
-- ============================================================

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/craft-products/complet-veston-doanh-nghiep-may-complet-veston-d-t-e9ad7af3-1.jpg', 'anh', NULL, NULL, 'craft_products', (SELECT id FROM craft_products WHERE name = 'Complet - Veston — Doanh nghiệp may Complet veston D&T' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/craft-products/complet-veston-doanh-nghiep-may-complet-veston-d-t-e9ad7af3-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/lang-cuu/craft-products/complet-veston-hung-luyen-comple-veston-78223b9d-1.jpg', 'anh', NULL, NULL, 'craft_products', (SELECT id FROM craft_products WHERE name = 'Complet - Veston — Hùng Luyến Comple Veston' AND village_id = (SELECT id FROM villages WHERE slug = 'lang-cuu'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/lang-cuu/craft-products/complet-veston-hung-luyen-comple-veston-78223b9d-1.jpg');
