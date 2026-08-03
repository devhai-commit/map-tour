# lang-uoc-le-db

CSDL PostgreSQL độc lập cho dữ liệu di sản/du lịch làng Ước Lễ — không thuộc và không phụ thuộc vào bất kỳ ứng dụng frontend cụ thể nào.

- Thiết kế schema & lý do: [`docs/thiet-ke-csdl.md`](docs/thiet-ke-csdl.md), [`docs/thiet-ke-csdl.docx`](docs/thiet-ke-csdl.docx)
- Hướng dẫn triển khai bằng Docker: [`docs/trien-khai.md`](docs/trien-khai.md)
- API đọc dữ liệu cho ứng dụng map-tour: [`map-tour/server`](map-tour/server) (service `api` trong `docker-compose.yml`, xem [`map-tour/README.md`](map-tour/README.md))

## Chạy nhanh (local/dev)

**Linux/macOS:**
```bash
cp .env.example .env   # rồi đổi POSTGRES_PASSWORD
chmod +x scripts/*.sh
bash scripts/deploy.sh
bash scripts/psql-shell.sh
```

**Windows (PowerShell):**
```powershell
Copy-Item .env.example .env   # rồi đổi POSTGRES_PASSWORD
.\scripts\deploy.ps1
.\scripts\psql-shell.ps1
```
Bản Windows dùng file `.ps1` tương ứng trong `scripts/` (`deploy.ps1`, `backup.ps1`, `restore.ps1`, `psql-shell.ps1`) — không cần `chmod`, không phụ thuộc `gzip`/bash. Nếu PowerShell chặn chạy script chưa ký, mở PowerShell với quyền phù hợp và chạy một lần:
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Xem [`docs/trien-khai.md`](docs/trien-khai.md) để biết cách triển khai trên server, backup/restore, và các lưu ý bảo mật.
