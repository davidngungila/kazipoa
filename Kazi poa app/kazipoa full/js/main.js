/**
 * Kazipoa Full - Main Application Entry Point
 * Complete dynamic and interactive booking platform
 */

import { AuthManager } from './modules/auth.js';
import { BookingManager } from './modules/booking.js';
import { NavigationManager } from './modules/navigation.js';
import { ProfileManager } from './modules/profile.js';
import { ThemeManager } from './modules/theme.js';
import { UIManager } from './modules/ui.js';
import { InteractivePageManager } from './modules/interactive.js';

class KazipoaApp {
  constructor() {
    this.auth = new AuthManager();
    this.booking = new BookingManager();
    this.navigation = new NavigationManager();
    this.profile = new ProfileManager();
    this.theme = new ThemeManager();
    this.ui = new UIManager();
    this.interactive = new InteractivePageManager(this);
    this.initialized = false;
  }

  async init() {
    if (this.initialized) return;
    
    try {
      console.log('🚀 Initializing Kazipoa Full App...');
      
      // Initialize managers in order
      await this.theme.init();
      await this.ui.init();
      await this.auth.init();
      await this.profile.init();
      await this.booking.init();
      await this.navigation.init();
      await this.interactive.init();
      
      // Setup event listeners
      this.setupEventListeners();
      
      // Setup global error handling
      this.setupErrorHandling();
      
      this.initialized = true;
      console.log('✅ Kazipoa Full App initialized successfully');
      
      // Emit custom event
      window.dispatchEvent(new CustomEvent('app-initialized'));
    } catch (error) {
      console.error('❌ Failed to initialize app:', error);
      this.ui.showError('Failed to initialize application');
    }
  }

  setupEventListeners() {
    // Handle page visibility changes
    document.addEventListener('visibilitychange', () => {
      if (!document.hidden) {
        this.auth.validateSession();
      }
    });

    // Handle online/offline status
    window.addEventListener('online', () => {
      this.ui.showNotification('You are back online', 'success');
      this.syncData();
    });

    window.addEventListener('offline', () => {
      this.ui.showNotification('You are offline', 'warning');
    });
  }

  setupErrorHandling() {
    window.addEventListener('error', (event) => {
      console.error('Global error:', event.error);
    });

    window.addEventListener('unhandledrejection', (event) => {
      console.error('Unhandled promise rejection:', event.reason);
    });
  }

  async syncData() {
    // Sync any pending data when coming back online
    await this.booking.syncPendingBookings();
    console.log('📡 Data synced');
  }

  logout() {
    this.auth.logout();
    this.navigation.redirectTo('/');
  }
}

// Initialize app when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    window.kazipoaApp = new KazipoaApp();
    window.kazipoaApp.init();
  });
} else {
  window.kazipoaApp = new KazipoaApp();
  window.kazipoaApp.init();
}

// Make app accessible globally for debugging
window.kazipoaDebug = {
  showUser: () => kazipoaApp.auth.getCurrentUser(),
  showBookings: () => kazipoaApp.booking.getBookings(),
  showProfile: () => kazipoaApp.profile.getProfile(),
};

export default KazipoaApp;
