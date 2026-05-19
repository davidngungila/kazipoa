import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kazipoa/core/config/supabase_config.dart';
import 'package:kazipoa/core/services/auth_manager.dart';
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
  try {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    if (session != null) {
      try {
        final profile = await client
            .from('profiles')
            .select()
            .eq('id', session.user.id)
            .single();
        final role = profile['role'] ?? 'client';
        AuthManager().login(session.user.id, role);
      } catch (e) {
        debugPrint('Error loading user profile on startup: $e');
      }
    }
  } catch (e) {
    debugPrint('Warning: Could not retrieve current session: $e');
  }

  runApp(
    const ProviderScope(
      child: KazipoaApp(),
    ),
  );
}
