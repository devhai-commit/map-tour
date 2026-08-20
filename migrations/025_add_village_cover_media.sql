-- Thêm cột lưu ảnh đại diện (avatar/cover) riêng cho làng, thay vì chỉ suy ra
-- gián tiếp từ ảnh cover của site đầu tiên (xem server/src/services/villages.ts).
-- Cho phép trang quản trị chỉnh sửa ảnh đại diện độc lập với dữ liệu điểm tham quan.
-- Các làng chưa từng đặt ảnh đại diện riêng vẫn tiếp tục hiện ảnh suy ra như cũ
-- (COALESCE ở tầng service) cho tới khi được chỉnh sửa qua trang quản trị mới.
ALTER TABLE villages
  ADD COLUMN cover_media_id uuid REFERENCES media (id) ON DELETE SET NULL;
