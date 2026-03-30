import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  static const String _userKey = 'kazipoa_currentUser';
  static const String _userTypeKey = 'kazipoa_userType';
  static const String _lastLoginKey = 'kazipoa_lastLogin';

  User? _currentUser;
  UserType? _currentUserType;

  User? get currentUser => _currentUser;
  UserType? get currentUserType => _currentUserType;
  bool get isAuthenticated => _currentUser != null;
  bool get isPro => _currentUserType == UserType.professional;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    final userTypeString = prefs.getString(_userTypeKey);
    
    if (userJson != null && userTypeString != null) {
      try {
        _currentUser = User.fromJson(json.decode(userJson));
        _currentUserType = UserType.values.firstWhere(
          (type) => type.toString() == 'UserType.$userTypeString',
          orElse: () => UserType.client,
        );
      } catch (e) {
        await clearUserData();
      }
    }
  }

  Future<bool> loginClient(String email, String password, String name, String phone) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation for demo
    if (email.isEmpty || password.length < 6) {
      return false;
    }

    final user = User(
      id: 'client_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      phone: phone,
      userType: UserType.client,
      createdAt: DateTime.now(),
      isVerified: VerificationStatus.unverified,
      lastLoginAt: DateTime.now(),
    );

    await _saveUser(user, UserType.client);
    notifyListeners();
    return true;
  }

  Future<bool> loginPro(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation for demo
    if (email.isEmpty || password.length < 6) {
      return false;
    }

    final user = User(
      id: 'pro_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: 'Professional User',
      phone: '+255712345678',
      userType: UserType.professional,
      createdAt: DateTime.now(),
      isVerified: VerificationStatus.verified,
      lastLoginAt: DateTime.now(),
    );

    await _saveUser(user, UserType.professional);
    notifyListeners();
    return true;
  }

  Future<bool> registerClient({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.length < 6 || name.isEmpty || phone.isEmpty) {
      return false;
    }

    final user = User(
      id: 'client_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      phone: phone,
      userType: UserType.client,
      createdAt: DateTime.now(),
      isVerified: VerificationStatus.unverified,
    );

    await _saveUser(user, UserType.client);
    notifyListeners();
    return true;
  }

  Future<bool> registerPro({
    required String email,
    required String password,
    required String businessName,
    required String specialization,
    required String phone,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.length < 6 || businessName.isEmpty || specialization.isEmpty) {
      return false;
    }

    final user = User(
      id: 'pro_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: businessName,
      phone: phone,
      userType: UserType.professional,
      createdAt: DateTime.now(),
      isVerified: VerificationStatus.pending,
    );

    await _saveUser(user, UserType.professional);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_userTypeKey);
    await prefs.remove(_lastLoginKey);
    
    _currentUser = null;
    _currentUserType = null;
    notifyListeners();
  }

  Future<void> _saveUser(User user, UserType userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setString(_userTypeKey, userType.toString().split('.').last);
    await prefs.setString(_lastLoginKey, DateTime.now().toIso8601String());
    
    _currentUser = user;
    _currentUserType = userType;
    notifyListeners();
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_userTypeKey);
    await prefs.remove(_lastLoginKey);
    
    _currentUser = null;
    _currentUserType = null;
    notifyListeners();
  }

  Future<bool> isSessionValid() async {
    if (_currentUser == null) return false;
    
    final prefs = await SharedPreferences.getInstance();
    final lastLoginString = prefs.getString(_lastLoginKey);
    
    if (lastLoginString == null) return false;
    
    final lastLogin = DateTime.parse(lastLoginString);
    final now = DateTime.now();
    
    // Session expires after 30 minutes
    return now.difference(lastLogin).inMinutes < 30;
  }

  Future<void> extendSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLoginKey, DateTime.now().toIso8601String());
  }
}
