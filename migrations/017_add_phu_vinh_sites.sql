-- Giai đoạn tối thiểu: chỉ tạo village Phú Vinh.
INSERT INTO villages (id, name, slug, admin_location, founded_period, main_occupations)
SELECT '8216fe86-f66d-4b19-904b-cbdee0bf1eba', 'Phú Vinh', 'phu-vinh',
       'Xã Phú Nghĩa, TP Hà Nội (trước là xã Phú Nghĩa, huyện Chương Mỹ, thành phố Hà Nội)',
       'Từ năm 1700 (đầu TK 17)', ARRAY[]::text[]
WHERE NOT EXISTS (SELECT 1 FROM villages WHERE slug='phu-vinh');

DO $$ BEGIN
  IF (SELECT count(*) FROM villages WHERE slug='phu-vinh') <> 1 THEN
    RAISE EXCEPTION 'Expected exactly one village with slug phu-vinh';
  END IF;
END $$;
