import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Color? color;
  final double blur;
  final double opacity;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.color,
    this.blur = 15.0,
    this.opacity = 0.4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Widget card = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? (isDark ? KazipoaTheme.darkGlassBackground : KazipoaTheme.glassBackground),
        border: border ?? Border.all(
          color: isDark ? KazipoaTheme.darkGlassBorder : KazipoaTheme.glassBorder,
          width: 1,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(24),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: blur,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(24),
          child: card,
        ),
      );
    }

    return card;
  }
}

class LiquidGlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final bool animate;

  const LiquidGlassCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius,
    this.animate = true,
  }) : super(key: key);

  @override
  State<LiquidGlassCard> createState() => _LiquidGlassCardState();
}

class _LiquidGlassCardState extends State<LiquidGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(
        duration: const Duration(seconds: 20),
        vsync: this,
      );
      _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    if (widget.animate) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Widget card = AnimatedBuilder(
      animation: widget.animate ? _animation : const AlwaysStoppedAnimation(0),
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          padding: widget.padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: widget.animate 
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (isDark ? KazipoaTheme.darkGlassBackground : KazipoaTheme.glassBackground),
                      (isDark ? KazipoaTheme.darkGlassBackground.withOpacity(0.6) : KazipoaTheme.glassBackground.withOpacity(0.6)),
                    ],
                    stops: [
                      0.0,
                      (_animation.value * 0.5 + 0.5).clamp(0.0, 1.0),
                    ],
                  )
                : null,
            color: widget.animate 
                ? null 
                : (isDark ? KazipoaTheme.darkGlassBackground : KazipoaTheme.glassBackground),
            border: Border.all(
              color: isDark ? KazipoaTheme.darkGlassBorder : KazipoaTheme.glassBorder,
              width: 1,
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 32,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );

    if (widget.onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(24),
          child: card,
        ),
      );
    }

    return card;
  }
}

class FrostedGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final double sigma;
  final double opacity;

  const FrostedGlassCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius,
    this.sigma = 10.0,
    this.opacity = 0.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Widget card = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: isDark 
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(opacity),
          borderRadius: borderRadius ?? BorderRadius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark 
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(24),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(24),
          child: card,
        ),
      );
    }

    return card;
  }
}

// Import for ImageFilter
import 'dart:ui';
