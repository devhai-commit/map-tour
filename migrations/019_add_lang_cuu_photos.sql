-- Chưa có ảnh đại diện cấp village có thể xác định authoritative.
DO $$ BEGIN
  IF (SELECT count(*) FROM villages WHERE slug='lang-cuu') <> 1 THEN
    RAISE EXCEPTION 'Village lang-cuu must exist before photo registration';
  END IF;
END $$;
