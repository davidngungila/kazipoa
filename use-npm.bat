@echo off
REM Direct npm command runner for Flutter project
echo Running npm: %1

REM Use full path to Node.js
"C:\Program Files\nodejs\npm.exe" %* %2 %3 %4 %5 %6 %7 %8 %9

REM Show result
if %errorlevel% neq 0 (
    echo npm command failed with error: %errorlevel%
) else (
    echo npm command completed successfully
)
