-- Bổ sung ảnh làng Phú Vinh vào CSDL, chốt lại trạng thái đã ghi trực tiếp vào
-- CSDL đang chạy bởi map-tour/server/scripts/import-phu-vinh-photos.ts (đọc
-- "Phú Vinh.xlsx" để tải ảnh Google Drive + lấy chú thích/owner cho từng ảnh)
-- — script này ghi thẳng vào CSDL đang chạy, KHÔNG qua migration SQL nào, nên
-- nếu khởi tạo lại CSDL từ init/ + migrations/ (vd. mất volume Docker) sẽ
-- thiếu toàn bộ các dòng media dưới đây. Cùng nguyên tắc với migrations/007,
-- 008, 013, 018.
--
-- Khớp owner:
-- - sites: tham chiếu trực tiếp owner_entity_id (uuid cố định, giống hệt uuid
--   đã dùng trong migrations/017_add_phu_vinh_sites.sql).
-- - heritage_buildings: khớp theo tên công trình + village_id (5 công trình
--   4.1–4.5, phần lớn ảnh của làng nằm ở đây vì hiện vật mỹ thuật 5.1/5.2
--   được gộp trực tiếp vào ảnh công trình tương ứng).
-- - decorative_art_items: khớp theo tên công trình sở hữu + subject_name.
-- - Phú Vinh không có ảnh craft_products (sheet sản phẩm nghề "Mây tre đan"
--   chỉ có dữ liệu văn bản, không có link ảnh Google Drive).
--
-- Idempotent: mỗi INSERT có điều kiện NOT EXISTS theo đúng url, chạy lại
-- nhiều lần cho kết quả như nhau. Luôn `bash scripts/backup.sh` (hoặc
-- `pwsh scripts/backup.ps1`) trước khi áp dụng lên dữ liệu thật.

-- ============================================================
-- sites — ảnh thật từ Phú Vinh.xlsx
-- ============================================================

-- Chùa Cổ Ngỗng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/chua-co-ngong-41033f55-1.jpg', 'anh', 'Ảnh chùa Cổ Ngỗng', NULL, 'sites', '41033f55-90ea-4539-aba1-1ea4ed330048'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/chua-co-ngong-41033f55-1.jpg');

-- Chùa Hạ Phú Vinh
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/chua-ha-phu-vinh-f15021e9-1.jpg', 'anh', 'Ảnh Chùa Hạ Phú Vinh', NULL, 'sites', 'f15021e9-5cee-4574-8b56-6d22a288dcf1'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/chua-ha-phu-vinh-f15021e9-1.jpg');

-- Chợ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/cho-f06f841f-1.jpg', 'anh', 'Ảnh chợ hiện tại', NULL, 'sites', 'f06f841f-b468-4f92-b6c6-72dd66815c99'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/cho-f06f841f-1.jpg');

-- Giếng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/gieng-c1ed694a-1.jpg', 'anh', 'Hình ảnh giếng cổ', NULL, 'sites', 'c1ed694a-3a3d-4eab-bd63-18c619cd15be'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/gieng-c1ed694a-1.jpg');

-- Nhà cổ Hoàng Hạnh
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/nha-co-hoang-hanh-d3802314-1.jpg', 'anh', 'Nhà ông Hoàng Hạnh', NULL, 'sites', 'd3802314-f819-40eb-9447-8d6f23b2a7b6'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/nha-co-hoang-hanh-d3802314-1.jpg');

-- Nhà cổ Nguyễn Hưu Bật
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/nha-co-nguyen-huu-bat-5b519f6e-1.jpg', 'anh', 'nhà ông Nguyễn Hưu Bật', NULL, 'sites', '5b519f6e-5d64-4d9b-9623-cb4e78f666cb'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/nha-co-nguyen-huu-bat-5b519f6e-1.jpg');

-- Nhà cổ Nguyễn Hữu Kí
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/nha-co-nguyen-huu-ki-b7a1677b-1.jpg', 'anh', 'Nhà ông Nguyễn Hữu Kí', NULL, 'sites', 'b7a1677b-f9ea-4a8d-9d1d-5c73ab4ba178'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/nha-co-nguyen-huu-ki-b7a1677b-1.jpg');

-- Quán
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/quan-8987a84a-1.jpg', 'anh', 'Quán', NULL, 'sites', '8987a84a-b2d7-4423-86b9-94d27953c155'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/quan-8987a84a-1.jpg');

-- Đình làng
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/dinh-lang-7cf72fe0-1.jpg', 'anh', 'Ảnh đình làng', NULL, 'sites', '7cf72fe0-3aa2-4c0e-9c57-e926d04db3ba'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/dinh-lang-7cf72fe0-1.jpg');

-- Đường chính
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/duong-chinh-a8c52c9f-1.jpg', 'anh', 'Ảnh đường chính', NULL, 'sites', 'a8c52c9f-dd7e-4ae6-904b-d65e844579c6'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/duong-chinh-a8c52c9f-1.jpg');

-- Đường nhánh/ngõ
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/duong-nhanh-ngo-2fb52b97-1.jpg', 'anh', 'Ảnh đường nhánh', NULL, 'sites', '2fb52b97-503f-4f3f-8ed0-26595709db20'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/duong-nhanh-ngo-2fb52b97-1.jpg');

-- Đường theo vật liệu
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/duong-theo-vat-lieu-6b618c65-1.jpg', 'anh', 'Ảnh vật liệu', NULL, 'sites', '6b618c65-7d7c-4287-accc-1845babb35cc'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/duong-theo-vat-lieu-6b618c65-1.jpg');

-- Đất nông nghiệp
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/sites/dat-nong-nghiep-d49c5ca9-1.jpg', 'anh', 'Hình ảnh', NULL, 'sites', 'd49c5ca9-4e36-4c36-b31d-417f813d6dcc'
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/sites/dat-nong-nghiep-d49c5ca9-1.jpg');

-- ============================================================
-- heritage_buildings — ảnh công trình kiến trúc từ Phú Vinh.xlsx
-- ============================================================

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — https://drive.google.com/file/d/1GSevipoQQzdY_0IxwrBMzdW8zIzerXj3/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-10.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1noxOu-PBddXS2A_hLWJ3EMIvICPKbo_y/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-11.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1KI4TplOk201D4SaLfihm41rEF3XXMubF/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-12.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/19BGYsclU_SgUjOfTug7k2TxiFbwSC1BJ/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-12.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-13.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1tE_cnnkWxY7hU3d_jnjVv7gH-zG_ML4K/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-14.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1CEeeruSKE24bKnigMoeFn-C-8-NfcBZ-/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-15.jpg', 'anh', 'Mái_vật liệu — https://drive.google.com/file/d/1cqfwSbhIFmYrwltDAufxjaByjI6v4evB/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-16.jpg', 'anh', 'Hình ảnh hiên — https://drive.google.com/file/d/1wYae9TH8259NvknaM8eUcQYyOmLsMEN1/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-16.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-17.jpg', 'anh', 'Hiên tam cấp ngưỡng cửa — https://drive.google.com/file/d/1Y96zCyNCIwQkBXxvmt_LoY5IfP2rdF30/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-17.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-18.jpg', 'anh', 'Nền (ảnh chụp) — https://drive.google.com/file/d/12itWcRjIi3L-huUinVVEGJbYBaDq-6jv/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-18.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-19.pdf', 'ban_ve', 'Sơ đồ mặt bằng — https://drive.google.com/file/d/1qeyQPBTn4Qa74_3Dt4gCbjekxGK0kCjZ/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-19.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-2.pdf', 'ban_ve', 'Tổng mặt bằng — https://drive.google.com/file/d/1D2RQHtfY4sTQjrf73txOy1qiB62hU-8k/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-2.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-20.pdf', 'ban_ve', 'Sơ đồ kết cấu — https://drive.google.com/file/d/1CA_tsVE5MEpOXmGue8y0VjBu5aycdkHy/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-20.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-21.jpg', 'anh', 'Ảnh trong nhà — https://drive.google.com/file/d/1ggYYJU-ovTHsO26i2nlRfgFX2dq10Khm/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-21.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-22.jpg', 'anh', 'Kết cấu vật liệu — https://drive.google.com/file/d/1qR9PdQthAcaz387u7gMQQA3jv6qsF8sJ/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-22.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-23.jpg', 'anh', 'Kết cấu tính chất — https://drive.google.com/file/d/1ZzdV5-6lHqdilrHPHUGez-JhCMPlKVN9/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-23.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-24.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/139efURUL3DA7rjA7iGAlKfGAeMALeq5t/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-24.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-25.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1z7Ym3e-mrKOmNulzsyq369PDy60HgTrV/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-25.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-26.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1CbqRnxFFHNcmDS0c3l-LjzPkNJD9ClKa/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-26.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-27.jpg', 'anh', 'Chân tảng ảnh — https://drive.google.com/file/d/1a5L7LWeqGxcw_MbMWDjlr-73daNcxmwu/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-27.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-3.jpg', 'anh', 'Các đối tượng phụ trợ — https://drive.google.com/file/d/10bgS16qp_DD3s0GtVRJ-aaiTsSvxzpaI/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-3.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-4.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — https://drive.google.com/file/d/1QVJE6zLQNy5kbGwejG1wrqbVgf1tA_xr/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-5.jpg', 'anh', 'Mặt đứng, mặt bên công trình — https://drive.google.com/file/d/1OJ73aL3VC1xyiqGwv4BSfAtq5R5lGtSL/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-6.jpg', 'anh', 'Ảnh các góc chính — https://drive.google.com/file/d/1CZNsjVA3igLY5oYJTX-tcTT7iztIjsqC/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-7.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/17rYUt0EYgQRsBcD2YbmGNqvhCh3L5fyy/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-8.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1bEqyDHcd3zBUxoAOviJkYR8na6y3kje8/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-9.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1u52FGHsjWbbWL7Bs4G-bjGtiRCvTiMFg/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà cổ ông Nguyễn Hữu Bật' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-co-ong-nguyen-huu-bat-8300ffc9-9.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — https://drive.google.com/file/d/1KuwjaOyW0Fyr1oiKb8CFi3sQ5wHyFM1l/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-10.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/138hApDFzR36PDrcOzl_bHIom7rbyaQ-y/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-11.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1S3KITEyuXGagwQrXPAxQwF-BukX1dBav/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-12.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1cOButhe8UoRzO01rEOFGpLb9BiM7fmQN/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-12.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-13.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1gCDzmo1HIrU7FBWYQyXX5lRrj8j-HkJj/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-14.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1QzDRtrPKZito-WQtI0JE-LublYPKqP1a/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-15.jpg', 'anh', 'Hình dạng mái — https://drive.google.com/file/d/1Khio265pbFL9a5MFfQiztasJVYXq28EN/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-16.jpg', 'anh', 'Mái_vật liệu — https://drive.google.com/file/d/1ItESrYcC8uWwL2b3nT37R9ntSoC6d6fa/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-16.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-17.jpg', 'anh', 'Hình ảnh hiên — https://drive.google.com/file/d/13zONIWJQNfXwFdUrFF3RjM_kyyXvAw24/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-17.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-18.jpg', 'anh', 'Nền (ảnh chụp) — https://drive.google.com/file/d/1w2ifbukI63OARipCrKuxaY4_fIYTjIpa/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-18.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-19.pdf', 'ban_ve', 'Sơ đồ mặt bằng — https://drive.google.com/file/d/13vKA68gOXqi705TVy_iGjUrASaUMKmbx/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-19.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-2.pdf', 'ban_ve', 'Tổng mặt bằng — https://drive.google.com/file/d/1NDLb5_kH7EB3mkDpZc3yMSL1_vSf1Gaz/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-2.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-20.pdf', 'ban_ve', 'Sơ đồ kết cấu — https://drive.google.com/file/d/1_bfxMgmCGU3P3Z5zw6b9AuIpPmbxaqgJ/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-20.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-21.jpg', 'anh', 'Ảnh trong nhà — https://drive.google.com/file/d/1_p2-ndotQBLe8BPwYbfa1zu1T8pPR2yu/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-21.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-22.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1ewyATCsMabzV_fkFTHIFj5pUcZUaU4HM/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-22.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-23.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1sg4wgOs2sFK79_eBh2dyLAf_w54GF_E6/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-23.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-24.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1wnxdUKKHIqF-fA_PygUl0QS6N4hTnPJE/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-24.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-25.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1FhQULb1ZttpsTXuRiZi5Z2e7RWE-wohg/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-25.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-26.jpg', 'anh', 'Chân tảng ảnh — https://drive.google.com/file/d/1UNon-FLAhphjf_nJPMqNrS6YPgYhJKBO/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-26.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-3.jpg', 'anh', 'Chức năng các công trình trong tổng thể — https://drive.google.com/file/d/1uUDTdruQ7HldAKpCmpAnprbzipVIyfvx/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-3.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-4.jpg', 'anh', 'Chức năng các công trình trong tổng thể — https://drive.google.com/file/d/11OQ0hl7u-HCKFqJddv0AUAxr0reGY0L0/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-5.jpg', 'anh', 'Chức năng các công trình trong tổng thể — https://drive.google.com/file/d/18v7sXb2DBM5-7lAnKByO4yxBgD7S9e50/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-6.jpg', 'anh', 'Chức năng các công trình trong tổng thể — https://drive.google.com/file/d/1YA3OTurmPg1sDFjNIdWaw9eGvjN7Xz6K/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-7.jpg', 'anh', 'Chụp thượng lương — https://drive.google.com/file/d/18-72gtnBynkAL3lNh2w5eujHYw4FNvQo/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-8.jpg', 'anh', 'Mặt đứng, mặt bên công trình — https://drive.google.com/file/d/1eIC_KK6EW1Zk4RfgyBjhUBMMjYmUREP3/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-9.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1kfgMb7AUuJf_tAhjDuQ525LpbAYfrl2I/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà nghệ nhân Hoàng Hạnh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-nghe-nhan-hoang-hanh-b7b5c87b-9.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — https://drive.google.com/file/d/1ADgsM6hspurA1AXSXYFYxou2M7KWNrqG/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-10.jpg', 'anh', 'Hình ảnh hiên — https://drive.google.com/file/d/1eU46rcs85AFDxdPILfSfdyBhp3-mkPSz/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-11.jpg', 'anh', 'Vị trí hiên — https://drive.google.com/file/d/120_WLdbEeI2zRFt7WFcvp40uHVnQAqRU/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-12.jpg', 'anh', 'Nền (ảnh chụp) — https://drive.google.com/file/d/1ZM6uKIElshia4uoTRwHmHQ8am4D0PTXI/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-12.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-13.pdf', 'ban_ve', 'Sơ đồ mặt bằng — https://drive.google.com/file/d/18CVdupMZMBAKw_BZU4XL85u3rCW76Or7/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-13.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-14.pdf', 'ban_ve', 'Sơ đồ kết cấu — https://drive.google.com/file/d/1yHyU_TCyWQBo0iMRRgx-2qrVmR3ZoSBn/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-14.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-15.jpg', 'anh', 'Ảnh trong nhà — https://drive.google.com/file/d/1Lkn9rSjfnR5bmqqYnyWst61uL6Fs2N0Z/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-16.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1XXEX3KEYr6U4Ji5mDtE5cWw7Dtaawz6Y/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-16.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-17.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1DZNdvTn8kno--xSzlUo-AvL9ZOiMI9RX/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-17.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-18.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1xuX6Xfyp6XeVwYIMxFZWmFrShioVk9DR/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-18.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-19.jpg', 'anh', 'Chân tảng ảnh — https://drive.google.com/file/d/14CdUuEwDXkClyiGSVTAHzC7FXQIylsOX/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-19.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-2.pdf', 'ban_ve', 'Tổng mặt bằng — https://drive.google.com/file/d/1Vb9WJ77ERFNDwQGaAZG2YTLCRBQGIZ00/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-2.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-3.jpg', 'anh', 'Mặt đứng, mặt bên công trình — https://drive.google.com/file/d/1KOox9w1JwbQCiO0wSMTQ2zWriW8Q6upH/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-3.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-4.jpg', 'anh', 'Ảnh các góc chính — https://drive.google.com/file/d/13_KmUpuGP3ygAKOizHt0TYYyqv21PCZF/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-5.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1r_BBvsIqax83lavEUngL1mEvg2hnPJmM/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-6.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1dLeLTlcJhHUx0zpRsWdwdk8oIinNthXR/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-7.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1ubn04zCWeFK0vKhxP-HQujMkyiYI09Yg/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-8.jpg', 'anh', 'Mái_vật liệu — https://drive.google.com/file/d/15_m2l75LBXz-7GXUEC0Nps9go_fdZhxD/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-9.jpg', 'anh', 'Mái_cấu tạo — https://drive.google.com/file/d/1B2LyJ9A7XnqGwgk9w6VOn6uQogSsxopw/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Nguyễn Hữu Kí' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/nha-ong-nguyen-huu-ki-e447dc56-9.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-1.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — https://drive.google.com/file/d/1w7wUiubR3JCSvXrNwKQ-DRn0EX_MZbsF/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-10.jpg', 'anh', 'Mặt đứng, mặt bên công trình — https://drive.google.com/file/d/1liF7GG5h3-yqDcrj8KB8v87uyzQx4D74/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-11.jpg', 'anh', 'Mặt đứng, mặt bên công trình — https://drive.google.com/file/d/1Gr9-t5xjyX1Wrq0F5hFeGlJsdzuCtbkE/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-12.jpg', 'anh', 'Vỏ công trình (màu sắc) — https://drive.google.com/file/d/1O5ovhPAtCOypHBVREg7eNGmwacUOELtR/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-12.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-13.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1WPrVLwOssS-f7UfVwZh3qfh8InUUdVFU/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-14.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1m0BQHYjnB88Q2ZQRbTBJoMjB15_SNWgJ/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-15.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1KFvX6PbmSBJwh3smivHNiDbPAN5C_ifH/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-16.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1w00vwGRifp3_GUe2dKZLWNwTg8O5aBws/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-16.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-17.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/13Kg6c1NG6sFNH22tgvYjgTzd97RJlRPr/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-17.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-18.jpg', 'anh', 'Mái_vật liệu — https://drive.google.com/file/d/1hezL08xIIZ6HfVBLaauWkMsq9yPyIsxh/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-18.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-19.jpg', 'anh', 'Mái_cấu tạo — https://drive.google.com/file/d/1k2Ma78ZFxt-ecWg6bZ7zVInr8-tm1SAX/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-19.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-2.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — https://drive.google.com/file/d/1yWI7J3Yoep-DPMLLKE6YZwAso2jRop2E/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-2.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-20.jpg', 'anh', 'Công trình có hiên không — https://drive.google.com/file/d/1fTgha_W3suoMyoCQH47P1UsOLIgQgUiY/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-20.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-21.jpg', 'anh', 'Hiên tam cấp ngưỡng cửa — https://drive.google.com/file/d/1eRnoJeeA5cNUTGUSqMpncTQTnn84iWes/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-21.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-22.jpg', 'anh', 'Nền (ảnh chụp) — https://drive.google.com/file/d/1m5SNy0Wjx0Z3ZaTe5ZFpvgwPcSb17tnz/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-22.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-23.pdf', 'ban_ve', 'Sơ đồ mặt bằng — https://drive.google.com/file/d/1STuE8JWeZW-5W7OVZvgawzTo9_xYc_OP/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-23.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-24.pdf', 'ban_ve', 'Sơ đồ kết cấu — https://drive.google.com/file/d/1iJcE4E-W2Cem8-QaHVqiE68EclL8YdZG/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-24.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-25.jpg', 'anh', 'Ảnh trong nhà — https://drive.google.com/file/d/1c6oVAbLSXOV7rd8FAQgbYRweIfUU1Eju/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-25.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-26.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1E3WVyNzqXMbRoKMIyYWmToTuiKrFFKCt/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-26.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-27.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/14mjjmUd-hYxa8N7u1lDnVZ0MiJw1HUVM/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-27.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-28.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/11W2m1aCN27DLJfXREPJVz-88XwN_hGNR/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-28.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-29.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1GUouXQYP_7vIHv1a1xclMQBwqhDhYkfU/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-29.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-3.pdf', 'ban_ve', 'Tổng mặt bằng — https://drive.google.com/file/d/1fWgdy7bXi_gGBDTs6oc2sCJ_EIrmxnoo/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-3.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-30.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1ksr8w4UWJcMJIfK0w9PH24tt0KckKo5L/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-30.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-31.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1xr9kolf0vQLYFU3rmmQMg1vxZsfCXK1n/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-31.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-32.jpg', 'anh', 'Chân tảng ảnh — https://drive.google.com/file/d/1Zo2Bk_m-6eS28cvwzmhloOX7bH8wbAsB/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-32.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-4.jpg', 'anh', 'Chức năng các công trình trong tổng thể — https://drive.google.com/file/d/1NMLOX1RNS4X7jwSaG4k-7bh2IZtGj-rV/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-5.jpg', 'anh', 'Chức năng các công trình trong tổng thể — https://drive.google.com/file/d/1fhKhhTgV-fh68TG5EpyT79az0z61IAu7/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-6.jpg', 'anh', 'Chức năng các công trình trong tổng thể — https://drive.google.com/file/d/12Zk7x3ZEvd-WbnzGA8wh4tfXDahi2rEb/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-6.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-7.jpg', 'anh', 'Các đối tượng phụ trợ — https://drive.google.com/file/d/1f0hxYqpRlGAEcvYtIHvDKjetRmW_wa5C/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-8.jpg', 'anh', 'Các đối tượng phụ trợ — https://drive.google.com/file/d/14hqSTWOvX7uaonsBTyLIhQl37Pt1wNuA/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-9.jpg', 'anh', 'Ảnh chụp đối tượng phụ trợ (nếu có) — https://drive.google.com/file/d/1ESCKxmmXvlftFtVpp-_NcN8yz7gr09UE/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Quán Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/quan-phu-vinh-61782dee-9.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-1.jpg', 'anh', 'Kiểu loại được xếp hạng — https://drive.google.com/file/d/1UBW93xi4tv1I_zdewwMrs857rQc8c3YM/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-1.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-10.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/113WRIVKICjvPLCR1lozILqbqZBq0EXRj/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-10.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-11.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1eoMZWESlZY5HW2q9LG9mWky6xKFw5_Yh/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-11.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-12.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1lHgmvcJWVmGvJXYK1Mw4gDMBnW_XLgmM/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-12.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-13.jpg', 'anh', 'Các bộ phận, chi tiết đặc biệt — https://drive.google.com/file/d/1rkqcTwv26fsTDcaWBj2iFnzDnLJtvIwC/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-13.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-14.jpg', 'anh', 'Mái_vật liệu đại đình — https://drive.google.com/file/d/18lM2_5FYGCh83cF202iWEWyG0eQ75lGu/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-14.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-15.jpg', 'anh', 'Mái_vật liệu nhà kho — https://drive.google.com/file/d/1-E_HyfQj-uQO6_Zs6aKip_EAWgOvagH3/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-15.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-16.jpg', 'anh', 'Mái_cấu tạo đại đình — https://drive.google.com/file/d/19--RF6V_S6UmsdnZ37Krgk2SwT7ronL-/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-16.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-17.jpg', 'anh', 'Mái_cấu tạo nhà kho — https://drive.google.com/file/d/1BkJoWxuZfW9W9vrEqw5PiYzB52IUqzCj/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-17.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-18.jpg', 'anh', 'Nền (ảnh chụp) — https://drive.google.com/file/d/1AuxXoYUQ1rB11ZXLC6PQwN0bRt3RT9PP/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-18.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-19.jpg', 'anh', 'Nền (ảnh chụp) — https://drive.google.com/file/d/1JvhnrCFAU2lIvVfMARC5Rtk_7Gte9ueZ/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-19.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-2.jpg', 'anh', 'Ảnh tổng thể từ cổng chính — https://drive.google.com/file/d/1XEGLmD_uKLpld54SqXqLXZK5SuoLGYBZ/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-2.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-20.pdf', 'ban_ve', 'Sơ đồ mặt bằng đại đình — https://drive.google.com/file/d/1l_TI-z9SzyXmiqs9TkOsiv0u2Z9Il7ae/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-20.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-21.pdf', 'ban_ve', 'Sơ đồ mặt bằng nhà kho — https://drive.google.com/file/d/1G7nIhnaGKjhVcyiWaILFEuCXW3RPraYz/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-21.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-22.pdf', 'ban_ve', 'Sơ đồ kết cấu đại đình — https://drive.google.com/file/d/1Eyxq8ym3VrlSLTkCpfbyQ8opuASPd38a/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-22.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-23.pdf', 'ban_ve', 'Sơ đồ kết cấu nhà kho — https://drive.google.com/file/d/1H8IsR89XXJ2ZKvTum2heWYxqnibzwGt0/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-23.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-24.jpg', 'anh', 'Ảnh trong nhà — https://drive.google.com/file/d/1PPVHDhuO29rvO7TOvq_PSR-VFZ91USjG/view?usp=drive_link', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-24.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-25.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1Cb5_qNJP670ntUPnenND60Xk6ae6yHzz/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-25.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-26.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1tkpI7PHvlgDMOU-WVC7tiBNdVnw2zZE9/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-26.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-27.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1hnhoJtW9FFNV7O51rcP1aRTBZMGI4sDy/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-27.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-28.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/18OGet_H3KJgzfDXMJKRS1nLTC671KPmF/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-28.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-29.jpg', 'anh', 'Kết cấu ảnh — https://drive.google.com/file/d/1AImvU9Kj7N2WJz0RtPAHzY58tD1J3dHV/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-29.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-3.jpg', 'anh', 'Cấu trúc chung — https://drive.google.com/file/d/1fyw2pNjaXua-nn_Yufu4fZmYwuLzBhSM/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-3.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-30.jpg', 'anh', 'Chân tảng ảnh — https://drive.google.com/file/d/1Ro7zeH-2Carii4ciQun0drCkx4CX1R2I/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-30.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-31.jpg', 'anh', 'Chân tảng ảnh — https://drive.google.com/file/d/15ePZ6k2vWjX5mHnncNAjhoU43WCOEB33/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-31.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-4.jpg', 'anh', 'Cấu trúc chung — https://drive.google.com/file/d/14xQbxGDj53h_6Ru4ecDLeF3jlV_AkeVg/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-4.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-5.jpg', 'anh', 'Cấu trúc chung — https://drive.google.com/file/d/1hEZoXvMKknoFjkSXWf6IRK1r56hl7o_o/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-5.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-6.pdf', 'ban_ve', 'Tổng mặt bằng — https://drive.google.com/file/d/17oVhtATrZ1lmdIq8KYBRHBNDMS3cusjs/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-6.pdf');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-7.jpg', 'anh', 'Cảm nhận của người quan sát về không gian khuôn viên — https://drive.google.com/file/d/1vS2PMSkSwXjZur-FQoFKmf2zaRtEi0WN/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-7.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-8.jpg', 'anh', 'Mặt đứng, mặt bên công trình — https://drive.google.com/file/d/1Fr_YjifwQ928Z8DkDSSZf0iDuAo4w1zg/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-8.jpg');

INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-9.jpg', 'anh', 'Mặt đứng, mặt bên công trình — https://drive.google.com/file/d/1x_sTTuPg5K0dKIGC8lWdU2qwfyLcdHjX/view?usp=sharing', NULL, 'heritage_buildings', (SELECT id FROM heritage_buildings WHERE name = 'Đình Phú Vinh' AND village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh'))
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/heritage-buildings/dinh-phu-vinh-22295a63-9.jpg');

-- ============================================================
-- decorative_art_items — ảnh hiện vật/mỹ thuật trang trí từ Phú Vinh.xlsx
-- ============================================================

-- Quán Phú Vinh — Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-6db86046-1.jpg', 'anh', 'https://drive.google.com/file/d/1KFvX6PbmSBJwh3smivHNiDbPAN5C_ifH/view?usp=sharing', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Quán Phú Vinh' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh') AND dai.subject_name = 'Các hình tượng linh hóa: Cá hóa rồng, cây cỏ hóa rồng,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/decorative/cac-hinh-tuong-linh-hoa-ca-hoa-rong-cay-co-hoa-rong-6db86046-1.jpg');

-- Quán Phú Vinh — Tượng thánh, thần (trong đền, miếu, Đạo quán, Hội quán
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/decorative/tuong-thanh-than-trong-den-mieu-dao-quan-hoi-quan-b15dac6b-1.jpg', 'anh', 'https://drive.google.com/file/d/1TOoy9dOzqpqCgegESzq8kuK5fWojN5lD/view?usp=sharing', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Quán Phú Vinh' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh') AND dai.subject_name = 'Tượng thánh, thần (trong đền, miếu, Đạo quán, Hội quán')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/decorative/tuong-thanh-than-trong-den-mieu-dao-quan-hoi-quan-b15dac6b-1.jpg');

-- Quán Phú Vinh — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-cb4cadb9-1.jpg', 'anh', 'https://drive.google.com/file/d/13P30onRzwpjKz5ZroiJDzhS_BL7PJ6EX/view?usp=sharing', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Quán Phú Vinh' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-cb4cadb9-1.jpg');

-- Quán Phú Vinh — Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-4cd4e215-1.jpg', 'anh', 'https://drive.google.com/file/d/19Mu7L-_OokrP4FZ5uXih_kBopm4SMAxM/view?usp=sharing', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Quán Phú Vinh' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh') AND dai.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-4cd4e215-1.jpg');

-- Quán Phú Vinh — Đồ tự khí: hương án, khám, ngai, bài vị
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-dce06542-1.jpg', 'anh', 'https://drive.google.com/file/d/1CpOWrWlV_MdqQlq41K6Lzzo5fqJTXHfE/view?usp=sharing', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Quán Phú Vinh' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh') AND dai.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-dce06542-1.jpg');

-- Đình Phú Vinh — Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-e9217b60-1.jpg', 'anh', 'https://drive.google.com/file/d/1iiixBOetAX6S0PwcUPtVX29Es2q-HfZb/view?usp=sharing', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đình Phú Vinh' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh') AND dai.subject_name = 'Đồ trang trí thờ tự gắn trên bộ khung kiến trúc (hoành phi, cuốn thư, câu đối, cửa võng, thiều châu, y môn,…)')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/decorative/do-trang-tri-tho-tu-gan-tren-bo-khung-kien-truc-hoanh-phi-cuon-thu-cau-doi-cua-vong-thieu-chau-y-mon-e9217b60-1.jpg');

-- Đình Phú Vinh — Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-438b3549-1.jpg', 'anh', 'https://drive.google.com/file/d/1rkqcTwv26fsTDcaWBj2iFnzDnLJtvIwC/view?usp=drive_link', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đình Phú Vinh' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh') AND dai.subject_name = 'Đồ tế khí: Bát hương, đỉnh, mâm bồng, đài, đồ chấp kích, lỗ bộ, lạc chầu, phỗng chầu,…')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/decorative/do-te-khi-bat-huong-dinh-mam-bong-dai-do-chap-kich-lo-bo-lac-chau-phong-chau-438b3549-1.jpg');

-- Đình Phú Vinh — Đồ tự khí: hương án, khám, ngai, bài vị
INSERT INTO media (url, kind, caption, attribution, owner_entity_type, owner_entity_id)
SELECT '/phu-vinh/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-815ec1d9-1.jpg', 'anh', 'https://drive.google.com/file/d/1DpZcsTTOMh1wNeXVQHPlyF4qA0a5tYE1/view?usp=sharing', NULL, 'decorative_art_items', (SELECT dai.id FROM decorative_art_items dai JOIN heritage_buildings hb ON hb.id = dai.building_id WHERE hb.name = 'Đình Phú Vinh' AND hb.village_id = (SELECT id FROM villages WHERE slug = 'phu-vinh') AND dai.subject_name = 'Đồ tự khí: hương án, khám, ngai, bài vị')
WHERE NOT EXISTS (SELECT 1 FROM media WHERE url = '/phu-vinh/decorative/do-tu-khi-huong-an-kham-ngai-bai-vi-815ec1d9-1.jpg');
