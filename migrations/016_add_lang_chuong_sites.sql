-- Giai đoạn tối thiểu: chỉ tạo village Làng Chuông.
INSERT INTO villages (id, name, slug, admin_location, founded_period, main_occupations)
SELECT '09ee09b0-41f2-429c-a515-0cd2592edc44', 'Làng Chuông', 'lang-chuong',
       'Xã Thanh Oai, TP. Hà Nội (trước xã Phương Trung, huyện Thanh Oai, Hà Nội)',
       'thế kỷ thứ 8 (cụ thể là vào năm 791 - năm Tân Mùi)', ARRAY[]::text[]
WHERE NOT EXISTS (SELECT 1 FROM villages WHERE slug='lang-chuong');

DO $$ BEGIN
  IF (SELECT count(*) FROM villages WHERE slug='lang-chuong') <> 1 THEN
    RAISE EXCEPTION 'Expected exactly one village with slug lang-chuong';
  END IF;
END $$;
