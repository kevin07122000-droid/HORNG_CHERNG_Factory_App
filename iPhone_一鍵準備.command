#!/bin/bash
set -e

cd "$(dirname "$0")/.."

echo "=========================================="
echo " HORNG CHERNG iPhone 專案初始化"
echo "=========================================="

if ! command -v flutter >/dev/null 2>&1; then
  echo ""
  echo "找不到 Flutter。請先安裝 Flutter SDK："
  echo "https://docs.flutter.dev/get-started/install/macos/mobile-ios"
  exit 1
fi

if ! command -v pod >/dev/null 2>&1; then
  echo ""
  echo "找不到 CocoaPods，正在嘗試安裝..."
  sudo gem install cocoapods
fi

echo ""
echo "1/5 建立 iOS Runner..."
flutter create --platforms=ios --org com.horngcherng .

echo ""
echo "2/5 取得套件..."
flutter pub get

echo ""
echo "3/5 設定 iPhone 權限..."
PLIST="ios/Runner/Info.plist"
if [ -f "$PLIST" ]; then
python3 ios_setup/patch_info_plist.py "$PLIST"
fi

echo ""
echo "4/5 安裝 iOS Pods..."
cd ios
pod install --repo-update
cd ..

echo ""
echo "5/5 完成"
echo ""
echo "請執行："
echo "open ios/Runner.xcworkspace"
echo ""
echo "然後在 Xcode："
echo "Runner > Signing & Capabilities > Team"
echo "選擇你的 Apple ID / Apple Developer Team，再接上 iPhone 執行。"
