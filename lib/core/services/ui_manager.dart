import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

/// UI Manager - Equivalent to JavaScript UIManager
/// Handles UI utilities, notifications, loading states, and user interactions
class UIManager {
  static const Duration _notificationDuration = Duration(seconds: 3);
  static const Duration _longNotificationDuration = Duration(seconds: 5);
  OverlayEntry? _currentNotification;
  OverlaySupportEntry? _currentLoadingDialog;

  /// Show notification with different types
  void showNotification(
    BuildContext context,
    String message, {
    String type = 'info',
    Duration? duration,
    String? title,
    VoidCallback? onTap,
    bool persistent = false,
  }) {
    // Dismiss current notification if exists
    hideNotification();
    
    final notificationDuration = persistent ? null : (duration ?? _notificationDuration);
    final colors = _getNotificationColors(type);
    final icon = _getNotificationIcon(type);
    
    _currentNotification = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors['background'],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors['iconBackground'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: colors['iconColor'],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null) ...[
                        Text(
                          title,
                          style: TextStyle(
                            color: colors['textColor'],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        message,
                        style: TextStyle(
                          color: colors['textColor'],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  IconButton(
                    onPressed: () {
                      hideNotification();
                      onTap();
                    },
                    icon: Icon(
                      Icons.open_in_new,
                      color: colors['textColor'],
                      size: 18,
                    ),
                  ),
                if (!persistent)
                  IconButton(
                    onPressed: () => hideNotification(),
                    icon: Icon(
                      Icons.close,
                      color: colors['textColor'],
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_currentNotification!);
    
    // Auto-dismiss if not persistent
    if (!persistent && notificationDuration != null) {
      Future.delayed(notificationDuration, () => hideNotification());
    }
  }

  /// Show success notification
  void showSuccess(BuildContext context, String message, {String? title, VoidCallback? onTap}) {
    showNotification(
      context,
      message,
      type: 'success',
      title: title,
      onTap: onTap,
    );
  }

  /// Show error notification
  void showError(BuildContext context, String message, {String? title, VoidCallback? onTap}) {
    showNotification(
      context,
      message,
      type: 'error',
      title: title,
      duration: _longNotificationDuration,
      onTap: onTap,
    );
  }

  /// Show warning notification
  void showWarning(BuildContext context, String message, {String? title, VoidCallback? onTap}) {
    showNotification(
      context,
      message,
      type: 'warning',
      title: title,
      onTap: onTap,
    );
  }

  /// Show info notification
  void showInfo(BuildContext context, String message, {String? title, VoidCallback? onTap}) {
    showNotification(
      context,
      message,
      type: 'info',
      title: title,
      onTap: onTap,
    );
  }

  /// Show loading dialog
  OverlaySupportEntry? showLoadingDialog({
    String message = 'Inapakia...',
    bool barrierDismissible = false,
  }) {
    _currentLoadingDialog = showOverlayNotification(
      (context) {
        return Material(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F00E7)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      duration: null,
    );
    return _currentLoadingDialog;
  }

  /// Show confirmation dialog
  Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Ndio',
    String cancelText = 'Hapana',
    Color confirmColor = const Color(0xFF0F00E7),
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  /// Show input dialog
  Future<String?> showInputDialog(
    BuildContext context, {
    required String title,
    required String hint,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) async {
    final controller = TextEditingController(text: initialValue);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          keyboardType: keyboardType,
          obscureText: obscureText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ghairi'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Sawa'),
          ),
        ],
      ),
    );
    
    return result;
  }

  /// Show bottom sheet
  Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => child,
    );
  }

  /// Create ripple effect
  void createRipple(BuildContext context, Offset position, {Color? color}) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    
    OverlayEntry? ripple;
    
    ripple = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx - 25,
        top: position.dy - 25,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          onEnd: () => ripple?.remove(),
          builder: (context, value, child) {
            return Container(
              width: 50 * (1 + value),
              height: 50 * (1 + value),
              decoration: BoxDecoration(
                color: (color ?? const Color(0xFF0F00E7)).withValues(alpha: 0.3 - (0.3 * value)),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
    
    overlay.insert(ripple);
  }

  /// Haptic feedback
  void hapticFeedback({HapticFeedbackType type = HapticFeedbackType.light}) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  /// Show snackbar
  void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration? duration,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        backgroundColor: backgroundColor ?? const Color(0xFF0F00E7),
        duration: duration ?? const Duration(seconds: 3),
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Hide current notification
  void hideNotification() {
    _currentNotification?.remove();
    _currentNotification = null;
  }

  /// Hide loading dialog
  void hideLoadingDialog() {
    if (_currentLoadingDialog != null) {
      _currentLoadingDialog?.dismiss();
      _currentLoadingDialog = null;
    }
  }

  /// Show persistent notification (for ongoing operations)
  void showPersistentNotification(
    BuildContext context,
    String message, {
    String type = 'info',
    String? title,
    VoidCallback? onTap,
  }) {
    showNotification(
      context,
      message,
      type: type,
      title: title,
      onTap: onTap,
      persistent: true,
    );
  }

  /// Update persistent notification
  void updatePersistentNotification(
    BuildContext context,
    String message, {
    String type = 'info',
    String? title,
  }) {
    if (_currentNotification != null) {
      hideNotification();
    }
    showPersistentNotification(context, message, type: type, title: title);
  }

  /// Get notification colors based on type
  Map<String, Color> _getNotificationColors(String type) {
    switch (type) {
      case 'success':
        return {
          'background': const Color(0xFF10B981),
          'textColor': Colors.white,
          'iconBackground': Colors.white.withValues(alpha: 0.2),
          'iconColor': Colors.white,
        };
      case 'error':
        return {
          'background': const Color(0xFFEF4444),
          'textColor': Colors.white,
          'iconBackground': Colors.white.withValues(alpha: 0.2),
          'iconColor': Colors.white,
        };
      case 'warning':
        return {
          'background': const Color(0xFFF59E0B),
          'textColor': Colors.white,
          'iconBackground': Colors.white.withValues(alpha: 0.2),
          'iconColor': Colors.white,
        };
      default: // info
        return {
          'background': const Color(0xFF0F00E7),
          'textColor': Colors.white,
          'iconBackground': Colors.white.withValues(alpha: 0.2),
          'iconColor': Colors.white,
        };
    }
  }

  /// Get notification icon based on type
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle;
      case 'error':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      default: // info
        return Icons.info;
    }
  }

  /// Show date picker dialog
  Future<DateTime?> showDatePickerDialog(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F00E7),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// Show time picker dialog
  Future<TimeOfDay?> showTimePickerDialog(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F00E7),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// Show action sheet
  Future<String?> showActionSheet(
    BuildContext context, {
    required String title,
    required List<String> actions,
    String? cancelText,
  }) async {
    return await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
          ],
          ...actions.map((action) => ListTile(
            title: Text(action),
            onTap: () => Navigator.of(context).pop(action),
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Dispose method
  void dispose() {
    _currentNotification?.remove();
    _currentNotification = null;
    _currentLoadingDialog?.dismiss();
    _currentLoadingDialog = null;
  }
}

/// Haptic feedback types
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}

// Provider
final uiManagerProvider = Provider<UIManager>((ref) {
  final manager = UIManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});

// Extension for easy access in widgets
extension UIManagerRef on WidgetRef {
  UIManager get ui => read(uiManagerProvider);
}
