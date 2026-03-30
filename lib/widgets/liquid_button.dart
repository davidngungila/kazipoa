import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LiquidButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? rippleColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool isDisabled;
  final ButtonType type;
  final double elevation;
  final double? splashRadius;

  const LiquidButton({
    Key? key,
    this.text = '',
    this.onPressed,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.rippleColor,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
    this.isDisabled = false,
    this.type = ButtonType.elevated,
    this.elevation = 2.0,
    this.splashRadius,
  }) : super(key: key);

  const LiquidButton.elevated({
    Key? key,
    required this.text,
    this.onPressed,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.rippleColor,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
    this.isDisabled = false,
    this.elevation = 2.0,
    this.splashRadius,
  }) : type = ButtonType.elevated, super(key: key);

  const LiquidButton.outlined({
    Key? key,
    required this.text,
    this.onPressed,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.rippleColor,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
    this.isDisabled = false,
    this.elevation = 0.0,
    this.splashRadius,
  }) : type = ButtonType.outlined, super(key: key);

  const LiquidButton.text({
    Key? key,
    required this.text,
    this.onPressed,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.rippleColor,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
    this.isDisabled = false,
    this.elevation = 0.0,
    this.splashRadius,
  }) : type = ButtonType.text, super(key: key);

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Color backgroundColor = widget.backgroundColor ?? 
        (widget.type == ButtonType.elevated 
            ? KazipoaTheme.primaryColor 
            : Colors.transparent);
    Color buttonForegroundColor = widget.foregroundColor ?? 
        (widget.type == ButtonType.elevated 
            ? KazipoaTheme.onPrimary 
            : KazipoaTheme.primaryColor);
    Color rippleColor = widget.rippleColor ?? 
        (isDark ? Colors.white.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.1));

    if (widget.isDisabled) {
      backgroundColor = backgroundColor.withValues(alpha: 0.5);
      buttonForegroundColor = buttonForegroundColor.withValues(alpha: 0.5);
    }

    Widget buttonChild = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child ?? _buildDefaultButton(backgroundColor, buttonForegroundColor),
    );

    if (widget.isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(buttonForegroundColor),
            ),
          ),
          const SizedBox(width: 8),
          widget.child ?? Text(
            widget.text,
            style: widget.textStyle?.copyWith(color: buttonForegroundColor) ?? KazipoaTheme.titleMedium(Theme.of(context).colorScheme.onSurface),
          ),
        ],
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: widget.width,
      height: widget.height ?? 48,
      decoration: _getButtonDecoration(backgroundColor, isDark, buttonForegroundColor),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isDisabled || widget.isLoading ? null : widget.onPressed,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          splashColor: rippleColor,
          highlightColor: rippleColor.withValues(alpha: 0.5),
          child: Center(
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24),
              child: buttonChild,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultButton(Color backgroundColor, Color buttonForegroundColor) {
    return Text(
      widget.text,
      style: (widget.textStyle ?? KazipoaTheme.titleMedium(Theme.of(context).colorScheme.onSurface)).copyWith(
        color: buttonForegroundColor,
      ),
    );
  }

  BoxDecoration _getButtonDecoration(Color backgroundColor, bool isDark, Color buttonForegroundColor) {
    switch (widget.type) {
      case ButtonType.elevated:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: widget.elevation * 2,
              offset: Offset(0, widget.elevation),
              spreadRadius: 0,
            ),
          ],
          gradient: _isPressed 
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    backgroundColor.withValues(alpha: 0.8),
                    backgroundColor.withValues(alpha: 0.9),
                  ],
                )
              : null,
        );
      
      case ButtonType.outlined:
        return BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: buttonForegroundColor,
            width: 1,
          ),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          gradient: _isPressed 
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    buttonForegroundColor.withValues(alpha: 0.1),
                    buttonForegroundColor.withValues(alpha: 0.05),
                  ],
                )
              : null,
        );
      
      case ButtonType.text:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          gradient: _isPressed 
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    buttonForegroundColor.withValues(alpha: 0.1),
                    buttonForegroundColor.withValues(alpha: 0.05),
                  ],
                )
              : null,
        );
    }
  }
}

enum ButtonType { elevated, outlined, text }

class RippleButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool isDisabled;

  const RippleButton({
    Key? key,
    this.text = '',
    this.onPressed,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  State<RippleButton> createState() => _RippleButtonState();
}

class _RippleButtonState extends State<RippleButton>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isDisabled && !widget.isLoading && widget.onPressed != null) {
      _rippleController.forward().then((_) {
        _rippleController.reset();
        widget.onPressed!();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Color backgroundColor = widget.backgroundColor ?? KazipoaTheme.primaryColor;
    Color foregroundColor = widget.foregroundColor ?? KazipoaTheme.onPrimary;

    if (widget.isDisabled) {
      backgroundColor = backgroundColor.withValues(alpha: 0.5);
      foregroundColor = foregroundColor.withValues(alpha: 0.5);
    }

    return Container(
      width: widget.width,
      height: widget.height ?? 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24),
                  child: widget.isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            widget.child ?? Text(
                              widget.text,
                              style: (widget.textStyle ?? KazipoaTheme.titleMedium).copyWith(
                                color: foregroundColor,
                              ),
                            ),
                          ],
                        )
                      : widget.child ?? Text(
                          widget.text,
                          style: (widget.textStyle ?? KazipoaTheme.titleMedium).copyWith(
                            color: foregroundColor,
                          ),
                        ),
                ),
              ),
              AnimatedBuilder(
                animation: _rippleAnimation,
                builder: (context, child) {
                  return Positioned.fill(
                    child: ClipRRect(
                      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: _rippleAnimation.value * 2,
                            colors: [
                              Colors.white.withValues(alpha: 0.3 * (1 - _rippleAnimation.value)),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
