-- Thêm 4 mục lịch sử/văn hóa (history_stories) cho làng Ước Lễ, lấy nguyên văn
-- từ sheet "3. Lịch sử văn hóa" trong file "Ước Lễ.xlsx", theo đúng 4 nhãn cột
-- "Dữ liệu" mà bộ import Excel của ứng dụng nhận diện (xem HISTORY_TYPES trong
-- map-tour/server/src/lib/importParse.ts): "Lịch sử làng" (lich_su), "Sự kiện
-- lịch sử đã diễn ra" (su_kien), "Phong tục" (phong_tuc), "Truyền thuyết"
-- (truyen_thuyet). Làng Ước Lễ trước migration này chưa có bản ghi
-- history_stories nào (khác với làng Cự Đà, xem migrations/006, vốn đã có 3/4
-- mục — chỉ thiếu đúng "Sự kiện lịch sử đã diễn ra" vì ô này rỗng trong file
-- nguồn "Làng Cự Đà.xlsx", nên KHÔNG thêm mục su_kien nào cho Cự Đà ở đây, để
-- tránh bịa dữ liệu ngoài nguồn).
--
-- Nội dung giữ nguyên văn từng ô, không rút gọn/diễn giải lại, theo đúng
-- nguyên tắc của migration 004/006. title đặt đúng bằng tên nhãn (giống cách
-- 3 mục đã có sẵn của Cự Đà đang được lưu — ví dụ title = "Phong tục", không
-- phải tên sự kiện cụ thể), period không áp dụng (NULL) vì tiêu đề không có
-- dạng "Thế kỷ/Thời .../Năm ..." mà findVillageDetailsBySlug()
-- (map-tour/server/src/services/villages.ts) nhận diện cho dòng thời gian —
-- khớp đúng cách 3 mục hiện có của Cự Đà đang hoạt động (không xuất hiện ở mục
-- "Lịch sử hình thành", mà "Sự kiện lịch sử đã diễn ra" xuất hiện dưới dạng 1 ô
-- trong lưới "Phong tục và nghĩa tình" vì type='su_kien' và không có period).
--
-- Idempotent: mỗi INSERT dùng id cố định + ON CONFLICT (id) DO NOTHING, chạy
-- lại nhiều lần cho kết quả như nhau. Đã pg_dump --data-only villages +
-- history_stories trước khi áp dụng lên CSDL đang chạy.

INSERT INTO history_stories (id, village_id, type, title, body_text)
VALUES
  ('41000000-0000-0000-0000-000000000001',
   (SELECT id FROM villages WHERE slug = 'lang-uoc-le'), 'lich_su', 'Lịch sử làng',
   'Ước Lễ nổi tiếng với nghề làm giò chả. Nghề làm giò chả ở làng Ước Lễ có cách đây gần 500 năm. Theo truyền miệng, thời nhà Mạc (1527 - 1592) có một cung tần trong triều đình vốn là người làng Ước Lễ về xây cổng làng và dạy cho dân làng nghề giò chả. Từ đó cha truyền con nối, nghề giò chả trở thành nghề truyền thống của làng Ước Lễ.'),

  ('41000000-0000-0000-0000-000000000002',
   (SELECT id FROM villages WHERE slug = 'lang-uoc-le'), 'su_kien', 'Sự kiện lịch sử đã diễn ra',
   $body$Theo thông tin lịch sử, cổng làng Ước Lễ được xây dựng vào năm 1851 (đời vua Tự Đức). Làng Ước Lễ là một trong số ít làng xây dựng được quỹ cứu trợ người dân trong những lúc gặp khó khăn: loạn lạc, mất mùa,...  có những lúc quỹ cứu trợ này lên tới 2000 đồng Đông Dương. Theo luật lệ thời đó, các làng xây dựng được quỹ cứu trợ 1000 đồng Đông Dương đã được vua ban thưởng, nên làng Ước Lễ đã được vua ngự ban cho biển “Mỹ tục khả phong” (Phong tục hay nên theo). Đến thời chống Pháp, lầu trên của cổng đã bị bắn phá đổ cùng với biển trên. Người dân làng đã cúng tiến và xây dựng lại tầng trên cùng với làm lại biển chữ từ khoảng năm 2000.$body$),

  ('41000000-0000-0000-0000-000000000003',
   (SELECT id FROM villages WHERE slug = 'lang-uoc-le'), 'phong_tuc', 'Phong tục',
   $body$ở Ước Lễ còn có một phong tục vô cùng độc đáo, đó là tục ăn “Tết bù” vào ngày rằm tháng Giêng. Phong tục này xuất phát từ việc dân làng thường bận làm giò chả phục vụ nhu cầu ăn Tết của người dân khắp nơi nên không thể chuẩn bị Tết chu đáo. Vì thế, rằm tháng Giêng mới là dịp các gia đình ở Ước Lễ quây quần ăn “Tết bù”.$body$),

  ('41000000-0000-0000-0000-000000000004',
   (SELECT id FROM villages WHERE slug = 'lang-uoc-le'), 'truyen_thuyet', 'Truyền thuyết',
   $body$ngày xưa, ông Lữ Gia đánh trận thua, chạy về tới cây đa trước cổng làng đầu đã bị chém gần lìa, gặp một bà cụ người làng, hỏi: Người bị chém đứt đầu có sống được không? Bà cụ nói: Sống thế nào được. Ông bèn dứt đầu ra khỏi cổ rồi ngã xuống ngựa. Dân tôn ông làm Thành hoàng, thờ cúng ở đình cho đến nay.
Truyền thuyết kể rằng, mảnh đất giữa làng xưa kia là nền của kho dự trữ thóc gạo do làng tự lập, gọi là quỹ “Nghĩa thương”. Làng cử người coi sóc, nhằm giúp đỡ dân nghèo trong làng và người cơ nhỡ. Vua Tự Đức kinh lý qua thấy phong tục đẹp, phong cho bốn chữ “Mỹ tục khả phong”. Bản hương ước lập năm 1928 có 106 điều, trong đó có một điều rất hay, tôi cho rằng ít có làng quê xứ Bắc xưa nào đề cập đến: “Đi ăn cỗ cấm lấy phần”.$body$)

ON CONFLICT (id) DO NOTHING;
