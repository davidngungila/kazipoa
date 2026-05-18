import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kazipoa/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('Testing Firebase initialization...');
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
    
    // Test Auth
    final auth = FirebaseAuth.instance;
    print('✅ Firebase Auth instance created');
    
    // Test Firestore
    final firestore = FirebaseFirestore.instance;
    print('✅ Firestore instance created');
    
    // Test Firestore settings
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    print('✅ Firestore settings configured');
    
    // Test basic Firestore operation (without actual network call)
    final collection = firestore.collection('test');
    print('✅ Firestore collection reference created');
    
    print('\n🎉 All Firebase services initialized successfully!');
    print('Project ID: ${Firebase.app().options.projectId}');
    print('App Name: ${Firebase.app().name}');
    
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }
}
