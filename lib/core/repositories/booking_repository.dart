import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/booking_service.dart';

/// Booking repository for managing booking operations
class BookingRepository {
  /// Create a new booking
  static Future<void> createBooking(Map<String, dynamic> bookingData) async {
    try {
      await BookingService.createBooking(bookingData);
    } catch (e) {
      if (kDebugMode) {
        print('Create booking error: $e');
      }
      rethrow;
    }
  }

  /// Get user's bookings
  static Future<QuerySnapshot> getUserBookings(String userId) async {
    try {
      return await BookingService.getUserBookings(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Get user bookings error: $e');
      }
      rethrow;
    }
  }

  /// Get service provider's bookings
  static Future<QuerySnapshot> getServiceBookings(String serviceId) async {
    try {
      return await BookingService.getServiceBookings(serviceId);
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
      await BookingService.updateBookingStatus(bookingId, status);
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
      await BookingService.cancelBooking(bookingId, reason);
    } catch (e) {
      if (kDebugMode) {
        print('Cancel booking error: $e');
      }
      rethrow;
    }
  }

  /// Search bookings with filters
  static Future<QuerySnapshot> searchBookings({
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
      return await BookingService.searchBookings(
        userId: userId,
        serviceId: serviceId,
        status: status,
        startDate: startDate,
        endDate: endDate,
        location: location,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
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
      return await BookingService.getBookingAnalytics(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Get booking analytics error: $e');
      }
      rethrow;
    }
  }

  /// Get booking details
  static Future<DocumentSnapshot> getBookingDetails(String bookingId) async {
    try {
      return await BookingService.getBookingDetails(bookingId);
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
      await BookingService.updateBookingDetails(bookingId, updates);
    } catch (e) {
      if (kDebugMode) {
        print('Update booking details error: $e');
      }
      rethrow;
    }
  }

  /// Get user notifications
  static Future<QuerySnapshot> getUserNotifications(String userId) async {
    try {
      return await BookingService.getUserNotifications(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Get user notifications error: $e');
      }
      rethrow;
    }
  }

  /// Mark notification as read
  static Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await BookingService.markNotificationAsRead(notificationId);
    } catch (e) {
      if (kDebugMode) {
        print('Mark notification as read error: $e');
      }
      rethrow;
    }
  }
}
