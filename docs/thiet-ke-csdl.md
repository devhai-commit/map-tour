# Thiết kế CSDL cho Map Tour — Làng Ước Lễ

Tài liệu này phân tích file khảo sát `khảo sát làng Ước Lễ.xlsx`, xác định phần dữ liệu nào nên đưa vào CSDL của ứng dụng map-tour, phần nào không cần, và đề xuất schema lưu trữ kèm lý do thiết kế.

## 1. Tổng quan file khảo sát gốc

File có **11 sheet**. Mỗi sheet (trừ sheet 2 và sheet 8) trình bày theo dạng **form khảo sát key–value**: cột `Nội dung` (tên trường), `Dữ liệu` (giá trị đã điền), `Thuộc tính` (kiểu dữ liệu: text/number/ảnh/bản đồ/bản vẽ), `Ghi chú` (hướng dẫn điền + gợi ý enum cho người đi khảo sát). Đây là **hướng dẫn nhập liệu**, không phải nội dung hiển thị — quan trọng cho việc thiết kế form nhập nhưng không lưu như dữ liệu của từng record.

Sheet 4.1–4.4 dùng **chung một schema ~60 trường** để mô tả 4 công trình khác nhau (đình Ước Lễ, chùa Sổ, nhà cụ Khả, nhà bà Bào) — về bản chất là 4 record của cùng 1 loại thực thể, chỉ bị tách thành 4 sheet riêng thay vì 4 dòng trong một bảng.


| # | Tên sheet | Vai trò | Số dòng thực tế |
|---|-----------|---------|------------------|
| 1 | Giới thiệu về làng | Hồ sơ định danh làng (1 record) | 13 |
| 2 | Bản đồ tổng thể của làng | Danh mục loại điểm/POI trên bản đồ | 81 |
| 3 | Lịch sử văn hóa | Lịch sử, sự kiện, phong tục, truyền thuyết | 7 |
| 4.1 | Kiến trúc đình Ước Lễ | Hồ sơ 1 công trình di sản | 63 |
| 4.2 | Kiến trúc Chùa Sổ | Hồ sơ 1 công trình di sản | 73 |
| 4.3 | Kiến trúc nhà cụ Khả | Hồ sơ 1 công trình di sản | 61 |
| 4.4 | Kiến trúc nhà bà Bào | Hồ sơ 1 công trình di sản | 59 |
| 5 | Hiện vật – Mỹ thuật trang trí | Đề tài trang trí + hiện vật cổ | 59 |
| 6 | Di sản văn hóa phi vật thể | Lễ hội, ẩm thực, nghề (phi vật thể) | 59 |
| 7 | Sản phẩm nghề truyền thống | Sản phẩm giò chả + khả năng làm du lịch | 39 |
| 8 | Điều tra xã hội học | **Rỗng — bỏ qua** | 0 |

## 2. Đối chiếu với ứng dụng hiện tại

Map-tour hiện là **web tĩnh** (React + Vite + TypeScript, không backend), "CSDL" hiện tại chỉ là một file `src/data/sites.ts` hardcode mảng `TourSite[]` (xem `src/types.ts`):

- `kind: 'point'` + `position: [lat, lng]` — cho công trình nhỏ (cổng, đình, giếng…)
- `kind: 'area'` + `boundary: [lat, lng][]` — cho khu vực lớn (khu làng cổ, khu làng nghề…)
- Các field chung: `id, name, category, description, village, panorama?`

Sheet 2 (Bản đồ tổng thể) của file khảo sát **khớp trực tiếp với mô hình này**: cột "Vị trí" ghi "Bản đồ" tương đương `point`/`area`, cột "Ảnh" tương đương media gắn kèm site. Đây là điểm neo tự nhiên để mở rộng dữ liệu khảo sát thật vào đúng cấu trúc app đang dùng, thay vì thiết kế lại từ đầu.

## 3. Phân loại: đưa vào CSDL hay không

### 3.1. Đưa vào CSDL

| Nhóm dữ liệu | Nguồn (sheet) | Vì sao cần |
|---|---|---|
| Thông tin làng | 1 | Nội dung cốt lõi cho trang "Giới thiệu", chỉ 1 record, không thay đổi thường xuyên — chi phí lưu thấp, giá trị hiển thị cao |
| Danh mục điểm/POI trên bản đồ | 2 | Đây **chính là** dữ liệu vận hành bản đồ — mục tiêu chính của app |
| Hồ sơ công trình di sản (rút gọn) | 4.1–4.4 | Khách du lịch cần biết: tên, chức năng, giá trị lịch sử, xếp hạng di tích, mô tả, ảnh — đây là nội dung "câu chuyện" hấp dẫn khách |
| Câu chuyện lịch sử/văn hóa | 3 | Nội dung kể chuyện, tăng giá trị trải nghiệm, tái sử dụng được ở nhiều nơi trong app (trang làng, trang công trình) |
| Đề tài mỹ thuật trang trí & hiện vật | 5 | Nội dung "khám phá sâu" cho khách quan tâm văn hóa — dạng gallery, gắn với công trình cụ thể |
| Di sản văn hóa phi vật thể | 6 | Trực tiếp phục vụ mục "trải nghiệm văn hóa" — có sẵn field "mức độ cho khách trải nghiệm", rất hợp với mục tiêu du lịch |
| Sản phẩm nghề truyền thống (phần hướng khách) | 7 (một phần) | Mục "KHẢ NĂNG PHÁT TRIỂN SẢN PHẨM DU LỊCH" trong sheet này thiết kế sẵn cho đúng mục đích app: trải nghiệm, quà tặng, kênh tiếp cận khách |
| Media (ảnh, bản vẽ, panorama, video) | tất cả sheet | Xuất hiện lặp lại ở mọi sheet — nên tách thành 1 loại thực thể dùng chung thay vì nhân bản field ảnh ở mỗi bảng |

### 3.2. Không đưa vào CSDL (hoặc tách riêng khỏi tầng hiển thị công khai)

| Dữ liệu | Nguồn | Lý do loại/tách |
|---|---|---|
| Toàn bộ sheet 8 | 8 | Rỗng hoàn toàn, chưa có dữ liệu thật — không có gì để lưu |
| Số đo kỹ thuật chi tiết công trình (đường kính cột theo mm, kích thước/kiểu chân tảng, độ sâu tam cấp, cấu tạo bộ vì…) | 4.1–4.4 | Phục vụ hồ sơ kiểm kê/bảo tồn di tích (đối tượng: nhà nghiên cứu, cơ quan quản lý di tích), không phải nội dung khách du lịch cần khi xem trên bản đồ. Giữ quá nhiều field kỹ thuật vụn trong bảng chính làm phình schema và không ai dùng ở tầng app. |
| Số liệu kinh doanh nội bộ (doanh thu bình quân/năm, khó khăn hiện tại, nhu cầu hỗ trợ) | 7 | Dữ liệu nhạy cảm về kinh tế hộ kinh doanh — không nên public trên app khách; có giá trị cho báo cáo/quy hoạch địa phương hơn là cho khách tham quan |
| Cột "Ghi chú" (hướng dẫn khảo sát, gợi ý enum, cách chụp ảnh) | mọi sheet | Là tài liệu hướng dẫn cho người đi khảo sát điền form — dùng để thiết kế form nhập liệu/validation, không phải nội dung của từng record cần hiển thị |

**Nguyên tắc chung áp dụng:** một field chỉ vào bảng "nội dung công khai" nếu nó **trực tiếp phục vụ trải nghiệm hoặc quyết định của khách du lịch** (xem gì, ở đâu, vì sao đặc biệt, có trải nghiệm được không). Field mang tính hồ sơ kỹ thuật/kiểm kê hoặc nhạy cảm về kinh doanh được tách sang bảng phụ "nội bộ" (`*_internal` / `*_technical_details`) — vẫn có thể lưu nếu muốn giữ đầy đủ dữ liệu khảo sát, nhưng không truy vấn ở tầng hiển thị công khai.

## 4. Schema đề xuất

### `villages` — hồ sơ làng (từ sheet 1)
1 record duy nhất trong phạm vi app hiện tại (1 làng), nhưng thiết kế dạng bảng để mở rộng nhiều làng sau này thay vì hardcode "1 làng = 1 config".

```
id, name, aliases[], admin_location, google_maps_link,
founded_period, brand_identity, name_meaning,
main_occupations[], natural_features, site_selection_history,
morphology_description, morphology_diagram_media_id
```

### `sites` — điểm/khu vực trên bản đồ (mở rộng `TourSite` hiện tại, từ sheet 2)
Bảng trung tâm của app — mọi thứ hiển thị trên bản đồ đều là 1 dòng ở đây.

```
id, village_id, kind ('point' | 'area'),
position [lat,lng] | boundary [lat,lng][],
name, category, sub_category,
short_description,
light_count_25m? (number),
history_culture_note? (text),
cover_media_id, panorama_media_id?,
heritage_building_id? (FK, nullable)
```

- `category`/`sub_category` chuẩn hóa theo đúng cây phân loại của sheet 2: `giao_thong` (đường chính/nhánh/theo vật liệu), `cong_trinh_cong_cong` (quán, điếm, chợ, cổng, đình, chùa, miếu, đền, nhà thờ họ…), `nha_o`, `cay`, `dat_nong_nghiep`, `mat_nuoc` — giữ nguyên taxonomy khảo sát để không mất thông tin phân loại gốc, thay vì dùng chuỗi tự do như dữ liệu demo hiện tại (`category: 'Nhà dân'`, `'Ao nhỏ'`…).
- `heritage_building_id` là **cầu nối** duy nhất: site nào có hồ sơ kiến trúc sâu (đình, chùa, nhà cổ) thì trỏ sang bảng `heritage_buildings`; site không có hồ sơ sâu (cây cổ thụ, giếng, đường…) để trống — tránh bắt mọi site phải có đủ 60 field kiến trúc.

### `heritage_buildings` — hồ sơ công trình di sản, **rút gọn** (từ sheet 4.1–4.4)
Chỉ giữ phần "editorial" — thông tin đủ để kể chuyện và định danh di tích, bỏ phần đo đạc kỹ thuật thô.

```
id, site_id (FK), name, address, function, ownership,
land_area_m2?, floor_area_m2?,
heritage_rank?, heritage_rank_year?, heritage_style_type?,
managing_unit?,
overall_structure_description, cultural_historical_value,
built_period, restoration_note?,
gallery_media_ids[]
```

**Lý do rút gọn:** sheet gốc có nhóm field Mái/Hiên/Nền/Kết cấu với hàng chục thông số (vật liệu mái, kiểu lát nền, chiều cao/đường kính cột theo mm, kiểu chân tảng…). Đây là dữ liệu **kiểm kê kiến trúc**, đúng đối tượng dùng là hồ sơ xếp hạng di tích/nghiên cứu bảo tồn — nếu đưa hết vào bảng chính, mỗi lần hiển thị 1 công trình trên app phải kéo theo 60 field mà giao diện khách du lịch không dùng đến. Nếu vẫn cần giữ đầy đủ (ví dụ để phục vụ hồ sơ di tích sau này), tách thành bảng phụ 1–1, không bắt buộc tầng hiển thị phải load:

```
heritage_building_technical_details
  id, building_id (FK, unique),
  roof_layers, roof_shape, roof_material, roof_color,
  facade_material, facade_condition,
  floor_material, floor_pattern,
  structure_material, structure_condition,
  column_height_cm?, column_diameter_cm?,
  pedestal_material?, pedestal_size?, pedestal_type?,
  floor_plan_drawing_media_id?, section_drawing_media_id?
```

### `history_stories` — lịch sử/sự kiện/phong tục/truyền thuyết (từ sheet 3)
Thiết kế dạng danh sách bài viết ngắn thay vì field cố định, vì bản chất nội dung này là **kể chuyện nhiều mục**, không phải thuộc tính đơn của làng — hơn nữa cùng cấu trúc này còn dùng lại được cho phong tục/sự kiện gắn với 1 công trình cụ thể (không chỉ gắn với làng).

```
id, village_id, site_id? (FK, nullable),
type ('lich_su' | 'su_kien' | 'phong_tuc' | 'truyen_thuyet'),
title, body_text, media_ids[]
```

### `decorative_art_items` — đề tài mỹ thuật trang trí & hiện vật cổ (từ sheet 5)
```
id, building_id (FK),
theme_group ('tin_nguong_ton_giao' | 'doi_song_sinh_hoat' | 'phong_thuy_cat_tuong' | 'hien_vat_co'),
subject_name, era_estimate?, description, media_ids[]
```
Gộp "đề tài trang trí" và "hiện vật cổ" (2 phần lớn trong sheet 5) vào 1 bảng vì cả hai đều có cùng hình dạng dữ liệu (chủ đề + ảnh + niên đại + mô tả, gắn với 1 công trình) — tách 2 bảng riêng sẽ chỉ là trùng lặp schema không cần thiết (theo nguyên tắc DRY).

### `intangible_heritage_items` — di sản văn hóa phi vật thể (từ sheet 6)
```
id, village_id, name,
recognition_level? ('unesco' | 'quoc_gia' | 'tinh' | null),
uniqueness_description,
participation_scope ('mot_nhom_hoi' | 'nhieu_nhom_hoi' | 'toan_the_cong_dong'),
generations_transmitted?,
tourist_experience_level ('chi_xem' | 'trai_nghiem_mot_phan' | 'trai_nghiem_toan_bo'),
event_timing, capacity_note?, media_ids[]
```
Field `tourist_experience_level` và `participation_scope` giữ nguyên vì sheet khảo sát đã thiết kế sẵn dạng enum có ý nghĩa trực tiếp cho việc gợi ý trải nghiệm trên app (ví dụ: lọc "di sản khách có thể trải nghiệm toàn bộ").

### `craft_products` — sản phẩm nghề truyền thống, phần hướng khách (từ sheet 7)
```
id, village_id, name, product_group, start_period,
is_traditional, cultural_link_level,
materials, product_story, process_description, process_media_ids[],
gift_suitability?, has_experience_activity, experience_duration?,
has_demo_space, has_display_area, has_guide_staff,
sales_channels[], main_market
```
Đây là bảng công khai — không chứa `average_revenue`, `current_difficulties`, `support_needs` (xem bảng nội bộ dưới).

```
craft_products_internal
  id, product_id (FK, unique),
  average_output_per_year?, average_revenue_per_year?,
  current_difficulties?, support_needs?
```
Tách riêng để đảm bảo dữ liệu kinh doanh nhạy cảm không vô tình bị lộ ra tầng API/hiển thị công khai — về nguyên tắc bảo mật, tách bảng theo mức độ nhạy cảm an toàn hơn là dùng flag `is_internal` trên từng field của 1 bảng chung.

### `media` — bảng dùng chung cho ảnh/bản vẽ/panorama/video
```
id, url, kind ('anh' | 'ban_ve' | 'panorama' | 'video'),
attribution?, caption?,
owner_entity_type, owner_entity_id
```
Thiết kế polymorphic (`owner_entity_type` + `owner_entity_id`) vì ảnh xuất hiện lặp lại ở **mọi** sheet khảo sát với vai trò giống nhau — nếu để field ảnh riêng ở từng bảng (`cover_media_id`, `gallery_media_ids`…) thì vẫn cần 1 nơi lưu bản thân file media (url, attribution, loại) tránh lặp thông tin khi 1 ảnh được dùng ở nhiều chỗ.

### Sơ đồ quan hệ

```
villages 1───N sites
sites    1───0..1 heritage_buildings ───1───0..1 heritage_building_technical_details
heritage_buildings 1───N decorative_art_items
villages 1───N history_stories (site_id optional)
villages 1───N intangible_heritage_items
villages 1───N craft_products ───1───0..1 craft_products_internal
(mọi bảng trên) 1───N media  (qua owner_entity_type/owner_entity_id)
```

## 5. Vì sao thiết kế theo hướng này

- **Bám theo taxonomy đã có trong khảo sát** (loại POI ở sheet 2, nhóm đề tài trang trí ở sheet 5, mức độ trải nghiệm ở sheet 6…) thay vì tự đặt lại — dữ liệu khảo sát đã được người có chuyên môn (kiến trúc/di sản) thiết kế enum hợp lý, giữ nguyên giúp không mất ý nghĩa và không cần đàm phán lại phân loại.
- **Tách nội dung "công khai cho khách" khỏi nội dung "hồ sơ kỹ thuật/nội bộ"** thành các bảng riêng (`heritage_building_technical_details`, `craft_products_internal`) — vì hai nhóm dữ liệu này có đối tượng dùng, mức độ nhạy cảm và tần suất truy vấn khác nhau; gộp chung sẽ buộc tầng hiển thị phải lọc field mỗi lần đọc và tăng rủi ro lộ dữ liệu nhạy cảm.
- **`sites` là bảng trung tâm, khớp với model `TourSite` đang chạy thật trong app** (`src/types.ts`) — mở rộng thay vì thiết kế lại, để dữ liệu khảo sát mới có thể đổ thẳng vào cấu trúc app hiện có mà không phải viết lại tầng hiển thị/bản đồ.
- **`heritage_building_id` là FK nullable từ `sites`**, không phải merge 2 bảng thành 1 — vì phần lớn site (đường, cây, giếng…) không có và không cần 60 field kiến trúc; bắt buộc tất cả site phải có đủ field đó sẽ tạo ra rất nhiều cột `NULL` không cần thiết.
- **Bảng `media` dùng chung, polymorphic** — vì ảnh/bản vẽ/panorama xuất hiện lặp lại với vai trò giống nhau ở mọi sheet khảo sát; tránh lặp lại cấu trúc lưu ảnh ở 7 bảng khác nhau (nguyên tắc DRY).
- **`history_stories` và `decorative_art_items` thiết kế dạng danh sách (nhiều dòng) thay vì field cố định** — vì nội dung kể chuyện/mỹ thuật có số lượng mục không cố định (1 làng có thể có nhiều sự kiện lịch sử, 1 công trình có thể có nhiều đề tài trang trí) và bản chất là nội dung mở, không phải thuộc tính đơn giá trị.
- **Sheet 8 bị loại hoàn toàn khỏi thiết kế** — không có dữ liệu, nên không có gì để mô hình hóa; khi nào khảo sát này được điền thật, cần phân tích lại nội dung cụ thể trước khi thiết kế bảng tương ứng (khảo sát xã hội học thường có cấu trúc rất khác: theo hộ dân/theo người trả lời, cần bảng riêng dạng "respondents" + "answers", không nên đoán trước khi có dữ liệu mẫu thật).

## 6. Bảng mapping nhanh: Sheet Excel → Bảng CSDL

| Sheet Excel | Bảng CSDL tương ứng | Ghi chú |
|---|---|---|
| 1. Giới thiệu về làng | `villages` | Toàn bộ field đưa vào, 1 record |
| 2. Bản đồ tổng thể của làng | `sites` | Mỗi loại đối tượng → 1 hoặc nhiều record `sites`, `category`/`sub_category` theo đúng cây phân loại trong sheet |
| 3. Lịch sử văn hóa | `history_stories` | Mỗi mục (lịch sử/sự kiện/phong tục/truyền thuyết) → 1 record, `type` phân biệt |
| 4.1–4.4. Kiến trúc… | `heritage_buildings` (phần editorial) + `heritage_building_technical_details` (phần đo đạc, tùy chọn) | Mỗi sheet → 1 record ở cả 2 bảng, liên kết `1:1` |
| 5. Hiện vật – Mỹ thuật trang trí | `decorative_art_items` | Mỗi đề tài/hiện vật → 1 record, `theme_group` phân biệt nhóm |
| 6. Di sản văn hóa phi vật thể | `intangible_heritage_items` | Mỗi mục lớn (Lễ hội làng, Tết bù, Ẩm thực giò chả) → 1 record |
| 7. Sản phẩm nghề truyền thống | `craft_products` (phần hướng khách) + `craft_products_internal` (phần kinh doanh, tùy chọn) | 1 record ở cả 2 bảng |
| 8. Điều tra xã hội học | *(không có)* | Sheet rỗng, chưa thiết kế |
| Cột "Ảnh"/"Bản vẽ"/"Panorama" ở mọi sheet | `media` | Mỗi tham chiếu ảnh → 1 record `media`, gắn `owner_entity_type`/`owner_entity_id` về bảng gốc |

## 7. Ghi chú về công nghệ lưu trữ (chưa triển khai)

Bản thiết kế trên là **schema logic**, độc lập với việc triển khai bằng công nghệ gì. Dự án hiện là web tĩnh không backend, nên có 2 hướng khi triển khai thật:

- **JSON/TS tĩnh theo entity** — mỗi bảng ở trên thành 1 file JSON (`villages.json`, `sites.json`, `heritage_buildings.json`…), liên kết qua `id` giống FK, ảnh lưu trong `public/`. Phù hợp nếu nội dung ít thay đổi và dev là người cập nhật.
- **CSDL thực (Postgres/SQLite) + backend nhỏ hoặc dịch vụ như Supabase/Directus** — cần nếu muốn người không biết code tự nhập/sửa dữ liệu qua giao diện quản trị, upload ảnh trực tiếp, hoặc dữ liệu sẽ mở rộng thêm nhiều làng/công trình về sau.

Quyết định giữa 2 hướng này chưa được chốt (xem thảo luận trong phiên làm việc) — schema ở trên áp dụng được cho cả hai, chỉ khác cách hiện thực hóa quan hệ (`FK` thật trong CSDL, hay `id` tham chiếu chéo giữa các file JSON).
