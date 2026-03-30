#!/bin/bash

# Unified Build Script for Kazipoa Flutter App
# Builds for all supported platforms from single codebase

echo "🚀 Building Kazipoa for all platforms..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Web Build
echo "🌐 Building for Web..."
flutter build web --web-renderer canvaskit --no-sound-null-safety
echo "✅ Web build completed: build/web/"

# Android Build
echo "📱 Building for Android..."
flutter build apk --release
flutter build appbundle --release
echo "✅ Android build completed: build/app/outputs/flutter-apk/"

# iOS Build (only on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Building for iOS..."
    flutter build ios --release
    echo "✅ iOS build completed: build/ios/"
else
    echo "⏭️  Skipping iOS build (not on macOS)"
fi

# Windows Build (only on Windows)
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo "🪟 Building for Windows..."
    flutter build windows --release
    echo "✅ Windows build completed: build/windows/"
else
    echo "⏭️  Skipping Windows build (not on Windows)"
fi

# macOS Build (only on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Building for macOS..."
    flutter build macos --release
    echo "✅ macOS build completed: build/macos/"
else
    echo "⏭️  Skipping macOS build (not on macOS)"
fi

# Linux Build (only on Linux)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Building for Linux..."
    flutter build linux --release
    echo "✅ Linux build completed: build/linux/"
else
    echo "⏭️  Skipping Linux build (not on Linux)"
fi

echo "🎉 Build process completed!"
echo "📊 Build Summary:"
echo "   Web: build/web/"
echo "   Android: build/app/outputs/flutter-apk/"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "   iOS: build/ios/"
    echo "   macOS: build/macos/"
fi
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo "   Windows: build/windows/"
fi
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "   Linux: build/linux/"
fi

echo "🚀 Ready for deployment across all platforms!"
