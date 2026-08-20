-- Rà soát ảnh đại diện (cover) của tất cả các "sites" trong CSDL: một số ảnh
-- 360 độ (dual-fisheye/equirectangular, ratio ~2:1, độ phân giải đặc trưng
-- 11904x5952 hoặc 5888x2944 của camera 360) đã bị nhập nhầm với kind='anh'
-- và được dùng làm ảnh đại diện (cover_media_id) — hiển thị dạng "quả bóng
-- đôi" méo trên card thay vì ảnh 2D bình thường. Phát hiện bằng cách so
-- kích thước pixel thực tế của 120 ảnh cover hiện có trong CSDL với danh
-- sách ảnh 360 gốc trên đĩa.
--
-- Với mỗi site bị ảnh hưởng: gắn lại đúng kind='panorama' cho media, chuyển
-- nó sang panorama_media_id (để vẫn xem được qua nút "Xem 360°"), và bỏ
-- trống cover_media_id (frontend đã có placeholder chữ cái đầu khi thiếu
-- cover — xem site.cover kiểm tra trong VillageIntroductionSections.tsx,
-- HomePage.tsx, HeritageListPage.tsx). Không site nào trong nhóm này có sẵn
-- ảnh 2D thay thế trong CSDL.
--
-- Idempotent: mỗi UPDATE chỉ áp dụng khi state vẫn đúng như lúc phát hiện
-- (kind vẫn 'anh' / panorama_media_id vẫn NULL / cover_media_id vẫn trỏ tới
-- đúng media 360 đã xác định) — chạy lại không có tác dụng phụ.

UPDATE media
SET kind = 'panorama'
WHERE kind = 'anh'
  AND owner_entity_type = 'sites'
  AND id IN (
    'b987b591-fda8-4c0f-aa30-33511abeb153', -- Chùa (Làng Chuông)
    '3d91be13-1850-4d4e-8aab-e84cc558ad18', -- Chợ - Chùa (Làng Chuông)
    'fb166dca-4afa-4e95-acd6-848eb3d0df37', -- Giếng xóm 8 Trung Khu (Làng Chuông)
    'd242bc7e-5d6a-4aa8-95a8-1db6293094ac', -- Nhà thờ họ (Làng Chuông)
    '1c28ff79-47dc-4e2b-b893-064948b164b8', -- Điếm xóm 2 thôn Liên Tân (Làng Chuông)
    '2b90ca2b-84a6-4d30-97b2-95753831dd28', -- Đường chính (Làng Chuông)
    '981ffef5-2e12-4ba4-9493-ae41defd6e2d', -- Đường nhánh/ngõ (Làng Chuông)
    '90f97dd4-95e1-417b-a0b5-74426cf8a07b', -- Đường theo vật liệu (Làng Chuông)
    '3acdf75c-97c5-4d8d-b9ba-55b5ddd5aba1', -- Đền Quán Trung (Làng Chuông)
    '4a742ab7-c62b-43f5-ac67-cc0f10d72b66', -- Đền Thượng (Làng Chuông)
    '75623f35-8187-4d2b-9411-a2ad6e2623a6', -- Đường nhánh/ngõ (Làng Cự Đà)
    '9984da86-1ab9-4b57-93cf-9259e7293666', -- Chùa Cổ Ngỗng (Làng Phú Vinh)
    '395b9ba2-9703-4a1e-b66f-73ff63a79939', -- Chùa Hạ Phú Vinh (Làng Phú Vinh)
    '4c439ff5-bcbe-4aae-b90a-b5bb9f8153f8', -- Chợ (Làng Phú Vinh)
    '9ead7af9-a069-48a2-b20d-11a5da85ea1a', -- Quán (Làng Phú Vinh)
    'b9bbe9f5-db90-4ab7-b7b6-db135fa0f86f', -- Đình làng (Làng Phú Vinh)
    '105ad189-69d4-4257-9e68-30f2ff005e5f', -- Đường chính (Làng Phú Vinh)
    'e1416eea-4bf0-4134-b7a8-94d0b411509f', -- Đất nông nghiệp (Làng Phú Vinh)
    '711b5e4f-4adf-4aaf-a507-1da6aacbe7e6', -- Cổng làng Ước Lễ
    'aea1ce6d-a5bd-47bc-9521-8040ad77e572', -- Nhà Thờ Giáo Họ
    '55513bc3-0810-4323-a91b-8c6c6d80aa75', -- Nhà Thờ Giáo Họ (dòng trùng, cùng file)
    '90936801-5bce-4bde-8ee6-644a984870e5', -- Nhà Thờ Giáo Họ (dòng trùng, cùng file)
    '6704c21e-bac4-4cfb-bbcd-6e07a1f30fe3', -- Đường gạch khá đẹp
    '21c8b55a-d352-4be0-899d-38f9e7b9cde8'  -- Đường gạch khá đẹp (dòng trùng, cùng file)
  );

UPDATE sites
SET panorama_media_id = cover_media_id
WHERE panorama_media_id IS NULL
  AND cover_media_id IN (
    'b987b591-fda8-4c0f-aa30-33511abeb153', '3d91be13-1850-4d4e-8aab-e84cc558ad18',
    'fb166dca-4afa-4e95-acd6-848eb3d0df37', 'd242bc7e-5d6a-4aa8-95a8-1db6293094ac',
    '1c28ff79-47dc-4e2b-b893-064948b164b8', '2b90ca2b-84a6-4d30-97b2-95753831dd28',
    '981ffef5-2e12-4ba4-9493-ae41defd6e2d', '90f97dd4-95e1-417b-a0b5-74426cf8a07b',
    '3acdf75c-97c5-4d8d-b9ba-55b5ddd5aba1', '4a742ab7-c62b-43f5-ac67-cc0f10d72b66',
    '75623f35-8187-4d2b-9411-a2ad6e2623a6', '9984da86-1ab9-4b57-93cf-9259e7293666',
    '395b9ba2-9703-4a1e-b66f-73ff63a79939', '4c439ff5-bcbe-4aae-b90a-b5bb9f8153f8',
    '9ead7af9-a069-48a2-b20d-11a5da85ea1a', 'b9bbe9f5-db90-4ab7-b7b6-db135fa0f86f',
    '105ad189-69d4-4257-9e68-30f2ff005e5f', 'e1416eea-4bf0-4134-b7a8-94d0b411509f',
    '711b5e4f-4adf-4aaf-a507-1da6aacbe7e6', 'aea1ce6d-a5bd-47bc-9521-8040ad77e572',
    '6704c21e-bac4-4cfb-bbcd-6e07a1f30fe3'
  );

UPDATE sites
SET cover_media_id = NULL
WHERE cover_media_id IN (
    'b987b591-fda8-4c0f-aa30-33511abeb153', '3d91be13-1850-4d4e-8aab-e84cc558ad18',
    'fb166dca-4afa-4e95-acd6-848eb3d0df37', 'd242bc7e-5d6a-4aa8-95a8-1db6293094ac',
    '1c28ff79-47dc-4e2b-b893-064948b164b8', '2b90ca2b-84a6-4d30-97b2-95753831dd28',
    '981ffef5-2e12-4ba4-9493-ae41defd6e2d', '90f97dd4-95e1-417b-a0b5-74426cf8a07b',
    '3acdf75c-97c5-4d8d-b9ba-55b5ddd5aba1', '4a742ab7-c62b-43f5-ac67-cc0f10d72b66',
    '75623f35-8187-4d2b-9411-a2ad6e2623a6', '9984da86-1ab9-4b57-93cf-9259e7293666',
    '395b9ba2-9703-4a1e-b66f-73ff63a79939', '4c439ff5-bcbe-4aae-b90a-b5bb9f8153f8',
    '9ead7af9-a069-48a2-b20d-11a5da85ea1a', 'b9bbe9f5-db90-4ab7-b7b6-db135fa0f86f',
    '105ad189-69d4-4257-9e68-30f2ff005e5f', 'e1416eea-4bf0-4134-b7a8-94d0b411509f',
    '711b5e4f-4adf-4aaf-a507-1da6aacbe7e6', 'aea1ce6d-a5bd-47bc-9521-8040ad77e572',
    '6704c21e-bac4-4cfb-bbcd-6e07a1f30fe3'
  );
