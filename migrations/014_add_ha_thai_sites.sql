-- Giai đoạn tối thiểu: chỉ tạo village Hạ Thái. Chưa có dataset chính thức
-- cho sites/heritage/decorative nên không tạo các entity đó.
INSERT INTO villages (id, name, slug, admin_location, founded_period, main_occupations)
SELECT 'fdd98e46-3b65-490d-aadc-dbb90eab321d', 'Hạ Thái', 'ha-thai',
       'Xã Hồng Vân, Hà Nội', 'Khoảng thế kỷ XVII (nghề sơn) / Thế kỷ XVIII (làng)',
       ARRAY['Nghề sơn mài truyền thống', 'Nghề nông']
WHERE NOT EXISTS (SELECT 1 FROM villages WHERE slug='ha-thai');

DO $$ BEGIN
  IF (SELECT count(*) FROM villages WHERE slug='ha-thai') <> 1 THEN
    RAISE EXCEPTION 'Expected exactly one village with slug ha-thai';
  END IF;
END $$;
