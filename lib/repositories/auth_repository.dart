import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password, String name) async {
    final result = await _client.auth.signUp(email: email, password: password);
    if (result.user != null) {
      await _client.from('profiles').insert({
        'id': result.user!.id,
        'email': email,
        'name': name,
        'created_at': DateTime.now().toIso8601String(),
        'profile_completed': false,
      });
    }
    return result;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? getCurrentUser() => _client.auth.currentUser;

  Stream<AuthState> authStateChanges() => _client.auth.onAuthStateChange;
}
