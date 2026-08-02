-- Bật extension sinh UUID (gen_random_uuid) — cần cho PostgreSQL 13-15.
-- PostgreSQL 16 đã có gen_random_uuid() built-in nhưng bật thêm không gây hại.
CREATE EXTENSION IF NOT EXISTS pgcrypto;
