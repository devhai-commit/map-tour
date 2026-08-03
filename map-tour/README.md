# Map Tour — Bản đồ Tour Du lịch Làng nghề

Ứng dụng web hiển thị các điểm tham quan du lịch trên bản đồ. Các địa điểm có
diện tích lớn (ví dụ: khu làng cổ, khu làng nghề) được biểu diễn bằng một
**đa giác** nối nhiều điểm ranh giới, thay vì chỉ một điểm đơn — thay vì một
marker không thể hiện hết phạm vi thực tế của địa điểm.

## Bối cảnh

Dữ liệu mẫu lấy chủ đề từ **Làng Ước Lễ** (Tân Ước, Hà Nội) — làng nghề giò
chả truyền thống, một trong các làng thí điểm được nêu trong đề tài nghiên
cứu "Nghiên cứu phát triển hệ thống du lịch thông minh khai thác thế mạnh
làng truyền thống vùng đồng bằng sông Hồng" (file `Thuyết minh NV làng
DLTM20251208_Final.pdf` trong thư mục dự án).

**Lưu ý:** toạ độ trong CSDL (seed mẫu ở `init/04_seed_sample.sql` của project
`lang-uoc-le-db`) là toạ độ ước lượng minh hoạ, chưa phải dữ liệu khảo sát
thực tế. File `TMB Ước lễ Full.pdf` (tổng mặt bằng) chứa bản vẽ quy hoạch chi
tiết nhưng ở dạng ảnh scan/CAD nên chưa thể trích xuất toạ độ tự động — cần
số hoá thủ công từ bản vẽ đó để thay thế dữ liệu mẫu bằng toạ độ chính xác.

## Cấu trúc dữ liệu & backend

Ứng dụng **không còn dùng dữ liệu tĩnh** — toàn bộ danh sách địa điểm được
đọc từ CSDL PostgreSQL (project `lang-uoc-le-db` ở thư mục gốc) qua một API
riêng nằm tại [`server/`](./server):

```
Frontend (Vite, cổng 5173)  ──fetch /api/sites──▶  server/ (Express, cổng 8787)  ──pg──▶  Postgres (docker-compose ở gốc repo)
```

- `server/` đọc cấu hình kết nối (`POSTGRES_DB/USER/PASSWORD/PORT`) trực tiếp
  từ file `.env` ở gốc repo — xem [`../docs/thiet-ke-csdl.md`](../docs/thiet-ke-csdl.md)
  cho thiết kế schema đầy đủ (bảng `villages`, `sites`, `media`, ...).
- `GET /api/sites` join bảng `sites` + `villages` + `media` (ảnh panorama) và
  trả về đúng shape `TourSite[]` mà frontend đã dùng trước đây (xem
  `src/types.ts`), nên các component (`TourMap`, `SiteList`, ...) không cần
  đổi khi nguồn dữ liệu đổi từ tĩnh sang CSDL.
- Frontend gọi qua hook `useSites()` (`src/context/SitesContext.tsx`) — fetch
  một lần ở gốc cây component và chia sẻ qua Context, tránh gọi API lặp lại ở
  mỗi trang.

Mỗi địa điểm (`TourSite`, xem `src/types.ts`) là một trong hai dạng:

- **`point`** — một điểm tọa độ đơn (`position: [lat, lng]`), dùng cho các
  công trình nhỏ như cổng làng, đình, chùa, giếng làng.
- **`area`** — một danh sách nhiều điểm tọa độ ranh giới
  (`boundary: [lat, lng][]`) được nối lại thành đa giác, dùng cho các khu
  vực có diện tích lớn như khu làng cổ, khu làng nghề.

Thêm địa điểm mới bằng cách thêm dòng vào bảng `sites` trong CSDL (qua
`scripts/psql-shell.ps1`/`.sh` ở gốc repo, hoặc Adminer), chọn
`kind = 'point'` hoặc `kind = 'area'` tuỳ theo quy mô thực tế của địa điểm —
không cần sửa code frontend.

## Nền bản đồ: MapLibre GL + PMTiles

Bản đồ nền dùng **MapLibre GL JS** (vector tile renderer) đọc trực tiếp file
`public/tiles/vietnam.pmtiles` — một gói dữ liệu bản đồ vector phủ toàn bộ
Việt Nam, đóng gói theo định dạng [PMTiles](https://protomaps.com/docs/pmtiles)
nên không cần máy chủ tile riêng: trình duyệt tải trực tiếp từng vùng dữ liệu
cần thiết từ file tĩnh này qua HTTP range request.

- File pmtiles đặt trong `public/tiles/` để Vite phục vụ nguyên trạng
  (không qua bundler) — thư mục `public/` hỗ trợ range request cần thiết cho
  pmtiles cả khi chạy `npm run dev` lẫn khi deploy file tĩnh.
- File này ~570MB nên đã được thêm vào `.gitignore` (`public/tiles/*.pmtiles`)
  — không commit vào git; khi thiết lập máy mới hoặc deploy, cần copy thủ
  công (hoặc qua Git LFS / object storage) file `vietnam.pmtiles` vào đúng
  đường dẫn `public/tiles/vietnam.pmtiles`.
- Nguồn dữ liệu `vietnam.pmtiles` được build bằng **Planetiler** theo
  **schema OpenMapTiles** (xác nhận qua metadata nội bộ file:
  `"name": "OpenMapTiles"`), *không* phải schema Protomaps — hai schema có
  tên layer trùng một phần nhưng field/thuộc tính bên trong khác nhau, nên
  bắt buộc phải dùng style khớp đúng schema OpenMapTiles, nếu không phần lớn
  layer (đường, nhãn địa danh, POI) sẽ không hiển thị dù dữ liệu vẫn có trong
  tile (bug đã gặp và sửa: xem `src/components/TourMap.tsx`).
- Style (màu sắc, layer nào hiển thị ở zoom nào) lấy từ
  [`osm-bright-gl-style`](https://github.com/openmaptiles/osm-bright-gl-style)
  của OpenMapTiles — bản JSON đã được điều chỉnh (bỏ `source.url` gắn key
  MapTiler, trỏ `glyphs`/`sprite` sang CDN miễn phí không cần API key) và lưu
  tại `src/assets/map/osm-bright-style.json`.
- Font chữ nhãn (glyphs) tải từ CDN công khai `tiles.openfreemap.org/fonts`
  (server glyph gốc `fonts.openmaptiles.org` đã ngừng phục vụ file `.pbf` —
  mọi request đều trả về trang HTML "redirecting" thay vì dữ liệu glyph,
  khiến MapLibre phải render cục bộ từng ký tự và log cảnh báo
  "Unable to load glyph range..."); sprite icon tải từ
  `openmaptiles.github.io/osm-bright-gl-style/sprite` — cần kết nối mạng để
  hiển thị nhãn địa danh/icon; có thể tự host lại các asset này nếu cần chạy
  hoàn toàn offline.
- Các điểm tham quan (`kind: 'point'`) hiển thị bằng `maplibregl.Marker`; các
  khu vực (`kind: 'area'`) hiển thị bằng layer `fill` + `line` từ một nguồn
  GeoJSON dựng từ `boundary` của từng địa điểm.
- Tên mỗi địa danh được chú thích trực tiếp trên bản đồ bằng layer `symbol`
  (nhãn phía trên marker cho điểm đơn, nhãn ở tâm đa giác cho khu vực).
- Tuyến đường nối 6 địa điểm tour chính (không gồm các điểm demo ngẫu nhiên)
  được vẽ theo **đường đi bộ thực tế**, lấy từ dịch vụ định tuyến công khai
  [OSRM (FOSSGIS, profile "foot")](https://routing.openstreetmap.de/) — không
  phải đường thẳng nối 2 điểm. Nếu request định tuyến thất bại (mất mạng, dịch
  vụ demo quá tải), tuyến đường sẽ không hiển thị thay vì vẽ đường thẳng sai
  lệch (xem `fetchFootRoute` trong `TourMap.tsx`).

## Xem ảnh 360° tại địa danh

Click vào nút **"Xem 360°"** (trong sidebar hoặc trong popup trên bản đồ) của
6 địa điểm tour gốc để mở một modal xem ảnh toàn cảnh 360° (panorama), dùng
thư viện [`@photo-sphere-viewer/core`](https://photo-sphere-viewer.js.org/).

- Cấu trúc dữ liệu: field optional `panorama: { url, attribution }` trên
  `TourSite` (xem `src/types.ts`).
- **Lưu ý quan trọng:** 6 ảnh trong `public/panoramas/` là ảnh phong cảnh
  CC0 tải từ [Poly Haven](https://polyhaven.com/hdris), chỉ được chọn vì
  *tương đồng chủ đề* (sân trong, phòng gỗ cũ, vườn kiểu Á Đông, ao nước,
  đường làng, xưởng ngoài trời) — **KHÔNG phải ảnh chụp thực tế** tại các
  địa điểm của Làng Ước Lễ. Cần thay bằng ảnh 360° thật (chụp tại chỗ) khi
  có điều kiện khảo sát thực địa; chỉ cần cập nhật lại `media.url` của bản
  ghi panorama tương ứng trong CSDL (bảng `media`, xem
  `init/04_seed_sample.sql`), không cần đổi code frontend.
- Địa điểm nào không có bản ghi `media` gắn `panorama_media_id` sẽ không
  hiển thị nút "Xem 360°".

## Chạy dự án

Cần chạy CSDL + API trước, rồi mới chạy frontend:

```bash
# 1. Ở thư mục gốc repo (lang-uoc-le-db/) — khởi động Postgres + API
cd ..
docker compose up -d postgres api

# 2. Ở thư mục này (map-tour/) — chạy frontend
cd map-tour
npm install
npm run dev
```

Mở địa chỉ hiển thị trong terminal (mặc định `http://localhost:5173`). Vite
proxy sẵn `/api` sang `http://localhost:8787` (cấu hình trong
`vite.config.ts`, đổi qua biến môi trường `VITE_API_PROXY_TARGET` nếu API
chạy ở nơi khác).

Muốn chạy API ngoài Docker (debug trực tiếp với `tsx watch`) thay cho
`docker compose up api`, xem [`server/README.md`](./server/README.md).

## Công nghệ sử dụng

- React + TypeScript + Vite
- [MapLibre GL JS](https://maplibre.org/) — vector tile renderer
- [pmtiles](https://github.com/protomaps/PMTiles) — đọc file `.pmtiles` trực tiếp từ trình duyệt, không cần tile server
- [osm-bright-gl-style](https://github.com/openmaptiles/osm-bright-gl-style) — style MapLibre khớp với schema OpenMapTiles của dữ liệu `vietnam.pmtiles`
