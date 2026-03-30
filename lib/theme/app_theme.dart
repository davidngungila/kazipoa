import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KazipoaTheme {
  // Brand Colors from web design
  static const Color primaryColor = Color(0xFF0F00E7);
  static const Color primaryLight = Color(0xFFE0E7FF);
  static const Color primaryDark = Color(0xFF0F00E7);
  static const Color secondaryColor = Color(0xFF6366F1);
  static const Color tertiaryColor = Color(0xFFF59E0B);
  
  // Surface Colors
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFF8FAFC);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceContainer = Color(0xFFF1F5F9);
  static const Color surfaceContainerLow = Color(0xFFFFFFFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F0);
  static const Color surfaceContainerHighest = Color(0xFFD1D5DB);
  
  // Text Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF0F172A);
  static const Color onBackground = Color(0xFF0F172A);
  static const Color onSurfaceVariant = Color(0xFF475569);
  
  // Status Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkOnSurface = Color(0xFFF1F5F9);
  static const Color darkOnBackground = Color(0xFFF1F5F9);
  static const Color darkOnSurfaceVariant = Color(0xFFCBD5E1);

  // Glass Morphism Colors
  static const Color glassBackground = Color(0x40FFFFFF); // rgba(255, 255, 255, 0.4)
  static const Color glassBorder = Color(0x80FFFFFF); // rgba(255, 255, 255, 0.5)
  static const Color darkGlassBackground = Color(0x801E293B); // rgba(30, 41, 59, 0.5)
  static const Color darkGlassBorder = Color(0x1AFFFFFF); // rgba(255, 255, 255, 0.1)

  // Text Styles
  static TextStyle headlineLarge(Color onSurface) => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: onSurface,
  );

  static TextStyle headlineMedium(Color onSurface) => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: onSurface,
  );

  static TextStyle headlineSmall(Color onSurface) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: onSurface,
  );

  static TextStyle titleLarge(Color onSurface) => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: onSurface,
  );

  static TextStyle titleMedium(Color onSurface) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: onSurface,
  );

  static TextStyle titleSmall(Color onSurface) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: onSurface,
  );

  static TextStyle bodyLarge(Color onSurface) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: onSurface,
  );

  static TextStyle bodyMedium(Color onSurface) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: onSurface,
  );

  static TextStyle bodySmall(Color onSurfaceVariant) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: onSurfaceVariant,
  );

  static TextStyle labelLarge(Color onSurface) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: onSurface,
  );

  static TextStyle labelMedium(Color onSurface) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: onSurface,
  );

  static TextStyle labelSmall(Color onSurfaceVariant) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: onSurfaceVariant,
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: surfaceColor,
        surfaceVariant: surfaceVariant,
        background: backgroundColor,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onSurface: onSurface,
        onBackground: onBackground,
        onSurfaceVariant: onSurfaceVariant,
        error: errorColor,
        onError: onPrimary,
        surfaceContainer: surfaceContainer,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainerHigh: surfaceContainerHigh,
        surfaceContainerHighest: surfaceContainerHighest,
      ),
      textTheme: TextTheme(
        displayLarge: headlineLarge(onSurface),
        displayMedium: headlineMedium(onSurface),
        displaySmall: headlineSmall(onSurface),
        headlineLarge: headlineLarge(onSurface),
        headlineMedium: headlineMedium(onSurface),
        headlineSmall: headlineSmall(onSurface),
        titleLarge: titleLarge(onSurface),
        titleMedium: titleMedium(onSurface),
        titleSmall: titleSmall(onSurface),
        bodyLarge: bodyLarge(onSurface),
        bodyMedium: bodyMedium(onSurface),
        bodySmall: bodySmall(onSurfaceVariant),
        labelLarge: labelLarge(onSurface),
        labelMedium: labelMedium(onSurface),
        labelSmall: labelSmall(onSurfaceVariant),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceContainerLow,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: onSurface.withOpacity(0.1),
        surfaceTintColor: primaryColor,
        titleTextStyle: titleLarge(onSurface),
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: surfaceContainerLow,
        elevation: 2,
        shadowColor: onSurface.withOpacity(0.1),
        surfaceTintColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimary,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
          surfaceTintColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: titleMedium(onSurface),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: titleMedium(onSurface),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: titleMedium(onSurface),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurfaceVariant.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurfaceVariant.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: labelMedium(onSurface),
        hintStyle: labelMedium(onSurface).copyWith(color: onSurfaceVariant),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceContainerLow,
        selectedItemColor: primaryColor,
        unselectedItemColor: onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: labelSmall(onSurfaceVariant),
        unselectedLabelStyle: labelSmall(onSurfaceVariant),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainer,
        selectedColor: primaryColor.withOpacity(0.1),
        disabledColor: surfaceVariant,
        labelStyle: labelMedium(onSurface),
        secondaryLabelStyle: labelSmall(onSurfaceVariant),
        brightness: Brightness.light,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: darkSurface,
        surfaceVariant: darkSurfaceVariant,
        background: darkBackground,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onSurface: darkOnSurface,
        onBackground: darkOnBackground,
        onSurfaceVariant: darkOnSurfaceVariant,
        error: errorColor,
        onError: onPrimary,
        surfaceContainer: darkSurface,
        surfaceContainerLow: darkSurfaceVariant,
        surfaceContainerHigh: darkBackground,
        surfaceContainerHighest: Color(0xFF1E293B),
      ),
      textTheme: TextTheme(
        displayLarge: headlineLarge(darkOnSurface),
        displayMedium: headlineMedium(darkOnSurface),
        displaySmall: headlineSmall(darkOnSurface),
        headlineLarge: headlineLarge(darkOnSurface),
        headlineMedium: headlineMedium(darkOnSurface),
        headlineSmall: headlineSmall(darkOnSurface),
        titleLarge: titleLarge(darkOnSurface),
        titleMedium: titleMedium(darkOnSurface),
        titleSmall: titleSmall(darkOnSurface),
        bodyLarge: bodyLarge(darkOnSurface),
        bodyMedium: bodyMedium(darkOnSurface),
        bodySmall: bodySmall(darkOnSurfaceVariant),
        labelLarge: labelLarge(darkOnSurface),
        labelMedium: labelMedium(darkOnSurface),
        labelSmall: labelSmall(darkOnSurfaceVariant),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkOnSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black.withOpacity(0.3),
        surfaceTintColor: primaryColor,
        titleTextStyle: titleLarge(darkOnSurface),
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: darkSurfaceVariant,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        surfaceTintColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimary,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
          surfaceTintColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: titleMedium(onSurface),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: titleMedium(onSurface),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: titleMedium(onSurface),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkOnSurfaceVariant.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkOnSurfaceVariant.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: labelMedium(darkOnSurface),
        hintStyle: labelMedium(darkOnSurface).copyWith(color: darkOnSurfaceVariant),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkOnSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: labelSmall(darkOnSurfaceVariant),
        unselectedLabelStyle: labelSmall(darkOnSurfaceVariant),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVariant,
        selectedColor: primaryColor.withOpacity(0.2),
        disabledColor: darkBackground,
        labelStyle: labelMedium(darkOnSurface),
        secondaryLabelStyle: labelSmall(darkOnSurfaceVariant),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
