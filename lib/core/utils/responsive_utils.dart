import 'package:flutter/material.dart';

/// Centralized responsive utilities for Kazipoa app
/// Replaces all hardcoded pixel values with responsive calculations
class ResponsiveUtils {
  
  // Base screen size for calculations (iPhone 12 dimensions)
  static const double baseWidth = 390.0;
  static const double baseHeight = 844.0;
  
  /// Get responsive width based on screen size
  static double getWidth(BuildContext context, double baseValue) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / baseWidth;
    return (baseValue * scaleFactor).clamp(baseValue * 0.7, baseValue * 1.5);
  }
  
  /// Get responsive height based on screen size
  static double getHeight(BuildContext context, double baseValue) {
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = screenHeight / baseHeight;
    return (baseValue * scaleFactor).clamp(baseValue * 0.7, baseValue * 1.5);
  }
  
  /// Get responsive font size
  static double getFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / baseWidth;
    return (baseSize * scaleFactor).clamp(baseSize * 0.8, baseSize * 1.3);
  }
  
  /// Get responsive padding
  static EdgeInsets getPadding(BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
    double all = 0,
  }) {
    if (all > 0) {
      return EdgeInsets.all(getWidth(context, all));
    }
    return EdgeInsets.symmetric(
      horizontal: getWidth(context, horizontal),
      vertical: getHeight(context, vertical),
    );
  }
  
  /// Get responsive margin
  static EdgeInsets getMargin(BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
    double all = 0,
  }) {
    if (all > 0) {
      return EdgeInsets.all(getWidth(context, all));
    }
    return EdgeInsets.symmetric(
      horizontal: getWidth(context, horizontal),
      vertical: getHeight(context, vertical),
    );
  }
  
  /// Get responsive border radius
  static double getBorderRadius(BuildContext context, double baseRadius) {
    return getWidth(context, baseRadius);
  }
  
  /// Get responsive icon size
  static double getIconSize(BuildContext context, double baseSize) {
    return getWidth(context, baseSize);
  }
  
  /// Get responsive spacing (for SizedBox)
  static double getSpacing(BuildContext context, double baseSpacing) {
    return getHeight(context, baseSpacing);
  }
  
  // Pre-defined responsive spacing values
  static double spacingXS(BuildContext context) => getSpacing(context, 4);
  static double spacingSM(BuildContext context) => getSpacing(context, 8);
  static double spacingMD(BuildContext context) => getSpacing(context, 16);
  static double spacingLG(BuildContext context) => getSpacing(context, 24);
  static double spacingXL(BuildContext context) => getSpacing(context, 32);
  static double spacingXXL(BuildContext context) => getSpacing(context, 48);
  
  // Pre-defined responsive sizes
  static double iconXS(BuildContext context) => getIconSize(context, 16);
  static double iconSM(BuildContext context) => getIconSize(context, 20);
  static double iconMD(BuildContext context) => getIconSize(context, 24);
  static double iconLG(BuildContext context) => getIconSize(context, 32);
  static double iconXL(BuildContext context) => getIconSize(context, 40);
  
  // Pre-defined responsive container sizes
  static double containerXS(BuildContext context) => getWidth(context, 40);
  static double containerSM(BuildContext context) => getWidth(context, 60);
  static double containerMD(BuildContext context) => getWidth(context, 80);
  static double containerLG(BuildContext context) => getWidth(context, 120);
  static double containerXL(BuildContext context) => getWidth(context, 160);
}

/// Extension methods for easier usage
extension ResponsiveContext on BuildContext {
  double w(double baseValue) => ResponsiveUtils.getWidth(this, baseValue);
  double h(double baseValue) => ResponsiveUtils.getHeight(this, baseValue);
  double fs(double baseSize) => ResponsiveUtils.getFontSize(this, baseSize);
  EdgeInsets p({double h = 0, double v = 0, double all = 0}) => 
    ResponsiveUtils.getPadding(this, horizontal: h, vertical: v, all: all);
  EdgeInsets m({double h = 0, double v = 0, double all = 0}) => 
    ResponsiveUtils.getMargin(this, horizontal: h, vertical: v, all: all);
  double br(double baseRadius) => ResponsiveUtils.getBorderRadius(this, baseRadius);
  double icon(double baseSize) => ResponsiveUtils.getIconSize(this, baseSize);
  double sp(double baseSpacing) => ResponsiveUtils.getSpacing(this, baseSpacing);
}
