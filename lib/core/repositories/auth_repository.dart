import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';

/// Authentication repository for user management
class AuthRepository {
  /// Get current authenticated user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  /// Stream of authentication state changes
  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await FirebaseService.signInWithEmail(email, password);
    } catch (e) {
      if (kDebugMode) {
        print('Sign in error: $e');
      }
      rethrow;
    }
  }

  /// Register new user with email and password
  Future<UserCredential> registerWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      return await FirebaseService.registerWithEmail(email, password, name);
    } catch (e) {
      if (kDebugMode) {
        print('Registration error: $e');
      }
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await FirebaseService.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Sign out error: $e');
      }
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseService.resetPassword(email);
    } catch (e) {
      if (kDebugMode) {
        print('Password reset error: $e');
      }
      rethrow;
    }
  }

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await FirebaseService.getUserProfile(userId);
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Get profile error: $e');
      }
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? phone,
    String? bio,
    String? location,
    bool? isPro,
    Map<String, dynamic>? services,
  }) async {
    try {
      await FirebaseService.updateUserProfile(
        name: name,
        phone: phone,
        bio: bio,
        location: location,
        isPro: isPro,
        services: services,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Update profile error: $e');
      }
      rethrow;
    }
  }

  /// Check if user is pro
  Future<bool> isUserPro(String userId) async {
    try {
      final profile = await getUserProfile(userId);
      return profile?['isPro'] ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Check pro status error: $e');
      }
      return false;
    }
  }

  /// Complete user profile setup
  Future<void> completeProfileSetup(String userId) async {
    try {
      await FirebaseService.updateUserProfile();
    } catch (e) {
      if (kDebugMode) {
        print('Complete profile error: $e');
      }
      rethrow;
    }
  }
}
