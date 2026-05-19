import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';

class DashboardEnhanced extends StatefulWidget {
  const DashboardEnhanced({super.key});

  @override
  State<DashboardEnhanced> createState() => _DashboardEnhancedState();
}

class _DashboardEnhancedState extends State<DashboardEnhanced>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive calculations
    final padding = screenWidth * 0.04;
    final titleFontSize = (screenWidth * 0.06).clamp(20.0, 24.0);
    final cardWidth = (screenWidth * 0.9).clamp(320.0, 448.0);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
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
                      children: [
                        // Profile Section
                        _buildProfileSection(titleFontSize),
                        
                        const SizedBox(height: 24),
                        
                        // Earnings Card
                        _buildEarningsCard(cardWidth),
                        
                        const SizedBox(height: 24),
                        
                        // Action Buttons
                        _buildActionButtons(),
                        
                        const SizedBox(height: 24),
                        
                        // Stats Row
                        _buildStatsRow(),
                        
                        const SizedBox(height: 24),
                        
                        // Logout Button
                        _buildLogoutButton(),
                        
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
            currentRoute: '/wasifu/pro_dashboard',
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
        color: Colors.black.withValues(alpha: 0.4),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          const Text(
            'Kazipoa',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF00D4FF),
              letterSpacing: -1,
            ),
          ),
          
          // Action Buttons
          Row(
            children: [
              // Book Other Pros
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.go('/home');
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Sign Up
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.go('/index');
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_add,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Notifications
              GestureDetector(
                onTap: () {
                  // TODO: Open notifications
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.grey.shade400,
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

  Widget _buildProfileSection(double titleFontSize) {
    return Column(
      children: [
        // Profile Image with Verification Badge
        Stack(
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 4,
                ),
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.grey.withValues(alpha: 0.3),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 56,
                  ),
                ),
              ),
            ),
            
            // Verification Badge
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4FF),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.verified,
                  color: Colors.black,
                  size: 14,
                  weight: 700,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Welcome Text
        const Text(
          'Karibu tena',
          style: TextStyle(
            color: Color(0xFF00D4FF),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        
        const SizedBox(height: 4),
        
        // Name
        const Text(
          'David Ngugila',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Badges
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Platinum Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE2E8F0), Colors.white, Color(0xFF94A3B8)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: const Text(
                'PLATINUM',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Profession
            const Text(
              'Fundi Umeme Aliyeidhinishwa',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEarningsCard(double cardWidth) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 32,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Background Icon
          Positioned(
            top: -16,
            right: -16,
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Icon(
                Icons.payments,
                color: const Color(0xFF00D4FF).withValues(alpha: 0.07),
                size: 72,
              ),
            ),
          ),
          
          // Title
          const Text(
            'Jumla ya Mapato: MWEZI HUU',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '1,450,000',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF00D4FF),
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'TZS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00D4FF).withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF00D4FF),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withValues(alpha: 0.6),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: FractionallySizedBox(
                widthFactor: 0.92,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D4FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Progress Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LENGO: 1.5M',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const Text(
                '92% IMEFIKIWA',
                style: TextStyle(
                  color: Color(0xFF00D4FF),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final actions = [
      {
        'icon': Icons.business_center,
        'title': 'Ofisi Yangu',
        'subtitle': 'Dhibiti shughuli zako za kila siku',
        'route': '/wasifu/my_office',
        'isActive': false,
        'hasBorder': false,
      },
      {
        'icon': Icons.live_tv,
        'title': 'Kazi Live',
        'subtitle': 'Live sessions na kazi za moja kwa moja',
        'route': '/kazi_live_hub_pro',
        'isActive': false,
        'hasBorder': false,
      },
      {
        'icon': Icons.chat_bubble,
        'title': 'Chat',
        'subtitle': 'Mawasiliano na wateja wako',
        'route': '/chat',
        'isActive': false,
        'hasBorder': false,
      },
            {
        'icon': Icons.person,
        'title': 'Wasifu Wangu',
        'subtitle': 'Hariri taarifa zako za kitaalamu',
        'route': '/wasifu',
        'isActive': false,
        'hasBorder': false,
      },
      {
        'icon': Icons.analytics,
        'title': 'Ripoti ya Uchambuzi',
        'subtitle': 'Takwimu za utendaji wako',
        'route': '/wasifu/analytics',
        'isActive': false,
        'hasBorder': false,
      },
      {
        'icon': Icons.calendar_month,
        'title': 'Miadi Yangu',
        'subtitle': 'Ona na dhibiti miadi zako',
        'route': '/wasifu/my_bookings',
        'isActive': false,
        'hasBorder': false,
      },
    ];

    return Column(
      children: actions.map((action) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              final route = action['route'] as String?;
              if (route != null) {
                context.go(route);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(24),
                border: action['hasBorder'] as bool
                    ? const Border(
                        left: BorderSide(
                          color: Color(0xFF00D4FF),
                          width: 4,
                        ),
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 32,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon Container
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: action['isActive'] as bool
                          ? const Color(0xFF00D4FF).withValues(alpha: 0.15)
                          : const Color(0xFF00D4FF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: const Color(0xFF00D4FF),
                      size: 24,
                      weight: action['isActive'] as bool ? 700 : 400,
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          action['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          action['subtitle'] as String,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Arrow
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF64748B),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 32,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Rating
          Column(
            children: [
              const Text(
                '4.9',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'DARAJA',
                style: TextStyle(
                  color: Color(0xFF00D4FF),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          
          // Divider
          Container(
            width: 1,
            height: 32,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          
          // Jobs
          Column(
            children: [
              const Text(
                '124',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'KAZI',
                style: TextStyle(
                  color: Color(0xFF00D4FF),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          
          // Divider
          Container(
            width: 1,
            height: 32,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          
          // Trust
          Column(
            children: [
              const Text(
                '98%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'AMINIKA',
                style: TextStyle(
                  color: Color(0xFF00D4FF),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.2),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.heavyImpact();
          // TODO: Implement logout
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFFEF4444),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Text(
              'ONDOKA',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
