import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// KaziLive repository for managing live sessions
class KaziLiveRepository {
  static const String _kaziliveTable = 'kazilive_sessions';

  /// Get upcoming KaziLive sessions
  static Future<List<Map<String, dynamic>>> getUpcomingSessions() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final now = DateTime.now().toIso8601String();

      final response = await Supabase.instance.client
          .from(_kaziliveTable)
          .select()
          .eq('user_id', user.id)
          .gte('scheduled_start', now)
          .eq('status', 'scheduled')
          .order('scheduled_start', ascending: true);
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get upcoming sessions error: $e');
      }
      rethrow;
    }
  }

  /// Get active KaziLive sessions
  static Future<List<Map<String, dynamic>>> getActiveSessions() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await Supabase.instance.client
          .from(_kaziliveTable)
          .select()
          .eq('user_id', user.id)
          .eq('status', 'live')
          .order('scheduled_start', ascending: false);
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get active sessions error: $e');
      }
      rethrow;
    }
  }

  /// Get session by ID
  static Future<Map<String, dynamic>?> getSession(String sessionId) async {
    try {
      final response = await Supabase.instance.client
          .from(_kaziliveTable)
          .select()
          .eq('id', sessionId)
          .single();
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get session error: $e');
      }
      return null;
    }
  }

  /// Enter a KaziLive session
  static Future<void> enterSession(String sessionId) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Increment viewer count
      await Supabase.instance.client.rpc('increment_viewer_count', params: {
        'session_id': sessionId,
      });

      // Add user to participants
      await Supabase.instance.client
          .from(_kaziliveTable)
          .update({
            'status': 'live',
            'actual_start': DateTime.now().toIso8601String(),
          })
          .eq('id', sessionId);
    } catch (e) {
      if (kDebugMode) {
        print('Enter session error: $e');
      }
      rethrow;
    }
  }

  /// Leave a KaziLive session
  static Future<void> leaveSession(String sessionId) async {
    try {
      // Decrement viewer count
      await Supabase.instance.client.rpc('decrement_viewer_count', params: {
        'session_id': sessionId,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Leave session error: $e');
      }
      rethrow;
    }
  }

  /// End a KaziLive session
  static Future<void> endSession(String sessionId) async {
    try {
      await Supabase.instance.client
          .from(_kaziliveTable)
          .update({
            'status': 'ended',
            'actual_end': DateTime.now().toIso8601String(),
          })
          .eq('id', sessionId);
    } catch (e) {
      if (kDebugMode) {
        print('End session error: $e');
      }
      rethrow;
    }
  }

  /// Stream active sessions for real-time updates
  static Stream<List<Map<String, dynamic>>> streamActiveSessions() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return Supabase.instance.client
        .from(_kaziliveTable)
        .stream(primaryKey: ['id'])
        .order('scheduled_start', ascending: false)
        .map((data) => data.where((session) => 
            session['user_id'] == user.id && 
            session['status'] == 'live').toList());
  }

  /// Stream session for real-time updates
  static Stream<Map<String, dynamic>?> streamSession(String sessionId) {
    return Supabase.instance.client
        .from(_kaziliveTable)
        .stream(primaryKey: ['id'])
        .map((data) => data.isNotEmpty ? data.first : null);
  }
}
