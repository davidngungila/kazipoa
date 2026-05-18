import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kazipoa/core/services/booking_service.dart';

class BookingState {
  final List<Map<String, dynamic>> bookings;
  final bool isLoading;
  final String? error;

  const BookingState({
    required this.bookings,
    required this.isLoading,
    this.error,
  });

  BookingState copyWith({
    List<Map<String, dynamic>>? bookings,
    bool? isLoading,
    String? error,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  List<Map<String, dynamic>> get pendingBookings {
    return bookings.where((booking) => booking['status'] == 'pending').toList();
  }
}

class BookingNotifier extends Notifier<BookingState> {
  @override
  BookingState build() {
    return const BookingState(
      bookings: [],
      isLoading: false,
      error: null,
    );
  }

  Future<void> loadBookings() async {
    state = const BookingState(bookings: [], isLoading: true, error: null);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = const BookingState(
          bookings: [],
          isLoading: false,
          error: 'User not authenticated',
        );
        return;
      }
      
      final bookingsSnapshot = await BookingService.getUserBookings(user.uid);
      final bookings = bookingsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      
      state = BookingState(
        bookings: bookings,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = BookingState(
        bookings: const [],
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    final currentState = state;
    state = currentState.copyWith(isLoading: true);
    
    try {
      await BookingService.createBooking(bookingData);
      
      // Reload bookings after creation
      await loadBookings();
    } catch (e) {
      state = currentState.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    final currentState = state;
    state = currentState.copyWith(isLoading: true);
    
    try {
      await BookingService.cancelBooking(bookingId, 'User cancelled');
      
      // Update local state
      final updatedBookings = currentState.bookings.map((booking) {
        if (booking['id'] == bookingId) {
          return Map<String, dynamic>.from(booking)
            ..['status'] = 'cancelled';
        }
        return booking;
      }).toList();
      
      state = currentState.copyWith(
        bookings: updatedBookings,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = currentState.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    final currentState = state;
    state = currentState.copyWith(isLoading: true);
    
    try {
      await BookingService.updateBookingStatus(bookingId, status);
      
      // Update local state
      final updatedBookings = currentState.bookings.map((booking) {
        if (booking['id'] == bookingId) {
          return Map<String, dynamic>.from(booking)
            ..['status'] = status;
        }
        return booking;
      }).toList();
      
      state = currentState.copyWith(
        bookings: updatedBookings,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = currentState.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider using Riverpod v3 syntax
final bookingProvider = NotifierProvider<BookingNotifier, BookingState>(BookingNotifier.new);

// Convenience getters
extension BookingProviderRef on WidgetRef {
  BookingNotifier get bookingNotifier => read(bookingProvider.notifier);
  BookingState get bookingState => watch(bookingProvider);
}
