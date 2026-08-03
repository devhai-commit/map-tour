-- Gắn ảnh cover (ảnh phẳng, khác panorama 360°) cho 6 site đã tồn tại,
-- dùng ảnh thật trong map-tour/public/heritage/ (thay placeholder CC0 cũ).
-- Idempotent: chỉ insert nếu site đó chưa có cover_media_id.

INSERT INTO media (url, kind, owner_entity_type, owner_entity_id)
SELECT '/heritage/cong-lang.jpg', 'anh', 'sites', s.id
FROM sites s WHERE s.name = 'Cổng làng Ước Lễ' AND s.cover_media_id IS NULL;

INSERT INTO media (url, kind, owner_entity_type, owner_entity_id)
SELECT '/heritage/dinh-lang.jpg', 'anh', 'sites', s.id
FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.cover_media_id IS NULL;

INSERT INTO media (url, kind, owner_entity_type, owner_entity_id)
SELECT '/heritage/chua-lang.jpg', 'anh', 'sites', s.id
FROM sites s WHERE s.name = 'Chùa làng Ước Lễ' AND s.cover_media_id IS NULL;

INSERT INTO media (url, kind, owner_entity_type, owner_entity_id)
SELECT '/heritage/gieng-lang.jpg', 'anh', 'sites', s.id
FROM sites s WHERE s.name = 'Giếng làng' AND s.cover_media_id IS NULL;

INSERT INTO media (url, kind, owner_entity_type, owner_entity_id)
SELECT '/heritage/khu-lang.jpg', 'anh', 'sites', s.id
FROM sites s WHERE s.name = 'Khu làng cổ' AND s.cover_media_id IS NULL;

INSERT INTO media (url, kind, owner_entity_type, owner_entity_id)
SELECT '/heritage/khu-lang-gio-cha.jpg', 'anh', 'sites', s.id
FROM sites s WHERE s.name = 'Khu làng nghề giò chả' AND s.cover_media_id IS NULL;

UPDATE sites s
SET cover_media_id = m.id
FROM media m
WHERE m.owner_entity_type = 'sites' AND m.owner_entity_id = s.id AND m.kind = 'anh' AND s.cover_media_id IS NULL;
