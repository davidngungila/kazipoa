# 🚀 How to Run the Kazipoa Flutter App

## Prerequisites

Before running the app, make sure you have:

### 1. Flutter SDK Installed
```bash
# Check if Flutter is installed
flutter --version

# If not installed, download from:
# https://flutter.dev/docs/get-started/install
```

### 2. Development Environment
- **Windows**: Visual Studio 2019+ with Windows development tools
- **macOS**: Xcode 12+ and CocoaPods
- **Linux**: GTK development libraries
- **Web**: Chrome browser

### 3. Platform Setup
```bash
# Check connected devices
flutter devices

# Check doctor for any issues
flutter doctor
```

## 🏃‍♂️ Running the App

### Option 1: Quick Start (Mobile/Connected Device)
```bash
# Navigate to project directory
cd c:\Users\Eutychus\Documents\Kazipoa

# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run
```

### Option 2: Web Browser
```bash
# Run in Chrome
flutter run -d chrome

# Run in other browsers
flutter run -d edge      # Microsoft Edge
flutter run -d firefox   # Firefox
flutter run -d safari    # Safari (macOS only)
```

### Option 3: Desktop Applications
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### Option 4: Specific Mobile Platforms
```bash
# Android (requires Android emulator or connected device)
flutter run -d android

# iOS (requires iOS simulator or connected device - macOS only)
flutter run -d ios
```

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. "Flutter command not found"
```bash
# Add Flutter to your PATH
# Windows: Add to Environment Variables
# macOS/Linux: Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:/path/to/flutter/bin"
```

#### 2. "No connected devices"
```bash
# Start Android emulator
flutter emulators
flutter emulators --launch <emulator_name>

# Or start Android Studio and launch emulator from there
```

#### 3. "Web renderer issues"
```bash
# Try different web renderers
flutter run -d chrome --web-renderer html      # HTML renderer
flutter run -d chrome --web-renderer canvaskit # CanvasKit renderer (default)
```

#### 4. "Dependency issues"
```bash
# Clean and reinstall
flutter clean
flutter pub get
flutter run
```

#### 5. "Platform-specific issues"
```bash
# Check platform-specific setup
flutter doctor -v

# For Android: Check Android SDK setup
flutter config --android-studio-dir /path/to/android-studio

# For iOS: Check Xcode setup
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunchTask
```

## 📱 Platform-Specific Instructions

### Android Setup
1. Install Android Studio
2. Create an Android Virtual Device (AVD)
3. Enable "Developer options" on physical device
4. Enable "USB debugging" on physical device

### iOS Setup (macOS only)
1. Install Xcode from App Store
2. Install CocoaPods: `sudo gem install cocoapods`
3. Open iOS Simulator: `open -a Simulator`
4. Accept Xcode license: `sudo xcodebuild -license`

### Web Setup
1. Install Chrome browser
2. Enable web support: `flutter config --enable-web`
3. Run with: `flutter run -d chrome`

### Windows Desktop Setup
1. Install Visual Studio 2019+ with "Desktop development with C++"
2. Enable desktop support: `flutter config --enable-windows-desktop`
3. Run with: `flutter run -d windows`

### macOS Desktop Setup
1. Install Xcode
2. Enable desktop support: `flutter config --enable-macos-desktop`
3. Run with: `flutter run -d macos`

### Linux Desktop Setup
1. Install GTK development libraries
2. Enable desktop support: `flutter config --enable-linux-desktop`
3. Run with: `flutter run -d linux`

## 🎯 Expected Results

When the app runs successfully, you should see:

1. **Login Screen** with liquid glass design
2. **Swahili localization** (Kitambulisho cha Mteja)
3. **Animated backgrounds** with moving blobs
4. **Glass morphism effects** on cards and buttons
5. **Theme switching** (light/dark mode support)

## 🛠️ Development Features

The app includes:
- ✅ **Hot Reload**: Changes appear instantly
- ✅ **Debug Mode**: Detailed error messages
- ✅ **Platform Detection**: Adapts UI to current platform
- ✅ **Responsive Design**: Works on all screen sizes
- ✅ **Cross-platform**: Same codebase, multiple platforms

## 📊 Performance Tips

### For Better Performance
```bash
# Use release builds for testing performance
flutter run --release

# Enable profile mode for performance analysis
flutter run --profile

# Check performance with Flutter Inspector
flutter run --debug
```

### Web Performance
```bash
# Use CanvasKit renderer for better performance
flutter run -d chrome --web-renderer canvaskit

# Build optimized web version
flutter build web --web-renderer canvaskit --csp
```

## 🔍 Debugging

### Debug Commands
```bash
# Check for issues
flutter analyze

# Run tests
flutter test

# Check widget inspector
flutter run --debug

# View logs
flutter logs
```

### Common Debug Points
- Check `lib/theme/app_theme.dart` for theme issues
- Verify `lib/widgets/` for UI component errors
- Check `lib/screens/` for screen navigation issues
- Review `lib/platform_config.dart` for platform-specific problems

## 🚀 Building for Production

When ready to deploy:
```bash
# Web
flutter build web

# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios

# Desktop builds
flutter build windows
flutter build macos
flutter build linux
```

## 🆘 Getting Help

If you encounter issues:

1. **Check Flutter Doctor**: `flutter doctor -v`
2. **Review Logs**: `flutter logs`
3. **Clean Project**: `flutter clean && flutter pub get`
4. **Check Documentation**: Review `MIGRATION_GUIDE.md`
5. **Create Issue**: Report problems on GitHub

---

**🎉 Ready to run your unified Flutter Kazipoa app!**
