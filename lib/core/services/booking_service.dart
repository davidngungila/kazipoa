import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:kazipoa/core/services/supabase_service.dart';

/// Booking service for managing appointments and service bookings
class BookingService {
  static const String _bookingsCollection = 'bookings';
  static const String _notificationsCollection = 'booking_notifications';

  /// Create a new booking
  static Future<void> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final bookingWithMetadata = {
        ...bookingData,
        'userId': user.id,
        'createdAt': DateTime.now().toIso8601String(),
        'status': 'pending',
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await Supabase.instance.client
          .from(_bookingsCollection)
          .insert(bookingWithMetadata);

      // Send notification to service provider
      await _sendBookingNotification(bookingWithMetadata);
      
    } catch (e) {
      if (kDebugMode) {
        print('Create booking error: $e');
      }
      rethrow;
    }
  }

  /// Get user's bookings
  static Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from(_bookingsCollection)
          .select()
          .eq('userId', userId)
          .order('createdAt', ascending: false);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get bookings error: $e');
      }
      rethrow;
    }
  }

  /// Get service provider's bookings
  static Future<List<Map<String, dynamic>>> getServiceBookings(String serviceId) async {
    try {
      final response = await Supabase.instance.client
          .from(_bookingsCollection)
          .select()
          .eq('serviceId', serviceId)
          .order('createdAt', ascending: false);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get service bookings error: $e');
      }
      rethrow;
    }
  }

  /// Update booking status
  static Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await Supabase.instance.client
          .from(_bookingsCollection)
          .update({
            'status': status,
            'updatedAt': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);

      // Send status update notification
      await _sendStatusUpdateNotification(bookingId, status);
      
    } catch (e) {
      if (kDebugMode) {
        print('Update booking status error: $e');
      }
      rethrow;
    }
  }

  /// Cancel booking
  static Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await Supabase.instance.client
          .from(_bookingsCollection)
          .update({
            'status': 'cancelled',
            'cancelledAt': DateTime.now().toIso8601String(),
            'cancellationReason': reason,
            'updatedAt': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);

      // Send cancellation notification
      await _sendCancellationNotification(bookingId, reason);
      
    } catch (e) {
      if (kDebugMode) {
        print('Cancel booking error: $e');
      }
      rethrow;
    }
  }

  /// Search bookings with filters
  static Future<List<Map<String, dynamic>>> searchBookings({
    String? userId,
    String? serviceId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      var query = Supabase.instance.client.from(_bookingsCollection).select();

      if (userId != null) {
        query = query.eq('userId', userId);
      }
      if (serviceId != null) {
        query = query.eq('serviceId', serviceId);
      }
      if (status != null) {
        query = query.eq('status', status);
      }
      if (startDate != null) {
        query = query.gte('createdAt', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('createdAt', endDate.toIso8601String());
      }
      if (location != null) {
        query = query.eq('location', location);
      }
      if (minPrice != null) {
        query = query.gte('price', minPrice);
      }
      if (maxPrice != null) {
        query = query.lte('price', maxPrice);
      }

      final response = await query.order('createdAt', ascending: false);
      return response;
      
    } catch (e) {
      if (kDebugMode) {
        print('Search bookings error: $e');
      }
      rethrow;
    }
  }

  /// Get booking analytics
  static Future<Map<String, dynamic>> getBookingAnalytics(String userId) async {
    try {
      final bookings = await getUserBookings(userId);

      int totalBookings = bookings.length;
      int pendingBookings = bookings.where((doc) => doc['status'] == 'pending').length;
      int confirmedBookings = bookings.where((doc) => doc['status'] == 'confirmed').length;
      int completedBookings = bookings.where((doc) => doc['status'] == 'completed').length;
      int cancelledBookings = bookings.where((doc) => doc['status'] == 'cancelled').length;

      double totalRevenue = 0.0;
      for (var booking in bookings) {
        if (booking['status'] == 'completed' && booking['price'] != null) {
          totalRevenue += (booking['price'] as num).toDouble();
        }
      }

      return {
        'totalBookings': totalBookings,
        'pendingBookings': pendingBookings,
        'confirmedBookings': confirmedBookings,
        'completedBookings': completedBookings,
        'cancelledBookings': cancelledBookings,
        'totalRevenue': totalRevenue,
        'completionRate': totalBookings > 0 ? (completedBookings / totalBookings) * 100 : 0.0,
      };
      
    } catch (e) {
      if (kDebugMode) {
        print('Get booking analytics error: $e');
      }
      rethrow;
    }
  }

  /// Send booking notification
  static Future<void> _sendBookingNotification(Map<String, dynamic> booking) async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) return;

      await Supabase.instance.client
          .from(_notificationsCollection)
          .insert({
            'userId': user.id,
            'type': 'booking_created',
            'title': 'New Booking Created',
            'message': 'Your booking has been created successfully',
            'bookingId': booking['id'],
            'createdAt': DateTime.now().toIso8601String(),
            'isRead': false,
          });
    } catch (e) {
      if (kDebugMode) {
        print('Send booking notification error: $e');
      }
    }
  }

  /// Send status update notification
  static Future<void> _sendStatusUpdateNotification(String bookingId, String status) async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) return;

      await Supabase.instance.client
          .from(_notificationsCollection)
          .insert({
            'userId': user.id,
            'type': 'booking_status_updated',
            'title': 'Booking Status Updated',
            'message': 'Your booking status has been updated to $status',
            'bookingId': bookingId,
            'createdAt': DateTime.now().toIso8601String(),
            'isRead': false,
          });
    } catch (e) {
      if (kDebugMode) {
        print('Send status update notification error: $e');
      }
    }
  }

  /// Send cancellation notification
  static Future<void> _sendCancellationNotification(String bookingId, String reason) async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) return;

      await Supabase.instance.client
          .from(_notificationsCollection)
          .insert({
            'userId': user.id,
            'type': 'booking_cancelled',
            'title': 'Booking Cancelled',
            'message': 'Your booking has been cancelled. Reason: $reason',
            'bookingId': bookingId,
            'createdAt': DateTime.now().toIso8601String(),
            'isRead': false,
          });
    } catch (e) {
      if (kDebugMode) {
        print('Send cancellation notification error: $e');
      }
    }
  }

  /// Get user notifications
  static Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from(_notificationsCollection)
          .select()
          .eq('userId', userId)
          .eq('isRead', false)
          .order('createdAt', ascending: false);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get notifications error: $e');
      }
      rethrow;
    }
  }

  /// Mark notification as read
  static Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await Supabase.instance.client
          .from(_notificationsCollection)
          .update({
            'isRead': true,
            'readAt': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId);
    } catch (e) {
      if (kDebugMode) {
        print('Mark notification as read error: $e');
      }
      rethrow;
    }
  }

  /// Get booking details
  static Future<Map<String, dynamic>?> getBookingDetails(String bookingId) async {
    try {
      final response = await Supabase.instance.client
          .from(_bookingsCollection)
          .select()
          .eq('id', bookingId)
          .single();
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get booking details error: $e');
      }
      rethrow;
    }
  }

  /// Update booking details
  static Future<void> updateBookingDetails(String bookingId, Map<String, dynamic> updates) async {
    try {
      await Supabase.instance.client
          .from(_bookingsCollection)
          .update({
            ...updates,
            'updatedAt': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
    } catch (e) {
      if (kDebugMode) {
        print('Update booking details error: $e');
      }
      rethrow;
    }
  }
}
