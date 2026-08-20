-- Chưa có ảnh đại diện cấp village có thể xác định authoritative.
DO $$ BEGIN
  IF (SELECT count(*) FROM villages WHERE slug='lang-chuong') <> 1 THEN
    RAISE EXCEPTION 'Village lang-chuong must exist before photo registration';
  END IF;
END $$;
