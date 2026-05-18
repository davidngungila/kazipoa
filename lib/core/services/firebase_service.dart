import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Firebase service for all backend operations
class FirebaseService {
  // Collection names
  static const String _usersCollection = 'users';
  static const String _servicesCollection = 'services';
  static const String _bookingsCollection = 'bookings';
  static const String _chatsCollection = 'chats';
  static const String _messagesCollection = 'messages';
  static const String _kaziliveCollection = 'kazilive_sessions';

  /// Authentication Methods
  static Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e),
        code: _getErrorCode(e),
      );
    }
  }

  static Future<UserCredential> registerWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user profile
      await FirebaseFirestore.instance.collection(_usersCollection).doc(result.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'profileCompleted': false,
      });
      
      return result;
    } catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e),
        code: _getErrorCode(e),
      );
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }

  /// User Profile Methods
  static Future<void> updateUserProfile({
    String? name,
    String? phone,
    String? bio,
    String? location,
    bool? isPro,
    Map<String, dynamic>? services,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final updateData = <String, dynamic>{};
    
    if (name != null) updateData['name'] = name;
    if (phone != null) updateData['phone'] = phone;
    if (bio != null) updateData['bio'] = bio;
    if (location != null) updateData['location'] = location;
    if (isPro != null) updateData['isPro'] = isPro;
    if (services != null) updateData['services'] = services;

    updateData['updatedAt'] = FieldValue.serverTimestamp();

    await FirebaseFirestore.instance.collection(_usersCollection).doc(user.uid).update(updateData);
  }

  static Future<DocumentSnapshot> getUserProfile(String userId) async {
    return await FirebaseFirestore.instance.collection(_usersCollection).doc(userId).get();
  }

  /// Service Management
  static Future<void> createService(Map<String, dynamic> serviceData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final serviceWithMetadata = {
      ...serviceData,
      'providerId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'active',
      'rating': 0.0,
      'reviewCount': 0,
    };

    await FirebaseFirestore.instance.collection(_servicesCollection).add(serviceWithMetadata);
  }

  static Future<QuerySnapshot> getServices({
    String? category,
    String? location,
    double? minRating,
    int limit = 20,
  }) async {
    Query query = FirebaseFirestore.instance.collection(_servicesCollection);

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    if (location != null) {
      query = query.where('location', isEqualTo: location);
    }
    if (minRating != null) {
      query = query.where('rating', isGreaterThanOrEqualTo: minRating);
    }

    return await query.limit(limit).get();
  }

  static Future<void> updateService(String serviceId, Map<String, dynamic> updates) async {
    await FirebaseFirestore.instance.collection(_servicesCollection).doc(serviceId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteService(String serviceId) async {
    await FirebaseFirestore.instance.collection(_servicesCollection).doc(serviceId).delete();
  }

  /// Booking Methods
  static Future<void> createBooking(Map<String, dynamic> bookingData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final bookingWithMetadata = {
      ...bookingData,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    };

    await FirebaseFirestore.instance.collection(_bookingsCollection).add(bookingWithMetadata);
  }

  static Future<QuerySnapshot> getUserBookings(String userId) async {
    return await FirebaseFirestore.instance
        .collection(_bookingsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
  }

  static Future<void> updateBookingStatus(String bookingId, String status) async {
    await FirebaseFirestore.instance.collection(_bookingsCollection).doc(bookingId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Chat Methods
  static Future<void> createChat(String userId, String otherUserId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final participants = [userId, otherUserId]..sort();
    final chatId = participants.join('_');
    
    await FirebaseFirestore.instance.collection(_chatsCollection).doc(chatId).set({
      'participants': participants,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> sendMessage(String chatId, String message) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final messageData = {
      'senderId': user.uid,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    };

    await FirebaseFirestore.instance.collection(_chatsCollection).doc(chatId).collection(_messagesCollection).add(messageData);

    // Update chat with last message
    await FirebaseFirestore.instance.collection(_chatsCollection).doc(chatId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getChatMessages(String chatId) {
    return FirebaseFirestore.instance
        .collection(_chatsCollection)
        .doc(chatId)
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  static Future<QuerySnapshot> getUserChats(String userId) async {
    return await FirebaseFirestore.instance
        .collection(_chatsCollection)
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .get();
  }

  /// Storage Methods
  static Future<String> uploadFile(File file, String path) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final ref = FirebaseStorage.instance.ref().child('$path/${user.uid}/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  static Future<void> deleteFile(String url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
  }

  /// Messaging Methods
  static Future<String?> getFCMToken() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    return await messaging.getToken();
  }

  static Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  /// Kazilive Methods
  static Future<void> createKaziliveSession(Map<String, dynamic> sessionData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final sessionWithMetadata = {
      ...sessionData,
      'hostId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'live',
      'viewerCount': 0,
    };

    await FirebaseFirestore.instance.collection(_kaziliveCollection).add(sessionWithMetadata);
  }

  static Future<QuerySnapshot> getLiveSessions() async {
    return await FirebaseFirestore.instance
        .collection(_kaziliveCollection)
        .where('status', isEqualTo: 'live')
        .orderBy('viewerCount', descending: true)
        .get();
  }

  static Future<void> joinSession(String sessionId) async {
    await FirebaseFirestore.instance.collection(_kaziliveCollection).doc(sessionId).update({
      'viewerCount': FieldValue.increment(1),
    });
  }

  static Future<void> leaveSession(String sessionId) async {
    await FirebaseFirestore.instance.collection(_kaziliveCollection).doc(sessionId).update({
      'viewerCount': FieldValue.increment(-1),
    });
  }

  /// Helper Methods
  static String _getAuthErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found for this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'The email address is already in use by another account.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'invalid-email':
          return 'The email address is not valid.';
        default:
          return 'An error occurred: ${error.message}';
      }
    }
    return 'An unknown error occurred.';
  }

  static String _getErrorCode(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.code;
    }
    return 'unknown';
  }
}

/// Custom exception class for auth errors
class AuthException implements Exception {
  final String message;
  final String code;

  AuthException({required this.message, required this.code});

  @override
  String toString() => 'AuthException: $message (Code: $code)';
}
