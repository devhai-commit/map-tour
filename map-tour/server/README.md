# map-tour API

API tối giản cho ứng dụng map-tour — đọc dữ liệu điểm tham quan từ CSDL
Postgres của project `lang-uoc-le-db` (thư mục gốc repo) và trả về đúng shape
`TourSite[]` mà frontend cần (xem `../src/types.ts`).

## Chạy qua Docker (khuyến nghị)

Từ thư mục gốc repo:

```bash
docker compose up -d postgres api
```

Service `api` build từ `Dockerfile` ở đây, tự nối vào network Docker nội bộ
với Postgres (`POSTGRES_HOST=postgres`), không cần cấu hình gì thêm ngoài
`.env` ở gốc repo.

## Chạy trực tiếp (không qua Docker, để debug)

```bash
npm install
npm run dev
```

Đọc cấu hình kết nối từ `.env` ở gốc repo (`../../.env`), mặc định kết nối
tới `127.0.0.1:${POSTGRES_PORT}` — đúng với cổng Postgres đã publish ra host
qua `docker compose up -d postgres` (không cần chạy service `api` trong
Docker cùng lúc).

Biến môi trường (đều optional, có default hợp lý cho dev):

| Biến | Default | Ghi chú |
|---|---|---|
| `POSTGRES_HOST` | `127.0.0.1` | Đổi thành `postgres` khi chạy trong network Docker Compose |
| `POSTGRES_PORT` | lấy từ `.env` gốc | Cổng Postgres đã publish ra host |
| `API_PORT` | `8787` | Cổng HTTP của API |
| `CORS_ORIGIN` | `http://localhost:5173` | Origin frontend được phép gọi API |

## Endpoint

- `GET /api/health` — kiểm tra API còn sống.
- `GET /api/sites` — danh sách toàn bộ điểm tham quan, join từ bảng
  `sites` + `villages` + `media` (ảnh panorama).
