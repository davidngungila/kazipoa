/**
 * Booking Manager
 * Handles booking creation, management, and tracking
 */

import { StorageManager } from '../utils/storage.js';
import { DateUtil } from '../utils/date.js';

export class BookingManager {
  constructor() {
    this.bookings = [];
    this.pendingBookings = [];
  }

  async init() {
    // Load bookings from storage or use demo data
    const stored = StorageManager.get('bookings');
    
    if (stored && stored.length > 0) {
      this.bookings = stored;
    } else {
      // Initialize with demo bookings
      this.bookings = this.getDemoBookings();
      StorageManager.set('bookings', this.bookings);
    }
    
    this.pendingBookings = StorageManager.get('pendingBookings') || [];
    
    console.log(`📅 Loaded ${this.bookings.length} bookings`);
  }

  getDemoBookings() {
    const today = new Date();
    return [
      {
        id: 'BKG_001',
        serviceType: 'Hair Styling',
        professionalId: 'USR_pro001',
        professionalName: 'Maria Baraza',
        clientId: 'USR_client001',
        bookingDate: new Date(today.getTime() + 2 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
        bookingTime: '14:00',
        duration: 60,
        status: 'confirmed',
        price: 50000,
        notes: 'Full makeover with braids',
        rating: null,
        createdAt: new Date(today.getTime() - 5 * 24 * 60 * 60 * 1000).toISOString(),
      },
      {
        id: 'BKG_002',
        serviceType: 'Home Cleaning',
        professionalId: 'USR_pro002',
        professionalName: 'James Kipchoge',
        clientId: 'USR_client001',
        bookingDate: today.toISOString().split('T')[0],
        bookingTime: '09:00',
        duration: 120,
        status: 'completed',
        price: 80000,
        notes: 'Full house cleaning',
        rating: 5,
        createdAt: new Date(today.getTime() - 10 * 24 * 60 * 60 * 1000).toISOString(),
      },
      {
        id: 'BKG_003',
        serviceType: 'Plumbing',
        professionalId: 'USR_pro003',
        professionalName: 'Peter Nyambati',
        clientId: 'USR_client001',
        bookingDate: new Date(today.getTime() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
        bookingTime: '10:30',
        duration: 180,
        status: 'pending',
        price: 150000,
        notes: 'Fix kitchen sink and install new shower',
        rating: null,
        createdAt: new Date().toISOString(),
      },
    ];
  }

  async createBooking(bookingData) {
    try {
      const booking = {
        id: 'BKG_' + Math.random().toString(36).substr(2, 9),
        ...bookingData,
        status: 'pending',
        createdAt: new Date().toISOString(),
      };

      // Check if online
      if (!navigator.onLine) {
        this.pendingBookings.push(booking);
        StorageManager.set('pendingBookings', this.pendingBookings);
        return { success: true, booking, offline: true };
      }

      // Simulate API call
      await this.simulateBookingCreation(booking);
      
      this.bookings.push(booking);
      StorageManager.set('bookings', this.bookings);
      
      console.log('✅ Booking created:', booking.id);
      return { success: true, booking };
    } catch (error) {
      console.error('❌ Failed to create booking:', error.message);
      return { success: false, error: error.message };
    }
  }

  async updateBooking(bookingId, updates) {
    try {
      const index = this.bookings.findIndex(b => b.id === bookingId);
      
      if (index === -1) {
        throw new Error('Booking not found');
      }

      this.bookings[index] = { ...this.bookings[index], ...updates };
      StorageManager.set('bookings', this.bookings);
      
      console.log('✅ Booking updated:', bookingId);
      return { success: true, booking: this.bookings[index] };
    } catch (error) {
      console.error('❌ Failed to update booking:', error.message);
      return { success: false, error: error.message };
    }
  }

  async cancelBooking(bookingId) {
    try {
      const booking = this.bookings.find(b => b.id === bookingId);
      
      if (!booking) {
        throw new Error('Booking not found');
      }

      booking.status = 'cancelled';
      booking.cancelledAt = new Date().toISOString();
      
      StorageManager.set('bookings', this.bookings);
      
      console.log('✅ Booking cancelled:', bookingId);
      return { success: true, booking };
    } catch (error) {
      console.error('❌ Failed to cancel booking:', error.message);
      return { success: false, error: error.message };
    }
  }

  getBookings(filter = {}) {
    let filtered = [...this.bookings];

    if (filter.status) {
      filtered = filtered.filter(b => b.status === filter.status);
    }

    if (filter.dateFrom) {
      const from = new Date(filter.dateFrom).getTime();
      filtered = filtered.filter(b => new Date(b.bookingDate).getTime() >= from);
    }

    if (filter.dateTo) {
      const to = new Date(filter.dateTo).getTime();
      filtered = filtered.filter(b => new Date(b.bookingDate).getTime() <= to);
    }

    if (filter.professional) {
      filtered = filtered.filter(b => b.professionalId === filter.professional);
    }

    return filtered.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
  }

  getBooking(bookingId) {
    return this.bookings.find(b => b.id === bookingId);
  }

  async syncPendingBookings() {
    if (this.pendingBookings.length === 0) return;

    try {
      for (const booking of this.pendingBookings) {
        await this.simulateBookingCreation(booking);
        this.bookings.push(booking);
      }

      this.pendingBookings = [];
      StorageManager.set('bookings', this.bookings);
      StorageManager.set('pendingBookings', []);
      
      console.log('✅ Pending bookings synced');
    } catch (error) {
      console.error('❌ Failed to sync pending bookings:', error.message);
    }
  }

  getBookingStats() {
    return {
      total: this.bookings.length,
      pending: this.bookings.filter(b => b.status === 'pending').length,
      confirmed: this.bookings.filter(b => b.status === 'confirmed').length,
      completed: this.bookings.filter(b => b.status === 'completed').length,
      cancelled: this.bookings.filter(b => b.status === 'cancelled').length,
    };
  }

  async simulateBookingCreation(booking) {
    return new Promise((resolve) => {
      setTimeout(() => {
        booking.status = 'confirmed';
        resolve(booking);
      }, 600);
    });
  }
}
