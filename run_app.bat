@echo off
echo 🚀 Starting Kazipoa Flutter App...
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo ✅ Flutter found
echo.

REM Navigate to project directory
cd /d "%~dp0"

REM Install dependencies
echo 📦 Installing dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)

echo ✅ Dependencies installed
echo.

REM Check for connected devices
echo 📱 Checking for devices...
flutter devices

echo.
echo 🎯 Choose how to run the app:
echo 1. Run on connected device/emulator (Mobile)
echo 2. Run in Chrome browser (Web)
echo 3. Run on Windows desktop
echo 4. Check available devices first
echo 5. Exit
echo.

set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo 📱 Running on mobile device...
    flutter run
) else if "%choice%"=="2" (
    echo 🌐 Running in Chrome...
    flutter run -d chrome
) else if "%choice%"=="3" (
    echo 🪟 Running on Windows desktop...
    flutter run -d windows
) else if "%choice%"=="4" (
    echo 📋 Available devices:
    flutter devices
    echo.
    pause
    call "%~f0"
) else if "%choice%"=="5" (
    echo 👋 Goodbye!
    exit /b 0
) else (
    echo ❌ Invalid choice
    pause
    call "%~f0"
)

echo.
echo 🎉 App running! Check your device/browser for the Kazipoa app.
echo.
echo 💡 Tips:
echo - Press 'r' in terminal for hot reload
echo - Press 'R' for hot restart
echo - Press 'q' to quit the app
echo.
pause
