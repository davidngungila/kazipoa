import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/profile_repository.dart';
import '../repositories/auth_repository.dart';

/// AuthGate for role-based routing
/// Checks authentication state and user role to route to appropriate screen
class AuthGate extends StatefulWidget {
  final Widget clientHome;
  final Widget proDashboard;
  final Widget guestHome;
  final Widget profileSetup;

  const AuthGate({
    super.key,
    required this.clientHome,
    required this.proDashboard,
    required this.guestHome,
    required this.profileSetup,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;
  String? _userRole;
  bool _isProfileComplete = false;

  @override
  void initState() {
    super.initState();
    _checkAuthAndRoute();
  }

  Future<void> _checkAuthAndRoute() async {
    try {
      // Check if user is authenticated
      final user = AuthRepository().getCurrentUser();
      
      if (user == null) {
        // User not authenticated, route to guest home
        if (mounted) {
          setState(() {
            _isLoading = false;
            _userRole = 'guest';
          });
        }
        return;
      }

      // User is authenticated, fetch profile
      final profile = await ProfileRepository.fetchProfile();
      
      if (profile == null) {
        // Profile doesn't exist, route to profile setup
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isProfileComplete = false;
          });
        }
        return;
      }

      // Check if profile is complete
      final isComplete = await ProfileRepository.isProfileComplete();
      final role = profile['role'] ?? 'client';

      if (mounted) {
        setState(() {
          _isLoading = false;
          _userRole = role;
          _isProfileComplete = isComplete;
        });
      }
    } catch (e) {
      // On error, route to guest home
      if (mounted) {
        setState(() {
          _isLoading = false;
          _userRole = 'guest';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Route based on role and profile completion
    if (_userRole == null || _userRole == 'guest') {
      return widget.guestHome;
    }

    if (!_isProfileComplete) {
      return widget.profileSetup;
    }

    switch (_userRole) {
      case 'pro':
        return widget.proDashboard;
      case 'client':
      default:
        return widget.clientHome;
    }
  }
}

/// AuthGate widget that listens to auth state changes
class AuthGateWithListener extends StatelessWidget {
  final Widget clientHome;
  final Widget proDashboard;
  final Widget guestHome;
  final Widget profileSetup;

  const AuthGateWithListener({
    super.key,
    required this.clientHome,
    required this.proDashboard,
    required this.guestHome,
    required this.profileSetup,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return AuthGate(
          clientHome: clientHome,
          proDashboard: proDashboard,
          guestHome: guestHome,
          profileSetup: profileSetup,
        );
      },
    );
  }
}
