import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/storage_manager.dart';

/// Navigation Manager - Equivalent to JavaScript NavigationManager
/// Handles app navigation, routing, and navigation state management
class NavigationManager {
  static const String _currentPageKey = 'currentPage';
  String _currentPage = 'home';
  final List<void Function()> _navigationListeners = [];

  // Getters
  String get currentPage => _currentPage;

  /// Initialize navigation manager
  Future<void> init() async {
    try {
      // Restore last page from storage
      _currentPage = await StorageManager.get<String>(_currentPageKey, 'home') ?? 'home';
      print('Navigation initialized. Current page: $_currentPage');
    } catch (e) {
      print('Error initializing navigation: $e');
      _currentPage = 'home';
    }
  }

  /// Navigate to a specific page
  void navigateToPage(BuildContext context, String page, {Object? arguments}) {
    _currentPage = page;
    StorageManager.set(_currentPageKey, page);
    
    // Notify listeners
    _notifyNavigationListeners();
    
    // Navigate using GoRouter
    final routeName = _getPageRoute(page);
    if (routeName != null) {
      context.push(routeName, extra: arguments);
    }
    
    print('Navigated to: $page');
  }

  /// Navigate to page by route name
  void navigateToRoute(BuildContext context, String route, {Object? arguments}) {
    final page = _getPageFromRoute(route);
    _currentPage = page;
    StorageManager.set(_currentPageKey, page);
    
    // Notify listeners
    _notifyNavigationListeners();
    
    context.push(route, extra: arguments);
    print('Navigated to route: $route (page: $page)');
  }

  /// Go back to previous page
  void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // If can't pop, navigate to home
      navigateToPage(context, 'home');
    }
  }

  /// Replace current page (no back stack)
  void replacePage(BuildContext context, String page, {Object? arguments}) {
    _currentPage = page;
    StorageManager.set(_currentPageKey, page);
    
    // Notify listeners
    _notifyNavigationListeners();
    
    final routeName = _getPageRoute(page);
    if (routeName != null) {
      context.pushReplacement(routeName, extra: arguments);
    }
    
    print('Replaced with page: $page');
  }

  /// Reset navigation stack and go to specific page
  void resetToPage(BuildContext context, String page, {Object? arguments}) {
    _currentPage = page;
    StorageManager.set(_currentPageKey, page);
    
    // Notify listeners
    _notifyNavigationListeners();
    
    final routeName = _getPageRoute(page);
    if (routeName != null) {
      context.go(routeName, extra: arguments);
    }
    
    print('Reset navigation to: $page');
  }

  /// Get page from navigation item text (matching JavaScript logic)
  String getPageFromNav(String navText) {
    final text = navText.toLowerCase();
    
    if (text.contains('nyumbani') || text.contains('home')) return 'home';
    if (text.contains('miadi') || text.contains('booking')) return 'bookings';
    if (text.contains('kazi live')) return 'kazilive';
    if (text.contains('chat') || text.contains('chating')) return 'chat';
    if (text.contains('wasifu') || text.contains('profile')) return 'profile';
    if (text.contains('analytics')) return 'analytics';
    if (text.contains('settings') || text.contains('setting')) return 'settings';
    
    return 'home'; // Default
  }

  /// Get page from route name
  String _getPageFromRoute(String route) {
    switch (route) {
      case '/':
      case '/home':
        return 'home';
      case '/bookings':
      case '/my-bookings':
        return 'bookings';
      case '/kazilive':
        return 'kazilive';
      case '/chat':
      case '/chats':
        return 'chat';
      case '/profile':
        return 'profile';
      case '/analytics':
        return 'analytics';
      case '/settings':
        return 'settings';
      case '/auth':
      case '/login':
        return 'auth';
      case '/register':
        return 'register';
      default:
        return 'home';
    }
  }

  /// Get route name from page
  String? _getPageRoute(String page) {
    switch (page) {
      case 'home':
        return '/home';
      case 'bookings':
        return '/bookings';
      case 'kazilive':
        return '/kazilive';
      case 'chat':
        return '/chat';
      case 'profile':
        return '/profile';
      case 'analytics':
        return '/analytics';
      case 'settings':
        return '/settings';
      case 'auth':
      case 'login':
        return '/auth';
      case 'register':
        return '/register';
      default:
        return '/home';
    }
  }

  /// Check if current page matches given page
  bool isCurrentPage(String page) {
    return _currentPage == page;
  }

  /// Check if current page is in the given list
  bool isCurrentPageIn(List<String> pages) {
    return pages.contains(_currentPage);
  }

  /// Get navigation state for bottom navigation
  int getBottomNavIndex() {
    switch (_currentPage) {
      case 'home':
        return 0;
      case 'bookings':
        return 1;
      case 'kazilive':
        return 2;
      case 'chat':
        return 3;
      case 'profile':
        return 4;
      default:
        return 0;
    }
  }

  /// Set current page (for programmatic navigation)
  void setCurrentPage(String page) {
    _currentPage = page;
    StorageManager.set(_currentPageKey, page);
    _notifyNavigationListeners();
  }

  /// Add navigation listener
  void addNavigationListener(void Function() listener) {
    _navigationListeners.add(listener);
  }

  /// Remove navigation listener
  void removeNavigationListener(void Function() listener) {
    _navigationListeners.remove(listener);
  }

  /// Notify all navigation listeners
  void _notifyNavigationListeners() {
    for (final listener in _navigationListeners) {
      try {
        listener();
      } catch (e) {
        print('Error in navigation listener: $e');
      }
    }
  }

  /// Navigate to authentication flow
  void navigateToAuth(BuildContext context, {bool replace = true}) {
    if (replace) {
      replacePage(context, 'auth');
    } else {
      navigateToPage(context, 'auth');
    }
  }

  /// Navigate to main app (after authentication)
  void navigateToMainApp(BuildContext context) {
    resetToPage(context, 'home');
  }

  /// Handle deep linking
  bool handleDeepLink(BuildContext context, Uri uri) {
    final path = uri.path;
    
    switch (path) {
      case '/':
        navigateToPage(context, 'home');
        return true;
      case '/bookings':
        navigateToPage(context, 'bookings');
        return true;
      case '/kazilive':
        navigateToPage(context, 'kazilive');
        return true;
      case '/chat':
        navigateToPage(context, 'chat');
        return true;
      case '/profile':
        navigateToPage(context, 'profile');
        return true;
      default:
        // Handle dynamic routes
        if (path.startsWith('/booking/')) {
          final bookingId = path.split('/').last;
          navigateToPage(context, 'booking-details', arguments: bookingId);
          return true;
        }
        if (path.startsWith('/chat/')) {
          final chatId = path.split('/').last;
          navigateToPage(context, 'chat-detail', arguments: chatId);
          return true;
        }
        if (path.startsWith('/profile/')) {
          final userId = path.split('/').last;
          navigateToPage(context, 'user-profile', arguments: userId);
          return true;
        }
        return false;
    }
  }

  /// Generate shareable link for a page
  String generateShareableLink(String page, {Map<String, String>? params}) {
    final route = _getPageRoute(page) ?? '/home';
    var link = 'kazipoa://$route';
    
    if (params != null && params.isNotEmpty) {
      final queryString = params.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      link += '?$queryString';
    }
    
    return link;
  }

  /// Get page title in Swahili
  String getPageTitle(String page) {
    switch (page) {
      case 'home':
        return 'Nyumbani';
      case 'bookings':
        return 'Miadi Zangu';
      case 'kazilive':
        return 'Kazi Live';
      case 'chat':
        return 'Chating';
      case 'profile':
        return 'Wasifu Wangu';
      case 'analytics':
        return 'Uchambuzi';
      case 'settings':
        return 'Mipangilio';
      case 'auth':
        return 'Ingia';
      case 'register':
        return 'Jisajili';
      default:
        return 'Kazipoa';
    }
  }

  /// Check if page requires authentication
  bool requiresAuth(String page) {
    final authRequiredPages = [
      'bookings',
      'chat', 
      'profile',
      'analytics',
      'settings',
      'booking-details',
      'chat-detail',
    ];
    
    return authRequiredPages.contains(page);
  }

  /// Navigate with authentication check
  void navigateWithAuthCheck(BuildContext context, String page, {Object? arguments}) {
    // In a real app, you'd check authentication status here
    // For now, we'll just navigate
    
    if (requiresAuth(page)) {
      // TODO: Check if user is authenticated
      // If not, navigate to auth first
      navigateToPage(context, page, arguments: arguments);
    } else {
      navigateToPage(context, page, arguments: arguments);
    }
  }

  /// Clear navigation history
  void clearHistory() {
    // Clear stored current page
    StorageManager.remove(_currentPageKey);
    _currentPage = 'home';
  }

  /// Get navigation history (simplified version)
  Future<List<String>> getNavigationHistory() async {
    // In a real implementation, you'd store navigation history
    // For now, return current page as history
    return [_currentPage];
  }

  /// Dispose method
  void dispose() {
    _navigationListeners.clear();
  }
}

// Provider
final navigationManagerProvider = Provider<NavigationManager>((ref) {
  final manager = NavigationManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});

// Extension for easy access in widgets
extension NavigationManagerRef on WidgetRef {
  NavigationManager get navigation => read(navigationManagerProvider);
}
