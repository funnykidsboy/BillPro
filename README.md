# BillPro (iOS 15+, SwiftUI + Core Data, TrollStore-friendly)

Phù hợp cho iOS **15+**. Không dùng SwiftData. Có:
- Home list đơn hàng (tên, SĐT, ngày giao, tổng)
- Tìm kiếm theo Tên/SĐT, lọc ngày (bạn có thể mở rộng nhanh)
- Thêm đơn, thêm mặt hàng (kho mặt hàng), bảng 5 cột (STT | Item | Price | Q | Amount)
- Total Quantity, Discount (có máy tính), Total Amount
- In PDF (PDFKit), AirPrint, Share

## Build .ipa từ WSL qua GitHub Actions (TrollStore)
Workflow **ios-build-trollstore.yml** sẽ:
1) `xcodegen generate` → tạo `.xcodeproj`
2) `xcodebuild` tạo **.app** không ký (`CODE_SIGNING_ALLOWED=NO`)
3) `ldid` ký ad-hoc để tương thích TrollStore
4) Đóng gói `.ipa` và upload artifact

> Không cần tài khoản dev để cài qua TrollStore. (Tuy nhiên nếu bạn muốn lên App Store/TF thì dùng lane Fastlane khác).

### Cách dùng
```bash
git init
git add .
git commit -m "BillPro iOS15 scaffold"
git branch -M main
git remote add origin <your_repo_url>
git push -u origin main
```
Vào tab **Actions** → chạy workflow **Build iOS 15 IPA (TrollStore)** → tải artifact `.ipa` và cài bằng TrollStore.

## Cấu trúc
- `project.yml` – XcodeGen spec (iOS 15 deployment)
- `BillPro/` – mã nguồn
  - `App/` – App entry + Core Data stack
  - `Models/` – Core Data NSManagedObject subclasses + logic tính tiền
  - `Views/` – SwiftUI màn hình
  - `Services/` – PDF/Print/Share
  - `Utils/` – Định dạng tiền/ngày
- `.github/workflows/ios-build-trollstore.yml` – CI build+ldid sign
- `fastlane/Fastfile` – (tuỳ chọn) lane build có ký tiêu chuẩn nếu bạn có chứng chỉ

Chúc build vui vẻ!
