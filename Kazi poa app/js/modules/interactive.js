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

    const userType = form.getAttribute('data-user-type') || 
                     (form.innerHTML.includes('Professional') ? 'professional' : 'client');

    const result = await this.app.auth.login(email, password, userType);

    this.app.ui.hideLoading();

    if (result.success) {
      this.app.ui.showSuccess(`Welcome, ${result.user.name}!`);
      setTimeout(() => {
        window.location.href = '../Pages/13.Dashboard.html';
      }, 1200);
    } else {
      this.app.ui.showError(result.error || 'Login failed');
    }
  }

  setupRegisterPage() {
    const form = document.querySelector('form');
    if (!form) return;

    form.addEventListener('submit', (e) => this.handleRegisterSubmit(e, form));
  }

  async handleRegisterSubmit(e, form) {
    e.preventDefault();

    const nameInput = form.querySelector('input[type="text"], input[placeholder*="name" i]');
    const emailInput = form.querySelector('input[type="email"]');
    const passwordInput = form.querySelector('input[type="password"]');
    const phoneInput = form.querySelector('input[type="tel"], input[placeholder*="phone" i]');

    if (!emailInput || !passwordInput) {
      this.app.ui.showError('Email and password are required');
      return;
    }

    const userData = {
      name: nameInput?.value.trim() || 'User',
      email: emailInput.value.trim(),
      password: passwordInput.value,
      phone: phoneInput?.value.trim() || '',
      userType: form.getAttribute('data-user-type') || 
                (form.innerHTML.includes('Professional') ? 'professional' : 'client'),
    };

    if (!userData.email || !userData.password) {
      this.app.ui.showError('Please fill in all required fields');
      return;
    }

    this.app.ui.showLoading('Creating account...');

    const result = await this.app.auth.register(userData);

    this.app.ui.hideLoading();

    if (result.success) {
      this.app.ui.showSuccess('Account created successfully!');
      setTimeout(() => {
        window.location.href = '../Pages/13.Dashboard.html';
      }, 1200);
    } else {
      this.app.ui.showError(result.error || 'Registration failed');
    }
  }

  setupDashboardPage() {
    const user = this.app.auth.getCurrentUser();
    
    if (!user) {
      this.app.ui.showWarning('Please log in first');
      setTimeout(() => {
        window.location.href = '../Pages/05.ClientID-login.html';
      }, 1500);
      return;
    }

    // Inject dashboard content
    setTimeout(() => {
      this.injectDashboardContent();
    }, 300);
  }

  injectDashboardContent() {
    const user = this.app.auth.getCurrentUser();
    const bookings = this.app.booking.getBookings().slice(0, 3);
    const stats = this.app.booking.getBookingStats();

    // Find containers to inject into
    const mainContent = document.querySelector('main') || 
                        document.querySelector('body > div') ||
                        document.body;

    // Try to find existing elements and update them
    const searchableElements = mainContent.querySelectorAll('*');
    
    let userGreeting = null;
    let statsContainer = null;
    let bookingsContainer = null;

    // Smart element detection
    for (const el of searchableElements) {
      const text = el.textContent.toLowerCase();
      const html = el.innerHTML.toLowerCase();
      
      // Looking for greeting area
      if (!userGreeting && (text.includes('welcome') || text.includes('hello'))) {
        userGreeting = el;
      }
      
      // Looking for stats area
      if (!statsContainer && (html.includes('total') || html.includes('booking') || text.includes('statistics'))) {
        if (el.children.length > 0) {
          statsContainer = el;
        }
      }
      
      // Looking for bookings list
      if (!bookingsContainer && (text.includes('recent') || text.includes('booking'))) {
        if (el.children.length > 0 && el.children.length < 10) {
          bookingsContainer = el;
        }
      }
    }

    // Update or inject content
    if (userGreeting) {
      userGreeting.innerHTML = `
        <div style="padding: 20px; background: linear-gradient(135deg, #0f00e7 0%, #7e22ce 100%); color: white; border-radius: 8px; margin-bottom: 20px;">
          <h2 style="margin: 0; font-size: 24px;">Welcome back, ${user.name}! ${user.avatar || '👋'}</h2>
          <p style="margin: 8px 0 0 0; opacity: 0.9;">Ready to book amazing services?</p>
        </div>
      `;
    }

    // Inject stats
    if (statsContainer) {
      statsContainer.innerHTML = `
        <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 20px;">
          <div style="padding: 16px; background: #f0f9ff; border-radius: 8px; text-align: center;">
            <div style="font-size: 24px; font-weight: bold; color: #0f00e7;">${stats.total}</div>
            <div style="font-size: 12px; color: #666; margin-top: 4px;">Total Bookings</div>
          </div>
          <div style="padding: 16px; background: #fef3c7; border-radius: 8px; text-align: center;">
            <div style="font-size: 24px; font-weight: bold; color: #f59e0b;">${stats.pending}</div>
            <div style="font-size: 12px; color: #666; margin-top: 4px;">Pending</div>
          </div>
          <div style="padding: 16px; background: #d1fae5; border-radius: 8px; text-align: center;">
            <div style="font-size: 24px; font-weight: bold; color: #10b981;">${stats.confirmed}</div>
            <div style="font-size: 12px; color: #666; margin-top: 4px;">Confirmed</div>
          </div>
          <div style="padding: 16px; background: #dbeafe; border-radius: 8px; text-align: center;">
            <div style="font-size: 24px; font-weight: bold; color: #3b82f6;">${stats.completed}</div>
            <div style="font-size: 12px; color: #666; margin-top: 4px;">Completed</div>
          </div>
        </div>
      `;
    }

    // Inject bookings
    if (bookingsContainer && bookings.length > 0) {
      bookingsContainer.innerHTML = `
        <div style="margin-top: 20px;">
          <h3 style="margin-bottom: 12px;">Recent Bookings</h3>
          ${bookings.map(booking => `
            <div style="padding: 12px; border: 1px solid #e2e8f0; border-radius: 6px; margin-bottom: 8px; background: #f8fafc;">
              <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                  <p style="margin: 0; font-weight: 600;">${booking.serviceType}</p>
                  <p style="margin: 4px 0 0 0; font-size: 12px; color: #666;">${booking.bookingDate} at ${booking.bookingTime}</p>
                </div>
                <span style="
                  padding: 4px 12px;
                  border-radius: 12px;
                  font-size: 11px;
                  font-weight: 600;
                  ${booking.status === 'confirmed' ? 'background: #d1fae5; color: #065f46;' :
                    booking.status === 'pending' ? 'background: #fef3c7; color: #92400e;' :
                    booking.status === 'completed' ? 'background: #dbeafe; color: #1e40af;' :
                    'background: #fee2e2; color: #991b1b;'}
                ">
                  ${booking.status.toUpperCase()}
                </span>
              </div>
            </div>
          `).join('')}
        </div>
      `;
    }
  }

  setupProfilePage() {
    const user = this.app.auth.getCurrentUser();
    
    if (!user) {
      this.app.ui.showWarning('Please log in first');
      setTimeout(() => {
        window.location.href = '../Pages/05.ClientID-login.html';
      }, 1500);
      return;
    }

    const form = document.querySelector('form');
    if (form) {
      // Pre-fill form
      const inputs = form.querySelectorAll('input, textarea');
      inputs.forEach((input, index) => {
        if (index === 0 && !input.value) input.value = user.name;
        if (input.type === 'email' && !input.value) input.value = user.email;
        if (input.placeholder?.includes('phone') && !input.value) input.value = user.phone || '';
      });

      form.addEventListener('submit', (e) => this.handleProfileUpdate(e, form));
    }
  }

  async handleProfileUpdate(e, form) {
    e.preventDefault();

    const inputs = form.querySelectorAll('input, textarea');
    const updates = {};

    inputs.forEach((input) => {
      if (input.name) {
        updates[input.name] = input.value;
      }
    });

    const result = this.app.profile.updateProfile(updates);

    if (result.success) {
      this.app.ui.showSuccess('Profile updated successfully!');
    } else {
      this.app.ui.showError(result.error || 'Failed to update profile');
    }
  }

  setupBookingPage() {
    const form = document.querySelector('form');
    if (form) {
      form.addEventListener('submit', (e) => this.handleBookingSubmit(e, form));
    }
  }

  async handleBookingSubmit(e, form) {
    e.preventDefault();

    const user = this.app.auth.getCurrentUser();
    if (!user) {
      this.app.ui.showError('Please log in first');
      return;
    }

    const serviceInput = form.querySelector('select, input[placeholder*="service" i]');
    const dateInput = form.querySelector('input[type="date"]');
    const timeInput = form.querySelector('input[type="time"]');
    const notesInput = form.querySelector('textarea, input[placeholder*="notes" i]');

    const bookingData = {
      serviceType: serviceInput?.value || 'General Service',
      bookingDate: dateInput?.value || new Date().toISOString().split('T')[0],
      bookingTime: timeInput?.value || '10:00',
      duration: 60,
      notes: notesInput?.value || '',
      clientId: user.id,
    };

    this.app.ui.showLoading('Creating booking...');

    const result = await this.app.booking.createBooking(bookingData);

    this.app.ui.hideLoading();

    if (result.success) {
      this.app.ui.showSuccess('Booking created successfully!');
      setTimeout(() => {
        window.location.href = '../Pages/06.Booking-success.html';
      }, 1200);
    } else {
      this.app.ui.showError(result.error || 'Failed to create booking');
    }
  }

  setupMyBookingsPage() {
    const user = this.app.auth.getCurrentUser();
    
    if (!user) {
      this.app.ui.showWarning('Please log in first');
      setTimeout(() => {
        window.location.href = '../Pages/05.ClientID-login.html';
      }, 1500);
      return;
    }

    setTimeout(() => {
      this.injectMyBookingsContent();
    }, 300);
  }

  injectMyBookingsContent() {
    const user = this.app.auth.getCurrentUser();
    const bookings = this.app.booking.getBookings();

    const container = document.querySelector('main') || 
                      document.querySelector('[data-bookings-list]') ||
                      document.body;

    let target = container.querySelector('[data-bookings-list]');
    if (!target) {
      // Look for a likely container
      const children = container.querySelectorAll('div');
      for (const child of children) {
        if (child.children.length > 2) {
          target = child;
          break;
        }
      }
    }
    if (!target) target = container;

    if (bookings.length === 0) {
      target.innerHTML = '<p style="text-align: center; padding: 40px; color: #999;">No bookings yet</p>';
    } else {
      target.innerHTML = bookings.map(booking => `
            <div style="padding: 16px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 12px; background: white; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
              <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 12px;">
                <div>
                  <h4 style="margin: 0 0 6px 0; font-size: 16px; color: #0f172a;">${booking.serviceType}</h4>
                  <p style="margin: 0; font-size: 13px; color: #475569;">Professional: <strong>${booking.professionalName || 'TBD'}</strong></p>
                  <p style="margin: 4px 0 0 0; font-size: 12px; color: #64748b;">ID: ${booking.id}</p>
                </div>
                <span style="
                  padding: 6px 14px;
                  border-radius: 20px;
                  font-size: 12px;
                  font-weight: 600;
                  white-space: nowrap;
                  ${booking.status === 'confirmed' ? 'background: #d1fae5; color: #065f46;' :
                    booking.status === 'pending' ? 'background: #fef3c7; color: #92400e;' :
                    booking.status === 'completed' ? 'background: #dbeafe; color: #1e40af;' :
                    'background: #fee2e2; color: #991b1b;'}
                ">
                  ${booking.status.charAt(0).toUpperCase() + booking.status.slice(1)}
                </span>
              </div>
              
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 12px; font-size: 13px;">
                <div>
                  <span style="color: #64748b;">📅 Date:</span>
                  <strong style="margin-left: 4px;">${booking.bookingDate}</strong>
                </div>
                <div>
                  <span style="color: #64748b;">🕐 Time:</span>
                  <strong style="margin-left: 4px;">${booking.bookingTime}</strong>
                </div>
                <div>
                  <span style="color: #64748b;">⏱️ Duration:</span>
                  <strong style="margin-left: 4px;">${booking.duration} mins</strong>
                </div>
                <div>
                  <span style="color: #64748b;">💰 Price:</span>
                  <strong style="margin-left: 4px;">TZS ${booking.price?.toLocaleString() || 'N/A'}</strong>
                </div>
              </div>

              ${booking.notes ? `
                <div style="padding: 8px; background: #f0f9ff; border-left: 3px solid #0f00e7; border-radius: 4px; margin-bottom: 12px; font-size: 12px;">
                  <strong>Notes:</strong> ${booking.notes}
                </div>
              ` : ''}

              <div style="display: flex; gap: 8px;">
                ${booking.status === 'pending' ? `
                  <button style="padding: 8px 16px; background: #ef4444; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600;" onclick="kazipoaApp.ui.showInfo('Cancel booking: ${booking.id}')">
                    Cancel
                  </button>
                ` : ''}
                ${booking.status === 'completed' && !booking.rating ? `
                  <button style="padding: 8px 16px; background: #f59e0b; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600;" onclick="kazipoaApp.ui.showInfo('Rate service: ${booking.id}')">
                    Rate Service
                  </button>
                ` : ''}
                <button style="padding: 8px 16px; background: #0f00e7; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600;" onclick="kazipoaApp.ui.showInfo('View booking: ${booking.id}')">
                  View Details
                </button>
              </div>
            </div>
          `).join('');
    }
  }

  setupHomePage() {
    // Add quick action buttons
    setTimeout(() => {
      const container = document.querySelector('main') || document.body;
      
      // Check if not logged in
      const user = this.app.auth.getCurrentUser();
      
      if (!user) {
        const callToAction = document.createElement('div');
        callToAction.style.cssText = `
          position: fixed;
          bottom: 20px;
          right: 20px;
          background: linear-gradient(135deg, #0f00e7 0%, #7e22ce 100%);
          color: white;
          padding: 16px 20px;
          border-radius: 8px;
          box-shadow: 0 10px 25px rgba(0,0,0,0.2);
          font-weight: 600;
          cursor: pointer;
          z-index: 999;
          animation: slideUp 0.3s ease-out;
        `;
        callToAction.innerHTML = `
          👉 <a href="../Pages/05.ClientID-login.html" style="color: white; text-decoration: none;">Get Started - Login</a>
        `;
        document.body.appendChild(callToAction);
      }
    }, 300);
  }

  setupGlobalButtonHandlers() {
    // Auto-link navigation
    document.addEventListener('click', (e) => {
      // Back button
      const backBtn = e.target.closest('[data-action="back"], .back-btn, button[aria-label="Back"]');
      if (backBtn) {
        window.history.back();
        return;
      }

      // Dashboard button
      if (e.target.closest('button')?.textContent.includes('Dashboard')) {
        window.location.href = '../Pages/13.Dashboard.html';
      }

      // Logout button
      if (e.target.closest('button')?.textContent.toLowerCase().includes('logout')) {
        if (confirm('Are you sure you want to log out?')) {
          this.app.logout();
          this.app.ui.showSuccess('Logged out!');
          setTimeout(() => {
            window.location.href = '../Pages/01.Index.html';
          }, 1000);
        }
      }

      // Profile button
      if (e.target.closest('button')?.textContent.includes('Profile')) {
        window.location.href = '../Pages/12.Profile-setup.html';
      }

      // Bookings button
      if (e.target.closest('button')?.textContent.includes('Booking') && 
          !e.target.closest('button')?.textContent.includes('My')) {
        window.location.href = '../Pages/07.Mybookings.html';
      }
    });
  }

  setupFormHandlers() {
    // Auto-validate forms
    document.addEventListener('input', (e) => {
      if (e.target.type === 'email') {
        const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(e.target.value);
        e.target.style.borderColor = isValid ? '#10b981' : e.target.value ? '#ef4444' : '';
      }
    });
  }

  displayPageContent() {
    // Show a subtle indicator that the app is active
    const indicator = document.createElement('div');
    indicator.setAttribute('data-app-ready', '');
    indicator.style.display = 'none';
    document.body.appendChild(indicator);
  }
}
