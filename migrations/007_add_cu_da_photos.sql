-- Thêm 168 bản ghi media cho toàn bộ ảnh/bản vẽ đã tải về
-- map-tour/public/cu-da/ (villages/, sites/, heritage-buildings/,
-- decorative/, craft-products/) — dữ liệu này trước đó được ghi trực tiếp
-- vào CSDL đang chạy bởi map-tour/server/scripts/import-cu-da-photos.ts
-- (đọc "Làng Cự Đà.xlsx" để lấy chú thích + đối tượng sở hữu cho từng ảnh),
-- KHÔNG qua migration SQL nào — nên nếu khởi tạo lại CSDL từ init/ +
-- migrations/ (vd. mất volume Docker) sẽ thiếu toàn bộ các dòng media này.
-- Migration này chốt lại đúng trạng thái đã ghi bởi script trên thành SQL,
-- để việc khởi tạo lại CSDL từ đầu tái tạo được đầy đủ dữ liệu ảnh.
--
-- Khớp owner theo tên/nhãn (không hardcode uuid, vì villages/heritage_buildings/
-- decorative_art_items/craft_products dùng gen_random_uuid() nên id thật sẽ
-- khác nhau giữa các lần khởi tạo) — cùng nguyên tắc với migrations/001,
-- migrations/002, migrations/006. Riêng decorative_art_items có nhiều dòng
-- trùng subject_name giữa các công trình khác nhau (vd. "Đồ tế khí..." vừa có
-- ở đình vừa có ở chùa) nên khớp thêm theo heritage_buildings.name của công
-- trình cha (qua building_id) để không bị nhầm ảnh giữa 2 công trình.
--
-- Idempotent: mỗi INSERT có điều kiện NOT EXISTS theo đúng url (giữ nguyên
-- url tương đối đã lưu, vd. '/cu-da/sites/duong-chinh-21000000-1.jpg'), chạy
-- lại nhiều lần cho kết quả như nhau. Nếu village/site/heritage_building/
-- decorative_art_item/craft_product tương ứng chưa tồn tại (vd. chạy migration
-- này trước khi Admin Import xong sheet đó), SELECT owner sẽ trả NULL và
-- INSERT sẽ báo lỗi NOT NULL violation trên owner_entity_id — chạy lại sau
-- khi đã import đủ dữ liệu văn bản. Luôn `bash scripts/backup.sh` (hoặc
-- `pwsh scripts/backup.ps1`) trước khi áp dụng lên dữ liệu thật.

-- ============================================================
-- villages
-- ============================================================

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/villages/cu-da-b3199521-1.jpg', 'anh', 'Tổng mặt bằng làng Cự Đà', 'villages', (SELECT id FROM villages WHERE name = 'Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/villages/cu-da-b3199521-1.jpg');

-- ============================================================
-- sites
-- ============================================================

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/chua-cu-da-21000000-1.jpg', 'anh', 'Chùa Cự Đà', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Cự Đà' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/chua-cu-da-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/chua-cu-da-21000000-2.jpg', 'anh', 'chùa và miếu không có sông bên cạnh', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Cự Đà' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/chua-cu-da-21000000-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/chua-cu-da-21000000-3.jpg', 'anh', 'chùa Cự Đà', 'sites', (SELECT id FROM sites s WHERE s.name = 'Chùa Cự Đà' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/chua-cu-da-21000000-3.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/cay-nhan-2-21000000-1.jpg', 'anh', 'Cây', 'sites', (SELECT id FROM sites s WHERE s.name = 'Cây Nhãn 2' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/cay-nhan-2-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/cay-muom-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Cây muỗm' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/cay-muom-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/cay-nhan-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Cây nhãn' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/cay-nhan-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/cong-lang-cu-da-21000000-1.jpg', 'anh', 'Cổng Giữa', 'sites', (SELECT id FROM sites s WHERE s.name = 'Cổng làng Cự Đà' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/cong-lang-cu-da-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/cong-lang-cu-da-21000000-2.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Cổng làng Cự Đà' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/cong-lang-cu-da-21000000-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/cong-xom-duong-lang-nha-co-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Cổng xóm - đường làng - nhà cổ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/cong-xom-duong-lang-nha-co-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/cong-xom-hieu-de-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Cổng xóm Hiếu Đễ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/cong-xom-hieu-de-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/cong-xom-quang-trung-21000000-1.jpg', 'anh', 'Cổng Xóm Quang Trung', 'sites', (SELECT id FROM sites s WHERE s.name = 'Cổng xóm Quang Trung' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/cong-xom-quang-trung-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/cot-co-21000000-1.jpg', 'anh', 'cột cờ', 'sites', (SELECT id FROM sites s WHERE s.name = 'Cột cờ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/cot-co-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/gieng-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Giếng' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/gieng-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/mieu-cu-da-21000000-1.jpg', 'anh', 'miếu', 'sites', (SELECT id FROM sites s WHERE s.name = 'Miếu Cự Đà' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/mieu-cu-da-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/nha-co-216-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Nhà cổ 216' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/nha-co-216-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/nha-co-31-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Nhà cổ 31' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/nha-co-31-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/nha-co-cu-mao-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Nhà cổ cụ Mão' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/nha-co-cu-mao-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/nha-co-ong-giao-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Nhà cổ ông Giao' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/nha-co-ong-giao-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/nha-tho-ho-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Nhà thờ họ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/nha-tho-ho-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/quan-nuoc-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Quán nước' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/quan-nuoc-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/quan-an-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Quán ăn' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/quan-an-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/dan-xa-tac-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Đàn Xã tắc' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/dan-xa-tac-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/dinh-lang-cu-da-21000000-1.jpg', 'anh', 'đình Vật', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đình làng Cự Đà' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/dinh-lang-cu-da-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/duong-chinh-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Đường chính' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/duong-chinh-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/duong-lang-gan-voi-hoat-dong-san-xuat-mien-21000000-1.jpg', 'anh', NULL, 'sites', (SELECT id FROM sites s WHERE s.name = 'Đường làng gắn với hoạt động sản xuất (miến)' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/duong-lang-gan-voi-hoat-dong-san-xuat-mien-21000000-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/sites/duong-nhanh-ngo-21000000-1.jpg', 'anh', 'đường nhánh ngõ quang trung II', 'sites', (SELECT id FROM sites s WHERE s.name = 'Đường nhánh/ngõ' AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/sites/duong-nhanh-ngo-21000000-1.jpg');

-- ============================================================
-- heritage_buildings
-- ============================================================

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — Ảnh từ cổng chính', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-10.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Tháp chuông', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-10.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-11.jpg', 'anh', 'Ảnh các góc chính — Ảnh 360', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-11.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-12.jpeg', 'anh', 'Các bộ phận, chi tiết đặc biệt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-12.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-13.jpeg', 'anh', 'Các bộ phận, chi tiết đặc biệt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-13.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-14.jpeg', 'anh', 'Các bộ phận, chi tiết đặc biệt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-14.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-15.jpg', 'anh', 'Mái_cấu tạo', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-15.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-16.jpg', 'anh', 'Hình ảnh hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-16.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-17.jpg', 'anh', 'Hình ảnh hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-17.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-18.jpg', 'anh', 'Hình ảnh hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-18.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-19.jpg', 'anh', 'Nền (ảnh chụp)', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-19.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-2.jpg', 'anh', 'Tổng mặt bằng — TMB', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-21.jpeg', 'anh', 'Gian 1', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-21.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-22.jpeg', 'anh', 'Gian 2', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-22.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-23.jpeg', 'anh', 'Gian 3', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-23.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-24.jpeg', 'anh', 'Gian 4', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-24.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-25.jpeg', 'anh', 'Gian 5', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-25.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-26.jpeg', 'anh', 'Kết cấu ảnh — Tổng thể bộ vì nóc', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-26.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-27.jpeg', 'anh', 'Kết cấu ảnh — Bộ vì nách', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-27.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-28.jpeg', 'anh', 'Kết cấu ảnh — Bộ vì nách', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-28.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-29.png', 'anh', 'Chân tảng ảnh — Chân tảng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-29.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-3.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — Bia vinh danh', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-3.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-4.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — Giếng quan âm', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-4.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-5.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Tam bảo', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-5.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-6.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Đằng sau nhà tam bảo', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-6.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-7.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Gian thờ địa tạng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-7.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-8.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Nhà học đường', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-8.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-9.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Tam quan', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/chua-cu-da-linh-minh-tu-4f9067b2-9.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-1.pdf', 'ban_ve', 'Tổng mặt bằng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-1.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-12.jpg', 'anh', 'Kết cấu ảnh — ảnh vì kèo', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-12.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-13.jpg', 'anh', 'Kết cấu ảnh — ảnh vì kèo', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-13.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-14.jpg', 'anh', 'Kết cấu ảnh', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-14.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-15.jpg', 'anh', 'Kết cấu ảnh', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-15.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-16.jpg', 'anh', 'Kết cấu ảnh', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-16.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-17.jpg', 'anh', 'Kết cấu ảnh', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-17.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-18.jpg', 'anh', 'Kết cấu ảnh', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-18.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-19.jpg', 'anh', 'Chân tảng ảnh — chân tảng nhà chính', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-19.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-2.jpg', 'anh', 'Mặt đứng, mặt bên công trình', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-20.jpg', 'anh', 'Chân tảng ảnh — chân tảng nhà phụ', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-20.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-3.jpg', 'anh', 'Mái_cấu tạo', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-3.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-4.jpg', 'anh', 'Hình ảnh hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-4.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-5.jpg', 'anh', 'Hình ảnh hiên — ảnh hiên nhà phụ', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-5.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-6.jpg', 'anh', 'Nền (ảnh chụp) — nền sân', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-6.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-7.jpg', 'anh', 'Nền (ảnh chụp) — nền hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-7.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-8.pdf', 'ban_ve', 'Sơ đồ mặt bằng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-8.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-9.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — Sơ đồ mặt cắt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-vu-ngoc-giao-0dcbc754-9.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — Không gian từ cổng chính', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-10.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-10.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-11.jpg', 'anh', 'Mái_cấu tạo — mái', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-11.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-12.jpg', 'anh', 'Vị trí hiên — Hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-12.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-13.jpg', 'anh', 'Vị trí hiên — Hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-13.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-14.jpg', 'anh', 'Nền (ảnh chụp) — Ảnh nền', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-14.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-15.pdf', 'ban_ve', 'Sơ đồ mặt bằng — Sơ  đồ mặt bằng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-15.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-16.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — sơ đồ mặt cắt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-16.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-17.jpg', 'anh', 'Ảnh trong nhà — Không gian bên trong', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-17.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-18.jpg', 'anh', 'Ảnh trong nhà — Gian 1', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-18.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-19.jpg', 'anh', 'Ảnh trong nhà — GIan 1', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-19.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-2.pdf', 'ban_ve', 'Tổng mặt bằng — TMB', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-2.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-20.jpg', 'anh', 'Ảnh trong nhà — Gian 2', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-20.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-21.jpg', 'anh', 'Ảnh trong nhà — Gian 3', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-21.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-22.jpg', 'anh', 'Kết cấu ảnh', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-22.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-23.jpg', 'anh', 'Kết cấu ảnh — Kết cấu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-23.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-24.jpg', 'anh', 'Kết cấu ảnh — Kết cấu', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-24.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-25.png', 'anh', 'Chân tảng ảnh — Trụ tảng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-25.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-3.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — Ảnh bình  phong', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-3.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-4.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt đứng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-4.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-6.jpg', 'anh', 'Ảnh các góc chính — Ảnh góc chính', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-6.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-7.jpg', 'anh', 'Ảnh các góc chính — Ảnh góc chính', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-7.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-8.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-8.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-9.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/nha-ong-mao-d1bb8b84-9.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-1.jpg', 'anh', 'Vị trí', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-10.jpg', 'anh', 'Hình ảnh hiên — Hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-10.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-11.jpg', 'anh', 'Hình ảnh hiên — Hiên', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-11.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-12.jpg', 'anh', 'Nền (ảnh chụp) — Nền sân', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-12.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-13.jpg', 'anh', 'Nền (ảnh chụp) — Nền trong công trình', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-13.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-14.pdf', 'ban_ve', 'Sơ đồ mặt bằng — Mặt bằng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-14.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-15.pdf', 'ban_ve', 'Sơ đồ mặt cắt và bộ vì — sơ đồ mặt cắt', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-15.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-17.jpg', 'anh', 'Gian 1', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-17.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-18.jpg', 'anh', 'Gian 2', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-18.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-19.jpg', 'anh', 'Gian 3', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-19.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-2.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — ảnh cổng chính', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-20.jpg', 'anh', 'Gian 4', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-20.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-21.jpg', 'anh', 'Gian 5', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-21.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-22.jpg', 'anh', 'Gian 6 — GIan 6', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-22.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-23.jpg', 'anh', 'GIan 7 — Gian 7', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-23.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-24.jpg', 'anh', 'Kết cấu ảnh — Kết cấu tổng thể', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-24.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-25.jpg', 'anh', 'Kết cấu ảnh — Vì nách', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-25.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-26.jpg', 'anh', 'Kết cấu ảnh — Vì nách', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-26.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-27.jpg', 'anh', 'Chân tảng ảnh — ảnh chân tảng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-27.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-28.jpg', 'anh', 'Chân tảng hoa văn — chân tảng hoa văn', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-28.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-3.pdf', 'ban_ve', 'Tổng mặt bằng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-3.pdf');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-4.jpg', 'anh', 'Mặt đứng, mặt bên công trình — Mặt đứng', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-4.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-5.jpg', 'anh', 'Ảnh các góc chính — ảnh góc phải công trình', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-5.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-6.jpg', 'anh', 'Ảnh các góc chính — Ảnh góc trái công trình', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-6.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-7.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — Chi tiết', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-7.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-8.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — Chi tiết', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-8.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-9.jpg', 'anh', 'Mái_cấu tạo — Mái', 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/heritage-buildings/dinh-lang-cu-da-26cdf372-9.jpg');

-- ============================================================
-- decorative_art_items
-- ============================================================

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/bieu-tuong-thieng-va-bieu-tuong-ton-giao-6287041f-1.jpg', 'anh', 'Bát bửu đạo giáo', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Biểu tượng thiêng và Biểu tượng tôn giáo' AND h.name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/bieu-tuong-thieng-va-bieu-tuong-ton-giao-6287041f-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/bat-tien-2cd719f7-1.jpg', 'anh', NULL, 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Bát tiên' AND h.name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/bat-tien-2cd719f7-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/bat-tien-2cd719f7-2.jpg', 'anh', NULL, 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Bát tiên' AND h.name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/bat-tien-2cd719f7-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/bat-tien-2cd719f7-3.jpg', 'anh', NULL, 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Bát tiên' AND h.name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/bat-tien-2cd719f7-3.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-0df0c034-1.jpg', 'anh', 'Vì nách hoạ tiết rồng', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…' AND h.name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-0df0c034-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-0df0c034-2.jpg', 'anh', 'Lá hoá rồng', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…' AND h.name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-0df0c034-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-314403c9-1.jpeg', 'anh', 'Lá hoá long', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-314403c9-1.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-a79dc4b8-1.jpg', 'anh', 'Vân hoá long', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…' AND h.name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-a79dc4b8-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-a79dc4b8-2.jpg', 'anh', 'Lá hoá long', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…' AND h.name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-a79dc4b8-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-1e09c0a0-1.png', 'anh', 'Rồng ở đỉnh mái', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Linh vật: Rồng, Phượng, Lân, Long mã, nghê, rùa,…' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-1e09c0a0-1.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-1e09c0a0-2.jpg', 'anh', 'Nghê ở trước hiên', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Linh vật: Rồng, Phượng, Lân, Long mã, nghê, rùa,…' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-1e09c0a0-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-fd1d837d-1.jpg', 'anh', 'Con nghê ở đỉnh cột', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Linh vật: Rồng, Phượng, Lân, Long mã, nghê, rùa,…' AND h.name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/linh-vat-rong-phuong-lan-long-ma-nghe-rua-fd1d837d-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/luong-long-chau-nhat-0d6dbff7-1.jpg', 'anh', 'Lưỡng long ở đỉnh mái', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Lưỡng long chầu nhật' AND h.name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/luong-long-chau-nhat-0d6dbff7-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/may-48b1e215-1.jpeg', 'anh', NULL, 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Mây' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/may-48b1e215-1.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/tien-df4c0e8e-1.jpeg', 'anh', NULL, 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Tiên' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/tien-df4c0e8e-1.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/tuong-mau-trong-den-phu-428e557d-1.jpg', 'anh', 'Tượng thờ mẫu', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Tượng Mẫu (trong đền, phủ)' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/tuong-mau-trong-den-phu-428e557d-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/tuong-to-trong-chua-6997111b-1.jpg', 'anh', 'tượng sư tổ', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Tượng Tổ (trong chùa)' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/tuong-to-trong-chua-6997111b-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/tuong-to-trong-chua-6997111b-2.jpeg', 'anh', 'tượng Tổ', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Tượng Tổ (trong chùa)' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/tuong-to-trong-chua-6997111b-2.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/tuong-phat-giao-trong-chua-d79dbbe9-1.jpg', 'anh', 'Tượng Phật', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Tượng phật giáo (trong chùa)' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/tuong-phat-giao-trong-chua-d79dbbe9-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/tuong-phat-giao-trong-chua-d79dbbe9-2.jpg', 'anh', 'Ban tượng Đức ông + 2 vị hậu cần', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Tượng phật giáo (trong chùa)' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/tuong-phat-giao-trong-chua-d79dbbe9-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/tuong-thanh-than-trong-den-mieu-dao-quan-hoi-quan-fd5aa9f4-1.jpg', 'anh', NULL, 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Tượng thánh, thần (trong đền, miếu, Đạo quán, Hội quán)' AND h.name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/tuong-thanh-than-trong-den-mieu-dao-quan-hoi-quan-fd5aa9f4-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/tuong-thanh-than-trong-den-mieu-dao-quan-hoi-quan-fd5aa9f4-2.jpg', 'anh', NULL, 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Tượng thánh, thần (trong đền, miếu, Đạo quán, Hội quán)' AND h.name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/tuong-thanh-than-trong-den-mieu-dao-quan-hoi-quan-fd5aa9f4-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/de-tai-cay-coi-tre-truc-tung-f81767a1-1.jpg', 'anh', NULL, 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đề tài cây cối: tre, trúc, tùng' AND h.name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/de-tai-cay-coi-tre-truc-tung-f81767a1-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/de-tai-cay-coi-tre-truc-tung-f81767a1-2.jpg', 'anh', NULL, 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đề tài cây cối: tre, trúc, tùng' AND h.name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/de-tai-cay-coi-tre-truc-tung-f81767a1-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-8231a62e-1.jpeg', 'anh', NULL, 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đề tài hoa quả: Mẫu đơn, hồng, cúc, đào, lựu' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/de-tai-hoa-qua-mau-don-hong-cuc-dao-luu-8231a62e-1.jpeg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-0fe0485b-1.jpg', 'anh', 'Cuốn thư', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)' AND h.name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-0fe0485b-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1a3a0d16-1.jpg', 'anh', 'Hoành phi', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)' AND h.name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-1a3a0d16-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-a0a82cac-1.jpg', 'anh', 'Hoành phi, câu đối', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)' AND h.name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-a0a82cac-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-d4636f70-1.jpg', 'anh', 'hoành phi', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-d4636f70-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-d4636f70-2.jpg', 'anh', 'hoành phi2', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-d4636f70-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-02e6073b-1.jpg', 'anh', 'Bát hương', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…' AND h.name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-02e6073b-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-99ae5ca4-1.jpg', 'anh', 'bát hương, mâm bồng', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-99ae5ca4-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-f4eae40c-1.png', 'anh', 'bát hương', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…' AND h.name = 'Đình làng Cự Đà')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-f4eae40c-1.png');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-1a5df654-1.jpg', 'anh', 'Hương án', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị' AND h.name = 'nhà ông Mão')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-1a5df654-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-bfd47cd5-1.jpg', 'anh', 'Hương án', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị' AND h.name = 'Nhà ông Vũ Ngọc Giao')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-bfd47cd5-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-d454d5cb-1.jpg', 'anh', 'khám thờ', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-d454d5cb-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-d454d5cb-2.jpg', 'anh', 'hương án', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-d454d5cb-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-d454d5cb-3.jpg', 'anh', 'bài vị', 'decorative_art_items', (SELECT d.id FROM decorative_art_items d JOIN heritage_buildings h ON h.id = d.building_id WHERE d.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị' AND h.name = 'Chùa Cự Đà _ Linh Minh Tự')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-d454d5cb-3.jpg');

-- ============================================================
-- craft_products
-- ============================================================

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/craft-products/mien-23be602a-1.jpg', 'anh', 'máy khoắng', 'craft_products', (SELECT id FROM craft_products p WHERE p.name = 'Miến' AND p.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/craft-products/mien-23be602a-1.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/craft-products/mien-23be602a-2.jpg', 'anh', 'máy đánh', 'craft_products', (SELECT id FROM craft_products p WHERE p.name = 'Miến' AND p.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/craft-products/mien-23be602a-2.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/craft-products/mien-23be602a-3.jpg', 'anh', 'phên phơi (phơi tái)', 'craft_products', (SELECT id FROM craft_products p WHERE p.name = 'Miến' AND p.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/craft-products/mien-23be602a-3.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/craft-products/mien-23be602a-4.jpg', 'anh', 'phơi tái', 'craft_products', (SELECT id FROM craft_products p WHERE p.name = 'Miến' AND p.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/craft-products/mien-23be602a-4.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/craft-products/mien-23be602a-5.jpg', 'anh', 'phơi miến', 'craft_products', (SELECT id FROM craft_products p WHERE p.name = 'Miến' AND p.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/craft-products/mien-23be602a-5.jpg');

INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id)
SELECT '/cu-da/craft-products/tuong-798e9b00-1.jpg', 'anh', 'Ảnh sản phẩm', 'craft_products', (SELECT id FROM craft_products p WHERE p.name = 'Tương' AND p.village_id = (SELECT id FROM villages WHERE slug = 'cu-da'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/cu-da/craft-products/tuong-798e9b00-1.jpg');

-- ============================================================
-- cover_media_id cho sites — mỗi site nhận ảnh "-1" (ảnh đầu tiên xử lý
-- cho site đó) làm cover, đúng theo setCoverIfUnset của import-cu-da-photos.ts
-- (chỉ set khi cover_media_id đang NULL, không ghi đè ảnh cover đã chọn tay).
-- ============================================================

UPDATE sites s
SET cover_media_id = m.id
FROM media m
WHERE m.owner_entity_type = 'sites'
  AND m.owner_entity_id = s.id
  AND s.village_id = (SELECT id FROM villages WHERE slug = 'cu-da')
  AND s.cover_media_id IS NULL
  AND m.url LIKE '/cu-da/sites/%-1.%';
