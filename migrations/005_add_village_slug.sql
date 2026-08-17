-- Thêm cột slug cho villages để dùng làm định danh trên URL (vd. /lang/lang-uoc-le)
-- thay vì lộ uuid ra route. Cần thiết vì app đang mở rộng từ 1 làng sang nhiều
-- làng — mỗi làng cần một đường dẫn ổn định, dễ đọc.
-- Backfill cho bản ghi đã seed sẵn trước khi bật ràng buộc NOT NULL/UNIQUE;
-- các bản ghi được tạo qua luồng import Excel (importCommit.ts) tự tính slug
-- khi upsert nên không cần backfill thêm cho tương lai.

ALTER TABLE villages ADD COLUMN slug text;

UPDATE villages SET slug = 'lang-uoc-le' WHERE name = 'Làng Ước Lễ';

ALTER TABLE villages ALTER COLUMN slug SET NOT NULL;
ALTER TABLE villages ADD CONSTRAINT uq_villages_slug UNIQUE (slug);
