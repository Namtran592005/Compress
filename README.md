# Compress.bat

Một tiện ích dòng lệnh cao cấp cho Windows, được thiết kế để **tối ưu hóa dung lượng đĩa** bằng cách nén các thư mục hệ thống và phần mềm quan trọng bằng tính năng nén chuẩn `compact.exe` của Windows (CompactOS). Script hỗ trợ tương tác trực quan, kiểm tra thông minh và chỉ thực thi khi có quyền quản trị (Admin).

---

## ⚙️ Chức năng chính

- Kiểm tra quyền admin, nếu không có quyền sẽ thoát và không làm gì.
- Báo cáo dung lượng trước và sau khi nén.
- Nén các thư mục hệ thống và phần mềm phổ biến (Windows, Program Files, AppData...).
- Phát hiện nếu hệ thống đã bật CompactOS và/hoặc các thư mục đã nén trước đó → bỏ qua và thông báo.
- Tránh nén lặp lại hoặc gây lỗi cho các hệ thống đã được tối ưu trước đó.
- Hiển thị quá trình rõ ràng, dễ hiểu với tương tác người dùng.

---

## 🧠 Hoạt động như thế nào?

Script thực hiện:

1. **Kiểm tra quyền admin:** Nếu không chạy bằng quyền admin, script sẽ thông báo và dừng ngay lập tức.
2. **Kiểm tra trạng thái CompactOS:** Nếu hệ thống đã bật sẵn CompactOS, sẽ bỏ qua phần này.
3. **Liệt kê và kiểm tra từng thư mục cần nén:** Nếu thư mục đã được nén từ trước, sẽ thông báo và bỏ qua.
4. **Nén thư mục:** Dùng lệnh `compact.exe /c /s /a /i /q` để thực hiện nén.
5. **Hiển thị báo cáo cuối cùng:** Tổng kết dung lượng tiết kiệm được và cảnh báo nếu cần.

---

## 📌 Các thư mục sẽ được kiểm tra và nén

- `C:\Windows`
- `C:\Program Files`
- `C:\Program Files (x86)`
- `C:\Users\<Tên người dùng>\AppData\Local`
- `C:\Users\<Tên người dùng>\AppData\Roaming`

> Lưu ý: Các thư mục chỉ được nén nếu chưa nén trước đó.

---

## 📥 Cách sử dụng

1. **Tải tệp script**: `CompressSystemInteractive.bat`
2. **Chuột phải → Run as Administrator**
3. **Làm theo hướng dẫn trên màn hình** (nếu có).
4. **Chờ quá trình hoàn tất và xem báo cáo cuối cùng.**

---

## 🔐 Yêu cầu

- **Windows 10 trở lên**
- **Chạy với quyền Administrator**
- Hệ thống đã bật CompactOS (nếu chưa, script có thể kích hoạt nếu được cho phép)

---

## ⚠️ Cảnh báo & Lưu ý

- **Không nên sử dụng trên ổ đĩa HDD cũ** vì có thể ảnh hưởng đến hiệu năng.
- Tránh chạy script này nhiều lần liên tiếp không cần thiết.
- Mặc dù dùng tính năng chuẩn của Windows, vẫn nên **backup hệ thống** trước khi thực hiện nếu bạn là người dùng không chuyên.
- Không khuyến khích dùng cho các hệ thống máy chủ hoặc máy ảo có cấu hình đặc thù.

---

## 📊 Ví dụ báo cáo kết quả

```text
[✔] Windows đã bật CompactOS
[✔] C:\Windows đã được nén từ trước → bỏ qua
[+] Đã nén thành công: C:\Program Files → Tiết kiệm: 1.2 GB
[+] Đã nén thành công: C:\Program Files (x86) → Tiết kiệm: 900 MB
[-] AppData\Local đã được nén từ trước → bỏ qua

=== TỔNG KẾT ===
Dung lượng tiết kiệm được: 2.1 GB
