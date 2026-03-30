# 🚀 Flutter Installation Guide

## 📋 Quick Installation Options

### Option 1: Automatic Installation (Recommended)
```powershell
# Run in PowerShell as Administrator
iwr -useb https://raw.githubusercontent.com/flutter/flutter/main/packages/flutter_tools/install.ps1 | iex
```

### Option 2: Manual Installation
```powershell
# Download Flutter SDK
# Visit: https://flutter.dev/docs/get-started/install/windows
```

### Option 3: Using Chocolatey
```powershell
# Install Chocolatey first (if not installed)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Flutter
choco install flutter
```

### Option 4: Using Winget
```powershell
# Install Flutter via Windows Package Manager
winget install Google.Flutter
```

## 🔧 Step-by-Step Manual Installation

### 1. Download Flutter SDK
1. Go to [Flutter Official Site](https://flutter.dev/docs/get-started/install/windows)
2. Download the Flutter SDK zip file
3. Extract to `C:\flutter` (recommended location)

### 2. Add Flutter to PATH
```powershell
# Add to system PATH
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\flutter\bin", "Machine")

# OR add to user PATH
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\flutter\bin", "User")
```

### 3. Restart PowerShell/Command Prompt
```powershell
# Verify installation
flutter --version
```

### 4. Run Flutter Doctor
```powershell
flutter doctor
```

### 5. Install Missing Components
Based on `flutter doctor` output, install missing components:

#### For Android Development:
```powershell
# Install Android Studio
winget install Google.AndroidStudio

# OR download from: https://developer.android.com/studio
```

#### For Web Development:
```powershell
# Enable web support
flutter config --enable-web
```

#### For Windows Desktop:
```powershell
# Install Visual Studio with C++ development tools
winget install Microsoft.VisualStudio.2022.Community

# OR download from: https://visualstudio.microsoft.com/
```

## 🛠️ Automated Installation Script

Save this as `install_flutter.ps1` and run as Administrator:

```powershell
# Flutter Installation Script
Write-Host "🚀 Installing Flutter SDK..." -ForegroundColor Green

# Create Flutter directory
New-Item -ItemType Directory -Force -Path "C:\flutter" | Out-Null

# Download Flutter SDK
Write-Host "📦 Downloading Flutter SDK..." -ForegroundColor Yellow
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip"
$flutterZip = "C:\flutter.zip"

Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip

# Extract Flutter SDK
Write-Host "📂 Extracting Flutter SDK..." -ForegroundColor Yellow
Expand-Archive -Path $flutterZip -DestinationPath "C:\" -Force

# Add to PATH
Write-Host "🔧 Adding Flutter to PATH..." -ForegroundColor Yellow
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*C:\flutter\bin*") {
    [Environment]::SetEnvironmentVariable("Path", $currentPath + ";C:\flutter\bin", "User")
}

# Clean up
Remove-Item $flutterZip

# Verify installation
Write-Host "✅ Flutter installed successfully!" -ForegroundColor Green
Write-Host "🔄 Please restart PowerShell and run 'flutter doctor'" -ForegroundColor Cyan
```

## 📱 Platform Setup

### Android Setup
```powershell
# Install Android Studio
winget install Google.AndroidStudio

# After installation, start Android Studio and install:
# - Android SDK
# - Android SDK Command-line Tools
# - Android SDK Build-Tools
# - Android SDK Platform-Tools
# - An Android Emulator (like Pixel 6 with API 34)
```

### Web Setup
```powershell
# Enable web support
flutter config --enable-web

# Verify web setup
flutter doctor
```

### Windows Desktop Setup
```powershell
# Install Visual Studio 2022 Community
winget install Microsoft.VisualStudio.2022.Community

# During installation, select:
# - Desktop development with C++
# - Windows 10/11 SDK
# - MSVC v143 build tools
```

## 🧪 Verification Steps

### 1. Check Flutter Version
```powershell
flutter --version
```

### 2. Run Flutter Doctor
```powershell
flutter doctor -v
```

### 3. Check Available Devices
```powershell
flutter devices
```

### 4. Test Installation
```powershell
# Create test project
flutter create test_app
cd test_app

# Run test
flutter run -d chrome
```

## 🔍 Troubleshooting

### Common Issues

#### "Flutter command not found"
```powershell
# Restart PowerShell
# OR add Flutter to PATH manually
$env:Path += ";C:\flutter\bin"
```

#### "Android license not accepted"
```powershell
flutter doctor --android-licenses
```

#### "No connected devices"
```powershell
# Start Android emulator
flutter emulators
flutter emulators --launch <emulator_name>
```

#### "Web renderer issues"
```powershell
# Try different renderers
flutter run -d chrome --web-renderer html
flutter run -d chrome --web-renderer canvaskit
```

### Performance Issues
```powershell
# Enable desktop support for better performance
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

## 📚 Additional Resources

- [Flutter Official Documentation](https://flutter.dev/docs)
- [Flutter Windows Installation](https://flutter.dev/docs/get-started/install/windows)
- [Android Studio Setup](https://developer.android.com/studio/install)
- [Visual Studio Setup](https://docs.microsoft.com/en-us/visualstudio/install/)

## 🎯 Next Steps After Installation

1. **Restart PowerShell/Command Prompt**
2. **Run `flutter doctor`** to verify setup
3. **Install missing components** based on doctor output
4. **Test with sample project**
5. **Run the Kazipoa app**:
   ```powershell
   cd c:\Users\Eutychus\Documents\Kazipoa
   flutter pub get
   flutter run
   ```

---

**🎉 Once Flutter is installed, you'll be able to run the Kazipoa app on any platform!**
