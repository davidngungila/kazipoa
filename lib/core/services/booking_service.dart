import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Booking service for managing appointments and service bookings
class BookingService {
  static const String _bookingsCollection = 'bookings';
  static const String _notificationsCollection = 'booking_notifications';

  /// Create a new booking
  static Future<void> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final bookingWithMetadata = {
        ...bookingData,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection(_bookingsCollection)
          .add(bookingWithMetadata);

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
  static Future<QuerySnapshot> getUserBookings(String userId) async {
    try {
      return await FirebaseFirestore.instance
          .collection(_bookingsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
    } catch (e) {
      if (kDebugMode) {
        print('Get bookings error: $e');
      }
      rethrow;
    }
  }

  /// Get service provider's bookings
  static Future<QuerySnapshot> getServiceBookings(String serviceId) async {
    try {
      return await FirebaseFirestore.instance
          .collection(_bookingsCollection)
          .where('serviceId', isEqualTo: serviceId)
          .orderBy('createdAt', descending: true)
          .get();
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
      await FirebaseFirestore.instance
          .collection(_bookingsCollection)
          .doc(bookingId)
          .update({
            'status': status,
            'updatedAt': FieldValue.serverTimestamp(),
          });

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
      await FirebaseFirestore.instance
          .collection(_bookingsCollection)
          .doc(bookingId)
          .update({
            'status': 'cancelled',
            'cancelledAt': FieldValue.serverTimestamp(),
            'cancellationReason': reason,
            'updatedAt': FieldValue.serverTimestamp(),
          });

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
      Query query = FirebaseFirestore.instance.collection(_bookingsCollection);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }
      if (serviceId != null) {
        query = query.where('serviceId', isEqualTo: serviceId);
      }
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }
      if (startDate != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: endDate);
      }
      if (location != null) {
        query = query.where('location', isEqualTo: location);
      }
      if (minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      }
      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      return await query.orderBy('createdAt', descending: true).get();
      
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
      final bookingsSnapshot = await getUserBookings(userId);
      final bookings = bookingsSnapshot.docs;

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
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final result = await FirebaseFirestore.instance
          .collection(_bookingsCollection)
          .add(booking);
      
      await FirebaseFirestore.instance
          .collection(_notificationsCollection)
          .add({
            'userId': user.uid,
            'type': 'booking_created',
            'title': 'New Booking Created',
            'message': 'Your booking has been created successfully',
            'bookingId': result.id,
            'createdAt': FieldValue.serverTimestamp(),
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
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection(_notificationsCollection)
          .add({
            'userId': user.uid,
            'type': 'booking_status_updated',
            'title': 'Booking Status Updated',
            'message': 'Your booking status has been updated to $status',
            'bookingId': bookingId,
            'createdAt': FieldValue.serverTimestamp(),
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
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection(_notificationsCollection)
          .add({
            'userId': user.uid,
            'type': 'booking_cancelled',
            'title': 'Booking Cancelled',
            'message': 'Your booking has been cancelled. Reason: $reason',
            'bookingId': bookingId,
            'createdAt': FieldValue.serverTimestamp(),
            'isRead': false,
          });
    } catch (e) {
      if (kDebugMode) {
        print('Send cancellation notification error: $e');
      }
    }
  }

  /// Get user notifications
  static Future<QuerySnapshot> getUserNotifications(String userId) async {
    try {
      return await FirebaseFirestore.instance
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();
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
      await FirebaseFirestore.instance
          .collection(_notificationsCollection)
          .doc(notificationId)
          .update({
            'isRead': true,
            'readAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      if (kDebugMode) {
        print('Mark notification as read error: $e');
      }
      rethrow;
    }
  }

  /// Get booking details
  static Future<DocumentSnapshot> getBookingDetails(String bookingId) async {
    try {
      return await FirebaseFirestore.instance
          .collection(_bookingsCollection)
          .doc(bookingId)
          .get();
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
      await FirebaseFirestore.instance
          .collection(_bookingsCollection)
          .doc(bookingId)
          .update({
            ...updates,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      if (kDebugMode) {
        print('Update booking details error: $e');
      }
      rethrow;
    }
  }
}
