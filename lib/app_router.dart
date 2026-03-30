import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/profile_screen.dart';

class KazipoaApp extends StatelessWidget {
  const KazipoaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kazipoa - Tafuta Kazi Tanzania',
      debugShowCheckedModeBanner: false,
      theme: KazipoaTheme.lightTheme,
      darkTheme: KazipoaTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
              settings: settings,
            );
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegistrationScreen(),
              settings: settings,
            );
          case '/dashboard':
            return MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
              settings: settings,
            );
          case '/bookings':
            return MaterialPageRoute(
              builder: (context) => const BookingsScreen(),
              settings: settings,
            );
          case '/profile':
            return MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}

// Additional screens that can be added later
class BookingSetupScreen extends StatelessWidget {
  const BookingSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unda Miadi'),
      ),
      body: const Center(
        child: Text('Booking Setup Screen - Coming Soon'),
      ),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uchambuzi'),
      ),
      body: const Center(
        child: Text('Analytics Screen - Coming Soon'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mipangilio'),
      ),
      body: const Center(
        child: Text('Settings Screen - Coming Soon'),
      ),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ujumbe'),
      ),
      body: const Center(
        child: Text('Messages Screen - Coming Soon'),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tafuta Huduma'),
      ),
      body: const Center(
        child: Text('Search Screen - Coming Soon'),
      ),
    );
  }
}
