import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/storage_manager.dart';
import '../utils/validator_util.dart';

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

      // Listen to Firebase auth state changes
      FirebaseAuth.instance.authStateChanges().listen(_handleFirebaseAuthChange);
    } catch (e) {
      print('Error initializing auth service: $e');
    }
  }

  /// Handle Firebase auth state changes
  void _handleFirebaseAuthChange(User? user) {
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

      // Attempt Firebase login
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Get additional user data from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .get();

        final userData = userDoc.data() ?? {};
        
        // Create user object matching JavaScript structure
        final user = {
          'id': result.user!.uid,
          'email': result.user!.email,
          'name': userData['name'] ?? result.user!.displayName ?? 'User',
          'phone': userData['phone'] ?? '',
          'userType': userData['userType'] ?? userType,
          'isEmailVerified': result.user!.emailVerified,
          'createdAt': userData['createdAt'] ?? DateTime.now().toIso8601String(),
          'lastLoginAt': DateTime.now().toIso8601String(),
          'isVerified': userData['isVerified'] ?? false,
          'profileImage': userData['profileImage'] ?? '',
        };

        // Update session state
        _currentUser = user;
        _isAuthenticated = true;

        // Store session data
        await StorageManager.setCurrentUser(user);
        await StorageManager.setUserType(userType);

        // Start session timer
        _startSessionTimer();

        // Update last login in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .update({'lastLoginAt': DateTime.now().toIso8601String()});

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
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseErrorMessage(e);
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

      // Create Firebase user
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userData['email'],
        password: userData['password'],
      );

      if (result.user != null) {
        // Create user profile in Firestore
        final user = {
          'id': result.user!.uid,
          'email': result.user!.email,
          'name': userData['name'],
          'phone': userData['phone'] ?? '',
          'userType': userData['userType'] ?? 'client',
          'isEmailVerified': result.user!.emailVerified,
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
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .set(user);

        // Update session state
        _currentUser = user;
        _isAuthenticated = true;

        // Store session data
        await StorageManager.setCurrentUser(user);
        await StorageManager.setUserType(userData['userType'] ?? 'client');

        // Start session timer
        _startSessionTimer();

        // Send email verification
        await result.user!.sendEmailVerification();

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
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseErrorMessage(e);
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
      await FirebaseAuth.instance.signOut();
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

      // Update in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!['id'])
          .update(updates);

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
      // Check Firebase auth state
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
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
      
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
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
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!['id'])
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
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

  /// Convert Firebase auth exceptions to user-friendly messages
  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Mtumiaji hajasajiliwa';
      case 'wrong-password':
        return 'Nenosiri sio sahihi';
      case 'email-already-in-use':
        return 'Barua pepe tayari inatumika';
      case 'weak-password':
        return 'Nenosiri ni dhaifu sana';
      case 'invalid-email':
        return 'Barua pepe sio sahihi';
      case 'user-disabled':
        return 'Akaunti yako imezuiwa';
      case 'too-many-requests':
        return 'Ombi nyingi sana. Tafadhali jaribu baadaye';
      case 'network-request-failed':
        return 'Hitilafu ya mtandao. Tafadhali angalia muunganisho wako';
      default:
        return 'Hitilafu: ${e.message}';
    }
  }

  /// Stream for auth state changes
  Stream<Map<String, dynamic>?> get authStateChanges {
    return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
      if (user != null) {
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
