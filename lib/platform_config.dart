import 'package:flutter/foundation.dart' show kIsWeb, kIsWindows, kIsMacOS, kIsLinux;

/// Platform configuration for unified Flutter app
class PlatformConfig {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb && !isDesktop;
  static bool get isDesktop => kIsWindows || kIsMacOS || kIsLinux;
  static bool get isWindows => kIsWindows;
  static bool get isMacOS => kIsMacOS;
  static bool get isLinux => kIsLinux;

  /// Platform-specific UI adjustments
  static double get defaultPadding {
    if (isWeb) return 24.0;
    if (isMobile) return 16.0;
    return 32.0; // Desktop
  }

  static double get cardWidth {
    if (isWeb) return 400.0;
    if (isMobile) return double.infinity;
    return 600.0; // Desktop
  }

  static double get maxWidth {
    if (isWeb) return 1200.0;
    if (isMobile) return double.infinity;
    return 800.0; // Desktop
  }

  /// Platform-specific features
  static bool get supportsFilePicker => !isWeb || isWeb;
  static bool get supportsNotifications => true;
  static bool get supportsLocalStorage => true;
  static bool get supportsCamera => !isWeb;

  /// Platform-specific navigation
  static bool get useDrawer => isMobile;
  static bool get useRail => isDesktop;
  static bool get useBottomNav => isMobile;

  /// Platform-specific animations
  static Duration get defaultAnimationDuration {
    if (isWeb) return const Duration(milliseconds: 200);
    return const Duration(milliseconds: 300);
  }

  /// Platform-specific rendering
  static String get webRenderer {
    if (isWeb) return 'canvaskit';
    return 'default';
  }

  /// Platform-specific storage
  static String get storagePrefix {
    if (isWeb) return 'kazipoa_web_';
    if (isMobile) return 'kazipoa_mobile_';
    return 'kazipoa_desktop_';
  }

  /// Platform-specific API endpoints
  static String get apiBaseUrl {
    if (kDebugMode) {
      return 'http://localhost:3000/api';
    }
    return 'https://api.kazipoa.tz';
  }

  /// Platform-specific app configuration
  static Map<String, dynamic> get appConfig {
    return {
      'name': 'Kazipoa',
      'version': '1.0.0',
      'platform': _getCurrentPlatform(),
      'buildNumber': '1',
      'supportsMultiWindow': isDesktop,
      'supportsOffline': true,
      'supportsPushNotifications': !isWeb,
      'supportsBiometric': isMobile,
    };
  }

  static String _getCurrentPlatform() {
    if (isWeb) return 'Web';
    if (isWindows) return 'Windows';
    if (isMacOS) return 'macOS';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Platform-specific theme adjustments
  static bool get useSystemTheme => isDesktop || isMobile;
  static bool get enableTransparency => !isWeb;
  static bool get enableBlur => !isWeb || isWeb;

  /// Platform-specific performance settings
  static int get maxCacheSize {
    if (isMobile) return 50; // MB
    if (isWeb) return 20; // MB
    return 100; // MB - Desktop
  }

  static bool get enableLazyLoading => true;
  static bool get enableVirtualization => isWeb || isDesktop;

  /// Platform-specific debugging
  static bool get enableDebugMode => kDebugMode;
  static bool get enablePerformanceOverlay => kDebugMode && isWeb;
  static bool get enableInspector => kDebugMode;
}

/// Platform-specific utilities
class PlatformUtils {
  /// Get platform-specific safe areas
  static EdgeInsets getSafeAreaPadding() {
    if (PlatformConfig.isMobile) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
    return const EdgeInsets.all(24);
  }

  /// Get platform-specific breakpoints
  static double get mobileBreakpoint => 600;
  static double get tabletBreakpoint => 1024;
  static double get desktopBreakpoint => 1440;

  /// Check if current viewport is mobile-sized
  static bool isMobileSize(double width) => width < mobileBreakpoint;
  
  /// Check if current viewport is tablet-sized
  static bool isTabletSize(double width) => 
      width >= mobileBreakpoint && width < tabletBreakpoint;
  
  /// Check if current viewport is desktop-sized
  static bool isDesktopSize(double width) => width >= tabletBreakpoint;

  /// Get responsive column count
  static int getResponsiveColumnCount(double width) {
    if (isMobileSize(width)) return 1;
    if (isTabletSize(width)) return 2;
    return 3; // Desktop
  }

  /// Get responsive font size multiplier
  static double getResponsiveFontScale(double width) {
    if (isMobileSize(width)) return 1.0;
    if (isTabletSize(width)) return 1.1;
    return 1.2; // Desktop
  }
}
