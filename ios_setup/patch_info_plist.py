import plistlib, sys
from pathlib import Path

path = Path(sys.argv[1])
with path.open("rb") as f:
    data = plistlib.load(f)

data["CFBundleDisplayName"] = "HORNG CHERNG"
data["NSCameraUsageDescription"] = "用於掃描產品料號、QR Code 與條碼。"
data["NSPhotoLibraryUsageDescription"] = "用於選擇品管照片、產品照片與圖面。"
data["NSPhotoLibraryAddUsageDescription"] = "用於儲存品管照片與相關文件。"
data["UISupportsDocumentBrowser"] = True

with path.open("wb") as f:
    plistlib.dump(data, f)

print("Info.plist 權限與 App 名稱已設定。")
