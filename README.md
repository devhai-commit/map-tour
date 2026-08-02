# lang-uoc-le-db

CSDL PostgreSQL độc lập cho dữ liệu di sản/du lịch làng Ước Lễ — không thuộc và không phụ thuộc vào bất kỳ ứng dụng frontend cụ thể nào.

- Thiết kế schema & lý do: [`docs/thiet-ke-csdl.md`](docs/thiet-ke-csdl.md), [`docs/thiet-ke-csdl.docx`](docs/thiet-ke-csdl.docx)
- Hướng dẫn triển khai bằng Docker: [`docs/trien-khai.md`](docs/trien-khai.md)

## Chạy nhanh (local/dev)

```bash
cp .env.example .env   # rồi đổi POSTGRES_PASSWORD
chmod +x scripts/*.sh
bash scripts/deploy.sh
bash scripts/psql-shell.sh
```

Xem [`docs/trien-khai.md`](docs/trien-khai.md) để biết cách triển khai trên server, backup/restore, và các lưu ý bảo mật.
