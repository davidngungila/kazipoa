# Kazipoa - Professional Booking Platform

A unified Flutter application for professional service booking in Tanzania, supporting mobile, web, and desktop platforms from a single codebase.

## Unified Framework Approach

This project uses **Flutter as the single framework** to avoid conflicts between web and mobile implementations:

- **Single Codebase**: One Flutter project for all platforms (iOS, Android, Web, Desktop)
- **Unified Design System**: Consistent liquid glass UI across all platforms
- **Shared Business Logic**: No duplicate code between web and mobile
- **Cross-platform Compatibility**: Native performance on all devices

## Platforms Supported

- **Mobile** (iOS & Android)
- **Web** (Chrome, Safari, Firefox, Edge)
- **Desktop** (Windows, macOS, Linux)

## Features

### User Experience
- **Liquid Glass Design**: Modern glassmorphism UI with animated backgrounds
- **Dark/Light Themes**: Automatic theme switching
- **Swahili Localization**: Localized for Tanzanian users
- **Responsive Design**: Adapts to all screen sizes

### Core Functionality
- **User Authentication**: Login/registration with social options
- **Service Booking**: Complete booking management system
- **Dashboard**: Analytics and booking overview
- **Profile Management**: Skills, settings, and personal information
- **Real-time Updates**: Live booking status and notifications

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **UI**: Material 3 Design System
- **Fonts**: Google Fonts (Inter)
- **State Management**: Provider/Bloc pattern ready
- **Navigation**: Flutter Router
- **Storage**: Ready for Firebase/SQLite integration

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app_router.dart           # Navigation routing
├── theme/
│   └── app_theme.dart        # Unified theme system
├── widgets/
│   ├── glass_card.dart       # Glass morphism widgets
│   └── liquid_button.dart    # Interactive buttons
├── screens/
│   ├── auth/                 # Authentication screens
│   ├── dashboard_screen.dart # Main dashboard
│   ├── bookings_screen.dart  # Booking management
│   └── profile_screen.dart   # User profile
└── services/                # Business logic (ready for implementation)
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.11.4)
- Dart SDK
- For web: Chrome browser
- For mobile: Android Studio / Xcode

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/davidngungila/kazipoa.git
   cd kazipoa
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   **Mobile:**
   ```bash
   flutter run
   ```
   
   **Web:**
   ```bash
   flutter run -d chrome
   ```
   
   **Desktop:**
   ```bash
   flutter run -d windows    # Windows
   flutter run -d macos      # macOS
   flutter run -d linux      # Linux
   ```

## Development

### Web Development
```bash
flutter run -d chrome --web-renderer html
```

### Mobile Development
```bash
flutter run                    # Runs on connected device/emulator
flutter devices               # List available devices
```

### Build for Production
```bash
# Web
flutter build web

# Android
flutter build apk

# iOS
flutter build ios

# Desktop
flutter build windows
flutter build macos
flutter build linux
```

## Current Status

### Completed
- [x] Unified Flutter framework setup
- [x] Complete UI design system (liquid glass theme)
- [x] All core screens implemented
- [x] Navigation and routing
- [x] Cross-platform compatibility
- [x] Theme switching (light/dark)
- [x] Responsive design

### In Progress
- [ ] Backend integration (Firebase/Supabase)
- [ ] Real-time booking system
- [ ] Payment integration
- [ ] Push notifications
- [ ] Advanced analytics

### Planned
- [ ] Service provider marketplace
- [ ] In-app messaging
- [ ] Review and rating system
- [ ] Advanced filtering and search
- [ ] Offline mode support

## Web vs Mobile Migration

The original "Kazi poa app" (vanilla JavaScript) has been **migrated to Flutter** to provide:

- **Single Codebase**: No more maintaining separate web and mobile apps
- **Better Performance**: Native compilation for all platforms
- **Unified UI**: Consistent experience across devices
- **Easier Maintenance**: One codebase to update and debug
- **Future-proof**: Flutter's growing ecosystem and support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions:
- Create an issue in the GitHub repository
- Email: support@kazipoa.tz
- Phone: +255 712 345 678

---

**Built with ❤️ using Flutter for the Tanzanian market**
