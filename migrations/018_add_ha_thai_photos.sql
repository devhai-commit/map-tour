-- Chưa có ảnh đại diện cấp village có thể xác định authoritative. Schema/API
-- hiện chỉ suy ra cover từ site, nên không tạo site/media giả từ tên file.
DO $$ BEGIN
  IF (SELECT count(*) FROM villages WHERE slug='ha-thai') <> 1 THEN
    RAISE EXCEPTION 'Village ha-thai must exist before photo registration';
  END IF;
END $$;
