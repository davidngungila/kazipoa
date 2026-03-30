import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color lightPurple = Color(0xFFE9D5FF);
  static const Color lavenderBackground = Color(0xFFF3E8FF);
  static const Color darkGrey = Color(0xFF374151);
  static const Color mediumGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFF9CA3AF);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);

  static const Color darkBackground = Color(0xFF1F2937);
  static const Color darkSurface = Color(0xFF374151);
  static const Color darkOnSurface = Color(0xFFF9FAFB);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: MaterialColor(primaryPurple.value, _getSwatch(primaryPurple)),
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.light(
        primary: primaryPurple,
        secondary: lightPurple,
        surface: Colors.white,
        onSurface: darkGrey,
        error: errorColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: lavenderBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          side: const BorderSide(color: primaryPurple, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(color: mediumGrey),
        hintStyle: const TextStyle(color: lightGrey),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        color: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryPurple,
        unselectedItemColor: lightGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkGrey,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkGrey,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkGrey,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkGrey,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkGrey,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: mediumGrey,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: mediumGrey,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: mediumGrey,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(primaryPurple.value, _getSwatch(primaryPurple)),
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: lightPurple,
        surface: darkSurface,
        onSurface: darkOnSurface,
        error: errorColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkOnSurface,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          side: const BorderSide(color: primaryPurple, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF374151),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4B5563)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4B5563)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        color: darkSurface,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryPurple,
        unselectedItemColor: Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkOnSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkOnSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFFD1D5DB),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFFD1D5DB),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFD1D5DB),
        ),
      ),
    );
  }

  static Map<int, Color> _getSwatch(Color color) {
    final swatch = <int, Color>{};
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    swatch[50] = Color.fromRGBO(r, g, b, .1);
    swatch[100] = Color.fromRGBO(r, g, b, .2);
    swatch[200] = Color.fromRGBO(r, g, b, .3);
    swatch[300] = Color.fromRGBO(r, g, b, .4);
    swatch[400] = Color.fromRGBO(r, g, b, .5);
    swatch[500] = Color.fromRGBO(r, g, b, .6);
    swatch[600] = Color.fromRGBO(r, g, b, .7);
    swatch[700] = Color.fromRGBO(r, g, b, .8);
    swatch[800] = Color.fromRGBO(r, g, b, .9);
    swatch[900] = Color.fromRGBO(r, g, b, 1);

    return swatch;
  }
}
