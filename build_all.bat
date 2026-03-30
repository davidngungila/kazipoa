@echo off
REM Unified Build Script for Kazipoa Flutter App (Windows)
REM Builds for all supported platforms from single codebase

echo 🚀 Building Kazipoa for all platforms...

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean
flutter pub get

REM Web Build
echo 🌐 Building for Web...
flutter build web --web-renderer canvaskit --no-sound-null-safety
echo ✅ Web build completed: build\web\

REM Android Build
echo 📱 Building for Android...
flutter build apk --release
flutter build appbundle --release
echo ✅ Android build completed: build\app\outputs\flutter-apk\

REM Windows Build
echo 🪟 Building for Windows...
flutter build windows --release
echo ✅ Windows build completed: build\windows\

REM Desktop builds (optional)
echo 🖥️ Building desktop applications...

REM Check if we can build for other platforms
echo ⏭️  Skipping iOS build (requires macOS)
echo ⏭️  Skipping macOS build (requires macOS)
echo ⏭️  Skipping Linux build (requires Linux)

echo 🎉 Build process completed!
echo 📊 Build Summary:
echo    Web: build\web\
echo    Android: build\app\outputs\flutter-apk\
echo    Windows: build\windows\
echo.
echo 🚀 Ready for deployment across all platforms!
pause
