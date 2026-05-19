import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingTimerWidget extends StatefulWidget {
  final DateTime expiresAt;
  final String bookingId;
  final VoidCallback? onExpired;
  final bool isActive;

  const BookingTimerWidget({
    super.key,
    required this.expiresAt,
    required this.bookingId,
    this.onExpired,
    this.isActive = true,
  });

  @override
  _BookingTimerWidgetState createState() => _BookingTimerWidgetState();
}

class _BookingTimerWidgetState extends State<BookingTimerWidget>
    with TickerProviderStateMixin {
  Timer? _countdownTimer;
  Duration? _remainingTime;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(BookingTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startTimer();
      } else {
        _stopTimer();
      }
    }
  }

  @override
  void dispose() {
    _stopTimer();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _stopTimer();
    _updateRemainingTime();
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      _updateRemainingTime();
      
      if (_remainingTime != null && _remainingTime!.inSeconds <= 0) {
        timer.cancel();
        HapticFeedback.heavyImpact();
        widget.onExpired?.call();
      } else if (_remainingTime != null && _remainingTime!.inSeconds <= 3600) {
        // Start pulsing when less than 1 hour remains
        if (!_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        }
      }
    });
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final expiresAt = widget.expiresAt;
    
    if (now.isAfter(expiresAt)) {
      setState(() {
        _remainingTime = Duration.zero;
      });
    } else {
      setState(() {
        _remainingTime = expiresAt.difference(now);
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds <= 0) {
      return "Imeisha";
    }
    
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return "${days}d ${hours}h ${minutes}m";
    } else if (hours > 0) {
      return "${hours}h ${minutes}m ${seconds}s";
    } else if (minutes > 0) {
      return "${minutes}m ${seconds}s";
    } else {
      return "${seconds}s";
    }
  }

  Color _getTimerColor() {
    if (_remainingTime == null) return Colors.grey;
    
    final totalSeconds = _remainingTime!.inSeconds;
    
    if (totalSeconds <= 0) {
      return Colors.red;
    } else if (totalSeconds <= 3600) {
      // Less than 1 hour - red with pulsing
      return Colors.red;
    } else if (totalSeconds <= 21600) {
      // Less than 6 hours - orange
      return Colors.orange;
    } else {
      // More than 6 hours - green
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingTime == null || !widget.isActive) {
      return const SizedBox.shrink();
    }

    final timerColor = _getTimerColor();
    final isExpired = _remainingTime!.inSeconds <= 0;
    final isUrgent = _remainingTime!.inSeconds <= 3600 && _remainingTime!.inSeconds > 0;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isUrgent ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: timerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: timerColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isExpired ? Icons.timer_off : Icons.timer,
                  color: timerColor,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDuration(_remainingTime!),
                  style: TextStyle(
                    color: timerColor,
                    fontSize: 12,
                    fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isExpired) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.warning,
                    color: timerColor,
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class BookingStatusCard extends StatelessWidget {
  final String status;
  final DateTime? acceptedAt;
  final DateTime? expiresAt;
  final String bookingType;

  const BookingStatusCard({
    super.key,
    required this.status,
    this.acceptedAt,
    this.expiresAt,
    required this.bookingType,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'expired':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'accepted':
        return Icons.check_circle;
      case 'expired':
        return Icons.timer_off;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusText() {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Inasubiri';
      case 'accepted':
        return 'Imekubaliwa';
      case 'expired':
        return 'Imeisha';
      case 'completed':
        return 'Imekamilishwa';
      case 'cancelled':
        return 'Imeghairishwa';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();
    final statusText = _getStatusText();
    final hasTimer = bookingType == 'recurring' && status == 'accepted' && expiresAt != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          
          if (acceptedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Imekubaliwa: ${_formatDateTime(acceptedAt!)}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
          
          if (hasTimer && expiresAt != null) ...[
            const SizedBox(height: 8),
            BookingTimerWidget(
              expiresAt: expiresAt!,
              bookingId: '', // Will be provided by parent
              isActive: true,
            ),
          ],
          
          if (bookingType == 'individual' && status == 'accepted') ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Bina kipima - Hakuna timer',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
