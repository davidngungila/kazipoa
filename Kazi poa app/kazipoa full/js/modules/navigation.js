/**
 * Navigation Manager
 * Handles page routing and navigation
 */

export class NavigationManager {
  constructor() {
    this.currentPage = null;
    this.navigationHistory = [];
    this.routes = {};
  }

  async init() {
    this.setupRoutes();
    this.setupNavigationListeners();
    this.detectCurrentPage();
    
    console.log('🗺️ Navigation manager initialized');
  }

  setupRoutes() {
    // Map routes to HTML files
    this.routes = {
      '/': 'Pages/01.Index.html',
      '/login': 'Pages/05.ClientID-login.html',
      '/register': 'Pages/04.ClientID-registration.html',
      '/pro-login': 'Pages/08.Pro-account-login.html',
      '/pro-register': 'Pages/09.Pro-account-registration.html',
      '/dashboard': 'Pages/13.Dashboard.html',
      '/profile': 'Pages/12.Profile-setup.html',
      '/profile-settings': 'Pages/15.Profile-settings.html',
      '/booking-setup': 'Pages/03.Booking-setup.html',
      '/my-bookings': 'Pages/07.Mybookings.html',
      '/client-bookings': 'Pages/16.MyClient-Booking.html',
      '/pro-profile': 'Pages/02.Pro-account-profile.html',
      '/my-office': 'Pages/14.Myoffice.html',
      '/analytics': 'Pages/17.Analytics.html',
      '/email-verify': 'Pages/10.Email-verification.html',
      '/otp-verify': 'Pages/11.OTP-verification.html',
      '/booking-success': 'Pages/06.Booking-success.html',
    };
  }

  setupNavigationListeners() {
    // Handle back button clicks
    document.addEventListener('click', (e) => {
      const backBtn = e.target.closest('[data-action="back"]');
      if (backBtn) {
        this.goBack();
      }

      const navBtn = e.target.closest('[data-navigate]');
      if (navBtn) {
        const target = navBtn.dataset.navigate;
        this.redirectTo(target);
      }
    });

    // Handle browser back/forward
    window.addEventListener('popstate', () => {
      this.detectCurrentPage();
    });
  }

  detectCurrentPage() {
    const path = window.location.pathname;
    this.currentPage = path;
    console.log('📄 Current page:', path);
  }

  redirectTo(path) {
    if (this.navigationHistory[this.navigationHistory.length - 1] !== path) {
      this.navigationHistory.push(path);
    }

    const file = this.routes[path];
    if (file) {
      window.location.href = file;
    } else {
      console.warn('⚠️ Route not found:', path);
    }
  }

  goBack() {
    if (this.navigationHistory.length > 1) {
      this.navigationHistory.pop();
      const previousPath = this.navigationHistory[this.navigationHistory.length - 1];
      this.redirectTo(previousPath);
    }
  }

  getCurrentPage() {
    return this.currentPage;
  }

  getNavigationHistory() {
    return [...this.navigationHistory];
  }

  clearHistory() {
    this.navigationHistory = [this.currentPage];
  }
}
