# HORNG CHERNG iPhone 安裝說明

## 你拿到的是什麼
這個 ZIP 是 iPhone 版完整 Flutter 原始專案與 iOS 建置工具。
App 已包含 HORNG CHERNG Logo、登入頁、生產、貨料、進出貨、QC、圖面、料號詳情、QR/條碼掃描與本機資料儲存。

## 第一次在 Mac 準備
1. 安裝最新版 Xcode。
2. 安裝 Flutter SDK。
3. 解壓縮本專案。
4. 在 Finder 對 `iPhone_一鍵準備.command` 按右鍵 → 開啟。
5. 腳本會建立標準 Flutter iOS Runner、安裝套件與設定 QR 掃描相機權限。
6. 完成後開啟 `ios/Runner.xcworkspace`。

## 裝到自己的 iPhone 測試
1. 用 USB 或 Wi‑Fi 把 iPhone 連到 Mac。
2. Xcode 左側選 Runner。
3. Signing & Capabilities → Team，登入你的 Apple ID 並選 Team。
4. Bundle Identifier 建議改成唯一值，例如：
   `com.horngcherng.factory`
5. Xcode 上方選你的 iPhone。
6. 按 ▶ Run。
7. 若 iPhone 要求信任開發者，依 iOS 畫面完成信任即可。

## TestFlight 給公司人員使用
1. 在 Apple Developer / App Store Connect 建立 App。
2. Xcode 選 Product → Archive。
3. 在 Organizer 選 Distribute App → App Store Connect。
4. 上傳完成後，到 App Store Connect 的 TestFlight 加入測試人員。
5. 測試人員在 iPhone 安裝 Apple TestFlight App，即可下載 HORNG CHERNG App。

## 正式上架
正式 App Store 上架還需要：
- Apple Developer Program
- App 隱私權資料
- App Icon 1024×1024
- 截圖
- 版本資訊
- 隱私權政策
- 正式後端/雲端資料庫（若多人共用）

## 重要
目前 V2 的工單資料使用手機本機儲存，尚不是公司多人即時共用資料庫。
正式公司版建議下一步加入：
- 管理員 / 生管 / 倉管 / 品管 / 工程 / 現場權限
- 雲端資料庫
- PDF/DWG 圖面版本控管
- QC 報告與出貨單 PDF
- 資料備份、稽核紀錄
