import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/storage_manager.dart';
import '../utils/date_util.dart';
import 'supabase_service.dart';

/// Enhanced Booking Service - Equivalent to JavaScript BookingManager
/// Handles booking creation, management, tracking with offline support
class EnhancedBookingService {
  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _pendingBookings = [];
  StreamSubscription<List<Map<String, dynamic>>>? _bookingsSubscription;

  // Getters
  List<Map<String, dynamic>> get bookings => _bookings;
  List<Map<String, dynamic>> get pendingBookings => _pendingBookings;

  /// Initialize booking service
  Future<void> init() async {
    try {
      // Load bookings from storage or use demo data
      final stored = await StorageManager.getBookings();
      
      if (stored.isNotEmpty) {
        _bookings = stored;
      } else {
        // Initialize with demo bookings
        _bookings = _getDemoBookings();
        await StorageManager.setBookings(_bookings);
      }
      
      _pendingBookings = await StorageManager.getPendingBookings();
      
      print('Loaded ${_bookings.length} bookings');
      
      // Listen to Firebase changes for real-time updates
      _listenToBookingsUpdates();
      
    } catch (e) {
      print('Error initializing booking service: $e');
    }
  }

  /// Listen to real-time booking updates from Supabase
  void _listenToBookingsUpdates() {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    _bookingsSubscription = Supabase.instance.client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('userId', user.id)
        .order('createdAt', ascending: false)
        .listen((data) {
      _bookings = data.map((booking) {
        booking['id'] = booking['id'];
        return booking;
      }).toList();
      
      // Update local storage
      StorageManager.setBookings(_bookings);
    });
  }

  /// Get demo bookings for testing
  List<Map<String, dynamic>> _getDemoBookings() {
    final today = DateTime.now();
    return [
      {
        'id': 'BKG_001',
        'serviceType': 'Ushauri wa Biashara',
        'professionalId': 'USR_pro001',
        'professionalName': 'Maria Baraza',
        'professionalImage': 'https://example.com/maria.jpg',
        'clientId': 'USR_client001',
        'clientName': 'Amani Msemaji',
        'clientPhone': '+255 712 345 678',
        'bookingDate': DateUtil.formatDate(today.add(const Duration(days: 2))),
        'bookingTime': '14:00',
        'duration': 60,
        'status': 'confirmed',
        'price': 50000.0,
        'currency': 'TZS',
        'notes': 'Full makeover with braids',
        'rating': null,
        'createdAt': DateUtil.formatDate(today.subtract(const Duration(days: 5))),
        'updatedAt': DateUtil.formatDate(today.subtract(const Duration(days: 5))),
        'location': {
          'address': 'Dar es Salaam, Tanzania',
          'latitude': -6.7924,
          'longitude': 39.2083,
        },
        'paymentStatus': 'pending',
        'isOnline': false,
      },
      {
        'id': 'BKG_002',
        'serviceType': 'Urembo wa Nywele',
        'professionalId': 'USR_pro002',
        'professionalName': 'Zuwena Nassor',
        'professionalImage': 'https://example.com/zuwena.jpg',
        'clientId': 'USR_client001',
        'clientName': 'Zuwena Nassor',
        'clientPhone': '+255 713 456 789',
        'bookingDate': DateUtil.formatDate(today.add(const Duration(days: 3))),
        'bookingTime': '10:30',
        'duration': 120,
        'status': 'pending',
        'price': 75000.0,
        'currency': 'TZS',
        'notes': 'Hair styling and makeup',
        'rating': null,
        'createdAt': DateUtil.formatDate(today.subtract(const Duration(days: 3))),
        'updatedAt': DateUtil.formatDate(today.subtract(const Duration(days: 3))),
        'location': {
          'address': 'Mikocheni, Dar es Salaam',
          'latitude': -6.7624,
          'longitude': 39.2183,
        },
        'paymentStatus': 'pending',
        'isOnline': false,
      },
      {
        'id': 'BKG_003',
        'serviceType': 'Matibabu ya Magonjwa',
        'professionalId': 'USR_pro003',
        'professionalName': 'Dr. John Mwangi',
        'professionalImage': 'https://example.com/john.jpg',
        'clientId': 'USR_client001',
        'clientName': 'Patient One',
        'clientPhone': '+255 714 567 890',
        'bookingDate': DateUtil.formatDate(today.subtract(const Duration(days: 1))),
        'bookingTime': '09:00',
        'duration': 30,
        'status': 'completed',
        'price': 30000.0,
        'currency': 'TZS',
        'notes': 'Regular checkup',
        'rating': 5.0,
        'createdAt': DateUtil.formatDate(today.subtract(const Duration(days: 7))),
        'updatedAt': DateUtil.formatDate(today.subtract(const Duration(days: 1))),
        'location': {
          'address': 'Mlimani City, Dar es Salaam',
          'latitude': -6.7524,
          'longitude': 39.2283,
        },
        'paymentStatus': 'paid',
        'isOnline': true,
      },
    ];
  }

  /// Create a new booking
  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Generate booking ID
      final bookingId = 'BKG_${DateTime.now().millisecondsSinceEpoch}';
      
      // Create booking object with metadata
      final booking = {
        'id': bookingId,
        'userId': user.id,
        'serviceType': bookingData['serviceType'] ?? '',
        'professionalId': bookingData['professionalId'] ?? '',
        'professionalName': bookingData['professionalName'] ?? '',
        'professionalImage': bookingData['professionalImage'] ?? '',
        'clientId': bookingData['clientId'] ?? user.id,
        'clientName': bookingData['clientName'] ?? '',
        'clientPhone': bookingData['clientPhone'] ?? '',
        'bookingDate': bookingData['bookingDate'] ?? '',
        'bookingTime': bookingData['bookingTime'] ?? '',
        'duration': bookingData['duration'] ?? 60,
        'status': 'pending',
        'price': bookingData['price'] ?? 0.0,
        'currency': bookingData['currency'] ?? 'TZS',
        'notes': bookingData['notes'] ?? '',
        'rating': null,
        'location': bookingData['location'] ?? {},
        'paymentStatus': 'pending',
        'isOnline': bookingData['isOnline'] ?? false,
        'bookingType': bookingData['bookingType'] ?? 'recurring', // 'recurring' or 'individual'
        'acceptedAt': null, // When pro accepts the booking
        'expiresAt': null, // 24 hours after acceptance
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Add to pending bookings for offline support
      _pendingBookings.add(booking);
      await StorageManager.setPendingBookings(_pendingBookings);

      // Try to sync with Firebase
      try {
        await _syncBookingToFirebase(booking);
        
        // Remove from pending after successful sync
        _pendingBookings.removeWhere((b) => b['id'] == bookingId);
        await StorageManager.setPendingBookings(_pendingBookings);
        
        // Add to local bookings
        _bookings.insert(0, booking);
        await StorageManager.setBookings(_bookings);
        
        print('Booking created and synced: $bookingId');
        return {
          'success': true,
          'booking': booking,
          'message': 'Ombi lako limetumwa kwa mafanikio!',
        };
      } catch (e) {
        // Keep in pending if Firebase sync fails
        print('Firebase sync failed, keeping in pending: $e');
        return {
          'success': true,
          'booking': booking,
          'pending': true,
          'message': 'Ombi lako limetengwa na litatumwa wakati mtandao upo.',
        };
      }
      
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred while creating booking: $e',
      };
    }
  }

  /// Sync booking to Supabase
  Future<void> _syncBookingToFirebase(Map<String, dynamic> booking) async {
    await Supabase.instance.client
        .from('bookings')
        .insert(booking);

    // Send notification to service provider
    await _sendBookingNotification(booking);
  }

  /// Update booking status
  Future<Map<String, dynamic>> updateBookingStatus(String bookingId, String status) async {
    try {
      final bookingIndex = _bookings.indexWhere((b) => b['id'] == bookingId);
      if (bookingIndex == -1) {
        throw Exception('Booking not found');
      }

      // Update local booking
      _bookings[bookingIndex]['status'] = status;
      _bookings[bookingIndex]['updatedAt'] = DateTime.now().toIso8601String();
      
      await StorageManager.setBookings(_bookings);

      // Update in Supabase
      try {
        await Supabase.instance.client
            .from('bookings')
            .update({
              'status': status,
              'updatedAt': DateTime.now().toIso8601String(),
            })
            .eq('id', bookingId);

        // Send status update notification
        await _sendStatusUpdateNotification(bookingId, status);
        
        print('Booking status updated: $bookingId -> $status');
      } catch (e) {
        print('Firebase update failed, keeping local changes: $e');
      }

      return {
        'success': true,
        'message': 'Booking status updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred while updating booking status: $e',
      };
    }
  }

  /// Accept booking and start 24-hour timer (for recurring bookings only)
  Future<Map<String, dynamic>> acceptBooking(String bookingId) async {
    try {
      final bookingIndex = _bookings.indexWhere((b) => b['id'] == bookingId);
      if (bookingIndex == -1) {
        throw Exception('Booking not found');
      }

      final booking = _bookings[bookingIndex];
      
      // Only start timer for recurring bookings
      if (booking['bookingType'] != 'recurring') {
        return {
          'success': false,
          'error': 'Timer only applies to recurring bookings',
        };
      }

      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      // Update booking with acceptance details
      _bookings[bookingIndex]['status'] = 'accepted';
      _bookings[bookingIndex]['acceptedAt'] = now.toIso8601String();
      _bookings[bookingIndex]['expiresAt'] = expiresAt.toIso8601String();
      _bookings[bookingIndex]['updatedAt'] = now.toIso8601String();
      
      await StorageManager.setBookings(_bookings);

      // Update in Supabase
      try {
        await Supabase.instance.client
            .from('bookings')
            .update({
              'status': 'accepted',
              'acceptedAt': DateTime.now().toIso8601String(),
              'expiresAt': expiresAt.toIso8601String(),
              'updatedAt': DateTime.now().toIso8601String(),
            })
            .eq('id', bookingId);

        // Send acceptance notification
        await _sendStatusUpdateNotification(bookingId, 'accepted');
        
        print('Booking accepted with 24-hour timer: $bookingId');
      } catch (e) {
        print('Firebase update failed, keeping local changes: $e');
      }

      return {
        'success': true,
        'message': 'Booking accepted successfully',
        'expiresAt': expiresAt.toIso8601String(),
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred while accepting booking: $e',
      };
    }
  }

  /// Accept individual booking (no timer)
  Future<Map<String, dynamic>> acceptIndividualBooking(String bookingId) async {
    try {
      final bookingIndex = _bookings.indexWhere((b) => b['id'] == bookingId);
      if (bookingIndex == -1) {
        throw Exception('Booking not found');
      }

      // Update booking status without timer
      _bookings[bookingIndex]['status'] = 'accepted';
      _bookings[bookingIndex]['acceptedAt'] = DateTime.now().toIso8601String();
      _bookings[bookingIndex]['updatedAt'] = DateTime.now().toIso8601String();
      
      await StorageManager.setBookings(_bookings);

      // Update in Supabase
      try {
        await Supabase.instance.client
            .from('bookings')
            .update({
              'status': 'accepted',
              'acceptedAt': DateTime.now().toIso8601String(),
              'updatedAt': DateTime.now().toIso8601String(),
            })
            .eq('id', bookingId);

        await _sendStatusUpdateNotification(bookingId, 'accepted');
        print('Individual booking accepted: $bookingId');
      } catch (e) {
        print('Firebase update failed, keeping local changes: $e');
      }

      return {
        'success': true,
        'message': 'Individual booking accepted successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred while accepting booking: $e',
      };
    }
  }

  /// Check for expired bookings and update their status
  Future<void> checkAndUpdateExpiredBookings() async {
    final now = DateTime.now();
    bool hasUpdates = false;

    for (int i = 0; i < _bookings.length; i++) {
      final booking = _bookings[i];
      
      // Check if booking is accepted and has expired
      if (booking['status'] == 'accepted' && 
          booking['expiresAt'] != null && 
          booking['bookingType'] == 'recurring') {
        
        final expiresAt = DateTime.parse(booking['expiresAt']);
        if (now.isAfter(expiresAt)) {
          _bookings[i]['status'] = 'expired';
          _bookings[i]['updatedAt'] = now.toIso8601String();
          hasUpdates = true;
          
          print('Booking expired: ${booking['id']}');
        }
      }
    }

    if (hasUpdates) {
      await StorageManager.setBookings(_bookings);
      
      // Update in Supabase
      try {
        final batch = Supabase.instance.client;
        for (final booking in _bookings) {
          if (booking['status'] == 'expired') {
            await batch
                .from('bookings')
                .update({
                  'status': 'expired',
                  'updatedAt': DateTime.now().toIso8601String(),
                })
                .eq('id', booking['id']);
          }
        }
      } catch (e) {
        print('Firebase batch update failed: $e');
      }
    }
  }

  /// Get remaining time for accepted booking
  Duration? getRemainingTime(String bookingId) {
    final booking = _bookings.where((b) => b['id'] == bookingId).firstOrNull;
    if (booking == null || booking['status'] != 'accepted' || booking['expiresAt'] == null) {
      return null;
    }

    final expiresAt = DateTime.parse(booking['expiresAt']);
    final now = DateTime.now();
    
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    
    return expiresAt.difference(now);
  }

  /// Cancel booking
  Future<Map<String, dynamic>> cancelBooking(String bookingId, String reason) async {
    try {
      final bookingIndex = _bookings.indexWhere((b) => b['id'] == bookingId);
      if (bookingIndex == -1) {
        throw Exception('Booking not found');
      }

      // Update local booking
      _bookings[bookingIndex]['status'] = 'cancelled';
      _bookings[bookingIndex]['cancelledAt'] = DateTime.now().toIso8601String();
      _bookings[bookingIndex]['cancellationReason'] = reason;
      _bookings[bookingIndex]['updatedAt'] = DateTime.now().toIso8601String();
      
      await StorageManager.setBookings(_bookings);

      // Update in Supabase
      try {
        await Supabase.instance.client
            .from('bookings')
            .update({
              'status': 'cancelled',
              'cancelledAt': DateTime.now().toIso8601String(),
              'cancellationReason': reason,
              'updatedAt': DateTime.now().toIso8601String(),
            })
            .eq('id', bookingId);

        // Send cancellation notification
        await _sendCancellationNotification(bookingId, reason);
        
        print('Booking cancelled: $bookingId');
      } catch (e) {
        print('Firebase update failed, keeping local changes: $e');
      }

      return {
        'success': true,
        'message': 'Booking cancelled successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred while cancelling booking: $e',
      };
    }
  }

  /// Rate booking
  Future<Map<String, dynamic>> rateBooking(String bookingId, double rating, String? review) async {
    try {
      final bookingIndex = _bookings.indexWhere((b) => b['id'] == bookingId);
      if (bookingIndex == -1) {
        throw Exception('Booking not found');
      }

      // Update local booking
      _bookings[bookingIndex]['rating'] = rating;
      _bookings[bookingIndex]['review'] = review;
      _bookings[bookingIndex]['ratedAt'] = DateTime.now().toIso8601String();
      _bookings[bookingIndex]['updatedAt'] = DateTime.now().toIso8601String();
      
      await StorageManager.setBookings(_bookings);

      // Update in Supabase
      try {
        await Supabase.instance.client
            .from('bookings')
            .update({
              'rating': rating,
              'review': review,
              'ratedAt': DateTime.now().toIso8601String(),
              'updatedAt': DateTime.now().toIso8601String(),
            })
            .eq('id', bookingId);
        
        print('Booking rated: $bookingId');
      } catch (e) {
        print('Firebase update failed, keeping local changes: $e');
      }

      return {
        'success': true,
        'message': 'Booking rated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An error occurred while rating booking: $e',
      };
    }
  }

  /// Get bookings by status
  List<Map<String, dynamic>> getBookingsByStatus(String status) {
    return _bookings.where((booking) => booking['status'] == status).toList();
  }

  /// Get bookings by date
  List<Map<String, dynamic>> getBookingsByDate(String date) {
    return _bookings.where((booking) => booking['bookingDate'] == date).toList();
  }

  /// Get upcoming bookings
  List<Map<String, dynamic>> getUpcomingBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      final bookingDateTime = DateTime.parse('${booking['bookingDate']} ${booking['bookingTime']}:00');
      return bookingDateTime.isAfter(now) && booking['status'] != 'cancelled';
    }).toList();
  }

  /// Get past bookings
  List<Map<String, dynamic>> getPastBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      final bookingDateTime = DateTime.parse('${booking['bookingDate']} ${booking['bookingTime']}:00');
      return bookingDateTime.isBefore(now) || booking['status'] == 'completed';
    }).toList();
  }

  /// Get booking analytics
  Map<String, dynamic> getBookingAnalytics() {
    final totalBookings = _bookings.length;
    final pendingBookings = getBookingsByStatus('pending').length;
    final confirmedBookings = getBookingsByStatus('confirmed').length;
    final completedBookings = getBookingsByStatus('completed').length;
    final cancelledBookings = getBookingsByStatus('cancelled').length;

    double totalRevenue = 0.0;
    int ratedBookings = 0;
    double totalRating = 0.0;

    for (var booking in _bookings) {
      if (booking['status'] == 'completed' && booking['paymentStatus'] == 'paid') {
        totalRevenue += (booking['price'] as num).toDouble();
      }
      if (booking['rating'] != null) {
        ratedBookings++;
        totalRating += (booking['rating'] as num).toDouble();
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
      'averageRating': ratedBookings > 0 ? totalRating / ratedBookings : 0.0,
      'cancellationRate': totalBookings > 0 ? (cancelledBookings / totalBookings) * 100 : 0.0,
    };
  }

  /// Sync pending bookings when coming back online
  Future<void> syncPendingBookings() async {
    if (_pendingBookings.isEmpty) return;

    print('Syncing ${_pendingBookings.length} pending bookings...');
    
    for (final booking in List.from(_pendingBookings)) {
      try {
        await _syncBookingToFirebase(booking);
        _pendingBookings.removeWhere((b) => b['id'] == booking['id']);
        
        // Add to main bookings if not already there
        if (!_bookings.any((b) => b['id'] == booking['id'])) {
          _bookings.insert(0, booking);
        }
      } catch (e) {
        print('Failed to sync booking ${booking['id']}: $e');
      }
    }

    await StorageManager.setPendingBookings(_pendingBookings);
    await StorageManager.setBookings(_bookings);
    
    print('Sync completed. ${_pendingBookings.length} bookings still pending.');
  }

  /// Get booking details
  Map<String, dynamic>? getBookingDetails(String bookingId) {
    try {
      return _bookings.firstWhere((booking) => booking['id'] == bookingId);
    } catch (e) {
      return null;
    }
  }

  /// Search bookings
  List<Map<String, dynamic>> searchBookings({
    String? query,
    String? status,
    String? dateRange,
    double? minPrice,
    double? maxPrice,
  }) {
    List<Map<String, dynamic>> results = List.from(_bookings);

    // Filter by query (search in service type, professional name, notes)
    if (query != null && query.isNotEmpty) {
      results = results.where((booking) {
        final serviceType = (booking['serviceType'] as String).toLowerCase();
        final professionalName = (booking['professionalName'] as String).toLowerCase();
        final notes = (booking['notes'] as String).toLowerCase();
        final searchQuery = query.toLowerCase();
        
        return serviceType.contains(searchQuery) ||
               professionalName.contains(searchQuery) ||
               notes.contains(searchQuery);
      }).toList();
    }

    // Filter by status
    if (status != null && status.isNotEmpty) {
      results = results.where((booking) => booking['status'] == status).toList();
    }

    // Filter by date range
    if (dateRange != null) {
      final now = DateTime.now();
      DateTime startDate;
      DateTime endDate;

      switch (dateRange) {
        case 'today':
          startDate = DateTime(now.year, now.month, now.day);
          endDate = startDate.add(const Duration(days: 1));
          break;
        case 'week':
          startDate = now.subtract(const Duration(days: 7));
          endDate = now;
          break;
        case 'month':
          startDate = DateTime(now.year, now.month, 1);
          endDate = DateTime(now.year, now.month + 1, 1);
          break;
        default:
          startDate = now.subtract(const Duration(days: 30));
          endDate = now;
      }

      results = results.where((booking) {
        final bookingDate = DateTime.parse(booking['bookingDate']);
        return bookingDate.isAfter(startDate) && bookingDate.isBefore(endDate);
      }).toList();
    }

    // Filter by price range
    if (minPrice != null) {
      results = results.where((booking) => (booking['price'] as num).toDouble() >= minPrice).toList();
    }
    if (maxPrice != null) {
      results = results.where((booking) => (booking['price'] as num).toDouble() <= maxPrice).toList();
    }

    return results;
  }

  /// Send booking notification
  Future<void> _sendBookingNotification(Map<String, dynamic> booking) async {
    try {
      await Supabase.instance.client
          .from('notifications')
          .insert({
            'userId': booking['professionalId'],
            'type': 'new_booking',
            'title': 'Ombi Jipya la Miadi',
            'message': '${booking['clientName']} ameweka ombi la ${booking['serviceType']}',
            'bookingId': booking['id'],
            'createdAt': DateTime.now().toIso8601String(),
            'isRead': false,
          });
    } catch (e) {
      print('Failed to send booking notification: $e');
    }
  }

  /// Send status update notification
  Future<void> _sendStatusUpdateNotification(String bookingId, String status) async {
    try {
      final booking = getBookingDetails(bookingId);
      if (booking == null) return;

      await Supabase.instance.client
          .from('notifications')
          .insert({
            'userId': booking['clientId'],
            'type': 'booking_status_update',
            'title': 'Hadhi ya Ombi Imebadilishwa',
            'message': 'Hadhi ya ombi lako imebadilishwa kuwa: $status',
            'bookingId': bookingId,
            'createdAt': DateTime.now().toIso8601String(),
            'isRead': false,
          });
    } catch (e) {
      print('Failed to send status update notification: $e');
    }
  }

  /// Send cancellation notification
  Future<void> _sendCancellationNotification(String bookingId, String reason) async {
    try {
      final booking = getBookingDetails(bookingId);
      if (booking == null) return;

      await Supabase.instance.client
          .from('notifications')
          .insert({
            'userId': booking['professionalId'],
            'type': 'booking_cancelled',
            'title': 'Ombi Limefutwa',
            'message': 'Ombi limefutwa. Sababu: $reason',
            'bookingId': bookingId,
            'createdAt': DateTime.now().toIso8601String(),
            'isRead': false,
          });
    } catch (e) {
      print('Failed to send cancellation notification: $e');
    }
  }

  /// Dispose method
  void dispose() {
    _bookingsSubscription?.cancel();
    _bookingsSubscription = null;
  }
}

// Provider
final enhancedBookingServiceProvider = Provider<EnhancedBookingService>((ref) {
  final service = EnhancedBookingService();
  ref.onDispose(() => service.dispose());
  return service;
});
