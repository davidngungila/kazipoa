import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Scaffold(
          backgroundColor: AppTheme.lavenderBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Wasifu Wangu',
              style: TextStyle(
                color: AppTheme.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.primaryPurple),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.lightPurple,
                          image: const DecorationImage(
                            image: NetworkImage('https://via.placeholder.com/100'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // User Name
                      Text(
                        authService.currentUser?.name ?? 'Guest User',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // User Email
                      Text(
                        authService.currentUser?.email ?? 'guest@example.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // User Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          authService.isPro ? 'Professional' : 'Client',
                          style: TextStyle(
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Menu Options
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person,
                        title: 'Edit Profile',
                        onTap: () {
                          // Handle edit profile
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          // Handle settings
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.history,
                        title: 'Booking History',
                        onTap: () {
                          // Handle booking history
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.payment,
                        title: 'Payment Methods',
                        onTap: () {
                          // Handle payment methods
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.help,
                        title: 'Help & Support',
                        onTap: () {
                          // Handle help & support
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Logout Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.red.shade300],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await authService.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.primaryPurple,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppTheme.darkGrey,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.lightGrey,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
