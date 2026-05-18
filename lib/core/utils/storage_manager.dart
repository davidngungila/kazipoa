import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Storage Manager - Equivalent to JavaScript StorageManager
/// Handles local storage operations for user data, settings, and cache
class StorageManager {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const String _currentUserKey = 'currentUser';
  static const String _userTypeKey = 'userType';
  static const String _lastLoginTimeKey = 'lastLoginTime';
  static const String _bookingsKey = 'bookings';
  static const String _pendingBookingsKey = 'pendingBookings';
  static const String _themeKey = 'theme';
  static const String _languageKey = 'language';

  static Future<void> set(String key, dynamic value) async {
    try {
      final jsonString = jsonEncode(value);
      await _storage.write(key: key, value: jsonString);
    } catch (e) {
      print('Error saving to storage: $e');
    }
  }

  static Future<T?> get<T>(String key, [T? defaultValue]) async {
    try {
      final jsonString = await _storage.read(key: key);
      
      if (jsonString == null) return defaultValue;
      
      final decoded = jsonDecode(jsonString);
      return decoded as T?;
    } catch (e) {
      print('Error reading from storage: $e');
      return defaultValue;
    }
  }

  static Future<void> remove(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Error removing from storage: $e');
    }
  }

  static Future<void> clear() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Error clearing storage: $e');
    }
  }

  // Specific user data methods
  static Future<void> setCurrentUser(Map<String, dynamic> user) async {
    await set(_currentUserKey, user);
    await set(_lastLoginTimeKey, DateTime.now().toIso8601String());
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    return await get<Map<String, dynamic>>(_currentUserKey);
  }

  static Future<void> setUserType(String userType) async {
    await set(_userTypeKey, userType);
  }

  static Future<String> getUserType() async {
    return await get<String>(_userTypeKey, 'client') ?? 'client';
  }

  static Future<DateTime?> getLastLoginTime() async {
    final timeString = await get<String>(_lastLoginTimeKey);
    if (timeString != null) {
      return DateTime.parse(timeString);
    }
    return null;
  }

  // Booking data methods
  static Future<void> setBookings(List<Map<String, dynamic>> bookings) async {
    await set(_bookingsKey, bookings);
  }

  static Future<List<Map<String, dynamic>>> getBookings() async {
    final bookings = await get<List<dynamic>>(_bookingsKey);
    return bookings?.cast<Map<String, dynamic>>() ?? [];
  }

  static Future<void> setPendingBookings(List<Map<String, dynamic>> bookings) async {
    await set(_pendingBookingsKey, bookings);
  }

  static Future<List<Map<String, dynamic>>> getPendingBookings() async {
    final bookings = await get<List<dynamic>>(_pendingBookingsKey);
    return bookings?.cast<Map<String, dynamic>>() ?? [];
  }

  // Theme and preferences
  static Future<void> setTheme(String theme) async {
    await set(_themeKey, theme);
  }

  static Future<String> getTheme() async {
    return await get<String>(_themeKey, 'light') ?? 'light';
  }

  static Future<void> setLanguage(String language) async {
    await set(_languageKey, language);
  }

  static Future<String> getLanguage() async {
    return await get<String>(_languageKey, 'sw') ?? 'sw';
  }

  // Check if key exists
  static Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      print('Error checking key existence: $e');
      return false;
    }
  }

  // Get all keys
  static Future<Set<String>> getAllKeys() async {
    try {
      final allKeys = await _storage.readAll();
      return allKeys.keys.toSet();
    } catch (e) {
      print('Error getting all keys: $e');
      return <String>{};
    }
  }
}
