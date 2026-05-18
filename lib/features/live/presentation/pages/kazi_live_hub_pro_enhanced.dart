import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/kazi_live_service.dart';

class KaziLiveHubProEnhanced extends StatefulWidget {
  const KaziLiveHubProEnhanced({super.key});

  @override
  State<KaziLiveHubProEnhanced> createState() => _KaziLiveHubProEnhancedState();
}

class _KaziLiveHubProEnhancedState extends State<KaziLiveHubProEnhanced>
    with TickerProviderStateMixin {
  
  Timer? _countdownTimer;
  Timer? _refreshTimer;
  bool _isTimerRunning = false;
  int _remainingSeconds = 10; // 10 second countdown
  final KaziLiveService _kaziLiveService = KaziLiveService();
  List<KaziLiveSession> _proSessions = [];
  
  @override
  void initState() {
    super.initState();
    _loadProSessions();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _loadProSessions() {
    // In a real app, this would get the pro's ID from auth service
    const proId = 'pro_123';
    _proSessions = _kaziLiveService.getProSessions(proId);
    setState(() {});
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _loadProSessions();
      }
    });
  }

  void _startCountdown() {
    setState(() {
      _isTimerRunning = true;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          _isTimerRunning = false;
          // Navigate to Kazi Live Pro session when timer ends
          context.go('/kazilive_session/session_123');
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive calculations
    final padding = screenWidth * 0.04;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.1, 0.2),
            radius: 1.5,
            colors: [
              Color(0x0D38BDF8),
              Colors.transparent,
            ],
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.9, 0.8),
              radius: 1.5,
              colors: [
                Color(0x140EA5E9),
                Colors.transparent,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(screenWidth),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Section
                        _buildStatsSection(),
                        
                        const SizedBox(height: 40),
                        
                        // Request List Header
                        _buildRequestListHeader(),
                        
                        const SizedBox(height: 24),
                        
                        // Request Cards
                        _buildRequestCards(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
          );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button - Top Left Corner
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.go('/landing');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '<',
                style: TextStyle(
                  color: Color(0xFF38BDF8),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Notifications
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Show notifications
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                color: Color(0xFF38BDF8),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        // New Requests Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withOpacity(0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Maombi Mapya',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  '12',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF38BDF8),
                    letterSpacing: -4,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Status Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B), Colors.black],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF38BDF8).withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hadhi Yako',
                  style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xFF38BDF8),
                      size: 18,
                      weight: 700,
                    ),
                    
                    const SizedBox(width: 4),
                    
                    const Text(
                      'PLATINUM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'Maombi Yanayosubiri',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF38BDF8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Inasasisha sasa hivi...',
            style: TextStyle(
              color: Color(0xFF38BDF8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCards() {
    return Column(
      children: [
        // Request Card 1 - Active
        _buildRequestCard(
          name: 'Sarah Juma',
          service: 'Usafi wa Nyumbani',
          time: '10:30 AM',
          timeLabel: 'Muda',
          location: 'Masaki, Dar es Salaam',
          locationIcon: Icons.location_on,
          isActive: true,
          isCompleted: false,
        ),
        
        const SizedBox(height: 16),
        
        // Request Card 2 - Waiting
        _buildRequestCard(
          name: 'Juma Shabaan',
          service: 'Usafi wa nyumbani',
          time: 'Inasubiri',
          timeLabel: 'Hali',
          location: 'Leo, Muda Wowote',
          locationIcon: Icons.schedule,
          isActive: true,
          isCompleted: false,
        ),
        
        const SizedBox(height: 16),
        
        // Request Card 3 - Completed
        _buildRequestCard(
          name: 'Anna Mlay',
          service: 'Kupika / Catering',
          time: '11:15 AM',
          timeLabel: 'Muda',
          location: 'Upanga, Dar es Salaam',
          locationIcon: Icons.location_on,
          isActive: false,
          isCompleted: true,
        ),
      ],
    );
  }

  Widget _buildRequestCard({
    required String name,
    required String service,
    required String time,
    required String timeLabel,
    required String location,
    required IconData locationIcon,
    required bool isActive,
    required bool isCompleted,
  }) {
    // Determine appropriate icon based on service type
    IconData getServiceIcon(String service) {
      if (service.toLowerCase().contains('usafi') || service.toLowerCase().contains('cleaning')) {
        return Icons.cleaning_services;
      } else if (service.toLowerCase().contains('kupika') || service.toLowerCase().contains('catering')) {
        return Icons.restaurant;
      } else if (service.toLowerCase().contains('fundi') || service.toLowerCase().contains('repair')) {
        return Icons.build;
      } else if (service.toLowerCase().contains('gardening') || service.toLowerCase().contains('mimea')) {
        return Icons.yard;
      } else if (service.toLowerCase().contains('car') || service.toLowerCase().contains('gari')) {
        return Icons.car_repair;
      } else {
        return Icons.work; // Default work icon
      }
    }
    return Opacity(
      opacity: isCompleted ? 0.6 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.6),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
          // Avatar with online status
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: Colors.grey.withOpacity(0.3),
                    child: Icon(
                      getServiceIcon(service),
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              
              // Online Status (for active requests)
              if (isActive && !isCompleted)
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E5FF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                Text(
                  service,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
                
                Row(
                  children: [
                    Text(
                      timeLabel,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                    
                    const SizedBox(width: 4),
                    
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                
                Row(
                  children: [
                    Icon(
                      locationIcon,
                      color: const Color(0xFF94A3B8),
                      size: 12,
                    ),
                    
                    const SizedBox(width: 4),
                    
                    Text(
                      location,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
