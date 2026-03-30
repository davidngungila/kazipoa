# ⚡ Quick Flutter Installation Guide

## 🚀 Option 1: Automatic Installation (Easiest)

### Step 1: Open PowerShell as Administrator
1. Press `Windows + X`
2. Select "Windows PowerShell (Admin)" or "Terminal (Admin)"
3. Click "Yes" to the UAC prompt

### Step 2: Run the Installation Script
```powershell
cd c:\Users\Eutychus\Documents\Kazipoa
.\install_flutter_fixed.ps1
```

### Step 3: Follow the Prompts
- The script will automatically download and install Flutter
- It will install Visual Studio and Android Studio if needed
- It will configure everything for you

### Step 4: Restart PowerShell
- Close the PowerShell window
- Open a NEW PowerShell window as Administrator
- Run the verification commands

## 🔧 Option 2: Manual Installation (If Script Fails)

### Step 1: Download Flutter SDK
1. Go to [https://flutter.dev/docs/get-started/install/windows](https://flutter.dev/docs/get-started/install/windows)
2. Download the Flutter SDK zip file
3. Extract to `C:\flutter`

### Step 2: Add to PATH
1. Press `Windows + R`, type `sysdm.cpl`
2. Go to "Advanced" → "Environment Variables"
3. Under "User variables", find "Path" and click "Edit"
4. Click "New" and add `C:\flutter\bin`
5. Click OK on all windows

### Step 3: Restart PowerShell
- Close and reopen PowerShell as Administrator

### Step 4: Verify Installation
```powershell
flutter --version
flutter doctor
```

## 📱 Platform Setup

### For Mobile Development
```powershell
# Install Android Studio
winget install Google.AndroidStudio

# After installation, run:
flutter doctor --android-licenses
```

### For Web Development
```powershell
# Enable web support
flutter config --enable-web
```

### For Desktop Development
```powershell
# Install Visual Studio (if not already installed)
winget install Microsoft.VisualStudio.2022.Community

# During installation, select:
# - Desktop development with C++
# - Windows 10/11 SDK
```

## 🧪 Verification Commands

Run these in a NEW PowerShell window:

```powershell
# Check Flutter version
flutter --version

# Check system status
flutter doctor

# Check available devices
flutter devices
```

## 🎯 Run Kazipoa App

Once Flutter is installed:

```powershell
# Navigate to project
cd c:\Users\Eutychus\Documents\Kazipoa

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Platform-Specific Commands:
```powershell
# Web browser
flutter run -d chrome

# Windows desktop
flutter run -d windows

# Mobile device (if connected)
flutter run -d android
```

## 🔍 Troubleshooting

### "Flutter command not found"
- Restart PowerShell
- Check PATH includes `C:\flutter\bin`
- Run `refreshenv` in PowerShell

### "Android license not accepted"
```powershell
flutter doctor --android-licenses
```

### "No connected devices"
```powershell
# Start Android emulator
flutter emulators
flutter emulators --launch <emulator_name>
```

### "Visual Studio components missing"
- Open Visual Studio Installer
- Click "Modify" on Visual Studio
- Add "Desktop development with C++"

## 📋 Expected Flutter Doctor Output

You should see something like:
```
[✓] Flutter (Channel stable, 3.19.6)
[✓] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[✓] Visual Studio - develop for Windows
[✓] Windows UWP - develop for Windows
```

Any ❌ marks indicate issues that need to be resolved.

## 🎉 Success!

When you see `flutter doctor` with mostly ✅ marks, you're ready to run the Kazipoa app!

```powershell
cd c:\Users\Eutychus\Documents\Kazipoa
flutter pub get
flutter run
```

---

**🚀 Your unified Flutter Kazipoa app will be running in minutes!**
