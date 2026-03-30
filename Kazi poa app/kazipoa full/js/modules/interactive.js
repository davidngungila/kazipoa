/**
 * Interactive Page Manager
 * Auto-binds buttons and forms to app functions without modifying HTML
 */

export class InteractivePageManager {
  constructor(app) {
    this.app = app;
    this.currentPageType = this.detectPageType();
  }

  async init() {
    // Wait a moment for app to fully initialize
    setTimeout(() => {
      this.setupPageInteractions();
      this.setupGlobalButtonHandlers();
      this.setupFormHandlers();
      this.displayPageContent();
    }, 500);
  }

  detectPageType() {
    const path = window.location.pathname.toLowerCase();
    
    if (path.includes('login')) return 'login';
    if (path.includes('registration') || path.includes('register')) return 'register';
    if (path.includes('dashboard')) return 'dashboard';
    if (path.includes('profile')) return 'profile';
    if (path.includes('booking')) return 'booking';
    if (path.includes('mybookings') || path.includes('myc')) return 'myBookings';
    if (path.includes('index') || path === '/') return 'home';
    
    return 'unknown';
  }

  setupPageInteractions() {
    switch (this.currentPageType) {
      case 'login':
        this.setupLoginPage();
        break;
      case 'register':
        this.setupRegisterPage();
        break;
      case 'dashboard':
        this.setupDashboardPage();
        break;
      case 'profile':
        this.setupProfilePage();
        break;
      case 'booking':
        this.setupBookingPage();
        break;
      case 'myBookings':
        this.setupMyBookingsPage();
        break;
      case 'home':
        this.setupHomePage();
        break;
    }
  }

  setupLoginPage() {
    const form = document.querySelector('form');
    if (!form) return;

    // Find or add a helpful message
    const existingMessage = document.querySelector('[data-demo-hint]');
    if (!existingMessage) {
      const hint = document.createElement('p');
      hint.setAttribute('data-demo-hint', '');
      hint.style.cssText = 'font-size: 12px; color: #666; margin-top: 8px; padding: 8px; background: #f0f0f0; border-radius: 4px; display: none;';
      hint.innerHTML = '💡 <strong>Demo:</strong> Email: client@kazipoa.tz | Password: Demo@2026 | Or use any email/password';
      form.appendChild(hint);
      
      // Show hint when form is focused
      form.addEventListener('focus', () => {
        hint.style.display = 'block';
      }, true);
    }

    form.addEventListener('submit', (e) => this.handleLoginSubmit(e, form));
  }

  async handleLoginSubmit(e, form) {
    e.preventDefault();
    
    const emailInput = form.querySelector('input[type="email"]');
    const passwordInput = form.querySelector('input[type="password"]');
    
    if (!emailInput || !passwordInput) return;

    const email = emailInput.value.trim();
    const password = passwordInput.value;

    if (!email || !password) {
      this.app.ui.showError('Please enter email and password');
      return;
    }

    this.app.ui.showLoading('Logging in...');
    
    const userType = window.location.pathname.includes('pro') ? 'professional' : 'client';
    const result = await this.app.auth.login(email, password, userType);
    
    this.app.ui.hideLoading();

    if (result.success) {
      this.app.ui.showSuccess('Login successful!');
      setTimeout(() => {
        window.location.href = 'Pages/13.Dashboard.html';
      }, 1500);
    } else {
      this.app.ui.showError(result.error);
    }
  }

  setupRegisterPage() {
    const form = document.querySelector('form');
    if (!form) return;

    form.addEventListener('submit', (e) => this.handleRegisterSubmit(e, form));
  }

  async handleRegisterSubmit(e, form) {
    e.preventDefault();
    
    const formData = new FormData(form);
    const userData = Object.fromEntries(formData);
    
    // Determine user type from page
    userData.userType = window.location.pathname.includes('pro') ? 'professional' : 'client';

    if (!userData.email || !userData.password || !userData.name) {
      this.app.ui.showError('Please fill all required fields');
      return;
    }

    this.app.ui.showLoading('Creating account...');
    
    const result = await this.app.auth.register(userData);
    
    this.app.ui.hideLoading();

    if (result.success) {
      this.app.ui.showSuccess('Account created successfully!');
      setTimeout(() => {
        window.location.href = 'Pages/13.Dashboard.html';
      }, 1500);
    } else {
      this.app.ui.showError(result.error);
    }
  }

  setupDashboardPage() {
    this.injectDashboardContent();
    this.setupDashboardActions();
  }

  injectDashboardContent() {
    const user = this.app.auth.getCurrentUser();
    if (!user) return;

    // Find main content area
    const mainContent = document.querySelector('main, .main-content, .container');
    if (!mainContent) return;

    // Create dashboard content
    const dashboardHTML = `
      <div class="dashboard-content mb-8">
        <div class="welcome-section bg-gradient-to-r from-primary to-secondary text-white p-6 rounded-lg mb-6">
          <h1 class="text-2xl font-bold mb-2">Welcome back, ${user.name}! 👋</h1>
          <p class="opacity-90">Manage your bookings and profile from here</p>
        </div>
        
        <div class="stats-grid grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
          <div class="stat-card bg-white dark:bg-slate-800 p-4 rounded-lg shadow">
            <div class="text-3xl mb-2">📅</div>
            <h3 class="font-semibold text-lg">Total Bookings</h3>
            <p class="text-2xl font-bold text-primary">${this.app.booking.getBookingStats().total}</p>
          </div>
          <div class="stat-card bg-white dark:bg-slate-800 p-4 rounded-lg shadow">
            <div class="text-3xl mb-2">⏳</div>
            <h3 class="font-semibold text-lg">Pending</h3>
            <p class="text-2xl font-bold text-warning">${this.app.booking.getBookingStats().pending}</p>
          </div>
          <div class="stat-card bg-white dark:bg-slate-800 p-4 rounded-lg shadow">
            <div class="text-3xl mb-2">✅</div>
            <h3 class="font-semibold text-lg">Completed</h3>
            <p class="text-2xl font-bold text-success">${this.app.booking.getBookingStats().completed}</p>
          </div>
        </div>
        
        <div class="quick-actions grid grid-cols-1 md:grid-cols-2 gap-4">
          <button class="action-btn bg-primary text-white p-4 rounded-lg hover:bg-primary/90 transition-colors" data-action="create-booking">
            <div class="text-xl mb-2">➕</div>
            <h3 class="font-semibold">Create Booking</h3>
            <p class="text-sm opacity-90">Book a new service</p>
          </button>
          <button class="action-btn bg-secondary text-white p-4 rounded-lg hover:bg-secondary/90 transition-colors" data-action="view-bookings">
            <div class="text-xl mb-2">📋</div>
            <h3 class="font-semibold">My Bookings</h3>
            <p class="text-sm opacity-90">View all bookings</p>
          </button>
        </div>
      </div>
    `;

    // Insert content
    mainContent.insertAdjacentHTML('afterbegin', dashboardHTML);
  }

  setupDashboardActions() {
    document.querySelector('[data-action="create-booking"]')?.addEventListener('click', () => {
      window.location.href = 'Pages/03.Booking-setup.html';
    });

    document.querySelector('[data-action="view-bookings"]')?.addEventListener('click', () => {
      window.location.href = 'Pages/07.Mybookings.html';
    });
  }

  setupProfilePage() {
    this.injectProfileContent();
    this.setupProfileActions();
  }

  injectProfileContent() {
    const user = this.app.auth.getCurrentUser();
    const profile = this.app.profile.getProfile();
    
    if (!user) return;

    const mainContent = document.querySelector('main, .main-content, .container');
    if (!mainContent) return;

    const profileHTML = `
      <div class="profile-content">
        <div class="profile-header bg-white dark:bg-slate-800 p-6 rounded-lg shadow mb-6">
          <div class="flex items-center gap-4">
            <div class="avatar text-4xl">${user.avatar || '👤'}</div>
            <div>
              <h1 class="text-2xl font-bold">${user.name}</h1>
              <p class="text-slate-600 dark:text-slate-400">${user.email}</p>
              <span class="badge badge-primary">${user.userType}</span>
            </div>
          </div>
        </div>
        
        <div class="profile-form bg-white dark:bg-slate-800 p-6 rounded-lg shadow">
          <h2 class="text-xl font-bold mb-4">Edit Profile</h2>
          <form id="profile-form">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
              <div>
                <label class="block text-sm font-medium mb-2">Name</label>
                <input type="text" name="name" value="${profile.name || user.name}" class="w-full p-2 border rounded" required>
              </div>
              <div>
                <label class="block text-sm font-medium mb-2">Phone</label>
                <input type="tel" name="phone" value="${profile.phone || user.phone || ''}" class="w-full p-2 border rounded">
              </div>
            </div>
            <div class="mb-4">
              <label class="block text-sm font-medium mb-2">Bio</label>
              <textarea name="bio" rows="3" class="w-full p-2 border rounded">${profile.bio || ''}</textarea>
            </div>
            <button type="submit" class="bg-primary text-white px-4 py-2 rounded hover:bg-primary/90">
              Save Profile
            </button>
          </form>
        </div>
      </div>
    `;

    mainContent.insertAdjacentHTML('afterbegin', profileHTML);

    // Add form handler
    document.getElementById('profile-form').addEventListener('submit', (e) => this.handleProfileUpdate(e));
  }

  async handleProfileUpdate(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const updates = Object.fromEntries(formData);
    
    this.app.ui.showLoading('Updating profile...');
    
    const result = this.app.profile.updateProfile(updates);
    
    this.app.ui.hideLoading();

    if (result.success) {
      this.app.ui.showSuccess('Profile updated successfully!');
    } else {
      this.app.ui.showError(result.error);
    }
  }

  setupBookingPage() {
    this.injectBookingContent();
    this.setupBookingActions();
  }

  injectBookingContent() {
    const mainContent = document.querySelector('main, .main-content, .container');
    if (!mainContent) return;

    const bookingHTML = `
      <div class="booking-content">
        <div class="booking-form bg-white dark:bg-slate-800 p-6 rounded-lg shadow">
          <h1 class="text-2xl font-bold mb-6">Create New Booking</h1>
          <form id="booking-form">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
              <div>
                <label class="block text-sm font-medium mb-2">Service Type</label>
                <select name="serviceType" class="w-full p-2 border rounded" required>
                  <option value="">Select a service</option>
                  <option value="Hair Styling">Hair Styling</option>
                  <option value="Home Cleaning">Home Cleaning</option>
                  <option value="Plumbing">Plumbing</option>
                  <option value="Electrical">Electrical</option>
                  <option value="Carpentry">Carpentry</option>
                  <option value="Gardening">Gardening</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium mb-2">Date</label>
                <input type="date" name="bookingDate" class="w-full p-2 border rounded" required>
              </div>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
              <div>
                <label class="block text-sm font-medium mb-2">Time</label>
                <input type="time" name="bookingTime" class="w-full p-2 border rounded" required>
              </div>
              <div>
                <label class="block text-sm font-medium mb-2">Duration (minutes)</label>
                <input type="number" name="duration" min="30" step="30" value="60" class="w-full p-2 border rounded" required>
              </div>
            </div>
            <div class="mb-4">
              <label class="block text-sm font-medium mb-2">Notes</label>
              <textarea name="notes" rows="3" class="w-full p-2 border rounded" placeholder="Any special requirements..."></textarea>
            </div>
            <button type="submit" class="bg-primary text-white px-6 py-2 rounded hover:bg-primary/90">
              Create Booking
            </button>
          </form>
        </div>
      </div>
    `;

    mainContent.insertAdjacentHTML('afterbegin', bookingHTML);

    // Add form handler
    document.getElementById('booking-form').addEventListener('submit', (e) => this.handleBookingSubmit(e));
  }

  async handleBookingSubmit(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const bookingData = Object.fromEntries(formData);
    
    // Add user info
    const user = this.app.auth.getCurrentUser();
    bookingData.clientId = user.id;
    bookingData.clientName = user.name;
    
    // Set default professional (in real app, this would be selected)
    bookingData.professionalId = 'USR_pro001';
    bookingData.professionalName = 'Maria Baraza';
    
    // Calculate price based on duration and service type
    const basePrice = 1000; // Base price per minute
    bookingData.price = bookingData.duration * basePrice;

    this.app.ui.showLoading('Creating booking...');
    
    const result = await this.app.booking.createBooking(bookingData);
    
    this.app.ui.hideLoading();

    if (result.success) {
      this.app.ui.showSuccess('Booking created successfully!');
      if (result.offline) {
        this.app.ui.showInfo('Booking will sync when you\'re back online');
      }
      setTimeout(() => {
        window.location.href = 'Pages/06.Booking-success.html';
      }, 1500);
    } else {
      this.app.ui.showError(result.error);
    }
  }

  setupMyBookingsPage() {
    this.injectBookingsContent();
  }

  injectBookingsContent() {
    const mainContent = document.querySelector('main, .main-content, .container');
    if (!mainContent) return;

    const bookings = this.app.booking.getBookings();
    
    const bookingsHTML = `
      <div class="bookings-content">
        <h1 class="text-2xl font-bold mb-6">My Bookings</h1>
        <div class="bookings-list space-y-4">
          ${bookings.map(booking => this.createBookingCard(booking)).join('')}
        </div>
      </div>
    `;

    mainContent.insertAdjacentHTML('afterbegin', bookingsHTML);

    // Add action handlers
    this.setupBookingActions();
  }

  createBookingCard(booking) {
    const statusColors = {
      pending: 'bg-yellow-100 text-yellow-800',
      confirmed: 'bg-blue-100 text-blue-800',
      completed: 'bg-green-100 text-green-800',
      cancelled: 'bg-red-100 text-red-800'
    };

    return `
      <div class="booking-card bg-white dark:bg-slate-800 p-4 rounded-lg shadow" data-booking-id="${booking.id}">
        <div class="flex justify-between items-start mb-2">
          <div>
            <h3 class="font-semibold text-lg">${booking.serviceType}</h3>
            <p class="text-slate-600 dark:text-slate-400">with ${booking.professionalName}</p>
          </div>
          <span class="badge ${statusColors[booking.status]}">${booking.status}</span>
        </div>
        <div class="grid grid-cols-2 gap-2 text-sm text-slate-600 dark:text-slate-400 mb-3">
          <div>📅 ${booking.bookingDate}</div>
          <div>⏰ ${booking.bookingTime}</div>
          <div>⏱️ ${booking.duration} minutes</div>
          <div>💰 TZS ${booking.price.toLocaleString()}</div>
        </div>
        ${booking.notes ? `<p class="text-sm text-slate-600 dark:text-slate-400 mb-3">${booking.notes}</p>` : ''}
        <div class="flex gap-2">
          ${booking.status === 'pending' || booking.status === 'confirmed' ? 
            `<button class="bg-red-500 text-white px-3 py-1 rounded text-sm hover:bg-red-600" data-action="cancel" data-booking-id="${booking.id}">Cancel</button>` : ''}
          ${booking.status === 'completed' ? 
            `<button class="bg-primary text-white px-3 py-1 rounded text-sm hover:bg-primary/90" data-action="review" data-booking-id="${booking.id}">Leave Review</button>` : ''}
        </div>
      </div>
    `;
  }

  setupBookingActions() {
    document.querySelectorAll('[data-action="cancel"]').forEach(btn => {
      btn.addEventListener('click', (e) => {
        const bookingId = e.target.dataset.bookingId;
        this.handleCancelBooking(bookingId);
      });
    });

    document.querySelectorAll('[data-action="review"]').forEach(btn => {
      btn.addEventListener('click', (e) => {
        const bookingId = e.target.dataset.bookingId;
        this.app.ui.showInfo('Review feature coming soon!');
      });
    });
  }

  async handleCancelBooking(bookingId) {
    if (!confirm('Are you sure you want to cancel this booking?')) return;

    this.app.ui.showLoading('Cancelling booking...');
    
    const result = await this.app.booking.cancelBooking(bookingId);
    
    this.app.ui.hideLoading();

    if (result.success) {
      this.app.ui.showSuccess('Booking cancelled successfully');
      // Refresh the bookings list
      setTimeout(() => {
        window.location.reload();
      }, 1000);
    } else {
      this.app.ui.showError(result.error);
    }
  }

  setupHomePage() {
    this.injectHomeContent();
  }

  injectHomeContent() {
    const mainContent = document.querySelector('main, .main-content, .container');
    if (!mainContent) return;

    const homeHTML = `
      <div class="home-content">
        <div class="hero-section bg-gradient-to-r from-primary to-secondary text-white p-8 rounded-lg mb-8">
          <h1 class="text-4xl font-bold mb-4">Welcome to Kazipoa</h1>
          <p class="text-xl mb-6">Your trusted platform for professional services in Tanzania</p>
          <div class="flex gap-4">
            <button class="bg-white text-primary px-6 py-3 rounded-lg font-semibold hover:bg-gray-100" data-action="get-started">
              Get Started
            </button>
            <button class="border-2 border-white text-white px-6 py-3 rounded-lg font-semibold hover:bg-white hover:text-primary" data-action="learn-more">
              Learn More
            </button>
          </div>
        </div>
        
        <div class="features-section mb-8">
          <h2 class="text-2xl font-bold text-center mb-6">Why Choose Kazipoa?</h2>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="feature-card text-center p-6 bg-white dark:bg-slate-800 rounded-lg shadow">
              <div class="text-4xl mb-4">🔍</div>
              <h3 class="text-xl font-semibold mb-2">Find Professionals</h3>
              <p class="text-slate-600 dark:text-slate-400">Connect with verified professionals in your area</p>
            </div>
            <div class="feature-card text-center p-6 bg-white dark:bg-slate-800 rounded-lg shadow">
              <div class="text-4xl mb-4">📅</div>
              <h3 class="text-xl font-semibold mb-2">Easy Booking</h3>
              <p class="text-slate-600 dark:text-slate-400">Book services with just a few clicks</p>
            </div>
            <div class="feature-card text-center p-6 bg-white dark:bg-slate-800 rounded-lg shadow">
              <div class="text-4xl mb-4">⭐</div>
              <h3 class="text-xl font-semibold mb-2">Trusted Reviews</h3>
              <p class="text-slate-600 dark:text-slate-400">Read and write reviews to build trust</p>
            </div>
          </div>
        </div>
      </div>
    `;

    mainContent.insertAdjacentHTML('afterbegin', homeHTML);

    // Add action handlers
    document.querySelector('[data-action="get-started"]')?.addEventListener('click', () => {
      window.location.href = 'Pages/04.ClientID-registration.html';
    });

    document.querySelector('[data-action="learn-more"]')?.addEventListener('click', () => {
      this.app.ui.showInfo('Learn more about Kazipoa - your trusted service platform!');
    });
  }

  setupGlobalButtonHandlers() {
    // Theme toggle
    document.addEventListener('click', (e) => {
      if (e.target.closest('[data-action="toggle-theme"]')) {
        this.app.theme.toggleTheme();
      }
    });

    // Logout
    document.addEventListener('click', (e) => {
      if (e.target.closest('[data-action="logout"]')) {
        if (confirm('Are you sure you want to logout?')) {
          this.app.logout();
        }
      }
    });
  }

  setupFormHandlers() {
    // Generic form handling is done in individual page setups
  }

  displayPageContent() {
    console.log(`📄 Page type detected: ${this.currentPageType}`);
    console.log('✅ Interactive page manager ready');
  }
}
