import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0F00E7);
  static const Color surfaceColor = Color(0xFFF8FAFC);
  static const Color onSurfaceColor = Color(0xFF0F172A);
  static const Color surfaceVariantColor = Color(0xFFF1F5F9);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color tertiaryColor = Color(0xFFF59E0B);
  static const Color secondaryColor = Color(0xFF6366F1);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        surfaceContainerHighest: Color(0xFFD1D5DB),
        error: errorColor,
        tertiary: tertiaryColor,
        secondary: secondaryColor,
        surfaceContainerHigh: Color(0xFFE2E8F0),
        surfaceContainerLow: Color(0xFFF1F5F9),
        onSurfaceVariant: Color(0xFF475569),
        outline: Color(0xFFCBD5E1),
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: onSurfaceColor,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: onSurfaceColor,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: onSurfaceColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: onSurfaceColor,
          ),
          labelLarge: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: onSurfaceColor,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: primaryColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: errorColor,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        surface: const Color(0xFF1E293B),
        onSurface: Colors.white,
        surfaceContainerHighest: const Color(0xFF334155),
        error: errorColor,
        tertiary: tertiaryColor,
        secondary: secondaryColor,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          labelLarge: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
