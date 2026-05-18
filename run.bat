@echo off
REM Flutter project runner - sets PATH and runs commands
echo Setting up Flutter environment...

REM Add Node.js to PATH
set PATH=C:\Program Files\nodejs;%PATH%

REM Change to Flutter directory
cd /d "c:\Users\Eutychus\OneDrive\Desktop\Kazi poa app\kazipoa_fixed"

REM Check command
if "%1"=="" (
    echo.
    echo Available commands:
    echo   run.bat install     - npm install
    echo   run.bat pub-get     - flutter pub get
    echo   run.bat build      - flutter build web
    echo   run.bat dev        - flutter run
    echo   run.bat test       - flutter test
    echo   run.bat analyze    - flutter analyze
    echo.
    echo Usage: run.bat [command]
    echo Example: run.bat dev
    goto :end
)

REM Execute Flutter command
if "%1"=="install" (
    npm install
) else if "%1"=="pub-get" (
    flutter pub get
) else if "%1"=="build" (
    flutter build web
) else if "%1"=="dev" (
    flutter run
) else if "%1"=="test" (
    flutter test
) else if "%1"=="analyze" (
    flutter analyze
) else (
    echo Unknown command: %1
)

:end
pause
