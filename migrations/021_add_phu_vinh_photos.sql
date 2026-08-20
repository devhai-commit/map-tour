-- Chưa có ảnh đại diện cấp village có thể xác định authoritative.
DO $$ BEGIN
  IF (SELECT count(*) FROM villages WHERE slug='phu-vinh') <> 1 THEN
    RAISE EXCEPTION 'Village phu-vinh must exist before photo registration';
  END IF;
END $$;
