import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/liquid_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Mesh Gradient Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF0F172A),
                          const Color(0xFF1E293B),
                        ]
                      : [
                          const Color(0xFFF8FAFC),
                          const Color(0xFFF1F5F9),
                        ],
                ),
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // Gradient blobs
                      Positioned(
                        top: -50,
                        left: -50,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 20),
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: KazipoaTheme.primaryColor.withOpacity(0.05),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        right: -50,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 25),
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: KazipoaTheme.secondaryColor.withOpacity(0.05),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // Top App Bar
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDark 
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.menu,
                                  color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Dashboard',
                                style: KazipoaTheme.headlineSmall.copyWith(
                                  color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDark 
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.notifications_outlined,
                                      color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: KazipoaTheme.errorColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // User Profile Section
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: LiquidGlassCard(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        KazipoaTheme.primaryColor,
                                        KazipoaTheme.secondaryColor,
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Karibu, John Doe!',
                                        style: KazipoaTheme.headlineSmall.copyWith(
                                          color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        'Professional Account',
                                        style: KazipoaTheme.bodyMedium.copyWith(
                                          color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.verified,
                                  color: KazipoaTheme.tertiaryColor,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Stats Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      '12',
                                      'Miadi Ya Leo',
                                      Icons.calendar_today,
                                      KazipoaTheme.primaryColor,
                                      isDark,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildStatCard(
                                      '48',
                                      'Miadi Yote',
                                      Icons.list_alt,
                                      KazipoaTheme.secondaryColor,
                                      isDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      '4.8',
                                      'Wakati Wa Kazi',
                                      Icons.star,
                                      KazipoaTheme.tertiaryColor,
                                      isDark,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildStatCard(
                                      'TZS 250K',
                                      'Mapato',
                                      Icons.attach_money,
                                      KazipoaTheme.successColor,
                                      isDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Recent Bookings
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Miadi Ya Karibuni',
                                    style: KazipoaTheme.titleLarge.copyWith(
                                      color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('/bookings');
                                    },
                                    child: Text(
                                      'Ona Zote',
                                      style: KazipoaTheme.labelMedium.copyWith(
                                        color: KazipoaTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildBookingCard(
                                'Hair Styling',
                                'Maria Baraza',
                                'In 2 days',
                                'Confirmed',
                                KazipoaTheme.successColor,
                                isDark,
                              ),
                              const SizedBox(height: 12),
                              _buildBookingCard(
                                'Home Cleaning',
                                'James Kipchoge',
                                'Today',
                                'Completed',
                                KazipoaTheme.successColor,
                                isDark,
                              ),
                              const SizedBox(height: 12),
                              _buildBookingCard(
                                'Plumbing',
                                'Peter Nyambati',
                                'In 7 days',
                                'Pending',
                                KazipoaTheme.warningColor,
                                isDark,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Quick Actions
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hatua Za Haraka',
                                style: KazipoaTheme.titleLarge.copyWith(
                                  color: isDark ? Colors.white : KazipoaTheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildQuickAction(
                                      'Unda Miadi',
                                      Icons.add_circle_outline,
                                      KazipoaTheme.primaryColor,
                                      () => Navigator.of(context).pushNamed('/booking'),
                                      isDark,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildQuickAction(
                                      'Wasifu',
                                      Icons.person_outline,
                                      KazipoaTheme.secondaryColor,
                                      () => Navigator.of(context).pushNamed('/profile'),
                                      isDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 100), // Space for bottom nav
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark 
              ? KazipoaTheme.darkSurface 
              : KazipoaTheme.surfaceContainerLow,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildBottomNavItem(
                  0,
                  Icons.home_outlined,
                  'Nyumbani',
                  isDark,
                ),
                _buildBottomNavItem(
                  1,
                  Icons.search_outlined,
                  'Tafuta',
                  isDark,
                ),
                _buildBottomNavItem(
                  2,
                  Icons.calendar_today_outlined,
                  'Miadi',
                  isDark,
                ),
                _buildBottomNavItem(
                  3,
                  Icons.message_outlined,
                  'Ujumbe',
                  isDark,
                ),
                _buildBottomNavItem(
                  4,
                  Icons.person_outline,
                  'Mimi',
                  isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color, bool isDark) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: KazipoaTheme.headlineMedium.copyWith(
              color: isDark ? Colors.white : KazipoaTheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: KazipoaTheme.bodySmall.copyWith(
              color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(String service, String client, String time, String status, Color statusColor, bool isDark) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KazipoaTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.work_outline,
              color: KazipoaTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  style: KazipoaTheme.titleMedium.copyWith(
                    color: isDark ? Colors.white : KazipoaTheme.onSurface,
                  ),
                ),
                Text(
                  client,
                  style: KazipoaTheme.bodySmall.copyWith(
                    color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  time,
                  style: KazipoaTheme.bodySmall.copyWith(
                    color: isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: KazipoaTheme.labelSmall.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color, VoidCallback onTap, bool isDark) {
    return LiquidGlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: KazipoaTheme.titleMedium.copyWith(
              color: isDark ? Colors.white : KazipoaTheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedIndex = index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected 
                    ? KazipoaTheme.primaryColor 
                    : (isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: KazipoaTheme.labelSmall.copyWith(
                  color: isSelected 
                      ? KazipoaTheme.primaryColor 
                      : (isDark ? Colors.white70 : KazipoaTheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
