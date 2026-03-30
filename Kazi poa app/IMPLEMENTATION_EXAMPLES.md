# 📝 Implementation Examples

Quick copy-paste examples for specific page functionality.

## 🔐 Login Page Example

Add this before the closing `</body>` tag:

```html
<script type="module">
  // Wait for app to be ready
  window.addEventListener('app-initialized', () => {
    const loginForm = document.querySelector('form[data-form-handler="login"]') || 
                      document.querySelector('form');
    
    if (loginForm) {
      loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const email = loginForm.email?.value || loginForm.querySelector('input[type="email"]')?.value;
        const password = loginForm.password?.value || loginForm.querySelector('input[type="password"]')?.value;
        
        if (!email || !password) {
          kazipoaApp.ui.showError('Please fill in all fields');
          return;
        }
        
        kazipoaApp.ui.showLoading('Logging in...');
        
        const result = await kazipoaApp.auth.login(email, password, 'client');
        
        kazipoaApp.ui.hideLoading();
        
        if (result.success) {
          kazipoaApp.ui.showSuccess('Welcome back!');
          setTimeout(() => {
            window.location.href = '../Pages/13.Dashboard.html';
          }, 1200);
        } else {
          kazipoaApp.ui.showError(result.error || 'Login failed');
        }
      });
    }
  });
</script>

<script type="module" src="../js/main.js"></script>
```

## 📝 Registration Page Example

```html
<script type="module">
  window.addEventListener('app-initialized', () => {
    const registerForm = document.querySelector('form');
    
    if (registerForm) {
      registerForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const userData = {
          name: registerForm.name?.value || registerForm.querySelector('input[placeholder*="name" i]')?.value,
          email: registerForm.email?.value || registerForm.querySelector('input[type="email"]')?.value,
          password: registerForm.password?.value || registerForm.querySelector('input[type="password"]')?.value,
          phone: registerForm.phone?.value || registerForm.querySelector('input[placeholder*="phone" i]')?.value,
          userType: 'client'
        };
        
        if (!userData.name || !userData.email || !userData.password) {
          kazipoaApp.ui.showError('Please fill in all required fields');
          return;
        }
        
        kazipoaApp.ui.showLoading('Creating account...');
        
        const result = await kazipoaApp.auth.register(userData);
        
        kazipoaApp.ui.hideLoading();
        
        if (result.success) {
          kazipoaApp.ui.showSuccess('Account created successfully!');
          setTimeout(() => {
            window.location.href = '../Pages/13.Dashboard.html';
          }, 1200);
        } else {
          kazipoaApp.ui.showError(result.error || 'Registration failed');
        }
      });
    }
  });
</script>

<script type="module" src="../js/main.js"></script>
```

## 📅 Booking Creation Page Example

```html
<script type="module">
  window.addEventListener('app-initialized', () => {
    const bookingForm = document.querySelector('form');
    
    if (bookingForm) {
      bookingForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const bookingData = {
          serviceType: bookingForm.service?.value || bookingForm.querySelector('select')?.value,
          bookingDate: bookingForm.date?.value || bookingForm.querySelector('input[type="date"]')?.value,
          bookingTime: bookingForm.time?.value || bookingForm.querySelector('input[type="time"]')?.value,
          duration: parseInt(bookingForm.duration?.value || 30),
          notes: bookingForm.notes?.value || bookingForm.querySelector('textarea')?.value || '',
          clientId: kazipoaApp.auth.getCurrentUser()?.id,
        };
        
        if (!bookingData.serviceType || !bookingData.bookingDate || !bookingData.bookingTime) {
          kazipoaApp.ui.showError('Please fill in all required fields');
          return;
        }
        
        kazipoaApp.ui.showLoading('Creating booking...');
        
        const result = await kazipoaApp.booking.createBooking(bookingData);
        
        kazipoaApp.ui.hideLoading();
        
        if (result.success) {
          const message = result.offline ? 'Booking saved (offline)' : 'Booking created successfully!';
          kazipoaApp.ui.showSuccess(message);
          setTimeout(() => {
            window.location.href = '../Pages/06.Booking-success.html';
          }, 1500);
        } else {
          kazipoaApp.ui.showError(result.error || 'Failed to create booking');
        }
      });
    }
  });
</script>

<script type="module" src="../js/main.js"></script>
```

## 📱 Dashboard Example

```html
<script type="module">
  window.addEventListener('app-initialized', () => {
    const user = kazipoaApp.auth.getCurrentUser();
    
    if (!user) {
      // Redirect to login if not authenticated
      window.location.href = '../Pages/05.ClientID-login.html';
      return;
    }
    
    // Display user name
    const nameElement = document.querySelector('[data-user-name]') || 
                        document.querySelector('h1');
    if (nameElement) {
      nameElement.textContent = `Welcome, ${user.name}!`;
    }
    
    // Display booking stats
    const stats = kazipoaApp.booking.getBookingStats();
    
    const statsElements = {
      total: document.querySelector('[data-stat-total']'),
      pending: document.querySelector('[data-stat-pending"]'),
      confirmed: document.querySelector('[data-stat-confirmed"]'),
      completed: document.querySelector('[data-stat-completed"]'),
    };
    
    Object.entries(stats).forEach(([key, value]) => {
      if (statsElements[key]) {
        statsElements[key].textContent = value;
      }
    });
    
    // Load recent bookings
    const bookings = kazipoaApp.booking.getBookings({ status: 'confirmed' }).slice(0, 5);
    
    // Display bookings in a list
    const bookingsList = document.querySelector('[data-bookings-list]');
    if (bookingsList) {
      bookingsList.innerHTML = bookings.map(booking => `
        <div class="p-4 border rounded-lg mb-3">
          <p class="font-semibold">${booking.serviceType}</p>
          <p class="text-sm text-gray-600">${booking.bookingDate} at ${booking.bookingTime}</p>
          <span class="inline-block mt-2 px-2 py-1 bg-green-100 text-green-800 rounded text-xs">
            ${booking.status}
          </span>
        </div>
      `).join('');
    }
  });
</script>

<script type="module" src="../js/main.js"></script>
```

## 👤 Profile Settings Example

```html
<script type="module">
  window.addEventListener('app-initialized', () => {
    const user = kazipoaApp.auth.getCurrentUser();
    const profile = kazipoaApp.profile.getProfile();
    
    if (!user) {
      window.location.href = '../Pages/05.ClientID-login.html';
      return;
    }
    
    // Load profile form
    const profileForm = document.querySelector('form');
    
    if (profileForm) {
      // Pre-fill form with current data
      profileForm.name.value = user.name || '';
      profileForm.email.value = user.email || '';
      profileForm.phone.value = user.phone || '';
      
      // Handle profile picture upload
      const profilePicInput = document.querySelector('input[type="file"]');
      if (profilePicInput) {
        profilePicInput.addEventListener('change', (e) => {
          const file = e.target.files[0];
          if (file) {
            kazipoaApp.profile.uploadProfilePicture(file);
          }
        });
      }
      
      // Handle form submission
      profileForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const updates = {
          name: profileForm.name.value,
          phone: profileForm.phone.value,
        };
        
        const result = kazipoaApp.profile.updateProfile(updates);
        
        if (result.success) {
          kazipoaApp.ui.showSuccess('Profile updated successfully!');
        } else {
          kazipoaApp.ui.showError(result.error);
        }
      });
    }
    
    // Handle logout
    const logoutBtn = document.querySelector('[data-action="logout"]');
    if (logoutBtn) {
      logoutBtn.addEventListener('click', () => {
        kazipoaApp.logout();
        kazipoaApp.ui.showSuccess('Logged out successfully');
        setTimeout(() => {
          window.location.href = '../Pages/01.Index.html';
        }, 1000);
      });
    }
  });
</script>

<script type="module" src="../js/main.js"></script>
```

## 🎮 My Bookings List Example

```html
<script type="module">
  window.addEventListener('app-initialized', () => {
    const user = kazipoaApp.auth.getCurrentUser();
    
    if (!user) {
      window.location.href = '../Pages/05.ClientID-login.html';
      return;
    }
    
    // Get all bookings
    const bookings = kazipoaApp.booking.getBookings();
    
    // Display bookings
    const bookingsList = document.querySelector('[data-bookings-list]') || 
                         document.querySelector('.bookings-container');
    
    if (bookingsList) {
      if (bookings.length === 0) {
        bookingsList.innerHTML = '<p class="text-center text-gray-500 py-8">No bookings yet</p>';
      } else {
        bookingsList.innerHTML = bookings.map(booking => `
          <div class="booking-card p-4 border rounded-lg mb-4">
            <div class="flex justify-between items-start mb-3">
              <div>
                <h3 class="font-semibold text-lg">${booking.serviceType}</h3>
                <p class="text-sm text-gray-600">ID: ${booking.id}</p>
              </div>
              <span class="inline-block px-3 py-1 rounded-full text-sm font-medium
                ${booking.status === 'confirmed' ? 'bg-green-100 text-green-800' : 
                  booking.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                  booking.status === 'completed' ? 'bg-blue-100 text-blue-800' :
                  'bg-red-100 text-red-800'}">
                ${booking.status}
              </span>
            </div>
            
            <div class="grid grid-cols-2 gap-2 mb-3 text-sm">
              <p>📅 ${booking.bookingDate}</p>
              <p>🕐 ${booking.bookingTime}</p>
              <p>⏱️ ${booking.duration} mins</p>
              <p>💬 ${booking.notes || 'No notes'}</p>
            </div>
            
            <div class="flex gap-2">
              ${booking.status === 'pending' ? `
                <button onclick="kazipoaApp.booking.cancelBooking('${booking.id}')" 
                  class="px-3 py-2 bg-red-500 text-white rounded hover:bg-red-600 text-sm">
                  Cancel
                </button>
              ` : ''}
              <button onclick="location.href='booking-detail.html?id=${booking.id}'" 
                class="px-3 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 text-sm">
                View Details
              </button>
            </div>
          </div>
        `).join('');
      }
    }
  });
</script>

<script type="module" src="../js/main.js"></script>
```

## 🌓 Theme Toggle Example

```html
<!-- Add this button anywhere on your page -->
<button id="themeToggle" class="px-4 py-2 rounded-lg border">
  <span class="theme-icon">🌙</span>
  <span class="theme-text">Dark Mode</span>
</button>

<script type="module">
  window.addEventListener('app-initialized', () => {
    const themeBtn = document.getElementById('themeToggle');
    
    if (themeBtn) {
      // Update button on load
      const updateThemeButton = () => {
        const isDark = kazipoaApp.theme.isDarkMode();
        themeBtn.querySelector('.theme-icon').textContent = isDark ? '☀️' : '🌙';
        themeBtn.querySelector('.theme-text').textContent = isDark ? 'Light Mode' : 'Dark Mode';
      };
      
      updateThemeButton();
      
      // Toggle on click
      themeBtn.addEventListener('click', () => {
        kazipoaApp.theme.toggleTheme();
        updateThemeButton();
      });
      
      // Listen for theme changes from other tabs
      window.addEventListener('theme-changed', updateThemeButton);
    }
  });
</script>

<script type="module" src="../js/main.js"></script>
```

## 🔗 Back Button Handler Example

```html
<!-- Add data-action="back" to any back button -->
<button data-action="back" class="px-4 py-2">
  <span class="material-symbols-outlined">arrow_back</span>
  Back
</button>

<script type="module">
  // This is automatically handled by navigation manager
  // But you can also manually handle it:
  window.addEventListener('app-initialized', () => {
    document.querySelectorAll('[data-action="back"]').forEach(btn => {
      btn.addEventListener('click', () => {
        kazipoaApp.navigation.goBack();
      });
    });
  });
</script>

<script type="module" src="../js/main.js"></script>
```

## 🔔 Notification Examples

```html
<script type="module">
  window.addEventListener('app-initialized', () => {
    // Success notification
    kazipoaApp.ui.showSuccess('Operation completed!', 3000);
    
    // Error notification
    kazipoaApp.ui.showError('Something went wrong!', 4000);
    
    // Warning notification
    kazipoaApp.ui.showWarning('Please be careful!', 3500);
    
    // Info notification
    kazipoaApp.ui.showInfo('Here is some information', 3000);
    
    // Show loading
    kazipoaApp.ui.showLoading('Processing...');
    
    // Hide loading
    setTimeout(() => {
      kazipoaApp.ui.hideLoading();
    }, 2000);
  });
</script>

<script type="module" src="../js/main.js"></script>
```

## 🎯 Protected Page (Require Login) Example

```html
<script type="module">
  window.addEventListener('app-initialized', () => {
    const user = kazipoaApp.auth.getCurrentUser();
    
    if (!user) {
      kazipoaApp.ui.showWarning('Please login to continue');
      setTimeout(() => {
        window.location.href = '../Pages/05.ClientID-login.html';
      }, 1500);
    } else {
      console.log('User is logged in:', user.name);
      // Page content can now load
    }
  });
</script>

<script type="module" src="../js/main.js"></script>
```

## 💾 Form Data Persistence Example

```html
<script type="module">
  // Save form data to storage as user types
  document.addEventListener('input', (e) => {
    if (e.target.form) {
      const formName = e.target.form.name || 'tempForm';
      const formData = new FormData(e.target.form);
      const data = Object.fromEntries(formData);
      
      // Save to storage
      import('../js/utils/storage.js').then(({ StorageManager }) => {
        StorageManager.set(`form_${formName}`, data);
      });
    }
  });
  
  // On form load, restore saved data
  window.addEventListener('app-initialized', () => {
    import('../js/utils/storage.js').then(({ StorageManager }) => {
      const forms = document.querySelectorAll('form');
      
      forms.forEach(form => {
        const formName = form.name || 'tempForm';
        const saved = StorageManager.get(`form_${formName}`);
        
        if (saved) {
          Object.entries(saved).forEach(([key, value]) => {
            const field = form.elements[key];
            if (field) {
              field.value = value;
            }
          });
        }
      });
    });
  });
</script>

<script type="module" src="../js/main.js"></script>
```

---

Copy and paste these examples into your HTML pages and customize as needed!
