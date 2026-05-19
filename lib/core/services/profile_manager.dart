import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/storage_manager.dart';
import '../utils/validator_util.dart';
import 'supabase_service.dart';

/// Profile Manager - Equivalent to JavaScript ProfileManager
/// Handles user profiles, profile updates, and profile data management
class ProfileManager {
  Map<String, dynamic>? _currentUserProfile;
  final List<void Function()> _profileListeners = [];

  // Getters
  Map<String, dynamic>? get currentUserProfile => _currentUserProfile;

  /// Initialize profile manager
  Future<void> init() async {
    try {
      // Load current user profile from storage or Firebase
      await _loadCurrentUserProfile();
      print('Profile manager initialized');
    } catch (e) {
      print('Error initializing profile manager: $e');
    }
  }

  /// Load current user profile
  Future<void> _loadCurrentUserProfile() async {
    try {
      final user = SupabaseService.currentUser;
      if (user != null) {
        // Try to get from storage first
        _currentUserProfile = await StorageManager.getCurrentUser();
        
        if (_currentUserProfile == null) {
          // If not in storage, fetch from Supabase
          await _fetchUserProfileFromSupabase(user.id);
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  /// Fetch user profile from Supabase
  Future<void> _fetchUserProfileFromSupabase(String userId) async {
    try {
      final profile = await SupabaseService.getUserProfile(userId);

      if (profile != null) {
        _currentUserProfile = profile;
        await StorageManager.setCurrentUser(_currentUserProfile!);
      }
    } catch (e) {
      print('Error fetching profile from Supabase: $e');
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> updates) async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) {
        return {
          'success': false,
          'error': 'No user logged in',
        };
      }

      // Validate updates
      final validationResult = _validateProfileUpdates(updates);
      if (!validationResult['valid']) {
        return {
          'success': false,
          'error': validationResult['error'],
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

      // Update local profile
      if (_currentUserProfile != null) {
        _currentUserProfile!.addAll(updates);
        _currentUserProfile!['updatedAt'] = DateTime.now().toIso8601String();
        await StorageManager.setCurrentUser(_currentUserProfile!);
      }

      // Notify listeners
      _notifyProfileListeners();

      print('Profile updated successfully');
      return {
        'success': true,
        'message': 'Wasifu umefanikiwa kwa mafanikio',
        'profile': _currentUserProfile,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred while updating profile: $e',
      };
    }
  }

  /// Update profile image
  Future<Map<String, dynamic>> updateProfileImage(File imageFile) async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) {
        return {
          'success': false,
          'error': 'No user logged in',
        };
      }

      // Validate file
      if (!imageFile.existsSync()) {
        return {
          'success': false,
          'error': 'Picha haiipo',
        };
      }

      // Upload to Supabase Storage
      final downloadUrl = await SupabaseService.uploadFile(imageFile, 'profile_images');

      // Update profile with new image URL
      final result = await updateProfile({
        'profileImage': downloadUrl,
        'profileImageUpdatedAt': DateTime.now().toIso8601String(),
      });

      print('Profile image updated: $downloadUrl');
      return result;
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred while updating profile image: $e',
      };
    }
  }

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Take image from camera
  Future<File?> takeImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error taking image from camera: $e');
      return null;
    }
  }

  /// Update basic profile information
  Future<Map<String, dynamic>> updateBasicProfile({
    String? name,
    String? phone,
    String? bio,
    String? location,
  }) async {
    final updates = <String, dynamic>{};
    
    if (name != null && name.isNotEmpty) {
      updates['name'] = name;
    }
    if (phone != null && phone.isNotEmpty) {
      updates['phone'] = phone;
    }
    if (bio != null && bio.isNotEmpty) {
      updates['bio'] = bio;
    }
    if (location != null && location.isNotEmpty) {
      updates['location'] = location;
    }

    return await updateProfile(updates);
  }

  /// Update professional profile information
  Future<Map<String, dynamic>> updateProfessionalProfile({
    String? businessName,
    String? businessDescription,
    List<String>? services,
    Map<String, dynamic>? businessHours,
    Map<String, dynamic>? pricing,
  }) async {
    final updates = <String, dynamic>{};
    
    if (businessName != null && businessName.isNotEmpty) {
      updates['businessName'] = businessName;
    }
    if (businessDescription != null && businessDescription.isNotEmpty) {
      updates['businessDescription'] = businessDescription;
    }
    if (services != null && services.isNotEmpty) {
      updates['services'] = services;
    }
    if (businessHours != null && businessHours.isNotEmpty) {
      updates['businessHours'] = businessHours;
    }
    if (pricing != null && pricing.isNotEmpty) {
      updates['pricing'] = pricing;
    }

    return await updateProfile(updates);
  }

  /// Update user preferences
  Future<Map<String, dynamic>> updatePreferences({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    String? language,
    String? currency,
  }) async {
    final updates = <String, dynamic>{};
    
    if (emailNotifications != null) {
      updates['preferences.emailNotifications'] = emailNotifications;
    }
    if (pushNotifications != null) {
      updates['preferences.pushNotifications'] = pushNotifications;
    }
    if (smsNotifications != null) {
      updates['preferences.smsNotifications'] = smsNotifications;
    }
    if (language != null) {
      updates['preferences.language'] = language;
    }
    if (currency != null) {
      updates['preferences.currency'] = currency;
    }

    return await updateProfile(updates);
  }

  /// Get user statistics
  Map<String, dynamic> getUserStatistics() {
    if (_currentUserProfile == null) {
      return {};
    }

    final profile = _currentUserProfile!;
    return {
      'totalBookings': profile['totalBookings'] ?? 0,
      'completedBookings': profile['completedBookings'] ?? 0,
      'cancelledBookings': profile['cancelledBookings'] ?? 0,
      'totalRevenue': profile['totalRevenue'] ?? 0.0,
      'averageRating': profile['averageRating'] ?? 0.0,
      'totalReviews': profile['totalReviews'] ?? 0,
      'memberSince': profile['createdAt'] ?? DateTime.now().toIso8601String(),
      'lastActive': profile['lastActive'] ?? DateTime.now().toIso8601String(),
    };
  }

  /// Get profile completion percentage
  double getProfileCompletionPercentage() {
    if (_currentUserProfile == null) return 0.0;

    final profile = _currentUserProfile!;
    int completedFields = 0;
    int totalFields = 10;

    // Check essential fields
    if (profile['name'] != null && profile['name'].toString().isNotEmpty) completedFields++;
    if (profile['email'] != null && profile['email'].toString().isNotEmpty) completedFields++;
    if (profile['phone'] != null && profile['phone'].toString().isNotEmpty) completedFields++;
    if (profile['profileImage'] != null && profile['profileImage'].toString().isNotEmpty) completedFields++;
    if (profile['bio'] != null && profile['bio'].toString().isNotEmpty) completedFields++;
    
    // Check professional-specific fields
    if (profile['userType'] == 'professional') {
      totalFields += 4;
      if (profile['businessName'] != null && profile['businessName'].toString().isNotEmpty) completedFields++;
      if (profile['businessDescription'] != null && profile['businessDescription'].toString().isNotEmpty) completedFields++;
      if (profile['services'] != null && (profile['services'] as List).isNotEmpty) completedFields++;
      if (profile['businessHours'] != null && profile['businessHours'].toString().isNotEmpty) completedFields++;
    }

    return (completedFields / totalFields) * 100;
  }

  /// Get profile suggestions for completion
  List<String> getProfileSuggestions() {
    if (_currentUserProfile == null) return [];

    final profile = _currentUserProfile!;
    final suggestions = <String>[];

    if (profile['name'] == null || profile['name'].toString().isEmpty) {
      suggestions.add('Ona jina lako kamili');
    }
    if (profile['phone'] == null || profile['phone'].toString().isEmpty) {
      suggestions.add('Ongeza namba ya simu');
    }
    if (profile['profileImage'] == null || profile['profileImage'].toString().isEmpty) {
      suggestions.add('Ongeza picha ya wasifu');
    }
    if (profile['bio'] == null || profile['bio'].toString().isEmpty) {
      suggestions.add('Ongeza maelezo ya wasifu');
    }

    if (profile['userType'] == 'professional') {
      if (profile['businessName'] == null || profile['businessName'].toString().isEmpty) {
        suggestions.add('Ongeza jina la biashara');
      }
      if (profile['services'] == null || (profile['services'] as List).isEmpty) {
        suggestions.add('Ongeza huduma unazotoa');
      }
    }

    return suggestions;
  }

  /// Validate profile updates
  Map<String, dynamic> _validateProfileUpdates(Map<String, dynamic> updates) {
    try {
      // Validate name
      if (updates.containsKey('name')) {
        final name = updates['name'] as String?;
        if (name == null || name.isEmpty) {
          return {'valid': false, 'error': 'Jina linahitajika'};
        }
        if (name.length < 2) {
          return {'valid': false, 'error': 'Jina linahitajika angalau herufi 2'};
        }
        if (name.length > 50) {
          return {'valid': false, 'error': 'Jina limetimia (maksimum 50 herufi)'};
        }
      }

      // Validate phone
      if (updates.containsKey('phone')) {
        final phone = updates['phone'] as String?;
        if (phone != null && phone.isNotEmpty) {
          final phoneValidation = ValidatorUtil.validateField(phone, 'phone');
          if (!phoneValidation['valid']) {
            return {'valid': false, 'error': phoneValidation['error']};
          }
        }
      }

      // Validate bio
      if (updates.containsKey('bio')) {
        final bio = updates['bio'] as String?;
        if (bio != null && bio.length > 500) {
          return {'valid': false, 'error': 'Maelezo yametimia (maksimum 500 herufi)'};
        }
      }

      // Validate business name
      if (updates.containsKey('businessName')) {
        final businessName = updates['businessName'] as String?;
        if (businessName != null && businessName.isNotEmpty) {
          if (businessName.length < 2) {
            return {'valid': false, 'error': 'Jina la biashara linahitajika angalau herufi 2'};
          }
          if (businessName.length > 100) {
            return {'valid': false, 'error': 'Jina la biashara limetimia (maksimum 100 herufi)'};
          }
        }
      }

      return {'valid': true};
    } catch (e) {
      return {'valid': false, 'error': 'Hitilafu katika uthibitishaji: $e'};
    }
  }

  /// Get profile visibility settings
  Map<String, bool> getProfileVisibility() {
    if (_currentUserProfile == null) {
      return {
        'showPhone': false,
        'showEmail': false,
        'showLocation': false,
        'showReviews': true,
        'showPortfolio': true,
      };
    }

    final profile = _currentUserProfile!;
    return {
      'showPhone': profile['showPhone'] ?? false,
      'showEmail': profile['showEmail'] ?? false,
      'showLocation': profile['showLocation'] ?? false,
      'showReviews': profile['showReviews'] ?? true,
      'showPortfolio': profile['showPortfolio'] ?? true,
    };
  }

  /// Update profile visibility settings
  Future<Map<String, dynamic>> updateProfileVisibility({
    bool? showPhone,
    bool? showEmail,
    bool? showLocation,
    bool? showReviews,
    bool? showPortfolio,
  }) async {
    final updates = <String, dynamic>{};
    
    if (showPhone != null) updates['showPhone'] = showPhone;
    if (showEmail != null) updates['showEmail'] = showEmail;
    if (showLocation != null) updates['showLocation'] = showLocation;
    if (showReviews != null) updates['showReviews'] = showReviews;
    if (showPortfolio != null) updates['showPortfolio'] = showPortfolio;

    return await updateProfile(updates);
  }

  /// Delete user account
  Future<Map<String, dynamic>> deleteAccount(String password) async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) {
        return {
          'success': false,
          'error': 'No user logged in',
        };
      }

      // Delete user data from Supabase
      await Supabase.instance.client
          .from('users')
          .delete()
          .eq('id', user.id);

      // Delete profile image from Storage if exists
      if (_currentUserProfile != null && 
          _currentUserProfile!['profileImage'] != null &&
          _currentUserProfile!['profileImage'].toString().isNotEmpty) {
        try {
          await SupabaseService.deleteFile(_currentUserProfile!['profileImage']);
        } catch (e) {
          print('Error deleting profile image: $e');
        }
      }

      // Delete user account
      await Supabase.instance.client.auth.admin.deleteUser(user.id);

      // Clear local data
      _currentUserProfile = null;
      await StorageManager.remove('currentUser');

      print('Account deleted successfully');
      return {
        'success': true,
        'message': 'Akaunti yako imefutwa kwa mafanikio',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred while deleting account: $e',
      };
    }
  }


  /// Add profile listener
  void addProfileListener(void Function() listener) {
    _profileListeners.add(listener);
  }

  /// Remove profile listener
  void removeProfileListener(void Function() listener) {
    _profileListeners.remove(listener);
  }

  /// Notify all profile listeners
  void _notifyProfileListeners() {
    for (final listener in _profileListeners) {
      try {
        listener();
      } catch (e) {
        print('Error in profile listener: $e');
      }
    }
  }

  /// Refresh current user profile
  Future<void> refreshProfile() async {
    final user = SupabaseService.currentUser;
    if (user != null) {
      await _fetchUserProfileFromSupabase(user.id);
      _notifyProfileListeners();
    }
  }

  /// Get profile completion recommendations
  List<Map<String, String>> getProfileCompletionRecommendations() {
    if (_currentUserProfile == null) return [];

    final profile = _currentUserProfile!;
    final recommendations = <Map<String, String>>[];

    if (getProfileCompletionPercentage() < 50) {
      recommendations.add({
        'title': 'Kamilisha Wasifu Wako',
        'description': 'Ongeza maelezo zaidi ili kuongeza uaminifu wa wasifu wako',
        'priority': 'high',
      });
    }

    if (profile['profileImage'] == null || profile['profileImage'].toString().isEmpty) {
      recommendations.add({
        'title': 'Ongeza Picha ya Wasifu',
        'description': 'Picha nzuri ya wasifu inasaidia kuongeza uaminifu',
        'priority': 'medium',
      });
    }

    if (profile['userType'] == 'professional' && 
        (profile['services'] == null || (profile['services'] as List).isEmpty)) {
      recommendations.add({
        'title': 'Ongeza Huduma Zako',
        'description': 'Orodhesha huduma unazotoa ili wate waweze kukupata',
        'priority': 'medium',
      });
    }

    return recommendations;
  }

  /// Dispose method
  void dispose() {
    _profileListeners.clear();
  }
}

// Provider
final profileManagerProvider = Provider<ProfileManager>((ref) {
  final manager = ProfileManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});

// Extension for easy access in widgets
extension ProfileManagerRef on WidgetRef {
  ProfileManager get profile => read(profileManagerProvider);
}
