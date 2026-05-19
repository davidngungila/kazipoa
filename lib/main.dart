import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kazipoa/core/config/supabase_config.dart';
import 'package:kazipoa/core/services/auth_manager.dart';
import 'package:kazipoa/core/services/enhanced_auth_service.dart';
import 'package:kazipoa/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables and initialize Supabase defensively
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Warning: Could not load .env file: $e');
  }

  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (e) {
    debugPrint('Error initializing Supabase: $e');
  }

  // Check if session exists on startup and populate AuthManager
  final container = ProviderContainer();
  try {
    await container.read(enhancedAuthServiceProvider).init();
    final authManager = AuthManager();
    final user = container.read(enhancedAuthServiceProvider).currentUser;
    if (user != null) {
      authManager.login(user['id'], user['role'] ?? 'client');
    }
  } catch (e) {
    debugPrint('Error initializing auth on startup: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const KazipoaApp(),
    ),
  );
}
