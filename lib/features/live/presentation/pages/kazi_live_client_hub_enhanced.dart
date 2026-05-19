import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/kazi_live_service.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class KaziLiveClientHubEnhanced extends StatefulWidget {
  const KaziLiveClientHubEnhanced({super.key});

  @override
  State<KaziLiveClientHubEnhanced> createState() => _KaziLiveClientHubEnhancedState();
}

class _KaziLiveClientHubEnhancedState extends State<KaziLiveClientHubEnhanced>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    
    // Initialize KaziLive service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      KaziLiveService().initialize();
    });
    
    // Note: Periodic refresh removed since we're no longer showing countdowns to clients
    // Countdown logic will be handled in backend for notifications
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive calculations
    final padding = screenWidth * 0.04;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: screenHeight * 0.5 - 150,
            left: screenWidth * 0.5 - 150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF00F0FF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
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
                        // Section Header
                        _buildSectionHeader(),
                        
                        const SizedBox(height: 32),
                        
                        // Pro Cards
                        _buildProCards(),
                        
                        SizedBox(height: screenHeight * 0.25), // Bottom nav space
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation
          CustomBottomNavigation(
            currentRoute: '/kazilive',
            screenWidth: screenWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Logo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'K',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              const Text(
                'Kazipoa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00F0FF),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          
          // Action Icons
          Row(
            children: [
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
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 24,
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // TODO: Show search
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kazi Live Hub',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -3,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF00F0FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(width: 8),
            
            const Text(
              'Uungane na wataalamu sasa hivi',
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProCards() {
    final kaziLiveService = KaziLiveService();
    final upcomingSessions = kaziLiveService.getUpcomingSessions();
    final countdownSessions = kaziLiveService.getCountdownSessions();
    final liveSessions = kaziLiveService.getLiveSessions();
    
    return Column(
      children: [
        // Live Now Sessions
        if (liveSessions.isNotEmpty) ...[
          ...liveSessions.map((session) => _buildLiveSessionCard(session)),
          const SizedBox(height: 24),
        ],
        
        // Countdown Sessions
        if (countdownSessions.isNotEmpty) ...[
          ...countdownSessions.map((session) => _buildCountdownCard(session)),
          const SizedBox(height: 24),
        ],
        
        // Upcoming Sessions
        if (upcomingSessions.isNotEmpty) ...[
          ...upcomingSessions.map((session) => _buildUpcomingSessionCard(session)),
        ],
        
        // Demo cards if no real sessions
        if (upcomingSessions.isEmpty && countdownSessions.isEmpty && liveSessions.isEmpty) ...[
          _buildDemoLiveCard(),
          const SizedBox(height: 24),
          _buildDemoUpcomingCard(),
        ],
      ],
    );
  }

  Widget _buildLiveNowCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Stack(
        children: [
          // Live Indicator
          Positioned(
            top: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          Column(
            children: [
              // Pro Info
              Row(
                children: [
                  // Avatar with verification
                  Stack(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF00F0FF),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00F0FF).withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Container(
                            color: Colors.grey.withValues(alpha: 0.3),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                      
                      // Verification Badge
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                            weight: 700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Pro Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Juma Saidi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            
                            const SizedBox(width: 8),
                            
                            // Platinum Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFE2E8F0), Colors.white, Color(0xFF94A3B8)],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'platinum',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 4),
                        
                        const Text(
                          'Ufundi wa Samani za Kisasa na Mapambo',
                          style: TextStyle(
                            color: Color(0x99FFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Join Now Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF00F0FF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F0FF).withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    // Navigate to Kazi Live Client Enhanced
                    context.go('/kazi_live_client');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'INGIA SASA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard({
    required String name,
    required String service,
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
    required String time,
    required Color timeColor,
    required Color buttonColor,
    required Color buttonTextColor,
    required bool isActive,
  }) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.8,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
        children: [
          // Pro Info
          Row(
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    color: Colors.grey.withValues(alpha: 0.3),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Pro Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              color: badgeTextColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      service,
                      style: TextStyle(
                        color: isActive 
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                        fontStyle: isActive ? FontStyle.normal : FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Time and Notify Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inaanza baada ya',
                    style: TextStyle(
                      color: isActive 
                          ? const Color(0xFF00F0FF).withValues(alpha: 0.7)
                          : Colors.white.withValues(alpha: 0.4),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    time,
                    style: TextStyle(
                      color: timeColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      letterSpacing: -2,
                    ),
                  ),
                ],
              ),
              
              // Notify Button
              Expanded(
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive 
                          ? buttonColor.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // TODO: Set notification
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: buttonTextColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'NITARIFA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildBottomNavigation(double screenWidth) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 96,
        padding: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withValues(alpha: 0.8),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Nyumbani
            _buildNavItem(
              icon: Icons.home,
              label: 'Nyumbani',
              isActive: false,
              onTap: () {},
            ),
            
            // Tafuta
            _buildNavItem(
              icon: Icons.search,
              label: 'Tafuta',
              isActive: false,
              onTap: () {},
            ),
            
            // Kazi Live (Elevated)
            _buildKaziLiveItem(),
            
            // Chat
            _buildNavItem(
              icon: Icons.forum,
              label: 'Chat',
              isActive: false,
              onTap: () {},
            ),
            
            // Wasifu
            _buildNavItem(
              icon: Icons.person_2,
              label: 'Wasifu',
              isActive: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.4),
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKaziLiveItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF00F0FF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F0FF).withValues(alpha: 0.4),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.rocket_launch,
            color: Colors.black,
            size: 32,
            weight: 700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Kazi Live',
          style: TextStyle(
            color: Color(0xFF00F0FF),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  // Build live session card
  Widget _buildLiveSessionCard(KaziLiveSession session) {
    return _buildLiveNowCard();
  }

  // Build countdown card - now shows actual date/time instead of countdown
  Widget _buildCountdownCard(KaziLiveSession session) {
    // Format the scheduled date and time
    final scheduledDateTime = session.scheduledTime;
    final dateStr = '${scheduledDateTime.day}/${scheduledDateTime.month}/${scheduledDateTime.year}';
    final timeStr = '${scheduledDateTime.hour.toString().padLeft(2, '0')}:${scheduledDateTime.minute.toString().padLeft(2, '0')}';
    final dateTimeStr = '$dateStr - $timeStr';
    
    return _buildUpcomingCard(
      name: 'Pro User', // Would come from session data
      service: session.serviceName,
      badge: 'Gold Pro',
      badgeColor: const Color(0xFFF59E0B),
      badgeTextColor: Colors.black,
      time: dateTimeStr,
      timeColor: const Color(0xFF00F0FF),
      buttonColor: const Color(0xFF00F0FF),
      buttonTextColor: Colors.black,
      isActive: true,
    );
  }

  // Build upcoming session card - now shows actual date/time instead of countdown
  Widget _buildUpcomingSessionCard(KaziLiveSession session) {
    // Format the scheduled date and time
    final scheduledDateTime = session.scheduledTime;
    final dateStr = '${scheduledDateTime.day}/${scheduledDateTime.month}/${scheduledDateTime.year}';
    final timeStr = '${scheduledDateTime.hour.toString().padLeft(2, '0')}:${scheduledDateTime.minute.toString().padLeft(2, '0')}';
    final dateTimeStr = '$dateStr - $timeStr';
    
    return _buildUpcomingCard(
      name: 'Pro User', // Would come from session data
      service: session.serviceName,
      badge: 'Silver Pro',
      badgeColor: const Color(0xFF94A3B8),
      badgeTextColor: Colors.black,
      time: dateTimeStr,
      timeColor: Colors.white.withValues(alpha: 0.8),
      buttonColor: Colors.white.withValues(alpha: 0.1),
      buttonTextColor: Colors.white.withValues(alpha: 0.5),
      isActive: false,
    );
  }

  // Demo live card
  Widget _buildDemoLiveCard() {
    return _buildLiveNowCard();
  }

  // Demo upcoming card
  Widget _buildDemoUpcomingCard() {
    return _buildUpcomingCard(
      name: 'Sarah Lema',
      service: 'Upishi wa Keki na Shughuli za Sherehe',
      badge: 'Gold Pro',
      badgeColor: const Color(0xFFF59E0B),
      badgeTextColor: Colors.black,
      time: '12:45',
      timeColor: const Color(0xFF00F0FF),
      buttonColor: const Color(0xFF00F0FF),
      buttonTextColor: Colors.black,
      isActive: true,
    );
  }
}
