import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Notification repository for managing user notifications
class NotificationRepository {
  static const String _notificationsTable = 'notifications';

  /// Get all notifications for current user
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await Supabase.instance.client
          .from(_notificationsTable)
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get notifications error: $e');
      }
      rethrow;
    }
  }

  /// Get unread notifications
  static Future<List<Map<String, dynamic>>> getUnreadNotifications() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await Supabase.instance.client
          .from(_notificationsTable)
          .select()
          .eq('user_id', user.id)
          .eq('read', false)
          .order('created_at', ascending: false);
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get unread notifications error: $e');
      }
      rethrow;
    }
  }

  /// Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    try {
      await Supabase.instance.client
          .from(_notificationsTable)
          .update({
            'read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId);
    } catch (e) {
      if (kDebugMode) {
        print('Mark as read error: $e');
      }
      rethrow;
    }
  }

  /// Mark all notifications as read
  static Future<void> markAllAsRead() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await Supabase.instance.client
          .from(_notificationsTable)
          .update({
            'read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', user.id)
          .eq('read', false);
    } catch (e) {
      if (kDebugMode) {
        print('Mark all as read error: $e');
      }
      rethrow;
    }
  }

  /// Get unread count
  static Future<int> getUnreadCount() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return 0;

      final response = await Supabase.instance.client
          .from(_notificationsTable)
          .select()
          .eq('user_id', user.id)
          .eq('read', false);

      return response.length;
    } catch (e) {
      if (kDebugMode) {
        print('Get unread count error: $e');
      }
      return 0;
    }
  }

  /// Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    try {
      await Supabase.instance.client
          .from(_notificationsTable)
          .delete()
          .eq('id', notificationId);
    } catch (e) {
      if (kDebugMode) {
        print('Delete notification error: $e');
      }
      rethrow;
    }
  }

  /// Stream notifications for real-time updates
  static Stream<List<Map<String, dynamic>>> streamNotifications() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return Supabase.instance.client
        .from(_notificationsTable)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.where((notif) => notif['user_id'] == user.id).toList());
  }

  /// Stream unread notifications for real-time updates
  static Stream<List<Map<String, dynamic>>> streamUnreadNotifications() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return Supabase.instance.client
        .from(_notificationsTable)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.where((notif) => 
            notif['user_id'] == user.id && 
            notif['read'] == false).toList());
  }
}
