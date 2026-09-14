#!/bin/bash
set -e
cd "$(dirname "$0")/.."

echo "取得套件..."
flutter pub get

echo "建立 iOS Release..."
flutter build ios --release

echo ""
echo "Release Build 已完成。"
echo "接著請開啟 Xcode："
echo "open ios/Runner.xcworkspace"
echo ""
echo "在 Xcode 選 Product > Archive"
echo "完成後可上傳 TestFlight 或匯出已簽署的 IPA。"
