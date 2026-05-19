import 'package:flutter/material.dart';

class ResponsiveText {
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Use the smaller dimension to ensure text fits on all screens
    final minDimension = screenWidth < screenHeight ? screenWidth : screenHeight;
    
    // Scale factor based on screen size (320 is the base small phone width)
    double scaleFactor = minDimension / 320.0;
    
    // Clamp the scale factor to prevent text from being too large or too small
    scaleFactor = scaleFactor.clamp(0.8, 1.4);
    
    return baseFontSize * scaleFactor;
  }

  // Predefined responsive font sizes for consistency
  static double getHeading1(BuildContext context) => getResponsiveFontSize(context, 32.0);
  static double getHeading2(BuildContext context) => getResponsiveFontSize(context, 28.0);
  static double getHeading3(BuildContext context) => getResponsiveFontSize(context, 24.0);
  static double getHeading4(BuildContext context) => getResponsiveFontSize(context, 20.0);
  static double getSubtitle1(BuildContext context) => getResponsiveFontSize(context, 18.0);
  static double getSubtitle2(BuildContext context) => getResponsiveFontSize(context, 16.0);
  static double getBody1(BuildContext context) => getResponsiveFontSize(context, 16.0);
  static double getBody2(BuildContext context) => getResponsiveFontSize(context, 14.0);
  static double getCaption(BuildContext context) => getResponsiveFontSize(context, 12.0);
  static double getSmall(BuildContext context) => getResponsiveFontSize(context, 10.0);
  static double getTiny(BuildContext context) => getResponsiveFontSize(context, 8.0);

  // Responsive text styles
  static TextStyle getHeading1Style(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: getHeading1(context),
      fontWeight: FontWeight.bold,
      color: color ?? const Color(0xFF0F172A),
    );
  }

  static TextStyle getHeading2Style(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: getHeading2(context),
      fontWeight: FontWeight.bold,
      color: color ?? const Color(0xFF0F172A),
    );
  }

  static TextStyle getHeading3Style(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: getHeading3(context),
      fontWeight: FontWeight.w600,
      color: color ?? const Color(0xFF0F172A),
    );
  }

  static TextStyle getHeading4Style(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: getHeading4(context),
      fontWeight: FontWeight.w600,
      color: color ?? const Color(0xFF0F172A),
    );
  }

  static TextStyle getSubtitle1Style(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: getSubtitle1(context),
      fontWeight: FontWeight.w500,
      color: color ?? const Color(0xFF64748B),
    );
  }

  static TextStyle getSubtitle2Style(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: getSubtitle2(context),
      fontWeight: FontWeight.w500,
      color: color ?? const Color(0xFF64748B),
    );
  }

  static TextStyle getBody1Style(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: getBody1(context),
      fontWeight: FontWeight.normal,
      color: color ?? const Color(0xFF0F172A),
    );
  }

  static TextStyle getBody2Style(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: getBody2(context),
      fontWeight: FontWeight.normal,
      color: color ?? const Color(0xFF64748B),
    );
  }

  static TextStyle getCaptionStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: getCaption(context),
      fontWeight: FontWeight.w500,
      color: color ?? const Color(0xFF64748B),
    );
  }

  static TextStyle getSmallStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: getSmall(context),
      fontWeight: FontWeight.bold,
      color: color ?? const Color(0xFF64748B),
    );
  }
}
