# 🔗 Integration Guide

## How to Connect JavaScript to Your HTML Pages

### Step 1: Add Script Tag to HTML

Add this single line just before the closing `</body>` tag in **each** HTML file:

```html
<script type="module" src="../js/main.js"></script>
```

**Example:**
```html
<!DOCTYPE html>
<html>
<head>
  <!-- existing head content -->
</head>
<body>
  <!-- existing body content -->

  <!-- Add this line at the very end -->
  <script type="module" src="../js/main.js"></script>
</body>
</html>
```

### Why `../js/main.js`?
- The `../` goes back from `Pages/` folder to the root
- Then accesses `js/` folder and loads `main.js`
- Using `type="module"` enables ES6 modules

### Step 2: Link CSS File (Optional but Recommended)

Add this in the `<head>` section:

```html
<link rel="stylesheet" href="../css/styles.css">
```

### Step 3: Use the App in Your Code

After the script loads, your JavaScript code can use the global `kazipoaApp` object:

```javascript
// In your HTML files or other scripts
document.addEventListener('DOMContentLoaded', () => {
  // Wait for app to initialize
  window.addEventListener('app-initialized', () => {
    console.log('App is ready!');
    
    // Use the app
    kazipoaApp.ui.showSuccess('Welcome!');
  });
});
```

## 🎯 Common Use Cases

### Login Form Submission
```html
<form data-form-handler="login">
  <input type="email" name="email" required>
  <input type="password" name="password" required>
  <button type="submit">Login</button>
</form>

<script type="module">
document.querySelector('[data-form-handler="login"]').addEventListener('submit', async (e) => {
  e.preventDefault();
  const email = e.target.email.value;
  const password = e.target.password.value;
  
  const result = await kazipoaApp.auth.login(email, password);
  if (result.success) {
    kazipoaApp.ui.showSuccess('Logged in successfully!');
    // Redirect after a delay
    setTimeout(() => {
      window.location.href = '../Pages/13.Dashboard.html';
    }, 1500);
  } else {
    kazipoaApp.ui.showError(result.error);
  }
});
</script>
```

### Show Notification
```html
<button onclick="kazipoaApp.ui.showSuccess('Success!')">Click me</button>
```

### Toggle Dark Mode
```html
<button onclick="kazipoaApp.theme.toggleTheme()">Toggle Dark Mode</button>
```

### Get Current User
```javascript
const user = kazipoaApp.auth.getCurrentUser();
console.log(user);
```

### Create Booking
```javascript
const bookingData = {
  serviceType: 'haircut',
  bookingDate: '2024-04-15',
  bookingTime: '14:00',
  duration: 30,
  notes: 'Please book a stylist'
};

const result = await kazipoaApp.booking.createBooking(bookingData);
if (result.success) {
  kazipoaApp.ui.showSuccess('Booking created!');
}
```

### Update Profile
```javascript
kazipoaApp.profile.updateProfile({
  name: 'John Doe',
  phone: '+255123456789',
  bio: 'Professional stylist'
});
```

## 📋 Available Global Objects and Methods

### `kazipoaApp.auth` - Authentication
- `login(email, password, userType)` - Login user
- `register(userData)` - Register new user
- `logout()` - Logout current user
- `getCurrentUser()` - Get current user object
- `updateProfile(updates)` - Update user profile
- `isUserType(type)` - Check user type
- `validateSession()` - Validate session

### `kazipoaApp.booking` - Bookings
- `createBooking(data)` - Create new booking
- `updateBooking(id, updates)` - Update booking
- `cancelBooking(id)` - Cancel booking
- `getBookings(filter)` - Get filtered bookings
- `getBooking(id)` - Get single booking
- `getBookingStats()` - Get booking statistics

### `kazipoaApp.profile` - Profile Management
- `updateProfile(updates)` - Update profile
- `updateSettings(updates)` - Update settings
- `uploadProfilePicture(file)` - Upload profile pic
- `getProfile()` - Get profile object
- `getSetting(key)` - Get specific setting
- `resetPassword(current, new)` - Reset password

### `kazipoaApp.theme` - Theme
- `toggleTheme()` - Switch light/dark mode
- `applyTheme(theme)` - Apply specific theme
- `getCurrentTheme()` - Get current theme
- `isDarkMode()` - Check if dark mode

### `kazipoaApp.ui` - UI Components
- `showNotification(message, type, duration)` - Show notification
- `showSuccess(message)` - Success notification
- `showError(message)` - Error notification
- `showLoading(message)` - Show loading spinner
- `hideLoading()` - Hide loading spinner
- `showModal(id, title, content, options)` - Show modal
- `closeModal(id)` - Close modal
- `setFormErrors(form, errors)` - Show form errors

### `kazipoaApp.navigation` - Navigation
- `redirectTo(path)` - Navigate to path
- `goBack()` - Go back to previous page
- `getCurrentPage()` - Get current page

## ⚡ Events You Can Listen To

```javascript
// App initialized
window.addEventListener('app-initialized', () => {
  console.log('App ready!');
});

// User logged out
window.addEventListener('user-logged-out', () => {
  console.log('User logged out');
});

// Session expired
window.addEventListener('session-expired', () => {
  console.log('Session expired, please login again');
});

// Theme changed
window.addEventListener('theme-changed', (e) => {
  console.log('Theme:', e.detail.theme);
});

// Profile updated
window.addEventListener('profile-updated', (e) => {
  console.log('Profile:', e.detail);
});

// Settings updated
window.addEventListener('settings-updated', (e) => {
  console.log('Settings:', e.detail);
});

// Form submitted
window.addEventListener('form-submitted', (e) => {
  console.log('Form type:', e.detail.type, 'Data:', e.detail.data);
});
```

## 📦 Utilities You Can Use

### StorageManager
```javascript
import { StorageManager } from '../js/utils/storage.js';

StorageManager.set('key', value);
const value = StorageManager.get('key');
StorageManager.remove('key');
StorageManager.clear();
```

### ValidatorUtil
```javascript
import { ValidatorUtil } from '../js/utils/validators.js';

ValidatorUtil.validateEmail(email);
ValidatorUtil.validatePassword(password);
ValidatorUtil.validatePhone(phone);
ValidatorUtil.validateRequired(value);
```

### DateUtil
```javascript
import { DateUtil } from '../js/utils/date.js';

DateUtil.format(date, 'YYYY-MM-DD');
DateUtil.formatRelative(date); // "2 hours ago"
DateUtil.addDays(date, 5);
```

### DOMUtil
```javascript
import { DOMUtil } from '../js/utils/dom.js';

DOMUtil.querySelector(selector);
DOMUtil.addClass(element, className);
DOMUtil.removeClass(element, className);
DOMUtil.setHTML(element, html);
```

## 🔄 Full Integration Example

Here's a complete example for a login page:

```html
<!DOCTYPE html>
<html class="light" lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - Kazipoa</title>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="min-h-screen flex items-center justify-center">
    <div class="w-full max-w-md p-8">
      <h1>Login to Kazipoa</h1>
      
      <form id="loginForm">
        <div class="mb-4">
          <label for="email">Email</label>
          <input 
            type="email" 
            id="email" 
            name="email" 
            required
            placeholder="your@email.com"
          >
        </div>
        
        <div class="mb-6">
          <label for="password">Password</label>
          <input 
            type="password" 
            id="password" 
            name="password" 
            required
            placeholder="••••••••"
          >
        </div>
        
        <button type="submit" class="w-full btn btn-primary">
          Login
        </button>
      </form>
    </div>
  </div>

  <script type="module">
    const form = document.getElementById('loginForm');
    
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      
      kazipoaApp.ui.showLoading('Logging in...');
      
      const email = form.email.value;
      const password = form.password.value;
      
      const result = await kazipoaApp.auth.login(email, password, 'client');
      
      kazipoaApp.ui.hideLoading();
      
      if (result.success) {
        kazipoaApp.ui.showSuccess('Welcome back!');
        setTimeout(() => {
          window.location.href = '../Pages/13.Dashboard.html';
        }, 1000);
      } else {
        kazipoaApp.ui.showError(result.error);
      }
    });
  </script>

  <!-- Main app script -->
  <script type="module" src="../js/main.js"></script>
</body>
</html>
```

## 🐛 Debugging

Enable detailed logging by opening browser console (F12):

```javascript
// All app actions will log with emojis
// ✅ Success
// ❌ Error
// ⚠️ Warning
// 🚀 Starting
// 📅 Date operations
// 👤 Profile updates
```

## ✅ Checklist

- [ ] Add `<script type="module" src="../js/main.js"></script>` to each HTML
- [ ] Optionally link CSS: `<link rel="stylesheet" href="../css/styles.css">`
- [ ] Test app initialization by opening browser console
- [ ] Check for any console errors
- [ ] Test authentication features
- [ ] Test booking functionality
- [ ] Test theme switching
- [ ] Test notifications

---

That's it! Your frontend is ready to use. All the JavaScript is now connected to your HTML pages.
