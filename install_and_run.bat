@echo off
echo ========================================
echo Kazipoa Flutter App - Install and Run
echo ========================================
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter is not installed. Installing now...
    echo.
    echo Please wait while we install Flutter...
    echo.
    
    REM Try to install Flutter using winget
    winget install Google.Flutter --accept-source-agreements --accept-package-agreements
    
    if %errorlevel% neq 0 (
        echo.
        echo Automatic installation failed. Please install Flutter manually:
        echo 1. Go to https://flutter.dev/docs/get-started/install/windows
        echo 2. Download Flutter SDK
        echo 3. Extract to C:\flutter
        echo 4. Add C:\flutter\bin to your PATH
        echo.
        echo After installation, run this script again.
        pause
        exit /b 1
    )
    
    echo.
    echo Flutter installed successfully!
    echo Please restart this command prompt and run this script again.
    pause
    exit /b 0
)

echo Flutter is installed!
echo.
echo Flutter version:
flutter --version
echo.

REM Navigate to project directory
cd /d "%~dp0"

REM Install dependencies
echo Installing Flutter dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Dependencies installed successfully!
echo.

REM Check for devices
echo Checking for available devices...
flutter devices
echo.

echo Choose how to run the app:
echo 1. Run in Chrome browser (Web)
echo 2. Run on Windows desktop
echo 3. Run on connected Android device
echo 4. Check all available devices
echo 5. Exit
echo.

set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo.
    echo Running in Chrome browser...
    flutter run -d chrome
) else if "%choice%"=="2" (
    echo.
    echo Running on Windows desktop...
    flutter run -d windows
) else if "%choice%"=="3" (
    echo.
    echo Running on Android device...
    flutter run -d android
) else if "%choice%"=="4" (
    echo.
    echo Available devices:
    flutter devices
    echo.
    pause
    call "%~f0"
) else if "%choice%"=="5" (
    echo.
    echo Goodbye!
    exit /b 0
) else (
    echo.
    echo Invalid choice. Please try again.
    pause
    call "%~f0"
)

echo.
echo Kazipoa app is running! Check your browser/device for the app.
echo.
echo Tips:
echo - Press 'r' for hot reload
echo - Press 'R' for hot restart  
echo - Press 'q' to quit
echo.
pause
