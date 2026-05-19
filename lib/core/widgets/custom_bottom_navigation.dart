import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_manager.dart';

class CustomBottomNavigation extends StatelessWidget {
  final String currentRoute;
  final double screenWidth;

  const CustomBottomNavigation({
    super.key,
    required this.currentRoute,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Nyumbani
            _buildNavItem(
              icon: Icons.home,
              label: 'Nyumbani',
              isActive: currentRoute == '/home',
              onTap: () => _handleNavigation(context, '/home'),
            ),
            
            // Miadi
            _buildNavItem(
              icon: Icons.event_available,
              label: 'Miadi',
              isActive: currentRoute.startsWith('/miadi'),
              onTap: () => _handleNavigation(context, '/miadi'),
            ),
            
            // Kazi Live (Elevated)
            _buildKaziLiveItem(context),
            
            // Chatting
            _buildNavItem(
              icon: Icons.chat_bubble,
              label: 'Chatting',
              isActive: currentRoute.startsWith('/chat'),
              onTap: () => _handleNavigation(context, '/chat'),
            ),
            
            // Wasifu
            _buildNavItem(
              icon: Icons.person,
              label: 'Wasifu',
              isActive: currentRoute.startsWith('/wasifu'),
              onTap: () => _handleNavigation(context, '/wasifu'),
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
            color: isActive ? const Color(0xFF38BDF8) : const Color(0xFF38BDF8).withValues(alpha: 0.5),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF38BDF8) : const Color(0xFF38BDF8).withValues(alpha: 0.7),
              fontSize: 9,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKaziLiveItem(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleNavigation(context, '/kazilive'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF00E5FF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.bolt, color: Colors.black),
          ),
          const SizedBox(height: 4),
          const Text(
            "Kazi Live",
            style: TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, String route) {
    final authManager = AuthManager();
    
    // Check if authentication is required for certain routes
    if (route != '/home' && route != '/wasifu' && authManager.requiresAuthentication(_getAuthAction(route))) {
      authManager.showAuthPrompt(context, _getAuthAction(route));
      return;
    }

    // Add haptic feedback
    HapticFeedback.lightImpact();
    
    // Navigate to the route
    context.go(route);
  }

  String _getAuthAction(String route) {
    switch (route) {
      case '/miadi':
        return 'book';
      case '/kazilive':
        return 'kazilive';
      case '/chat':
        return 'chat';
      default:
        return '';
    }
  }
}
