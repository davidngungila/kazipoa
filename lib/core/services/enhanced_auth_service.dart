import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/storage_manager.dart';
import '../utils/validator_util.dart';
import 'supabase_service.dart';

/// Enhanced Auth Service - Equivalent to JavaScript AuthManager
/// Handles authentication, session management, and user data with enhanced features
class EnhancedAuthService {
  Map<String, dynamic>? _currentUser;
  bool _isAuthenticated = false;
  Timer? _sessionTimer;
  static const Duration _sessionTimeout = Duration(minutes: 30);

  // Getters
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  /// Initialize auth service and restore session if exists
  Future<void> init() async {
    try {
      // Restore session from storage
      _currentUser = await StorageManager.getCurrentUser();
      _isAuthenticated = _currentUser != null;

      if (_isAuthenticated && _currentUser != null) {
        _startSessionTimer();
        print('Session restored for user: ${_currentUser!['id']}');
      }

      // Listen to Supabase auth state changes
      SupabaseService.authStateChanges().listen((data) {
        _handleSupabaseAuthChange(data.session?.user);
      });
    } catch (e) {
      print('Error initializing auth service: $e');
    }
  }

  /// Handle Supabase auth state changes
  void _handleSupabaseAuthChange(User? user) {
    if (user == null && _isAuthenticated) {
      // User signed out, clear local session
      _clearSession();
    }
  }

  /// Enhanced login with validation and session management
  Future<Map<String, dynamic>> login(
    String email, 
    String password, 
    {String userType = 'client'}
  ) async {
    try {
      // Validate inputs
      ValidatorUtil.validateEmail(email);
      ValidatorUtil.validatePassword(password);

      // Attempt Supabase login
      final result = await SupabaseService.signInWithEmail(email, password);

      if (result.user != null) {
        // Get additional user data from Supabase
        final userData = await SupabaseService.getUserProfile(result.user!.id) ?? {};
        
        final role = userData['role'] ?? userType;
        
        // Create user object matching JavaScript structure
        final user = {
          'id': result.user!.id,
          'email': result.user!.email,
          'name': userData['name'] ?? result.user!.userMetadata?['name'] ?? 'User',
          'phone': userData['phone'] ?? '',
          'userType': role,
          'role': role,
          'isEmailVerified': result.user!.emailConfirmedAt != null,
          'createdAt': userData['created_at'] ?? DateTime.now().toIso8601String(),
          'lastLoginAt': DateTime.now().toIso8601String(),
          'isVerified': userData['isVerified'] ?? false,
          'profileImage': userData['profileImage'] ?? '',
          'profile_completed': userData['profile_completed'] ?? false,
        };

        // Update session state
        _currentUser = user;
        _isAuthenticated = true;

        // Store session data
        await StorageManager.setCurrentUser(user);
        await StorageManager.setUserType(userType);

        // Start session timer
        _startSessionTimer();

        print('User logged in: ${user['id']}');
        return {
          'success': true,
          'user': user,
          'message': 'Umefanikiwa kuingia!',
        };
      } else {
        return {
          'success': false,
          'error': 'Login failed: No user returned',
        };
      }
    } on AuthException catch (e) {
      String errorMessage = _getSupabaseErrorMessage(e);
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred during login: $e',
      };
    }
  }

  /// Enhanced registration with validation
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      // Validate required fields
      ValidatorUtil.validateEmail(userData['email']);
      ValidatorUtil.validatePassword(userData['password']);
      ValidatorUtil.validateName(userData['name']);

      // Create Supabase user
      final result = await SupabaseService.registerWithEmail(
        userData['email'],
        userData['password'],
        userData['name'],
      );

      if (result.user != null) {
        // User profile is already created in SupabaseService.registerWithEmail
        final role = userData['userType'] ?? 'client';
        final user = {
          'id': result.user!.id,
          'email': result.user!.email,
          'name': userData['name'],
          'phone': userData['phone'] ?? '',
          'userType': role,
          'role': role,
          'isEmailVerified': result.user!.emailConfirmedAt != null,
          'createdAt': DateTime.now().toIso8601String(),
          'lastLoginAt': DateTime.now().toIso8601String(),
          'isVerified': false,
          'profileImage': userData['profileImage'] ?? '',
          'businessName': userData['businessName'] ?? '',
          'businessDescription': userData['businessDescription'] ?? '',
          'services': userData['services'] ?? [],
          'location': userData['location'] ?? {},
          'rating': 0.0,
          'totalBookings': 0,
          'profile_completed': false,
        };

        // Update session state
        _currentUser = user;
        _isAuthenticated = true;

        // Store session data
        await StorageManager.setCurrentUser(user);
        await StorageManager.setUserType(role);

        // Start session timer
        _startSessionTimer();

        print('User registered: ${user['id']}');
        return {
          'success': true,
          'user': user,
          'message': 'Usajili umefanikiwa! Tafadhali thibitisha.',
        };
      } else {
        return {
          'success': false,
          'error': 'Registration failed: No user returned',
        };
      }
    } on AuthException catch (e) {
      String errorMessage = _getSupabaseErrorMessage(e);
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred during registration: $e',
      };
    }
  }

  /// Logout with session cleanup
  Future<Map<String, dynamic>> logout() async {
    try {
      await SupabaseService.signOut();
      _clearSession();
      
      return {
        'success': true,
        'message': 'Umefanikiwa kuingia',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred during logout: $e',
      };
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> updates) async {
    try {
      if (!_isAuthenticated || _currentUser == null) {
        return {
          'success': false,
          'error': 'No user logged in',
        };
      }

      // Update in Supabase
      await SupabaseService.updateUserProfile(
        name: updates['name'],
        phone: updates['phone'],
        bio: updates['bio'],
        location: updates['location'],
        isPro: updates['isPro'],
        services: updates['services'],
      );

      // Update local user data
      _currentUser!.addAll(updates);
      await StorageManager.setCurrentUser(_currentUser!);

      return {
        'success': true,
        'message': 'Profile updated successfully',
        'user': _currentUser,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred during profile update: $e',
      };
    }
  }

  /// Validate current session
  Future<bool> validateSession() async {
    if (!_isAuthenticated || _currentUser == null) {
      return false;
    }

    try {
      // Check Supabase auth state
      final supabaseUser = SupabaseService.currentUser;
      if (supabaseUser == null) {
        _clearSession();
        return false;
      }

      // Refresh session timer
      _startSessionTimer();
      return true;
    } catch (e) {
      print('Error validating session: $e');
      _clearSession();
      return false;
    }
  }

  /// Send password reset email
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      ValidatorUtil.validateEmail(email);
      
      await SupabaseService.resetPassword(email);
      
      return {
        'success': true,
        'message': 'Email la kurejesha nenosiri limetumwa',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred: $e',
      };
    }
  }

  /// Refresh user data from Firestore
  Future<void> refreshUserData() async {
    if (!_isAuthenticated || _currentUser == null) return;

    try {
      final userData = await SupabaseService.getUserProfile(_currentUser!['id']);

      if (userData != null) {
        _currentUser!.addAll(userData);
        await StorageManager.setCurrentUser(_currentUser!);
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }

  /// Get current user (matching JavaScript interface)
  Map<String, dynamic>? getCurrentUser() {
    return _currentUser;
  }

  /// Check if user is logged in
  bool isUserLoggedIn() {
    return _isAuthenticated && _currentUser != null;
  }

  /// Get user type
  Future<String> getUserType() async {
    if (_currentUser != null) {
      return _currentUser!['userType'] ?? 'client';
    }
    return await StorageManager.getUserType();
  }

  /// Session management
  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(_sessionTimeout, () {
      print('Session expired, logging out...');
      logout();
    });
  }

  void _clearSession() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    _currentUser = null;
    _isAuthenticated = false;
    
    // Clear storage
    StorageManager.remove('currentUser');
    StorageManager.remove('lastLoginTime');
  }

  /// Convert Supabase auth exceptions to user-friendly messages
  String _getSupabaseErrorMessage(AuthException e) {
    switch (e.code) {
      case 'user_not_found':
        return 'Mtumiaji hajasajiliwa';
      case 'wrong_password':
        return 'Nenosiri sio sahihi';
      case 'email_already_in_use':
        return 'Barua pepe tayari inatumika';
      case 'weak_password':
        return 'Nenosiri ni dhaifu sana';
      case 'invalid_email':
        return 'Barua pepe sio sahihi';
      case 'user_disabled':
        return 'Akaunti yako imezuiwa';
      case 'too_many_requests':
        return 'Ombi nyingi sana. Tafadhali jaribu baadaye';
      case 'network_request_failed':
        return 'Hitilafu ya mtandao. Tafadhali angalia muunganisho wako';
      default:
        return 'Hitilafu: ${e.message}';
    }
  }

  /// Stream for auth state changes
  Stream<Map<String, dynamic>?> get authStateChanges {
    return SupabaseService.authStateChanges().asyncMap((data) async {
      if (data.session?.user != null) {
        await refreshUserData();
        return _currentUser;
      }
      return null;
    });
  }

  /// Dispose method
  void dispose() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }
}

// Provider
final enhancedAuthServiceProvider = Provider<EnhancedAuthService>((ref) {
  final service = EnhancedAuthService();
  ref.onDispose(() => service.dispose());
  return service;
});
