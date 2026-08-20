-- Rà soát toàn bộ CSDL (villages, sites, heritage_buildings và các bảng liên quan,
-- history_stories, decorative_art_items, intangible_heritage_items, craft_products,
-- media) để: (1) thống nhất tên làng theo định dạng "Làng " + tên (vd. "Làng Phú
-- Vinh"), áp dụng nhất quán ở mọi nơi tên làng được dùng làm định danh (cột
-- villages.name, các địa chỉ dạng "Làng X, xã Y, ..."); (2) viết hoa chữ cái đầu
-- các ô văn bản tự do còn sót lại chưa được xử lý ở migrations/010 (migration đó
-- mới chỉ khớp một danh sách id cụ thể phát hiện tại thời điểm đó, không bao phủ
-- toàn bộ CSDL — đặc biệt là các làng thêm sau: Cự Đà, Hạ Thái, Làng Cựu, Làng
-- Chuông, Phú Vinh, và bảng media); (3) sửa các lỗi chính tả/gõ nhầm cụ thể phát
-- hiện qua rà soát thủ công (vd. "nhũng" -> "những", "bị trí" -> "vị trí", "kết
-- câu" -> "kết cấu", thiếu dấu cách, khoảng trắng kép...); (4) chuẩn hóa các giá
-- trị category của sites đang bị nhập hoa toàn bộ (vd. "NHÀ Ở") trùng nghĩa với
-- giá trị Title Case đã có (vd. "Nhà ở"), tránh phân mảnh dữ liệu lọc theo category.
--
-- Nguyên tắc rà soát viết hoa (kế thừa migrations/010): chỉ sửa CHỮ CÁI ĐẦU của
-- ô (không sửa các dòng tiếp theo trong ô nhiều dòng — đó có thể là nhãn liệt kê
-- ngắn hoặc câu tiếp diễn, không phải đầu câu mới). Không đụng tới các cột dùng
-- làm mã/enum nội bộ (kind, type, theme_group, participation_scope,
-- tourist_experience_level, slug, google_maps_link) vì các cột này được so khớp
-- bằng giá trị chữ thường cố định trong CHECK constraint và code ứng dụng.
--
-- Idempotent: mọi UPDATE đều có điều kiện lọc theo trạng thái "còn sai" (chữ đầu
-- đang là chữ thường, hoặc chuỗi con còn chứa lỗi cụ thể) nên chạy lại nhiều lần
-- cho kết quả như nhau. Đã pg_dump --data-only các bảng liên quan trước khi áp
-- dụng lên CSDL đang chạy.

-- ============================================================
-- A. Thống nhất tên làng: "Làng " + tên (vd. "Làng Phú Vinh")
-- ============================================================
-- A1. Các làng chưa có tiền tố "Làng"/"làng" nào (Cự Đà, Hạ Thái, Phú Vinh)
UPDATE villages SET name = 'Làng ' || name
WHERE name !~ '^[Ll]àng ';

-- A2. Làng đã có tiền tố nhưng viết thường ("làng Chuông" -> "Làng Chuông")
UPDATE villages SET name = 'Làng ' || substring(name from 6)
WHERE name LIKE 'làng %';

-- ============================================================
-- B. Tên làng dùng làm mốc tham chiếu ở nơi khác trong CSDL — thống nhất viết
--    hoa "Làng"/tên riêng theo đúng số đông cách dùng đã có trong cùng bảng
--    (vd. địa chỉ heritage_buildings đa số đã ghi "Làng Cự Đà, xã ...").
--    KHÔNG đụng tới các cách dùng "làng" như danh từ chung giữa câu văn xuôi
--    (vd. "từ bàn đạp là làng Chuông", "Đình làng Cự Đà" — đây là cách đặt tên
--    công trình theo mẫu "Đình làng X" đã nhất quán, không phải lỗi).
-- ============================================================

-- B1. Địa chỉ heritage_buildings dùng "làng Ước Lễ"/"làng cựu" viết thường,
--     trong khi các địa chỉ tương tự của Cự Đà đã viết "Làng Cự Đà, xã ..."
UPDATE heritage_buildings SET address = replace(address, 'làng Ước Lễ', 'Làng Ước Lễ')
WHERE address LIKE '%làng Ước Lễ%';

UPDATE heritage_buildings SET address = replace(address, 'làng cựu', 'Làng Cựu')
WHERE address LIKE '%làng cựu%';

-- B2. Tên riêng "Cự Đà" bị gõ thường ở chữ "Đà" (case-sensitive, không trùng
--     với các chỗ đã viết đúng "Cự Đà")
UPDATE intangible_heritage_items SET uniqueness_description = replace(uniqueness_description, 'Cự đà', 'Cự Đà')
WHERE uniqueness_description LIKE '%Cự đà%';

UPDATE history_stories SET body_text = replace(replace(replace(body_text,
    'Cự đà', 'Cự Đà'),
    'Hà nội', 'Hà Nội'),
    'Sài gòn', 'Sài Gòn')
WHERE body_text LIKE '%Cự đà%' OR body_text LIKE '%Hà nội%' OR body_text LIKE '%Sài gòn%';

-- B3. Tên riêng "Chuông" trong tên công trình/chú thích ảnh bị để thường
UPDATE heritage_buildings SET name = replace(name, 'làng chuông', 'làng Chuông')
WHERE name LIKE '%làng chuông%';

UPDATE media SET caption = replace(caption, 'làng chuông', 'làng Chuông')
WHERE caption LIKE '%làng chuông%';

-- B4. Tên riêng "Quang Trung" (xóm/hamlet) bị để thường
UPDATE heritage_buildings SET address = replace(address, 'thôn quang trung', 'thôn Quang Trung')
WHERE address LIKE '%thôn quang trung%';

UPDATE media SET caption = replace(caption, 'quang trung', 'Quang Trung')
WHERE caption LIKE '%quang trung%';

-- ============================================================
-- C. Viết hoa chữ cái đầu ô — mở rộng migrations/010 ra toàn bộ CSDL hiện tại
--    (rà soát bằng: left(col,1) = lower(left(col,1)) AND left(col,1) <> upper(left(col,1)))
-- ============================================================

UPDATE villages SET founded_period = upper(left(founded_period,1)) || substring(founded_period from 2)
WHERE left(founded_period,1) = lower(left(founded_period,1)) AND left(founded_period,1) <> upper(left(founded_period,1));

UPDATE villages SET morphology_description = upper(left(morphology_description,1)) || substring(morphology_description from 2)
WHERE left(morphology_description,1) = lower(left(morphology_description,1)) AND left(morphology_description,1) <> upper(left(morphology_description,1));

UPDATE heritage_buildings SET name = upper(left(name,1)) || substring(name from 2)
WHERE left(name,1) = lower(left(name,1)) AND left(name,1) <> upper(left(name,1));

UPDATE heritage_buildings SET address = upper(left(address,1)) || substring(address from 2)
WHERE left(address,1) = lower(left(address,1)) AND left(address,1) <> upper(left(address,1));

UPDATE heritage_buildings SET "function" = upper(left("function",1)) || substring("function" from 2)
WHERE left("function",1) = lower(left("function",1)) AND left("function",1) <> upper(left("function",1));

UPDATE heritage_buildings SET ownership = upper(left(ownership,1)) || substring(ownership from 2)
WHERE left(ownership,1) = lower(left(ownership,1)) AND left(ownership,1) <> upper(left(ownership,1));

UPDATE heritage_buildings SET heritage_rank = upper(left(heritage_rank,1)) || substring(heritage_rank from 2)
WHERE left(heritage_rank,1) = lower(left(heritage_rank,1)) AND left(heritage_rank,1) <> upper(left(heritage_rank,1));

UPDATE heritage_buildings SET heritage_style_type = upper(left(heritage_style_type,1)) || substring(heritage_style_type from 2)
WHERE left(heritage_style_type,1) = lower(left(heritage_style_type,1)) AND left(heritage_style_type,1) <> upper(left(heritage_style_type,1));

UPDATE heritage_buildings SET managing_unit = upper(left(managing_unit,1)) || substring(managing_unit from 2)
WHERE left(managing_unit,1) = lower(left(managing_unit,1)) AND left(managing_unit,1) <> upper(left(managing_unit,1));

UPDATE heritage_buildings SET overall_structure_description = upper(left(overall_structure_description,1)) || substring(overall_structure_description from 2)
WHERE left(overall_structure_description,1) = lower(left(overall_structure_description,1)) AND left(overall_structure_description,1) <> upper(left(overall_structure_description,1));

UPDATE heritage_buildings SET cultural_historical_value = upper(left(cultural_historical_value,1)) || substring(cultural_historical_value from 2)
WHERE left(cultural_historical_value,1) = lower(left(cultural_historical_value,1)) AND left(cultural_historical_value,1) <> upper(left(cultural_historical_value,1));

UPDATE heritage_buildings SET built_period = upper(left(built_period,1)) || substring(built_period from 2)
WHERE left(built_period,1) = lower(left(built_period,1)) AND left(built_period,1) <> upper(left(built_period,1));

UPDATE heritage_building_technical_details SET roof_shape = upper(left(roof_shape,1)) || substring(roof_shape from 2)
WHERE left(roof_shape,1) = lower(left(roof_shape,1)) AND left(roof_shape,1) <> upper(left(roof_shape,1));

UPDATE heritage_building_technical_details SET roof_material = upper(left(roof_material,1)) || substring(roof_material from 2)
WHERE left(roof_material,1) = lower(left(roof_material,1)) AND left(roof_material,1) <> upper(left(roof_material,1));

UPDATE heritage_building_technical_details SET roof_color = upper(left(roof_color,1)) || substring(roof_color from 2)
WHERE left(roof_color,1) = lower(left(roof_color,1)) AND left(roof_color,1) <> upper(left(roof_color,1));

UPDATE heritage_building_technical_details SET facade_material = upper(left(facade_material,1)) || substring(facade_material from 2)
WHERE left(facade_material,1) = lower(left(facade_material,1)) AND left(facade_material,1) <> upper(left(facade_material,1));

UPDATE heritage_building_technical_details SET facade_condition = upper(left(facade_condition,1)) || substring(facade_condition from 2)
WHERE left(facade_condition,1) = lower(left(facade_condition,1)) AND left(facade_condition,1) <> upper(left(facade_condition,1));

UPDATE heritage_building_technical_details SET floor_material = upper(left(floor_material,1)) || substring(floor_material from 2)
WHERE left(floor_material,1) = lower(left(floor_material,1)) AND left(floor_material,1) <> upper(left(floor_material,1));

UPDATE heritage_building_technical_details SET floor_pattern = upper(left(floor_pattern,1)) || substring(floor_pattern from 2)
WHERE left(floor_pattern,1) = lower(left(floor_pattern,1)) AND left(floor_pattern,1) <> upper(left(floor_pattern,1));

UPDATE heritage_building_technical_details SET structure_material = upper(left(structure_material,1)) || substring(structure_material from 2)
WHERE left(structure_material,1) = lower(left(structure_material,1)) AND left(structure_material,1) <> upper(left(structure_material,1));

UPDATE heritage_building_technical_details SET structure_condition = upper(left(structure_condition,1)) || substring(structure_condition from 2)
WHERE left(structure_condition,1) = lower(left(structure_condition,1)) AND left(structure_condition,1) <> upper(left(structure_condition,1));

UPDATE heritage_building_technical_details SET pedestal_material = upper(left(pedestal_material,1)) || substring(pedestal_material from 2)
WHERE left(pedestal_material,1) = lower(left(pedestal_material,1)) AND left(pedestal_material,1) <> upper(left(pedestal_material,1));

UPDATE heritage_building_technical_details SET pedestal_size = upper(left(pedestal_size,1)) || substring(pedestal_size from 2)
WHERE left(pedestal_size,1) = lower(left(pedestal_size,1)) AND left(pedestal_size,1) <> upper(left(pedestal_size,1));

UPDATE heritage_building_technical_details SET pedestal_type = upper(left(pedestal_type,1)) || substring(pedestal_type from 2)
WHERE left(pedestal_type,1) = lower(left(pedestal_type,1)) AND left(pedestal_type,1) <> upper(left(pedestal_type,1));

UPDATE decorative_art_items SET description = upper(left(description,1)) || substring(description from 2)
WHERE left(description,1) = lower(left(description,1)) AND left(description,1) <> upper(left(description,1));

UPDATE intangible_heritage_items SET generations_transmitted = upper(left(generations_transmitted,1)) || substring(generations_transmitted from 2)
WHERE left(generations_transmitted,1) = lower(left(generations_transmitted,1)) AND left(generations_transmitted,1) <> upper(left(generations_transmitted,1));

UPDATE craft_products SET start_period = upper(left(start_period,1)) || substring(start_period from 2)
WHERE left(start_period,1) = lower(left(start_period,1)) AND left(start_period,1) <> upper(left(start_period,1));

UPDATE craft_products SET cultural_link_level = upper(left(cultural_link_level,1)) || substring(cultural_link_level from 2)
WHERE left(cultural_link_level,1) = lower(left(cultural_link_level,1)) AND left(cultural_link_level,1) <> upper(left(cultural_link_level,1));

UPDATE craft_products SET experience_duration = upper(left(experience_duration,1)) || substring(experience_duration from 2)
WHERE left(experience_duration,1) = lower(left(experience_duration,1)) AND left(experience_duration,1) <> upper(left(experience_duration,1));

UPDATE sites SET name = upper(left(name,1)) || substring(name from 2)
WHERE left(name,1) = lower(left(name,1)) AND left(name,1) <> upper(left(name,1));

UPDATE media SET caption = upper(left(caption,1)) || substring(caption from 2)
WHERE left(caption,1) = lower(left(caption,1)) AND left(caption,1) <> upper(left(caption,1));

-- ============================================================
-- D. Lỗi chính tả/gõ nhầm cụ thể phát hiện qua rà soát thủ công
-- ============================================================

-- D1. villages
UPDATE villages SET name_meaning = replace(name_meaning, 'nhũng loại cây', 'những loại cây')
WHERE name_meaning LIKE '%nhũng loại cây%';

UPDATE villages SET natural_features = replace(natural_features, 'bị trí', 'vị trí')
WHERE natural_features LIKE '%bị trí%';

UPDATE villages SET natural_features = replace(natural_features, 'Làng là nằm', 'Làng nằm')
WHERE natural_features LIKE '%Làng là nằm%';

UPDATE villages SET site_selection_history = replace(site_selection_history, 'luyện quân .', 'luyện quân.')
WHERE site_selection_history LIKE '%luyện quân .%';

-- D2. heritage_buildings (Chùa Sổ — "kết câu" -> "kết cấu"; thiếu dấu cách sau dấu chấm;
--     "tô tạo tượng phạt" -> "tô tạo tượng Phật")
UPDATE heritage_buildings SET overall_structure_description = replace(
    replace(overall_structure_description, 'kết câu', 'kết cấu'),
    'điện.Kiến', 'điện. Kiến')
WHERE overall_structure_description LIKE '%kết câu%' OR overall_structure_description LIKE '%điện.Kiến%';

UPDATE heritage_buildings SET overall_structure_description = replace(overall_structure_description, 'Nhà3 gian', 'Nhà 3 gian')
WHERE overall_structure_description LIKE '%Nhà3 gian%';

UPDATE heritage_buildings SET cultural_historical_value = replace(cultural_historical_value, 'tô tạo tượng phạt', 'tô tạo tượng Phật')
WHERE cultural_historical_value LIKE '%tô tạo tượng phạt%';

UPDATE heritage_buildings SET cultural_historical_value = replace(cultural_historical_value, 'họ trần', 'họ Trần')
WHERE cultural_historical_value LIKE '%họ trần%';

UPDATE heritage_buildings SET managing_unit = replace(managing_unit, 'Họ trần', 'Họ Trần')
WHERE managing_unit LIKE '%Họ trần%';

-- D3. history_stories
UPDATE history_stories SET body_text = replace(body_text, 'hời gian', 'Thời gian')
WHERE body_text LIKE '%hời gian%';

UPDATE history_stories SET body_text = replace(body_text, 'cổng đinh làng', 'cổng đình làng')
WHERE body_text LIKE '%cổng đinh làng%';

UPDATE history_stories SET body_text = replace(
    replace(body_text, 'quyết đinh ở lại', 'quyết định ở lại'),
    'gia phả họ trần', 'gia phả họ Trần')
WHERE body_text LIKE '%quyết đinh ở lại%' OR body_text LIKE '%gia phả họ trần%';

UPDATE history_stories SET body_text = replace(
    replace(body_text, 'đất ở , ruộng công', 'đất ở, ruộng công'),
    '7 mẫu , 4 sào', '7 mẫu, 4 sào')
WHERE body_text LIKE '%đất ở , ruộng công%' OR body_text LIKE '%7 mẫu , 4 sào%';

UPDATE history_stories SET body_text = replace(body_text, 'nơi trước kia chủ yếu làm bến đồ thuyền', 'nơi trước kia chủ yếu làm bến đỗ thuyền')
WHERE body_text LIKE '%làm bến đồ thuyền%';

UPDATE history_stories SET body_text = replace(
    replace(body_text, 'làm thần hoàng làng .', 'làm Thành hoàng làng.'),
    'phong làm thành hoàng làng Cự Đà', 'phong làm Thành hoàng làng Cự Đà')
WHERE body_text LIKE '%làm thần hoàng làng .%' OR body_text LIKE '%phong làm thành hoàng làng Cự Đà%';

-- D4. craft_products / craft_products_internal
UPDATE craft_products SET product_group = replace(product_group, 'kim khó', 'kim khí')
WHERE product_group LIKE '%kim khó%';

UPDATE craft_products SET process_description = replace(process_description, 'đnags', 'đáng')
WHERE process_description LIKE '%đnags%';

UPDATE craft_products SET process_description = replace(process_description, 'quay non', 'quay nón')
WHERE process_description LIKE '%quay non%';

UPDATE craft_products_internal SET support_needs = replace(support_needs, 'tuor tuyến', 'tour tuyến')
WHERE support_needs LIKE '%tuor tuyến%';

UPDATE craft_products_internal SET support_needs = replace(support_needs, '. kết nối tuyến', '. Kết nối tuyến')
WHERE support_needs LIKE '%. kết nối tuyến%';

-- D5. intangible_heritage_items (từ "chin" -> "chín"; thiếu dấu cách sau dấu ngoặc kép)
UPDATE intangible_heritage_items SET uniqueness_description = replace(
    replace(uniqueness_description, 'bột chin', 'bột chín'),
    'Bột chin', 'Bột chín')
WHERE uniqueness_description LIKE '%bột chin%' OR uniqueness_description LIKE '%Bột chin%';

UPDATE intangible_heritage_items SET uniqueness_description = replace(uniqueness_description, 'chin hạt', 'chín hạt')
WHERE uniqueness_description LIKE '%chin hạt%';

UPDATE intangible_heritage_items SET uniqueness_description = replace(uniqueness_description, '".Nguyên liệu', '". Nguyên liệu')
WHERE uniqueness_description LIKE '%".Nguyên liệu%';

-- D6. intangible_heritage_items.generations_transmitted — cụm bị lặp lại ở nhiều dòng
--     với cùng lỗi thiếu khoảng trắng quanh dấu gạch ngang, và viết thường sau em-dash
UPDATE intangible_heritage_items SET generations_transmitted = replace(generations_transmitted, 'mẹ -con cháu', 'mẹ - con cháu')
WHERE generations_transmitted LIKE '%mẹ -con cháu%';

UPDATE intangible_heritage_items SET generations_transmitted = replace(generations_transmitted, '— hơn 3 thế hệ', '— Hơn 3 thế hệ')
WHERE generations_transmitted LIKE '%— hơn 3 thế hệ%';

-- ============================================================
-- E. Chuẩn hóa category của sites — một số bản ghi nhập category viết HOA TOÀN
--    BỘ, trùng nghĩa với giá trị Title Case đã dùng ở các bản ghi khác cùng
--    category, gây phân mảnh khi lọc/nhóm theo category ở tầng ứng dụng.
-- ============================================================
UPDATE sites SET category = 'Cây' WHERE category = 'CÂY';
UPDATE sites SET category = 'Giao thông' WHERE category = 'GIAO THÔNG';
UPDATE sites SET category = 'Mặt nước' WHERE category = 'MẶT NƯỚC';
UPDATE sites SET category = 'Nhà ở' WHERE category = 'NHÀ Ở';
UPDATE sites SET category = 'Nhà công cộng' WHERE category = 'NHÀ CÔNG CỘNG';

-- ============================================================
-- F. Chuẩn hóa khoảng trắng kép (hai dấu cách liền nhau) thành một dấu cách,
--    lỗi phổ biến do dán liệu từ Excel/Google Docs.
-- ============================================================
UPDATE media SET caption = regexp_replace(caption, '  +', ' ', 'g')
WHERE caption ~ '[^\s]  +[^\s]';

UPDATE intangible_heritage_items SET name = regexp_replace(name, '  +', ' ', 'g')
WHERE name ~ '[^\s]  +[^\s]';

UPDATE intangible_heritage_items SET uniqueness_description = regexp_replace(uniqueness_description, '  +', ' ', 'g')
WHERE uniqueness_description ~ '[^\s]  +[^\s]';

UPDATE intangible_heritage_items SET generations_transmitted = regexp_replace(generations_transmitted, '  +', ' ', 'g')
WHERE generations_transmitted ~ '[^\s]  +[^\s]';

UPDATE intangible_heritage_items SET capacity_note = regexp_replace(capacity_note, '  +', ' ', 'g')
WHERE capacity_note ~ '[^\s]  +[^\s]';

UPDATE craft_products SET product_group = regexp_replace(product_group, '  +', ' ', 'g')
WHERE product_group ~ '[^\s]  +[^\s]';

UPDATE history_stories SET body_text = regexp_replace(body_text, '  +', ' ', 'g')
WHERE body_text ~ '[^\s]  +[^\s]';

UPDATE decorative_art_items SET description = regexp_replace(description, '  +', ' ', 'g')
WHERE description ~ '[^\s]  +[^\s]';

UPDATE heritage_buildings SET address = regexp_replace(address, '  +', ' ', 'g')
WHERE address ~ '[^\s]  +[^\s]';

UPDATE heritage_buildings SET overall_structure_description = regexp_replace(overall_structure_description, '  +', ' ', 'g')
WHERE overall_structure_description ~ '[^\s]  +[^\s]';

UPDATE heritage_buildings SET cultural_historical_value = regexp_replace(cultural_historical_value, '  +', ' ', 'g')
WHERE cultural_historical_value ~ '[^\s]  +[^\s]';

-- Dấu cách thừa trước dấu phẩy (vd. "thôn Hạ Thái , xã" -> "thôn Hạ Thái, xã")
UPDATE heritage_buildings SET address = replace(address, 'Hạ Thái , xã', 'Hạ Thái, xã')
WHERE address LIKE '%Hạ Thái , xã%';

UPDATE heritage_buildings SET address = regexp_replace(address, ' +,', ',', 'g')
WHERE address ~ ' +,';

-- ============================================================
-- H. Tên riêng trong sites.name cần sửa cụ thể (không chỉ viết hoa chữ đầu)
-- ============================================================
UPDATE sites SET name = 'Nhà cổ bác Tứ' WHERE name = 'Nhà cổ bác tứ';
