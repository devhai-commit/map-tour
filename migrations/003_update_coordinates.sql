-- Cập nhật toạ độ các điểm/khu vực trong làng theo vị trí thật lấy từ
-- Google Maps: https://www.google.com/maps/@20.8259091,105.810058,18z
-- (cổng làng Ước Lễ), thay cho toạ độ placeholder gần đúng ở lần seed đầu
-- (init/04_seed_sample.sql, xem chú thích trong file đó).
-- Giữ nguyên cùng độ lệch (delta) lat/lng cho mọi điểm/khu vực so với bản cũ,
-- để giữ nguyên hình dạng và khoảng cách tương đối giữa các di tích trong
-- làng — chỉ dịch cả cụm về đúng vị trí thật ngoài đời.
-- Khớp theo s.name (không dùng id) vì id có thể không cố định giữa các lần
-- seed khác nhau. Idempotent: chạy lại nhiều lần cho kết quả như nhau (UPDATE
-- luôn set về giá trị đích cố định, không cộng dồn theo delta).

UPDATE villages
SET google_maps_link = 'https://www.google.com/maps/@20.8259091,105.810058,18z'
WHERE name = 'Làng Ước Lễ';

UPDATE sites SET position_lat = 20.8259091, position_lng = 105.810058
WHERE name = 'Cổng làng Ước Lễ' AND kind = 'point';

UPDATE sites SET position_lat = 20.826409, position_lng = 105.810958
WHERE name = 'Đình làng Ước Lễ' AND kind = 'point';

UPDATE sites SET position_lat = 20.826809, position_lng = 105.811058
WHERE name = 'Chùa làng Ước Lễ' AND kind = 'point';

UPDATE sites SET position_lat = 20.826109, position_lng = 105.810658
WHERE name = 'Giếng làng' AND kind = 'point';

UPDATE sites SET boundary = '[[20.826209,105.810158],[20.826909,105.810558],[20.826709,105.811358],[20.825809,105.811258],[20.825509,105.810458]]'::jsonb
WHERE name = 'Khu làng cổ' AND kind = 'area';

UPDATE sites SET boundary = '[[20.824609,105.811058],[20.825009,105.811658],[20.824409,105.812158],[20.823909,105.811558]]'::jsonb
WHERE name = 'Khu làng nghề giò chả' AND kind = 'area';
