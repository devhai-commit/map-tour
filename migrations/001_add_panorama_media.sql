-- Bổ sung media panorama cho 6 site đã tồn tại (tạo trước khi có schema
-- media/panorama_media_id đầy đủ trong lần seed đầu). Khớp theo s.name vì
-- id các site này được sinh ngẫu nhiên (gen_random_uuid()) ở lần seed cũ,
-- không cố định như trong init/04_seed_sample.sql (bản mới).
-- Idempotent: chỉ insert nếu site đó chưa có panorama_media_id.

INSERT INTO media (url, kind, attribution, owner_entity_type, owner_entity_id)
SELECT '/panoramas/cong-lang-uoc-le.jpg', 'panorama', '"Courtyard" by Greg Zaal (CC0, Poly Haven)', 'sites', s.id
FROM sites s WHERE s.name = 'Cổng làng Ước Lễ' AND s.panorama_media_id IS NULL
RETURNING id, owner_entity_id;

INSERT INTO media (url, kind, attribution, owner_entity_type, owner_entity_id)
SELECT '/panoramas/dinh-lang-uoc-le.jpg', 'panorama', '"Old Room" by Sergej Majboroda (CC0, Poly Haven)', 'sites', s.id
FROM sites s WHERE s.name = 'Đình làng Ước Lễ' AND s.panorama_media_id IS NULL;

INSERT INTO media (url, kind, attribution, owner_entity_type, owner_entity_id)
SELECT '/panoramas/chua-lang-uoc-le.jpg', 'panorama', '"Ninomaru Teien" by Greg Zaal (CC0, Poly Haven)', 'sites', s.id
FROM sites s WHERE s.name = 'Chùa làng Ước Lễ' AND s.panorama_media_id IS NULL;

INSERT INTO media (url, kind, attribution, owner_entity_type, owner_entity_id)
SELECT '/panoramas/gieng-lang.jpg', 'panorama', '"Pond" by Greg Zaal (CC0, Poly Haven)', 'sites', s.id
FROM sites s WHERE s.name = 'Giếng làng' AND s.panorama_media_id IS NULL;

INSERT INTO media (url, kind, attribution, owner_entity_type, owner_entity_id)
SELECT '/panoramas/khu-lang-co.jpg', 'panorama', '"Small Rural Road" by Andreas Mischok (CC0, Poly Haven)', 'sites', s.id
FROM sites s WHERE s.name = 'Khu làng cổ' AND s.panorama_media_id IS NULL;

INSERT INTO media (url, kind, attribution, owner_entity_type, owner_entity_id)
SELECT '/panoramas/khu-lang-nghe-gio-cha.jpg', 'panorama', '"Outdoor Workshop" by Dimitrios Savva & Jarod Guest (CC0, Poly Haven)', 'sites', s.id
FROM sites s WHERE s.name = 'Khu làng nghề giò chả' AND s.panorama_media_id IS NULL;

-- Gắn panorama_media_id trên sites về đúng media row vừa tạo (khớp qua owner_entity_id = sites.id)
UPDATE sites s
SET panorama_media_id = m.id
FROM media m
WHERE m.owner_entity_type = 'sites' AND m.owner_entity_id = s.id AND s.panorama_media_id IS NULL;
