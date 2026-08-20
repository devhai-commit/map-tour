-- Sửa lỗi viết hoa chữ cái đầu (và 2 lỗi viết hoa tên riêng giữa câu) trong
-- các trường văn bản tự do, phát hiện qua rà soát toàn bộ CSDL: nhiều ô do
-- nhập liệu từ Excel (xem migrations/006, 009 và map-tour/server/src/lib/
-- importParse.ts) bắt đầu bằng chữ thường thay vì chữ hoa, ví dụ ô "Phong
-- tục" của làng Ước Lễ hiện đang hiển thị "ở Ước Lễ còn có..." thay vì
-- "Ở Ước Lễ còn có...".
--
-- Chỉ sửa CHỮ CÁI ĐẦU của từng ô (và 2 tên riêng viết sai giữa câu nêu dưới),
-- KHÔNG thay đổi nội dung/chính tả nào khác (vd. không thêm dấu cách còn
-- thiếu ở "nhà3 gian 2 chái" — đó là lỗi khác, ngoài phạm vi rà soát viết hoa
-- lần này). Với các ô nhiều dòng (vd. decorative_art_items.description ghép
-- tên hiện vật ngắn + đoạn mô tả dài do dữ liệu khảo sát gốc), chỉ sửa dòng
-- đầu tiên của ô — các dòng sau (vd. "tượng Tổ" trong item 6997111b) giữ
-- nguyên vì đó là nhãn liệt kê ngắn, không phải đầu câu/đầu ô.
--
-- Rà soát bằng: left(col,1) = lower(left(col,1)) AND left(col,1) <> upper(left(col,1))
-- trên toàn bộ cột kiểu text ở villages, sites, history_stories,
-- craft_products(_internal), heritage_buildings(_technical_details),
-- decorative_art_items, intangible_heritage_items.
--
-- Idempotent: mỗi UPDATE giới hạn theo danh sách id cụ thể đã rà soát được,
-- CỘNG điều kiện "chữ đầu đang là chữ thường" — chạy lại nhiều lần cho kết
-- quả như nhau (sau lần đầu, điều kiện chữ-thường không còn đúng nữa nên
-- UPDATE sau sẽ không khớp dòng nào). Đã pg_dump --data-only các bảng liên
-- quan trước khi áp dụng lên CSDL đang chạy.

-- ============================================================
-- history_stories.body_text (làng Ước Lễ, thêm ở migrations/009)
-- ============================================================
UPDATE history_stories SET body_text = upper(left(body_text,1)) || substring(body_text from 2)
WHERE id = ANY(ARRAY['41000000-0000-0000-0000-000000000003','41000000-0000-0000-0000-000000000004']::uuid[])
  AND left(body_text,1) = lower(left(body_text,1)) AND left(body_text,1) <> upper(left(body_text,1));

-- ============================================================
-- craft_products.materials
-- ============================================================
UPDATE craft_products SET materials = upper(left(materials,1)) || substring(materials from 2)
WHERE village_id = (SELECT id FROM villages WHERE slug = 'cu-da')
  AND left(materials,1) = lower(left(materials,1)) AND left(materials,1) <> upper(left(materials,1));

-- ============================================================
-- heritage_buildings
-- ============================================================
UPDATE heritage_buildings SET name = upper(left(name,1)) || substring(name from 2)
WHERE name = 'nhà ông Mão'
  AND left(name,1) = lower(left(name,1)) AND left(name,1) <> upper(left(name,1));

UPDATE heritage_buildings SET address = upper(left(address,1)) || substring(address from 2)
WHERE name IN ('Đình làng Cự Đà','Chùa Cự Đà _ Linh Minh Tự','Nhà ông Vũ Ngọc Giao','Nhà ông Mão')
  AND left(address,1) = lower(left(address,1)) AND left(address,1) <> upper(left(address,1));

UPDATE heritage_buildings SET function = upper(left(function,1)) || substring(function from 2)
WHERE name = 'Nhà ông Vũ Ngọc Giao'
  AND left(function,1) = lower(left(function,1)) AND left(function,1) <> upper(left(function,1));

UPDATE heritage_buildings SET overall_structure_description = upper(left(overall_structure_description,1)) || substring(overall_structure_description from 2)
WHERE name IN ('Chùa Cự Đà _ Linh Minh Tự','Nhà ông Vũ Ngọc Giao')
  AND left(overall_structure_description,1) = lower(left(overall_structure_description,1)) AND left(overall_structure_description,1) <> upper(left(overall_structure_description,1));

-- ============================================================
-- heritage_building_technical_details (khóa theo building_id, unique)
-- ============================================================
UPDATE heritage_building_technical_details SET roof_shape = upper(left(roof_shape,1)) || substring(roof_shape from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Vũ Ngọc Giao')
  AND left(roof_shape,1) = lower(left(roof_shape,1)) AND left(roof_shape,1) <> upper(left(roof_shape,1));

UPDATE heritage_building_technical_details SET roof_material = upper(left(roof_material,1)) || substring(roof_material from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name IN ('Đình làng Cự Đà','Chùa Cự Đà _ Linh Minh Tự','Nhà ông Vũ Ngọc Giao','Nhà ông Mão'))
  AND left(roof_material,1) = lower(left(roof_material,1)) AND left(roof_material,1) <> upper(left(roof_material,1));

UPDATE heritage_building_technical_details SET roof_color = upper(left(roof_color,1)) || substring(roof_color from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name IN ('Đình làng Cự Đà','Chùa Cự Đà _ Linh Minh Tự','Nhà ông Vũ Ngọc Giao'))
  AND left(roof_color,1) = lower(left(roof_color,1)) AND left(roof_color,1) <> upper(left(roof_color,1));

UPDATE heritage_building_technical_details SET facade_material = upper(left(facade_material,1)) || substring(facade_material from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name IN ('Chùa Cự Đà _ Linh Minh Tự','Nhà ông Vũ Ngọc Giao','Nhà ông Mão'))
  AND left(facade_material,1) = lower(left(facade_material,1)) AND left(facade_material,1) <> upper(left(facade_material,1));

UPDATE heritage_building_technical_details SET facade_condition = upper(left(facade_condition,1)) || substring(facade_condition from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name IN ('Đình làng Cự Đà','Chùa Cự Đà _ Linh Minh Tự','Nhà ông Vũ Ngọc Giao'))
  AND left(facade_condition,1) = lower(left(facade_condition,1)) AND left(facade_condition,1) <> upper(left(facade_condition,1));

UPDATE heritage_building_technical_details SET floor_material = upper(left(floor_material,1)) || substring(floor_material from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name IN ('Chùa Cự Đà _ Linh Minh Tự','Nhà ông Mão'))
  AND left(floor_material,1) = lower(left(floor_material,1)) AND left(floor_material,1) <> upper(left(floor_material,1));

UPDATE heritage_building_technical_details SET floor_pattern = upper(left(floor_pattern,1)) || substring(floor_pattern from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name IN ('Đình làng Cự Đà','Chùa Cự Đà _ Linh Minh Tự','Nhà ông Mão'))
  AND left(floor_pattern,1) = lower(left(floor_pattern,1)) AND left(floor_pattern,1) <> upper(left(floor_pattern,1));

UPDATE heritage_building_technical_details SET structure_material = upper(left(structure_material,1)) || substring(structure_material from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name IN ('Đình làng Cự Đà','Chùa Cự Đà _ Linh Minh Tự','Nhà ông Vũ Ngọc Giao','Nhà ông Mão'))
  AND left(structure_material,1) = lower(left(structure_material,1)) AND left(structure_material,1) <> upper(left(structure_material,1));

UPDATE heritage_building_technical_details SET structure_condition = upper(left(structure_condition,1)) || substring(structure_condition from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name IN ('Chùa Cự Đà _ Linh Minh Tự','Nhà ông Vũ Ngọc Giao'))
  AND left(structure_condition,1) = lower(left(structure_condition,1)) AND left(structure_condition,1) <> upper(left(structure_condition,1));

UPDATE heritage_building_technical_details SET pedestal_material = upper(left(pedestal_material,1)) || substring(pedestal_material from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name IN ('Nhà ông Vũ Ngọc Giao','Nhà ông Mão'))
  AND left(pedestal_material,1) = lower(left(pedestal_material,1)) AND left(pedestal_material,1) <> upper(left(pedestal_material,1));

UPDATE heritage_building_technical_details SET pedestal_size = upper(left(pedestal_size,1)) || substring(pedestal_size from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name = 'Nhà ông Mão')
  AND left(pedestal_size,1) = lower(left(pedestal_size,1)) AND left(pedestal_size,1) <> upper(left(pedestal_size,1));

-- ============================================================
-- decorative_art_items.description (chỉ sửa dòng đầu của ô, xem ghi chú trên)
-- ============================================================
UPDATE decorative_art_items SET description = upper(left(description,1)) || substring(description from 2)
WHERE building_id IN (SELECT id FROM heritage_buildings WHERE name IN
  ('Đình làng Cự Đà','Chùa Cự Đà _ Linh Minh Tự','Nhà ông Vũ Ngọc Giao','Nhà ông Mão'))
  AND left(description,1) = lower(left(description,1)) AND left(description,1) <> upper(left(description,1));

-- ============================================================
-- intangible_heritage_items
-- ============================================================
UPDATE intangible_heritage_items SET capacity_note = upper(left(capacity_note,1)) || substring(capacity_note from 2)
WHERE village_id = (SELECT id FROM villages WHERE slug = 'cu-da')
  AND left(capacity_note,1) = lower(left(capacity_note,1)) AND left(capacity_note,1) <> upper(left(capacity_note,1));

UPDATE intangible_heritage_items SET generations_transmitted = upper(left(generations_transmitted,1)) || substring(generations_transmitted from 2)
WHERE village_id = (SELECT id FROM villages WHERE slug = 'cu-da')
  AND left(generations_transmitted,1) = lower(left(generations_transmitted,1)) AND left(generations_transmitted,1) <> upper(left(generations_transmitted,1));

UPDATE intangible_heritage_items SET event_timing = upper(left(event_timing,1)) || substring(event_timing from 2)
WHERE village_id = (SELECT id FROM villages WHERE slug = 'cu-da')
  AND left(event_timing,1) = lower(left(event_timing,1)) AND left(event_timing,1) <> upper(left(event_timing,1));

-- ============================================================
-- villages.name_meaning — chữ cái đầu + 2 tên riêng viết hoa sai giữa câu
-- ("họ NGô" -> "họ Ngô", "THanh Hóa" -> "Thanh Hóa")
-- ============================================================
UPDATE villages
   SET name_meaning = upper(left(name_meaning,1)) || substring(name_meaning from 2)
 WHERE slug = 'cu-da'
   AND left(name_meaning,1) = lower(left(name_meaning,1)) AND left(name_meaning,1) <> upper(left(name_meaning,1));

UPDATE villages
   SET name_meaning = replace(name_meaning, 'họ NGô', 'họ Ngô')
 WHERE slug = 'cu-da'
   AND name_meaning LIKE '%họ NGô%';

UPDATE villages
   SET name_meaning = replace(name_meaning, 'THanh Hóa', 'Thanh Hóa')
 WHERE slug = 'cu-da'
   AND name_meaning LIKE '%THanh Hóa%';
