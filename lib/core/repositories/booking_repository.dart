import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_client.dart';

/// Booking repository for managing booking operations
class BookingRepository {
  static const String _bookingsTable = 'bookings';
  static const String _bookingRequestsTable = 'booking_requests';
  static const String _recurringBookingsTable = 'recurring_bookings';

  /// Create a new booking
  static Future<void> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final bookingWithMetadata = {
        ...bookingData,
        'user_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
        'status': 'pending',
        'updated_at': DateTime.now().toIso8601String(),
      };

      await Supabase.instance.client
          .from(_bookingsTable)
          .insert(bookingWithMetadata);
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
          .from(_bookingsTable)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Get user bookings error: $e');
      }
      rethrow;
    }
  }

  /// Get service provider's bookings
  static Future<List<Map<String, dynamic>>> getServiceBookings(String serviceId) async {
    try {
      final response = await Supabase.instance.client
          .from(_bookingsTable)
          .select()
          .eq('service_id', serviceId)
          .order('created_at', ascending: false);
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
          .from(_bookingsTable)
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
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
          .from(_bookingsTable)
          .update({
            'status': 'cancelled',
            'cancelled_at': DateTime.now().toIso8601String(),
            'cancellation_reason': reason,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
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
      var query = Supabase.instance.client.from(_bookingsTable).select();

      if (userId != null) {
        query = query.eq('user_id', userId);
      }
      if (serviceId != null) {
        query = query.eq('service_id', serviceId);
      }
      if (status != null) {
        query = query.eq('status', status);
      }
      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
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

      final response = await query.order('created_at', ascending: false);
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

  /// Get booking details
  static Future<Map<String, dynamic>?> getBookingDetails(String bookingId) async {
    try {
      final response = await Supabase.instance.client
          .from(_bookingsTable)
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
          .from(_bookingsTable)
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
    } catch (e) {
      if (kDebugMode) {
        print('Update booking details error: $e');
      }
      rethrow;
    }
  }

  /// Reschedule booking
  static Future<void> rescheduleBooking(String bookingId, DateTime newDate, String newTime) async {
    try {
      await Supabase.instance.client
          .from(_bookingsTable)
          .update({
            'booking_date': newDate.toIso8601String(),
            'booking_time': newTime,
            'rescheduled': true,
            'rescheduled_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
    } catch (e) {
      if (kDebugMode) {
        print('Reschedule booking error: $e');
      }
      rethrow;
    }
  }

  /// Stream bookings for real-time updates
  static Stream<List<Map<String, dynamic>>> streamBookings(String userId) {
    return Supabase.instance.client
        .from(_bookingsTable)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }
}
