-- Tách quyền tối thiểu cho tài khoản mà backend/API sẽ dùng để kết nối,
-- thay vì dùng thẳng superuser (POSTGRES_USER) trong ứng dụng.
-- Đổi mật khẩu bên dưới trước khi dùng thật (không hardcode mật khẩu thật
-- trong file này khi commit lên git).
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'lang_uoc_le_readwrite') THEN
    CREATE ROLE lang_uoc_le_readwrite LOGIN PASSWORD 'change_me_app_password';
  END IF;
END
$$;

-- Dùng current_database() thay vì hardcode tên DB, vì tên thật lấy từ
-- POSTGRES_DB trong .env và có thể khác giá trị mẫu "lang_uoc_le".
DO $$
BEGIN
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO lang_uoc_le_readwrite', current_database());
END
$$;

GRANT USAGE ON SCHEMA public TO lang_uoc_le_readwrite;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO lang_uoc_le_readwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO lang_uoc_le_readwrite;
