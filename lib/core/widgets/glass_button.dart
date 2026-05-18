import 'package:flutter/material.dart';      
class GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  const GlassButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.1),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
