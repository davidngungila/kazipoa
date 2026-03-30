# ⚡ Quick Reference Guide

One-page reference for all Kazipoa app functions and utilities.

## 🚀 Quick Start

1. **Add to HTML files:**
```html
<script type="module" src="../js/main.js"></script>
```

2. **Use in your code:**
```javascript
window.addEventListener('app-initialized', () => {
  // Your code here
  kazipoaApp.ui.showSuccess('Hello!');
});
```

---

## 👤 Authentication

| Function | Usage |
|----------|-------|
| Login | `kazipoaApp.auth.login(email, password, type)` |
| Register | `kazipoaApp.auth.register({name, email, password, phone})` |
| Logout | `kazipoaApp.auth.logout()` |
| Get User | `kazipoaApp.auth.getCurrentUser()` |
| Update Profile | `kazipoaApp.auth.updateProfile({...})` |
| Check Type | `kazipoaApp.auth.isUserType('client')` |
| Validate Session | `kazipoaApp.auth.validateSession()` |

---

## 📅 Bookings

| Function | Usage |
|----------|-------|
| Create | `kazipoaApp.booking.createBooking({serviceType, bookingDate, bookingTime, duration, notes})` |
| Update | `kazipoaApp.booking.updateBooking(id, {status, ...})` |
| Cancel | `kazipoaApp.booking.cancelBooking(id)` |
| Get All | `kazipoaApp.booking.getBookings()` |
| Get Filtered | `kazipoaApp.booking.getBookings({status, dateFrom, dateTo})` |
| Get One | `kazipoaApp.booking.getBooking(id)` |
| Get Stats | `kazipoaApp.booking.getBookingStats()` |

---

## 👥 Profile

| Function | Usage |
|----------|-------|
| Update Profile | `kazipoaApp.profile.updateProfile({name, phone, bio})` |
| Get Profile | `kazipoaApp.profile.getProfile()` |
| Upload Photo | `kazipoaApp.profile.uploadProfilePicture(file)` |
| Update Settings | `kazipoaApp.profile.updateSettings({theme, language})` |
| Get Settings | `kazipoaApp.profile.getSettings()` |
| Get Setting | `kazipoaApp.profile.getSetting('theme')` |
| Reset Password | `kazipoaApp.profile.resetPassword(current, new)` |

---

## 🎨 UI Components

| Function | Usage |
|----------|-------|
| Success | `kazipoaApp.ui.showSuccess(message, duration)` |
| Error | `kazipoaApp.ui.showError(message)` |
| Warning | `kazipoaApp.ui.showWarning(message)` |
| Info | `kazipoaApp.ui.showInfo(message)` |
| Loading Show | `kazipoaApp.ui.showLoading(message)` |
| Loading Hide | `kazipoaApp.ui.hideLoading()` |
| Show Modal | `kazipoaApp.ui.showModal(id, title, content, {actions, closeable})` |
| Close Modal | `kazipoaApp.ui.closeModal(id)` |
| Form Errors | `kazipoaApp.ui.setFormErrors(form, {field: 'error'})` |
| Clear Errors | `kazipoaApp.ui.clearFormErrors(form)` |
| Disable Form | `kazipoaApp.ui.disableForm(form)` |
| Enable Form | `kazipoaApp.ui.enableForm(form)` |

---

## 🗺️ Navigation

| Function | Usage |
|----------|-------|
| Navigate | `kazipoaApp.navigation.redirectTo('/dashboard')` |
| Go Back | `kazipoaApp.navigation.goBack()` |
| Current Page | `kazipoaApp.navigation.getCurrentPage()` |
| History | `kazipoaApp.navigation.getNavigationHistory()` |
| Clear History | `kazipoaApp.navigation.clearHistory()` |

---

## 🎨 Theme

| Function | Usage |
|----------|-------|
| Toggle | `kazipoaApp.theme.toggleTheme()` |
| Apply | `kazipoaApp.theme.applyTheme('dark')` |
| Get Current | `kazipoaApp.theme.getCurrentTheme()` |
| Is Dark | `kazipoaApp.theme.isDarkMode()` |

---

## 💾 Storage

```javascript
import { StorageManager } from '../js/utils/storage.js';

StorageManager.set('key', value);          // Save
StorageManager.get('key');                 // Retrieve
StorageManager.remove('key');              // Delete
StorageManager.clear();                    // Clear all
StorageManager.keys();                     // Get all keys
StorageManager.exist('key');               // Check exists
```

---

## ✅ Validators

```javascript
import { ValidatorUtil, FormValidator } from '../js/utils/validators.js';

// Individual validators
ValidatorUtil.validateEmail(email);
ValidatorUtil.validatePassword(password);
ValidatorUtil.validatePhone(phone);
ValidatorUtil.validateName(name);
ValidatorUtil.validateRequired(value);
ValidatorUtil.validateURL(url);
ValidatorUtil.validateDate(date);
ValidatorUtil.validateTime(time);

// Form validator
const validator = new FormValidator({
  email: ['required', 'email'],
  password: ['required', { type: 'min', value: 8 }],
});

if (validator.validate(data)) {
  // Valid
} else {
  console.log(validator.getErrors());
}
```

---

## 📅 Date Utils

```javascript
import { DateUtil } from '../js/utils/date.js';

DateUtil.format(date, 'YYYY-MM-DD');    // Format date
DateUtil.formatTime(date, 'HH:mm');     // Format time
DateUtil.formatRelative(date);          // "2 hours ago"
DateUtil.isToday(date);                 // Boolean
DateUtil.isFuture(date);                // Boolean
DateUtil.isPast(date);                  // Boolean
DateUtil.addDays(date, 5);              // Add days
DateUtil.addHours(date, 2);             // Add hours
DateUtil.getDayName(date);              // "Monday"
DateUtil.getMonthName(date);            // "January"
DateUtil.getDifference(date1, date2);   // Days between
```

---

## 🌐 DOM Utils

```javascript
import { DOMUtil } from '../js/utils/dom.js';

DOMUtil.getElementById('id');
DOMUtil.querySelector('.class');
DOMUtil.querySelectorAll('.item');
DOMUtil.createElement('div', {class: 'box'}, 'content');
DOMUtil.appendChild(parent, child);
DOMUtil.setHTML(element, '<p>Hi</p>');
DOMUtil.setText(element, 'Text');
DOMUtil.addClass(element, 'active');
DOMUtil.removeClass(element, 'inactive');
DOMUtil.toggleClass(element, 'hidden');
DOMUtil.hasClass(element, 'visible');
DOMUtil.on(element, 'click', handler);
DOMUtil.off(element, 'click', handler);
DOMUtil.remove(element);
DOMUtil.hide(element);
DOMUtil.show(element);
DOMUtil.isVisible(element);
DOMUtil.scrollIntoView(element, true);
DOMUtil.getOffset(element);
```

---

## 🔗 Routes

```
/                    → 01.Index.html
/login              → 05.ClientID-login.html
/register           → 04.ClientID-registration.html
/pro-login          → 08.Pro-account-login.html
/pro-register       → 09.Pro-account-registration.html
/dashboard          → 13.Dashboard.html
/profile            → 12.Profile-setup.html
/profile-settings   → 15.Profile-settings.html
/booking-setup      → 03.Booking-setup.html
/my-bookings        → 07.Mybookings.html
/client-bookings    → 16.MyClient-Booking.html
/pro-profile        → 02.Pro-account-profile.html
/my-office          → 14.Myoffice.html
/analytics          → 17.Analytics.html
/email-verify       → 10.Email-verification.html
/otp-verify         → 11.OTP-verification.html
/booking-success    → 06.Booking-success.html
```

---

## 📡 Events

```javascript
// Listen to events
window.addEventListener('app-initialized', () => {});
window.addEventListener('user-logged-out', () => {});
window.addEventListener('session-expired', () => {});
window.addEventListener('theme-changed', (e) => {});
window.addEventListener('profile-updated', (e) => {});
window.addEventListener('settings-updated', (e) => {});
window.addEventListener('profile-picture-updated', () => {});
window.addEventListener('form-submitted', (e) => {});
```

---

## 🎯 HTML Attributes

```html
<!-- Back button -->
<button data-action="back">Back</button>

<!-- Navigate -->
<button data-navigate="/dashboard">Dashboard</button>

<!-- Form handler -->
<form data-form-handler="login">...</form>

<!-- Modal trigger -->
<button data-modal="settings">Settings</button>

<!-- Loading state -->
<button data-loading>Send</button>
```

---

## 🔐 Data Persistence

```javascript
// Automatically persisted to localStorage with 'kazipoa_' prefix
// Current User: kazipoaApp.auth.getCurrentUser()
// Bookings: kazipoaApp.booking.getBookings()
// Profile: kazipoaApp.profile.getProfile()
// Settings: kazipoaApp.profile.getSettings()
// Theme: kazipoaApp.theme.getCurrentTheme()

// Manual storage
import { StorageManager } from '../js/utils/storage.js';
StorageManager.set('customData', {foo: 'bar'});
```

---

## 🐛 Debugging

```javascript
// All logs use emojis for quick scanning
// ✅ Success operations
// ❌ Errors
// ⚠️ Warnings
// 🚀 Starting operations
// 📅 Date operations
// 👤 Profile operations
// 📡 Network operations
// 💾 Storage operations

// Enable console to see all logs
console.log('Check browser console (F12)');
```

---

## 📱 Mobile Friendly

- All components are responsive
- Touch-friendly buttons and forms
- Optimized for small screens
- Smooth animations on mobile

---

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Script not loading | Check path: `../js/main.js` from Pages folder |
| App not initialized | Wait for `app-initialized` event |
| User is null | Check with `kazipoaApp.auth.getCurrentUser()` |
| Form not submitting | Add `event.preventDefault()` |
| Storage not working | Check localStorage enabled in browser |
| Dark mode not working | Check HTML `class="dark"` attribute |

---

## 🎨 CSS Classes

```html
<!-- Buttons -->
<button class="btn btn-primary">Primary</button>
<button class="btn btn-secondary">Secondary</button>
<button class="btn btn-outline">Outline</button>

<!-- Badges -->
<span class="badge badge-primary">New</span>
<span class="badge badge-success">Active</span>

<!-- Notifications -->
<!-- Automatically styled with notification-{type} class -->

<!-- Glass effect -->
<div class="glass-panel">Content</div>

<!-- Animations -->
<div class="animate-slideIn">Slide in</div>
<div class="animate-fadeIn">Fade in</div>
<div class="animate-spin">Spinning</div>

<!-- Utilities -->
<div class="text-center cursor-pointer opacity-75"></div>
```

---

## 📞 Support Matrix

| Feature | Status | Notes |
|---------|--------|-------|
| Authentication | ✅ Simulated | Ready for backend integration |
| Bookings | ✅ Full Featured | Create, update, cancel, list |
| Profile | ✅ Working | Settings and preferences |
| Theme | ✅ Perfect | Dark/light mode with persistence |
| Notifications | ✅ Complete | 4 types with auto-dismiss |
| Forms | ✅ Validated | Built-in validation |
| Offline | ✅ Ready | Pending sync when online |
| Storage | ✅ Persistent | localStorage based |

---

## 🚀 Next Steps

1. Add the script tag to all HTML files
2. Implement specific page functionality using examples
3. Connect to real backend API using APIClient
4. Replace simulated auth with real authentication
5. Deploy to production with HTTPS

---

## 📚 File Reference

| File | Purpose |
|------|---------|
| `js/main.js` | App entry point |
| `js/modules/auth.js` | Authentication |
| `js/modules/booking.js` | Booking management |
| `js/modules/profile.js` | Profile management |
| `js/modules/navigation.js` | Page routing |
| `js/modules/theme.js` | Theme switching |
| `js/modules/ui.js` | UI components |
| `js/utils/storage.js` | Storage management |
| `js/utils/validators.js` | Form validation |
| `js/utils/date.js` | Date utilities |
| `js/utils/api.js` | API client |
| `js/utils/dom.js` | DOM utilities |
| `css/styles.css` | Global styles |

---

That's it! You have everything you need to build a dynamic frontend. Start implementing! 🚀
