@echo off
REM Flutter commands wrapper - sets up npm PATH and runs commands
echo Setting up environment...

REM Add Node.js to PATH for this session
set PATH=C:\Program Files\nodejs;%PATH%

REM Check if command provided
if "%1"=="" (
    echo.
    echo Flutter Commands Available:
    echo   flutter-commands.bat install     - Install npm packages
    echo   flutter-commands.bat pub:get     - Get Flutter packages
    echo   flutter-commands.bat build      - Build Flutter web app
    echo   flutter-commands.bat dev        - Run Flutter development
    echo   flutter-commands.bat test       - Run Flutter tests
    echo   flutter-commands.bat analyze    - Analyze Flutter code
    echo   flutter-commands.bat format     - Format Dart code
    echo.
    echo Usage: flutter-commands.bat [command]
    echo Example: flutter-commands.bat dev
    goto :end
)

REM Execute the command
echo Running: %1
npm %1

:end
pause
