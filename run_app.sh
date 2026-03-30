#!/bin/bash

echo "🚀 Starting Kazipoa Flutter App..."
echo

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found"
echo

# Navigate to project directory
cd "$(dirname "$0")"

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed"
echo

# Check for connected devices
echo "📱 Checking for devices..."
flutter devices

echo
echo "🎯 Choose how to run the app:"
echo "1. Run on connected device/emulator (Mobile)"
echo "2. Run in Chrome browser (Web)"
echo "3. Run on macOS desktop"
echo "4. Run on Linux desktop"
echo "5. Check available devices first"
echo "6. Exit"
echo

read -p "Enter your choice (1-6): " choice

case $choice in
    1)
        echo "📱 Running on mobile device..."
        flutter run
        ;;
    2)
        echo "🌐 Running in Chrome..."
        flutter run -d chrome
        ;;
    3)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "🍎 Running on macOS desktop..."
            flutter run -d macos
        else
            echo "❌ macOS desktop mode is only available on macOS"
            echo "Try option 4 for Linux desktop or option 2 for web"
            exit 1
        fi
        ;;
    4)
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "🐧 Running on Linux desktop..."
            flutter run -d linux
        else
            echo "❌ Linux desktop mode is only available on Linux"
            echo "Try option 3 for macOS desktop or option 2 for web"
            exit 1
        fi
        ;;
    5)
        echo "📋 Available devices:"
        flutter devices
        echo
        echo "Press Enter to continue..."
        read
        exec "$0"
        ;;
    6)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        echo "Press Enter to try again..."
        read
        exec "$0"
        ;;
esac

echo
echo "🎉 App running! Check your device/browser for the Kazipoa app."
echo
echo "💡 Tips:"
echo "- Press 'r' in terminal for hot reload"
echo "- Press 'R' for hot restart"
echo "- Press 'q' to quit the app"
echo
