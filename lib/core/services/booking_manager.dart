import 'package:flutter/material.dart';
import 'dart:async';

enum BookingState {
  created,
  broadcasted,
  pendingResponses,
  acceptedByPro,
  awaitingClientApproval,
  approved,
  active,
  completed,
  expired,
  declined,
}

enum BookingType {
  single,
  multiple,
}

class Booking {
  final String id;
  final String clientId;
  final String? proId;
  final String serviceType;
  final String description;
  final String budget;
  final String location;
  final DateTime requestedDate;
  final TimeOfDay requestedTime;
  final List<String> photos;
  final bool isUrgent;
  final String paymentMethod;
  final BookingType bookingType;
  BookingState state;
  final DateTime createdAt;
  DateTime? expiresAt;
  DateTime? acceptedAt;
  DateTime? clientApprovalAt;
  DateTime? completedAt;
  String? clientCode; // For Kazilive

  Booking({
    required this.id,
    required this.clientId,
    this.proId,
    required this.serviceType,
    required this.description,
    required this.budget,
    required this.location,
    required this.requestedDate,
    required this.requestedTime,
    required this.photos,
    required this.isUrgent,
    required this.paymentMethod,
    required this.bookingType,
    required this.state,
    required this.createdAt,
    this.expiresAt,
    this.acceptedAt,
    this.clientApprovalAt,
    this.completedAt,
    this.clientCode,
  });

  Booking copyWith({
    String? proId,
    BookingState? state,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    DateTime? clientApprovalAt,
    DateTime? completedAt,
    String? clientCode,
  }) {
    return Booking(
      id: id,
      clientId: clientId,
      proId: proId ?? this.proId,
      serviceType: serviceType,
      description: description,
      budget: budget,
      location: location,
      requestedDate: requestedDate,
      requestedTime: requestedTime,
      photos: photos,
      isUrgent: isUrgent,
      paymentMethod: paymentMethod,
      bookingType: bookingType,
      state: state ?? this.state,
      createdAt: createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      clientApprovalAt: clientApprovalAt ?? this.clientApprovalAt,
      completedAt: completedAt ?? this.completedAt,
      clientCode: clientCode ?? this.clientCode,
    );
  }
}

class BookingManager {
  static final BookingManager _instance = BookingManager._internal();
  factory BookingManager() => _instance;
  BookingManager._internal();

  final List<Booking> _bookings = [];
  final Map<String, Timer> _timers = {};
  
  List<Booking> get bookings => List.unmodifiable(_bookings);

  // Create new booking
  Booking createBooking({
    required String clientId,
    required String serviceType,
    required String description,
    required String budget,
    required String location,
    required DateTime date,
    required TimeOfDay time,
    required List<String> photos,
    required bool isUrgent,
    required String paymentMethod,
    required BookingType bookingType,
  }) {
    final booking = Booking(
      id: 'BK${DateTime.now().millisecondsSinceEpoch}',
      clientId: clientId,
      serviceType: serviceType,
      description: description,
      budget: budget,
      location: location,
      requestedDate: date,
      requestedTime: time,
      photos: photos,
      isUrgent: isUrgent,
      paymentMethod: paymentMethod,
      bookingType: bookingType,
      state: BookingState.created,
      createdAt: DateTime.now(),
    );

    _bookings.add(booking);
    
    // Start booking flow
    _startBookingFlow(booking);
    
    return booking;
  }

  // Start booking flow with timers
  void _startBookingFlow(Booking booking) {
    // Timer 1: Response Timer (24 hours)
    _startResponseTimer(booking);
    
    // Update state to broadcasted
    _updateBookingState(booking.id, BookingState.broadcasted);
  }

  // Timer 1: Response Timer (24 hours for pros to accept)
  void _startResponseTimer(Booking booking) {
    final expiresAt = DateTime.now().add(const Duration(hours: 24));
    
    _updateBooking(booking.id, (b) => b.copyWith(
      state: BookingState.pendingResponses,
      expiresAt: expiresAt,
    ));

    final timer = Timer(expiresAt.difference(DateTime.now()), () {
      _handleResponseTimerExpiry(booking.id);
    });

    _timers['response_${booking.id}'] = timer;
  }

  // Handle response timer expiry
  void _handleResponseTimerExpiry(String bookingId) {
    final booking = _bookings.firstWhere((b) => b.id == bookingId);
    
    if (booking.state == BookingState.pendingResponses) {
      _updateBookingState(bookingId, BookingState.expired);
      _cancelTimer('response_$bookingId');
    }
  }

  // Pro accepts booking
  void acceptBooking(String bookingId, String proId) {
    final booking = _bookings.firstWhere((b) => b.id == bookingId);
    
    if (booking.state != BookingState.pendingResponses) {
      return; // Can't accept if not in pending state
    }

    _cancelTimer('response_$bookingId');
    
    final acceptedAt = DateTime.now();
    final clientApprovalExpiresAt = acceptedAt.add(const Duration(hours: 48));
    
    _updateBooking(bookingId, (b) => b.copyWith(
      proId: proId,
      state: BookingState.acceptedByPro,
      acceptedAt: acceptedAt,
      expiresAt: clientApprovalExpiresAt,
    ));

    // Start client decision timer
    _startClientDecisionTimer(bookingId);
  }

  // Timer 2: Client Decision Timer (48 hours)
  void _startClientDecisionTimer(String bookingId) {
    final booking = _bookings.firstWhere((b) => b.id == bookingId);
    
    final timer = Timer(
      booking.expiresAt!.difference(DateTime.now()),
      () {
        _handleClientDecisionTimerExpiry(bookingId);
      },
    );

    _timers['client_decision_$bookingId'] = timer;
  }

  // Handle client decision timer expiry
  void _handleClientDecisionTimerExpiry(String bookingId) {
    _updateBookingState(bookingId, BookingState.expired);
    _cancelTimer('client_decision_$bookingId');
  }

  // Client approves booking
  void approveBooking(String bookingId) {
    final booking = _bookings.firstWhere((b) => b.id == bookingId);
    
    if (booking.state != BookingState.acceptedByPro) {
      return;
    }

    _cancelTimer('client_decision_$bookingId');
    
    // Generate client code for Kazilive
    final clientCode = 'CL${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    _updateBooking(bookingId, (b) => b.copyWith(
      state: BookingState.approved,
      clientApprovalAt: DateTime.now(),
      clientCode: clientCode,
    ));
  }

  // Start Kazilive session
  void startKaziliveSession(String bookingId) {
    final booking = _bookings.firstWhere((b) => b.id == bookingId);
    
    if (booking.state != BookingState.approved) {
      return;
    }

    _updateBookingState(bookingId, BookingState.active);
    
    // Timer 3: Session Timer (tracks duration)
    _startSessionTimer(bookingId);
  }

  // Timer 3: Session Timer
  void _startSessionTimer(String bookingId) {
    // This timer would track the session duration
    // For now, we'll just note that the session has started
    // In a real implementation, this would track time for billing
  }

  // Complete booking
  void completeBooking(String bookingId) {
    _updateBooking(bookingId, (b) => b.copyWith(
      state: BookingState.completed,
      completedAt: DateTime.now(),
    ));
    
    _cancelAllTimersForBooking(bookingId);
  }

  // Decline booking
  void declineBooking(String bookingId, String proId) {
    final booking = _bookings.firstWhere((b) => b.id == bookingId);
    
    if (booking.state != BookingState.pendingResponses) {
      return;
    }

    // For multiple booking, continue to next pros
    if (booking.bookingType == BookingType.multiple) {
      // Continue broadcasting to more pros
      return;
    }

    _updateBookingState(bookingId, BookingState.declined);
    _cancelTimer('response_$bookingId');
  }

  // Get bookings for client
  List<Booking> getClientBookings(String clientId) {
    return _bookings.where((b) => b.clientId == clientId).toList();
  }

  // Get bookings for pro
  List<Booking> getProBookings(String proId) {
    return _bookings.where((b) => b.proId == proId).toList();
  }

  // Get bookings by state
  List<Booking> getBookingsByState(BookingState state) {
    return _bookings.where((b) => b.state == state).toList();
  }

  // Get active bookings for client
  List<Booking> getActiveClientBookings(String clientId) {
    return _bookings.where((b) => 
      b.clientId == clientId && 
      [BookingState.pendingResponses, BookingState.acceptedByPro, BookingState.approved, BookingState.active]
      .contains(b.state)
    ).toList();
  }

  // Get active bookings for pro
  List<Booking> getActiveProBookings(String proId) {
    return _bookings.where((b) => 
      b.proId == proId && 
      [BookingState.acceptedByPro, BookingState.approved, BookingState.active]
      .contains(b.state)
    ).toList();
  }

  // Update booking state
  void _updateBookingState(String bookingId, BookingState newState) {
    _updateBooking(bookingId, (b) => b.copyWith(state: newState));
  }

  // Update booking
  void _updateBooking(String bookingId, Booking Function(Booking) updater) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = updater(_bookings[index]);
    }
  }

  // Cancel timer
  void _cancelTimer(String timerKey) {
    final timer = _timers[timerKey];
    if (timer != null) {
      timer.cancel();
      _timers.remove(timerKey);
    }
  }

  // Cancel all timers for a booking
  void _cancelAllTimersForBooking(String bookingId) {
    _cancelTimer('response_$bookingId');
    _cancelTimer('client_decision_$bookingId');
    _cancelTimer('session_$bookingId');
  }

  // Get booking time remaining
  Duration? getTimeRemaining(String bookingId) {
    final booking = _bookings.firstWhere((b) => b.id == bookingId);
    
    if (booking.expiresAt == null) return null;
    
    final remaining = booking.expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  // Check if booking is expiring soon (within 1 hour)
  bool isExpiringSoon(String bookingId) {
    final remaining = getTimeRemaining(bookingId);
    if (remaining == null) return false;
    
    return remaining.inHours <= 1 && remaining.inMinutes > 0;
  }

  // Cleanup
  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}
