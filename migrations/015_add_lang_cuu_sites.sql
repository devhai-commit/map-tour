-- Giai đoạn tối thiểu: chỉ tạo village Làng Cựu.
INSERT INTO villages (id, name, slug, admin_location, founded_period, main_occupations)
SELECT 'c33319de-4845-41bf-94c1-3fa501e5e867', 'Làng Cựu', 'lang-cuu',
       'Xã Chuyên Mỹ, TP. Hà Nội (trước xã Vân Từ, huyện Phú Xuyên, TP. Hà Nội)',
       'khoảng thế kỷ XIII', ARRAY[]::text[]
WHERE NOT EXISTS (SELECT 1 FROM villages WHERE slug='lang-cuu');

DO $$ BEGIN
  IF (SELECT count(*) FROM villages WHERE slug='lang-cuu') <> 1 THEN
    RAISE EXCEPTION 'Expected exactly one village with slug lang-cuu';
  END IF;
END $$;
