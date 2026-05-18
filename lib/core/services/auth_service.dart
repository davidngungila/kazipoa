import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        return {
          'success': true,
          'user': {
            'uid': result.user!.uid,
            'email': result.user!.email,
            'name': result.user!.displayName ?? 'User',
          },
          'message': 'Login successful',
        };
      } else {
        return {
          'success': false,
          'error': 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred during login: $e',
      };
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userData['email'],
        password: userData['password'],
      );
      
      if (result.user != null) {
        // Create user profile in Firestore
        await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
          'name': userData['name'],
          'email': userData['email'],
          'phone': userData['phone'] ?? '',
          'userType': userData['userType'] ?? 'client',
          'createdAt': DateTime.now().toIso8601String(),
          'isVerified': false,
        });

        return {
          'success': true,
          'user': {
            'uid': result.user!.uid,
            'email': result.user!.email,
            'name': userData['name'],
            'userType': userData['userType'],
          },
          'message': 'Registration successful',
        };
      } else {
        return {
          'success': false,
          'error': 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred during registration: $e',
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return {
        'success': true,
        'message': 'Logout successful',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred during logout: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> updates) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return {
          'success': false,
          'error': 'No user logged in',
        };
      }

      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update(updates);

      return {
        'success': true,
        'message': 'Profile updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred during profile update: $e',
      };
    }
  }

  Map<String, dynamic>? getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return {
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? 'User',
      };
    }
    return null;
  }

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Stream<Map<String, dynamic>?> get authStateChanges {
    return FirebaseAuth.instance.authStateChanges().map((user) {
      if (user != null) {
        return {
          'uid': user.uid,
          'email': user.email,
          'isEmailVerified': user.emailVerified,
        };
      }
      return null;
    });
  }
}

// Provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
