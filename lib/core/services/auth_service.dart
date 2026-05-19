import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:kazipoa/core/config/supabase_config.dart';
import 'package:kazipoa/core/services/supabase_service.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  Map<String, dynamic>? _cachedCurrentUser;
  
  static final StreamController<Map<String, dynamic>?> _mockAuthStreamController = 
      StreamController<Map<String, dynamic>?>.broadcast();

  bool get _useMock => SupabaseConfig.url.isEmpty || 
      SupabaseConfig.url.contains('your_supabase_project_url') ||
      SupabaseConfig.anonKey.isEmpty ||
      SupabaseConfig.anonKey.contains('your_supabase_anon_key');

  AuthService() {
    if (_useMock) {
      _initMock();
    }
  }

  Future<void> _initMock() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('mock_current_user');
      if (userStr != null) {
        final user = jsonDecode(userStr);
        _cachedCurrentUser = {
          'uid': user['uid'],
          'email': user['email'],
          'name': user['name'] ?? 'User',
        };
        SupabaseService.setMockCurrentUser(_cachedCurrentUser);
        _mockAuthStreamController.add(_cachedCurrentUser);
      }
    } catch (e) {
      debugPrint('Error initializing mock auth: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    if (_useMock) {
      final res = await _mockLogin(email, password);
      if (res['success'] == true) {
        _cachedCurrentUser = {
          'uid': res['user']['uid'],
          'email': res['user']['email'],
          'name': res['user']['name'],
        };
        SupabaseService.setMockCurrentUser(_cachedCurrentUser);
      }
      return res;
    }
    
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        // Query profiles table to retrieve role and other details
        final profileResponse = await _client
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .single();
            
        final role = profileResponse['role'] ?? 'client';
        
        return {
          'success': true,
          'user': {
            'uid': response.user!.id,
            'email': response.user!.email,
            'name': profileResponse['name'] ?? response.user!.userMetadata?['full_name'] ?? 'User',
            'userType': role,
            'role': role,
            'profile_completed': profileResponse['profile_completed'] ?? false,
          },
          'message': 'Login successful',
        };
      }
      return {'success': false, 'error': 'Mtumiaji hajapatikana'};
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    if (_useMock) {
      final res = await _mockRegister(userData);
      if (res['success'] == true) {
        _cachedCurrentUser = {
          'uid': res['user']['uid'],
          'email': res['user']['email'],
          'name': res['user']['name'],
        };
        SupabaseService.setMockCurrentUser(_cachedCurrentUser);
      }
      return res;
    }

    try {
      final response = await _client.auth.signUp(
        email: userData['email'],
        password: userData['password'],
        data: {'full_name': userData['name']},
      );
      if (response.user != null) {
        try {
          await _client.from('profiles').upsert({
            'id': response.user!.id,
            'name': userData['name'],
            'email': userData['email'],
            'phone': userData['phone'] ?? '',
            'role': userData['userType'] ?? 'client',
            'profile_completed': false,
          });
        } catch (dbErr) {
          debugPrint('DB error during signup: $dbErr');
        }
        return {
          'success': true,
          'user': {
            'uid': response.user!.id,
            'email': response.user!.email,
            'name': userData['name'],
            'userType': userData['userType'],
          },
          'message': 'Registration successful',
        };
      }
      return {'success': false, 'error': 'Registration failed'};
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    if (_useMock) {
      _cachedCurrentUser = null;
      SupabaseService.setMockCurrentUser(null);
      return await _mockLogout();
    }

    try {
      await _client.auth.signOut();
      return {'success': true, 'message': 'Logout successful'};
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> updates) async {
    if (_useMock) {
      return await _mockUpdateProfile(updates);
    }

    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        return {'success': false, 'error': 'No user logged in'};
      }
      await _client.from('profiles').update(updates).eq('id', user.id);
      return {'success': true, 'message': 'Profile updated successfully'};
    } on PostgrestException catch (e) {
      return {'success': false, 'error': e.message};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Map<String, dynamic>? getCurrentUser() {
    if (_useMock) {
      return _cachedCurrentUser;
    }

    final user = _client.auth.currentUser;
    if (user != null) {
      return {
        'uid': user.id,
        'email': user.email,
        'name': user.userMetadata?['full_name'] ?? 'User',
      };
    }
    return null;
  }

  bool isUserLoggedIn() {
    if (_useMock) {
      return _cachedCurrentUser != null;
    }
    return _client.auth.currentUser != null;
  }

  Stream<Map<String, dynamic>?> get authStateChanges {
    if (_useMock) {
      return _mockAuthStreamController.stream;
    }

    return _client.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user != null) {
        return {
          'uid': user.id,
          'email': user.email,
        };
      }
      return null;
    });
  }

  // ========== MOCK METHODS ==========

  Future<Map<String, dynamic>> _mockRegister(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersStr = prefs.getString('mock_users') ?? '[]';
      final List<dynamic> users = jsonDecode(usersStr);
      
      final email = userData['email'];
      final name = userData['name'];
      final password = userData['password'];
      final userType = userData['userType'] ?? 'client';
      
      if (users.any((u) => u['email'] == email)) {
        return {'success': false, 'error': 'Barua pepe tayari inatumika'};
      }
      
      final uid = 'mock_user_${DateTime.now().millisecondsSinceEpoch}';
      final newUser = {
        'uid': uid,
        'email': email,
        'name': name,
        'password': password,
        'role': userType,
        'userType': userType,
      };
      
      users.add(newUser);
      await prefs.setString('mock_users', jsonEncode(users));
      
      final profilesStr = prefs.getString('mock_profiles') ?? '{}';
      final Map<String, dynamic> profiles = jsonDecode(profilesStr);
      profiles[uid] = {
        'id': uid,
        'name': name,
        'email': email,
        'phone': userData['phone'] ?? '',
        'role': userType,
        'profile_completed': false,
        'location': 'Dar es Salaam',
      };
      await prefs.setString('mock_profiles', jsonEncode(profiles));
      
      await prefs.setString('mock_current_user', jsonEncode(newUser));
      _mockAuthStreamController.add({
        'uid': uid,
        'email': email,
        'name': name,
        'userType': userType,
      });
      
      return {
        'success': true,
        'user': {
          'uid': uid,
          'email': email,
          'name': name,
          'userType': userType,
        },
        'message': 'Registration successful',
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _mockLogin(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersStr = prefs.getString('mock_users') ?? '[]';
      final List<dynamic> users = jsonDecode(usersStr);
      
      final userIdx = users.indexWhere((u) => u['email'] == email && u['password'] == password);
      if (userIdx == -1) {
        return {'success': false, 'error': 'Barua pepe au nenosiri sio sahihi'};
      }
      
      final user = users[userIdx];
      final uid = user['uid'];
      
      final profilesStr = prefs.getString('mock_profiles') ?? '{}';
      final Map<String, dynamic> profiles = jsonDecode(profilesStr);
      final profile = profiles[uid] ?? {
        'id': uid,
        'name': user['name'],
        'email': user['email'],
        'role': user['role'] ?? 'client',
        'profile_completed': false,
      };
      
      await prefs.setString('mock_current_user', jsonEncode(user));
      _mockAuthStreamController.add({
        'uid': uid,
        'email': user['email'],
        'name': user['name'],
        'userType': profile['role'],
      });
      
      return {
        'success': true,
        'user': {
          'uid': uid,
          'email': user['email'],
          'name': user['name'],
          'userType': profile['role'],
          'role': profile['role'],
          'profile_completed': profile['profile_completed'] ?? false,
        },
        'message': 'Login successful',
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _mockLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mock_current_user');
    _mockAuthStreamController.add(null);
    return {'success': true, 'message': 'Logout successful'};
  }

  Future<Map<String, dynamic>> _mockUpdateProfile(Map<String, dynamic> updates) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserStr = prefs.getString('mock_current_user');
      if (currentUserStr == null) {
        return {'success': false, 'error': 'No user logged in'};
      }
      
      final currentUser = jsonDecode(currentUserStr);
      final uid = currentUser['uid'];
      
      final profilesStr = prefs.getString('mock_profiles') ?? '{}';
      final Map<String, dynamic> profiles = jsonDecode(profilesStr);
      
      final profile = profiles[uid] ?? {};
      profile.addAll(updates);
      profiles[uid] = profile;
      await prefs.setString('mock_profiles', jsonEncode(profiles));
      
      return {'success': true, 'message': 'Profile updated successfully'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}

// Provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
