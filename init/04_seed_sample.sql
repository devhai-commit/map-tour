-- Dữ liệu mẫu (KHÔNG phải dữ liệu khảo sát thật) — dùng để kiểm tra schema
-- hoạt động đúng sau khi triển khai. Tái sử dụng đúng các entry demo đã có
-- trong src/data/sites.ts, file đó đã ghi rõ trong comment đầu file:
-- toạ độ chỉ là placeholder xấp xỉ, KHÔNG phải GPS khảo sát thật.
-- Muốn bỏ seed này khi triển khai thật: xoá hoặc đổi tên file thành .sql.disabled
-- trước lần "docker compose up" đầu tiên (init script chỉ chạy khi volume rỗng).

INSERT INTO villages (id, name, admin_location, main_occupations)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'Làng Ước Lễ',
  'Xã Tân Ước, huyện Thanh Oai, Hà Nội',
  ARRAY['Làm giò chả truyền thống']
);

INSERT INTO sites (village_id, kind, position_lat, position_lng, name, category, short_description)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'point', 20.7758, 105.7748, 'Cổng làng Ước Lễ', 'Di tích kiến trúc',
   'Cổng làng cổ xây gạch từ thời Mạc, biểu tượng nổi tiếng nhất của làng.'),
  ('00000000-0000-0000-0000-000000000001', 'point', 20.7763, 105.7757, 'Đình làng Ước Lễ', 'Di tích tín ngưỡng',
   'Nơi thờ Thành hoàng làng, diễn ra các lễ hội và sinh hoạt cộng đồng truyền thống.'),
  ('00000000-0000-0000-0000-000000000001', 'point', 20.7767, 105.7758, 'Chùa làng Ước Lễ', 'Di tích tín ngưỡng',
   'Ngôi chùa cổ của làng, điểm sinh hoạt Phật giáo và tham quan văn hóa tâm linh.'),
  ('00000000-0000-0000-0000-000000000001', 'point', 20.7760, 105.7754, 'Giếng làng', 'Cảnh quan',
   'Giếng nước cổ gắn với đời sống sinh hoạt lâu đời của người dân trong làng.');

INSERT INTO sites (village_id, kind, boundary, name, category, short_description)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'area',
   '[[20.7761,105.7749],[20.7768,105.7753],[20.7766,105.7761],[20.7757,105.776],[20.7754,105.7752]]'::jsonb,
   'Khu làng cổ', 'Quần thể di sản',
   'Cụm nhà cổ, ngõ xóm lát gạch nghiêng và không gian kiến trúc truyền thống vùng đồng bằng sông Hồng.'),
  ('00000000-0000-0000-0000-000000000001', 'area',
   '[[20.7745,105.7758],[20.7749,105.7764],[20.7743,105.7769],[20.7738,105.7763]]'::jsonb,
   'Khu làng nghề giò chả', 'Làng nghề',
   'Cụm xưởng sản xuất giò chả truyền thống, nơi khách có thể tham quan quy trình chế biến.');
