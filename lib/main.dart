import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kazipoa/app/app.dart';
import 'package:kazipoa/firebase_options.dart';

// Initialize Firebase services
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final messagingProvider = Provider<FirebaseMessaging>((ref) => FirebaseMessaging.instance);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase with platform-specific options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize Firebase Auth
    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: false,
      userAccessGroup: null,
    );
    
    // Configure Firestore settings
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    
    // Initialize Firebase Messaging for notifications
    final messaging = FirebaseMessaging.instance;
    
    // Request notification permissions
    final notificationSettings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    // Get FCM token
    final fcmToken = await messaging.getToken();
    debugPrint('FCM Token: $fcmToken');
    
    // Listen to token refresh
    messaging.onTokenRefresh.listen((token) {
      debugPrint('FCM Token refreshed: $token');
    });
    
    debugPrint('Firebase initialized successfully');
    debugPrint('Notification settings: ${notificationSettings.authorizationStatus}');
    
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // You might want to handle this error appropriately
    // For example, show a dialog or redirect to an error screen
  }
  
  runApp(
    const ProviderScope(
      child: KazipoaApp(),
    ),
  );
}
