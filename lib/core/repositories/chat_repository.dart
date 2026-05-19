import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Chat repository for managing conversations and messages
class ChatRepository {
  static const String _conversationsTable = 'conversations';
  static const String _messagesTable = 'messages';

  /// Get all conversations for current user
  static Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await Supabase.instance.client
          .from(_conversationsTable)
          .select()
          .or('participant1_id.eq.${user.id},participant2_id.eq.${user.id}')
          .order('last_message_at', ascending: false);
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get conversations error: $e');
      }
      rethrow;
    }
  }

  /// Get conversation by ID
  static Future<Map<String, dynamic>?> getConversation(String conversationId) async {
    try {
      final response = await Supabase.instance.client
          .from(_conversationsTable)
          .select()
          .eq('id', conversationId)
          .single();
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get conversation error: $e');
      }
      return null;
    }
  }

  /// Create or get existing conversation
  static Future<Map<String, dynamic>> getOrCreateConversation(String otherUserId) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Check if conversation already exists
      final existingConversations = await Supabase.instance.client
          .from(_conversationsTable)
          .select()
          .or('and(participant1_id.eq.${user.id},participant2_id.eq.$otherUserId),and(participant1_id.eq.$otherUserId,participant2_id.eq.${user.id})')
          .limit(1);

      if (existingConversations.isNotEmpty) {
        return existingConversations.first;
      }

      // Create new conversation
      final newConversation = {
        'participant1_id': user.id,
        'participant2_id': otherUserId,
        'created_at': DateTime.now().toIso8601String(),
        'last_message_at': DateTime.now().toIso8601String(),
      };

      final response = await Supabase.instance.client
          .from(_conversationsTable)
          .insert(newConversation)
          .select()
          .single();

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get or create conversation error: $e');
      }
      rethrow;
    }
  }

  /// Get messages for a conversation
  static Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    try {
      final response = await Supabase.instance.client
          .from(_messagesTable)
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false);
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get messages error: $e');
      }
      rethrow;
    }
  }

  /// Send a message
  static Future<void> sendMessage(String conversationId, String content) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final message = {
        'conversation_id': conversationId,
        'sender_id': user.id,
        'content': content,
        'created_at': DateTime.now().toIso8601String(),
        'read': false,
      };

      await Supabase.instance.client.from(_messagesTable).insert(message);

      // Update conversation's last message time
      await Supabase.instance.client
          .from(_conversationsTable)
          .update({
            'last_message_at': DateTime.now().toIso8601String(),
          })
          .eq('id', conversationId);
    } catch (e) {
      if (kDebugMode) {
        print('Send message error: $e');
      }
      rethrow;
    }
  }

  /// Mark messages as read
  static Future<void> markMessagesAsRead(String conversationId) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await Supabase.instance.client
          .from(_messagesTable)
          .update({'read': true, 'read_at': DateTime.now().toIso8601String()})
          .eq('conversation_id', conversationId)
          .neq('sender_id', user.id);
    } catch (e) {
      if (kDebugMode) {
        print('Mark messages as read error: $e');
      }
      rethrow;
    }
  }

  /// Get unread message count
  static Future<int> getUnreadCount() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return 0;

      final response = await Supabase.instance.client
          .from(_messagesTable)
          .select()
          .eq('read', false)
          .neq('sender_id', user.id);

      return response.length;
    } catch (e) {
      if (kDebugMode) {
        print('Get unread count error: $e');
      }
      return 0;
    }
  }

  /// Stream messages for real-time updates
  static Stream<List<Map<String, dynamic>>> streamMessages(String conversationId) {
    return Supabase.instance.client
        .from(_messagesTable)
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: false);
  }

  /// Stream conversations for real-time updates
  static Stream<List<Map<String, dynamic>>> streamConversations() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return Supabase.instance.client
        .from(_conversationsTable)
        .stream(primaryKey: ['id'])
        .order('last_message_at', ascending: false)
        .map((data) => data.where((conv) => 
            conv['participant1_id'] == user.id || 
            conv['participant2_id'] == user.id).toList());
  }
}
