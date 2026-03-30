import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/landing_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        // For now, always show landing page as the main interface
        // TODO: Implement proper auth flow with login screen when needed
        return const LandingPage();
        
        /* Proper auth check (commented for testing):
        // Show loading while checking authentication
        if (authService.currentUser == null && authService.currentUserType == null) {
          return const Scaffold(
            backgroundColor: Color(0xFFF3E8FF), // lavender background
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Icon(
                    Icons.work,
                    size: 80,
                    color: Color(0xFF7C3AED), // primary purple
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Kazipoa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7C3AED), // primary purple
                    ),
                  ),
                  SizedBox(height: 40),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280), // medium grey
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // If authenticated, show main navigation
        if (authService.isAuthenticated) {
          return const LandingPage();
        }

        // If not authenticated, show login screen
        return const LoginScreen();
        */
      },
    );
  }
}
