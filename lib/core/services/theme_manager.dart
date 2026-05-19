import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/storage_manager.dart';

/// Theme Manager - Equivalent to JavaScript ThemeManager
/// Handles app themes, color schemes, and theme persistence
class ThemeManager {
  static const String _fontSizeKey = 'font_size';
  
  ThemeMode _currentThemeMode = ThemeMode.light;
  String _currentLanguage = 'sw';
  double _currentFontSize = 14.0;
  final List<void Function()> _themeListeners = [];

  // Getters
  ThemeMode get currentThemeMode => _currentThemeMode;
  String get currentLanguage => _currentLanguage;
  double get currentFontSize => _currentFontSize;
  bool get isDarkMode => _currentThemeMode == ThemeMode.dark;

  /// Initialize theme manager
  Future<void> init() async {
    try {
      // Load saved theme preferences
      _currentThemeMode = await _getThemeMode();
      _currentLanguage = await StorageManager.getLanguage();
      _currentFontSize = await StorageManager.get<double>(_fontSizeKey) ?? 14.0;
      
      print('Theme initialized: ${_currentThemeMode.name}, Language: $_currentLanguage');
    } catch (e) {
      print('Error initializing theme: $e');
    }
  }

  /// Get theme mode from storage
  Future<ThemeMode> _getThemeMode() async {
    final themeString = await StorageManager.getTheme();
    switch (themeString.toLowerCase()) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _currentThemeMode = themeMode;
    
    // Save to storage
    final themeString = themeMode.name;
    await StorageManager.setTheme(themeString);
    
    // Notify listeners
    _notifyThemeListeners();
    
    print('Theme changed to: ${themeMode.name}');
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newTheme = _currentThemeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    await setThemeMode(newTheme);
  }

  /// Set app language
  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    await StorageManager.setLanguage(language);
    _notifyThemeListeners();
    print('Language changed to: $language');
  }

  /// Set font size
  Future<void> setFontSize(double fontSize) async {
    _currentFontSize = fontSize.clamp(10.0, 24.0);
    await StorageManager.set(_fontSizeKey, _currentFontSize);
    _notifyThemeListeners();
    print('Font size changed to: $_currentFontSize');
  }

  /// Get light theme data
  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F00E7),
        brightness: Brightness.light,
        primary: const Color(0xFF0F00E7),
        secondary: const Color(0xFF6366F1),
        surface: const Color(0xFFF8FAFC),
        background: const Color(0xFFF8FAFC),
        error: const Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF0F172A),
        onBackground: const Color(0xFF0F172A),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Color(0xFF3B82F6),
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF0F00E7),
          size: 24,
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.7),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F00E7),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shadowColor: const Color(0xFF0F00E7).withOpacity(0.2),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF0F00E7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF475569),
          side: const BorderSide(color: Color(0xFF475569)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF0F00E7),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: const Color(0xFF475569).withOpacity(0.6),
          fontSize: 14,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: _currentFontSize + 8,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A),
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: _currentFontSize + 6,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A),
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: _currentFontSize + 4,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A),
        ),
        headlineLarge: TextStyle(
          fontSize: _currentFontSize + 6,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF0F172A),
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          fontSize: _currentFontSize + 4,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF0F172A),
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: _currentFontSize + 2,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF0F172A),
        ),
        titleLarge: TextStyle(
          fontSize: _currentFontSize + 2,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A),
        ),
        titleMedium: TextStyle(
          fontSize: _currentFontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A),
        ),
        titleSmall: TextStyle(
          fontSize: _currentFontSize - 1,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A),
        ),
        bodyLarge: TextStyle(
          fontSize: _currentFontSize + 1,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF475569),
        ),
        bodyMedium: TextStyle(
          fontSize: _currentFontSize,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF475569),
        ),
        bodySmall: TextStyle(
          fontSize: _currentFontSize - 1,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF475569),
        ),
        labelLarge: TextStyle(
          fontSize: _currentFontSize,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF475569),
        ),
        labelMedium: TextStyle(
          fontSize: _currentFontSize - 1,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF475569),
        ),
        labelSmall: TextStyle(
          fontSize: _currentFontSize - 2,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF475569),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF475569),
        size: 24,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF0F00E7),
        unselectedItemColor: Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  /// Get dark theme data
  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F00E7),
        brightness: Brightness.dark,
        primary: const Color(0xFF0F00E7),
        secondary: const Color(0xFF6366F1),
        surface: const Color(0xFF0F172A),
        background: const Color(0xFF0F172A),
        error: const Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFFF8FAFC),
        onBackground: const Color(0xFFF8FAFC),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Color(0xFF3B82F6),
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF0F00E7),
          size: 24,
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(0xFF334155),
            width: 1,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F00E7),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shadowColor: const Color(0xFF0F00E7).withOpacity(0.2),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF0F00E7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF94A3B8),
          side: const BorderSide(color: Color(0xFF94A3B8)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF334155),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF334155),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF0F00E7),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 14,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 14,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: _currentFontSize + 8,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF8FAFC),
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: _currentFontSize + 6,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF8FAFC),
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: _currentFontSize + 4,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF8FAFC),
        ),
        headlineLarge: TextStyle(
          fontSize: _currentFontSize + 6,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFF8FAFC),
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          fontSize: _currentFontSize + 4,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFF8FAFC),
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: _currentFontSize + 2,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFF8FAFC),
        ),
        titleLarge: TextStyle(
          fontSize: _currentFontSize + 2,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF8FAFC),
        ),
        titleMedium: TextStyle(
          fontSize: _currentFontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF8FAFC),
        ),
        titleSmall: TextStyle(
          fontSize: _currentFontSize - 1,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF8FAFC),
        ),
        bodyLarge: TextStyle(
          fontSize: _currentFontSize + 1,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF94A3B8),
        ),
        bodyMedium: TextStyle(
          fontSize: _currentFontSize,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF94A3B8),
        ),
        bodySmall: TextStyle(
          fontSize: _currentFontSize - 1,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF94A3B8),
        ),
        labelLarge: TextStyle(
          fontSize: _currentFontSize,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF94A3B8),
        ),
        labelMedium: TextStyle(
          fontSize: _currentFontSize - 1,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF94A3B8),
        ),
        labelSmall: TextStyle(
          fontSize: _currentFontSize - 2,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF94A3B8),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF94A3B8),
        size: 24,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0F172A),
        selectedItemColor: Color(0xFF0F00E7),
        unselectedItemColor: Color(0xFF64748B),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  /// Get current theme data based on theme mode
  ThemeData getCurrentTheme(BuildContext context) {
    switch (_currentThemeMode) {
      case ThemeMode.dark:
        return getDarkTheme();
      case ThemeMode.light:
        return getLightTheme();
      case ThemeMode.system:
        final brightness = MediaQuery.of(context).platformBrightness;
        return brightness == Brightness.dark ? getDarkTheme() : getLightTheme();
    }
  }

  /// Get theme data for specific mode
  ThemeData getThemeData(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return getDarkTheme();
      case ThemeMode.light:
        return getLightTheme();
      case ThemeMode.system:
        return getLightTheme(); // Default to light for system mode
    }
  }

  /// Add theme listener
  void addThemeListener(void Function() listener) {
    _themeListeners.add(listener);
  }

  /// Remove theme listener
  void removeThemeListener(void Function() listener) {
    _themeListeners.remove(listener);
  }

  /// Notify all theme listeners
  void _notifyThemeListeners() {
    for (final listener in _themeListeners) {
      try {
        listener();
      } catch (e) {
        print('Error in theme listener: $e');
      }
    }
  }

  /// Get available themes
  List<Map<String, dynamic>> getAvailableThemes() {
    return [
      {
        'name': 'Mwanga',
        'mode': ThemeMode.light,
        'icon': Icons.light_mode,
        'description': 'Rangi angavu na rahisi kuona',
      },
      {
        'name': 'Giza',
        'mode': ThemeMode.dark,
        'icon': Icons.dark_mode,
        'description': 'Rangi giza iliopunguza machozi',
      },
      {
        'name': 'Ya Kifaa',
        'mode': ThemeMode.system,
        'icon': Icons.settings_brightness,
        'description': 'Tumia mipangilio ya kifaa chako',
      },
    ];
  }

  /// Get available languages
  List<Map<String, dynamic>> getAvailableLanguages() {
    return [
      {
        'code': 'sw',
        'name': 'Kiswahili',
        'nativeName': 'Kiswahili',
        'flag': 'TZ',
      },
      {
        'code': 'en',
        'name': 'English',
        'nativeName': 'English',
        'flag': 'US',
      },
    ];
  }

  /// Get available font sizes
  List<Map<String, dynamic>> getAvailableFontSizes() {
    return [
      {'size': 10.0, 'name': 'Ndogo', 'description': 'Herufi ndogo'},
      {'size': 12.0, 'name': 'Kawaida', 'description': 'Herufi za kawaida'},
      {'size': 14.0, 'name': 'Kubwa', 'description': 'Herufi kubwa'},
      {'size': 16.0, 'name': 'Kubwa Zaidi', 'description': 'Herufi kubwa zaidi'},
      {'size': 18.0, 'name': 'Kubwa Sana', 'description': 'Herufi kubwa sana'},
      {'size': 20.0, 'name': 'Kubwa Zaidi', 'description': 'Herufi kubwa zaidi'},
    ];
  }

  /// Reset theme to defaults
  Future<void> resetToDefaults() async {
    await setThemeMode(ThemeMode.light);
    await setLanguage('sw');
    await setFontSize(14.0);
  }

  /// Get theme preferences as map
  Map<String, dynamic> getThemePreferences() {
    return {
      'themeMode': _currentThemeMode.name,
      'language': _currentLanguage,
      'fontSize': _currentFontSize,
      'isDarkMode': isDarkMode,
    };
  }

  /// Apply theme preferences from map
  Future<void> applyThemePreferences(Map<String, dynamic> preferences) async {
    if (preferences.containsKey('themeMode')) {
      final themeModeString = preferences['themeMode'] as String;
      final themeMode = _parseThemeMode(themeModeString);
      await setThemeMode(themeMode);
    }
    
    if (preferences.containsKey('language')) {
      await setLanguage(preferences['language'] as String);
    }
    
    if (preferences.containsKey('fontSize')) {
      await setFontSize((preferences['fontSize'] as num).toDouble());
    }
  }

  /// Parse theme mode from string
  ThemeMode _parseThemeMode(String themeModeString) {
    switch (themeModeString.toLowerCase()) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Dispose method
  void dispose() {
    _themeListeners.clear();
  }
}

// Provider
final themeManagerProvider = Provider<ThemeManager>((ref) {
  final manager = ThemeManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});

// Extension for easy access in widgets
extension ThemeManagerRef on WidgetRef {
  ThemeManager get theme => read(themeManagerProvider);
}
