import 'package:flutter/material.dart';

class ResponsiveLayout {
  // Screen size breakpoints
  static const double mobileSmall = 320;
  static const double mobileMedium = 375;
  static const double mobileLarge = 414;
  static const double tabletSmall = 768;
  static const double tabletLarge = 1024;
  
  // Get screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileSmall) return ScreenSize.mobileExtraSmall;
    if (width < mobileMedium) return ScreenSize.mobileSmall;
    if (width < mobileLarge) return ScreenSize.mobileMedium;
    if (width < tabletSmall) return ScreenSize.mobileLarge;
    if (width < tabletLarge) return ScreenSize.tabletSmall;
    return ScreenSize.tabletLarge;
  }
  
  // Responsive spacing
  static double getSpacing(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobileExtraSmall:
        return 8.0;
      case ScreenSize.mobileSmall:
        return 12.0;
      case ScreenSize.mobileMedium:
        return 16.0;
      case ScreenSize.mobileLarge:
        return 20.0;
      case ScreenSize.tabletSmall:
        return 24.0;
      case ScreenSize.tabletLarge:
        return 32.0;
    }
  }
  
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (width * 0.04).clamp(12.0, 32.0);
  }
  
  static double getVerticalPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return (height * 0.02).clamp(8.0, 24.0);
  }
  
  // Responsive card dimensions
  static double getCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = getHorizontalPadding(context) * 2;
    return (width - padding).clamp(280.0, 400.0);
  }
  
  static double getCardHeight(BuildContext context, {double minHeight = 120}) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobileExtraSmall:
        return minHeight * 0.8;
      case ScreenSize.mobileSmall:
        return minHeight * 0.9;
      case ScreenSize.mobileMedium:
        return minHeight;
      case ScreenSize.mobileLarge:
        return minHeight * 1.1;
      case ScreenSize.tabletSmall:
        return minHeight * 1.2;
      case ScreenSize.tabletLarge:
        return minHeight * 1.3;
    }
  }
  
  // Responsive button dimensions
  static double getButtonHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return (height * 0.06).clamp(44.0, 56.0);
  }
  
  static double getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (width * 0.06).clamp(20.0, 32.0);
  }
  
  // Safe area helpers
  static EdgeInsets getSafeEdgeInsets(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;
    final viewInsets = mediaQuery.viewInsets;
    
    return EdgeInsets.only(
      top: padding.top,
      bottom: padding.bottom + viewInsets.bottom,
      left: padding.left,
      right: padding.right,
    );
  }
  
  // Responsive constraints
  static BoxConstraints getCardConstraints(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final maxWidth = (width * 0.9).clamp(280.0, 400.0);
    
    return BoxConstraints(
      maxWidth: maxWidth,
      minWidth: 280.0,
      minHeight: getCardHeight(context),
    );
  }
  
  // Responsive grid columns
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1;
    if (width < 900) return 2;
    return 3;
  }
  
  // Check if device is small
  static bool isSmallDevice(BuildContext context) {
    return getScreenSize(context).index <= ScreenSize.mobileSmall.index;
  }
  
  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    return getScreenSize(context).index >= ScreenSize.tabletSmall.index;
  }
}

enum ScreenSize {
  mobileExtraSmall,
  mobileSmall,
  mobileMedium,
  mobileLarge,
  tabletSmall,
  tabletLarge,
}

// Responsive widget wrapper
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.constraints,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: ResponsiveLayout.getHorizontalPadding(context),
      vertical: ResponsiveLayout.getVerticalPadding(context),
    );
    
    return Container(
      width: width,
      height: height,
      padding: responsivePadding,
      constraints: constraints ?? ResponsiveLayout.getCardConstraints(context),
      child: child,
    );
  }
}

// Safe area scaffold wrapper
class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  
  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        top: appBar != null ? false : true,
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

// Responsive card widget
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Color? color;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  
  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.color,
    this.border,
    this.boxShadow,
    this.borderRadius,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final defaultShadow = boxShadow ?? [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ];
    
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final defaultPadding = padding ?? EdgeInsets.all(ResponsiveLayout.getSpacing(context));
    
    Widget card = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: defaultBorderRadius,
        border: border,
        boxShadow: defaultShadow,
      ),
      child: Padding(
        padding: defaultPadding,
        child: child,
      ),
    );
    
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: defaultBorderRadius,
          onTap: onTap,
          child: card,
        ),
      );
    }
    
    return card;
  }
}
