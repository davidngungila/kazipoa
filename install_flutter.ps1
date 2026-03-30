# Flutter Installation Script for Windows
# Run this script as Administrator

Write-Host "🚀 Flutter Installation Script for Kazipoa App" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run this script as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "✅ Running with Administrator privileges" -ForegroundColor Green
Write-Host ""

# Check if Flutter is already installed
try {
    flutter --version | Out-Null
    Write-Host "✅ Flutter is already installed!" -ForegroundColor Green
    Write-Host "Current version:" -ForegroundColor Yellow
    flutter --version
    Write-Host ""
    Write-Host "🔄 Skipping installation, proceeding to setup..." -ForegroundColor Cyan
    $flutterInstalled = $true
} catch {
    Write-Host "📦 Flutter not found, proceeding with installation..." -ForegroundColor Yellow
    $flutterInstalled = $false
}

# Install Flutter if not present
if (-not $flutterInstalled) {
    Write-Host "📥 Downloading Flutter SDK..." -ForegroundColor Yellow
    
    # Create Flutter directory
    $flutterPath = "C:\flutter"
    if (Test-Path $flutterPath) {
        Write-Host "📁 Flutter directory exists, cleaning up..." -ForegroundColor Yellow
        Remove-Item -Path $flutterPath -Recurse -Force
    }
    
    New-Item -ItemType Directory -Force -Path $flutterPath | Out-Null
    
    # Download Flutter SDK
    try {
        $flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip"
        $flutterZip = "$env:TEMP\flutter.zip"
        
        Write-Host "⬇️  Downloading from official Flutter repository..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip -UseBasicParsing
        
        Write-Host "📂 Extracting Flutter SDK..." -ForegroundColor Yellow
        Expand-Archive -Path $flutterZip -DestinationPath "C:\" -Force
        
        # Clean up
        Remove-Item $flutterZip
        
        Write-Host "✅ Flutter SDK installed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to download Flutter SDK" -ForegroundColor Red
        Write-Host "Please check your internet connection and try again" -ForegroundColor Yellow
        Write-Host "Or download manually from: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor Cyan
        pause
        exit 1
    }
}

# Add Flutter to PATH
Write-Host "🔧 Adding Flutter to system PATH..." -ForegroundColor Yellow
try {
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*C:\flutter\bin*") {
        [Environment]::SetEnvironmentVariable("Path", $currentPath + ";C:\flutter\bin", "User")
        Write-Host "✅ Flutter added to PATH" -ForegroundColor Green
    } else {
        Write-Host "✅ Flutter already in PATH" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Could not add Flutter to PATH automatically" -ForegroundColor Yellow
    Write-Host "Please add C:\flutter\bin to your PATH manually" -ForegroundColor Red
}

# Enable platform support
Write-Host "🌐 Enabling platform support..." -ForegroundColor Yellow
try {
    & "C:\flutter\bin\flutter.bat" config --enable-web
    & "C:\flutter\bin\flutter.bat" config --enable-windows-desktop
    Write-Host "✅ Web and Windows desktop support enabled" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Could not enable platform support automatically" -ForegroundColor Yellow
}

# Check for Visual Studio
Write-Host "🔍 Checking for Visual Studio..." -ForegroundColor Yellow
$vsInstalled = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%Visual Studio%'" | Measure-Object | Select-Object -ExpandProperty Count
if ($vsInstalled -eq 0) {
    Write-Host "⚠️  Visual Studio not found. Installing Visual Studio Community..." -ForegroundColor Yellow
    try {
        winget install Microsoft.VisualStudio.2022.Community --silent
        Write-Host "✅ Visual Studio installation started" -ForegroundColor Green
        Write-Host "⏳ This may take several minutes to complete..." -ForegroundColor Cyan
    } catch {
        Write-Host "❌ Could not install Visual Studio automatically" -ForegroundColor Red
        Write-Host "Please install Visual Studio 2022 Community manually from:" -ForegroundColor Yellow
        Write-Host "https://visualstudio.microsoft.com/vs/community/" -ForegroundColor Cyan
    }
} else {
    Write-Host "✅ Visual Studio found" -ForegroundColor Green
}

# Check for Android Studio
Write-Host "📱 Checking for Android Studio..." -ForegroundColor Yellow
$androidStudio = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%Android Studio%'" | Measure-Object | Select-Object -ExpandProperty Count
if ($androidStudio -eq 0) {
    Write-Host "⚠️  Android Studio not found. Installing Android Studio..." -ForegroundColor Yellow
    try {
        winget install Google.AndroidStudio --silent
        Write-Host "✅ Android Studio installation started" -ForegroundColor Green
        Write-Host "⏳ This may take several minutes to complete..." -ForegroundColor Cyan
    } catch {
        Write-Host "❌ Could not install Android Studio automatically" -ForegroundColor Red
        Write-Host "Please install Android Studio manually from:" -ForegroundColor Yellow
        Write-Host "https://developer.android.com/studio" -ForegroundColor Cyan
    }
} else {
    Write-Host "✅ Android Studio found" -ForegroundColor Green
}

# Installation complete
Write-Host ""
Write-Host "🎉 Flutter installation completed!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Close this PowerShell window" -ForegroundColor White
Write-Host "2. Open a NEW PowerShell window as Administrator" -ForegroundColor White
Write-Host "3. Run: flutter doctor" -ForegroundColor White
Write-Host "4. Follow the instructions to fix any remaining issues" -ForegroundColor White
Write-Host "5. Navigate to: cd c:\Users\Eutychus\Documents\Kazipoa" -ForegroundColor White
Write-Host "6. Run: flutter pub get" -ForegroundColor White
Write-Host "7. Run: flutter run" -ForegroundColor White
Write-Host ""
Write-Host "📚 For detailed instructions, see: INSTALL_FLUTTER.md" -ForegroundColor Yellow
Write-Host ""
Write-Host "⚡ Quick Test Commands:" -ForegroundColor Cyan
Write-Host "flutter --version" -ForegroundColor Gray
Write-Host "flutter doctor" -ForegroundColor Gray
Write-Host "flutter devices" -ForegroundColor Gray
Write-Host ""
Write-Host "🚀 Ready to run Kazipoa app!" -ForegroundColor Green

pause
