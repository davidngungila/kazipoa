import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/kazi_live_service.dart';

class KaziLiveProEnhanced extends StatefulWidget {
  const KaziLiveProEnhanced({super.key});

  @override
  State<KaziLiveProEnhanced> createState() => _KaziLiveProEnhancedState();
}

class _KaziLiveProEnhancedState extends State<KaziLiveProEnhanced>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _sessionTimer;
  int _sessionDuration = 0;
  KaziLiveSession? _currentSession;
  final KaziLiveService _kaziLiveService = KaziLiveService();

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    
    // Get current active session
    _currentSession = _kaziLiveService.activeSession;
    _startSessionTimer();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _sessionDuration++;
        });
      }
    });
  }

  void _endSession() {
    if (_currentSession != null) {
      _kaziLiveService.endSession(_currentSession!.id);
      HapticFeedback.heavyImpact();
      
      // Navigate back to pro hub
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          context.go('/kazi_live_hub_pro');
        }
      });
    }
  }

  static const primary = Color(0xFF00E5FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color(0x1100E5FF).withValues(alpha: _pulseAnimation.value),
                      Colors.black,
                    ],
                    center: Alignment.topLeft,
                    radius: 1.5,
                  ),
                ),
              );
            },
          ),
          
          // Top Navigation Bar
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _endSession,
                  child: const Text(
                    '<',
                    style: TextStyle(
                      color: primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  "Live Session",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
          ),
          
          // Content
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 70, 16, 120),
              children: [
                // Session info card
                _glassCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Session Duration",
                                  style: TextStyle(color: Colors.grey, fontSize: 10)),
                              SizedBox(height: 4),
                              Text(_formatDuration(_sessionDuration),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          _liveBadge(),
                        ],
                      ),
                      if (_currentSession != null) ...[
                        SizedBox(height: 16),
                        _buildSessionInfo(),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Status tracker
                _glassCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hali ya Kazi",
                                  style: TextStyle(color: Colors.grey, fontSize: 10)),
                              SizedBox(height: 4),
                              Text("Uko Njiani",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          _timeBadge(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _stepIcon(active: true, label: "En Route", icon: Icons.directions_car),
                          Expanded(child: _progressLine()),
                          _stepIcon(active: false, label: "Arrived", icon: Icons.location_on),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Map placeholder
                _glassCard(
                  height: 240,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                    child: const Center(
                      child: Text(
                        "Live Map View",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // End Session Button
                _glassCard(
                  child: ElevatedButton(
                    onPressed: _endSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: 0.2),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "End Session",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${secs.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildSessionInfo() {
    if (_currentSession == null) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Service: ${_currentSession!.serviceName}",
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          "Client ID: ${_currentSession!.clientId}",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _liveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: const Text(
        "LIVE",
        style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget _glassCard({required Widget child, double? height, EdgeInsets? padding}) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }

  static Widget _timeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "LIVE",
        style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget _stepIcon({required bool active, required String label, required IconData icon}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active ? primary : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? primary : Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  static Widget _progressLine() {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, Colors.grey],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
