import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/client/client_home_screen.dart';
import '../screens/client/client_screens.dart';
import '../screens/pro/pro_screens.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    // If not authenticated, show login screen
    if (!authService.isAuthenticated) {
      return const LoginScreen();
    }

    // If authenticated, show appropriate navigation
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: authService.isPro ? _proScreens : _clientScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        type: BottomNavigationBarType.fixed,
        items: authService.isPro ? _proNavItems : _clientNavItems,
      ),
    );
  }

  List<Widget> get _clientScreens {
    return [
      const ClientHomeScreen(),
      const ClientBrowseScreen(),
      const ClientBookingsScreen(),
      const ClientProfileScreen(),
    ];
  }

  List<Widget> get _proScreens {
    return [
      const ProHomeScreen(),
      const ProBookingsScreen(),
      const ProWasifuScreen(),
      const ProSettingsScreen(),
    ];
  }

  List<BottomNavigationBarItem> get _clientNavItems {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Browse',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Bookings',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  List<BottomNavigationBarItem> get _proNavItems {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Bookings',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.business_center),
        label: 'Wasifu',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];
  }
}
