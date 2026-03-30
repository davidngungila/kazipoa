# 🚀 Kazipoa Full - Professional Booking Platform

A complete dynamic and interactive recreation of the Kazipoa booking platform built with vanilla JavaScript, TailwindCSS, and advanced UI components.

## 📋 Features

### Core Functionality
- **User Authentication**: Login, registration, and session management
- **Booking System**: Create, manage, and track bookings
- **User Profiles**: Manage profile information and settings
- **Navigation**: Smooth page routing and history management
- **Theme Support**: Dark/light mode switching with persistence
- **Responsive Design**: Mobile-first responsive layouts

### UI Components
- **Notifications**: Toast notifications for success, error, warning, and info messages
- **Modals**: Customizable modal dialogs
- **Forms**: Advanced form handling with validation
- **Ripple Effects**: Interactive button feedback
- **Glass Morphism**: Modern glassmorphic design elements
- **Animations**: Smooth transitions and animations

### Utilities
- **Storage Manager**: Unified localStorage/sessionStorage interface
- **Validators**: Comprehensive form and data validation
- **Date Utilities**: Date formatting and manipulation
- **API Client**: Centralized HTTP request handling
- **DOM Utilities**: DOM manipulation helpers

## 🏗️ Project Structure

```
kazipoa full/
├── Pages/                 # HTML pages (17 complete pages)
│   ├── 01.Index.html                    # Home page
│   ├── 02.Pro-account-profile.html        # Professional profile
│   ├── 03.Booking-setup.html             # Create booking
│   ├── 04.ClientID-registration.html     # Client registration
│   ├── 05.ClientID-login.html            # Client login
│   ├── 06.Booking-success.html           # Booking success
│   ├── 07.Mybookings.html                # Client bookings
│   ├── 08.Pro-account-login.html         # Professional login
│   ├── 09.Pro-account-registration.html  # Professional registration
│   ├── 10.Email-verification.html        # Email verification
│   ├── 11.OTP-verification.html          # OTP verification
│   ├── 12.Profile-setup.html             # Profile setup
│   ├── 13.Dashboard.html                # Main dashboard
│   ├── 14.Myoffice.html                  # Professional office
│   ├── 15.Profile-settings.html         # Profile settings
│   ├── 16.MyClient-Booking.html          # Client bookings (for professionals)
│   └── 17.Analytics.html                 # Analytics dashboard
│
├── js/                    # JavaScript modules
│   ├── main.js           # App entry point
│   ├── modules/          # Feature modules
│   │   ├── auth.js       # Authentication
│   │   ├── booking.js    # Booking management
│   │   ├── profile.js    # Profile management
│   │   ├── navigation.js # Page routing
│   │   ├── theme.js      # Theme switching
│   │   ├── ui.js         # UI management
│   │   └── interactive.js # Auto-wire UI interactions
│   ├── utils/            # Utility functions
│   │   ├── storage.js    # Storage management
│   │   ├── validators.js # Form validation
│   │   ├── date.js       # Date utilities
│   │   ├── api.js        # API client
│   │   └── dom.js        # DOM helpers
│   └── components/       # Reusable components
│       ├── formHandler.js
│       └── rippleButton.js
│
├── css/                  # Stylesheets
│   └── styles.css       # Global styles
├── package.json         # Project metadata
└── README.md           # This file
```

## 🚀 Getting Started

### Prerequisites
- Modern web browser with ES6 module support
- Python 3 (for local development server)

### Installation

1. Navigate to the project directory:
   ```bash
   cd "kazipoa full"
   ```

2. Start a local server:
   ```bash
   npm start
   # or
   python -m http.server 8000
   ```

3. Open your browser and navigate to `http://localhost:8000/Pages/01.Index.html`

## 📦 Core Modules

### Auth Manager
```javascript
const result = await kazipoaApp.auth.login(email, password);
const registerResult = await kazipoaApp.auth.register(userData);
await kazipoaApp.auth.logout();
```

### Booking Manager
```javascript
const booking = await kazipoaApp.booking.createBooking(bookingData);
const bookings = kazipoaApp.booking.getBookings();
await kazipoaApp.booking.cancelBooking(bookingId);
```

### Profile Manager
```javascript
kazipoaApp.profile.updateProfile(updates);
kazipoaApp.profile.updateSettings(settings);
```

### UI Manager
```javascript
kazipoaApp.ui.showSuccess('Operation completed!');
kazipoaApp.ui.showError('Something went wrong');
kazipoaApp.ui.showLoading('Please wait...');
```

### Theme Manager
```javascript
kazipoaApp.theme.toggleTheme();
const isDark = kazipoaApp.theme.isDarkMode();
```

## 🛠️ Utilities

### Storage Manager
```javascript
StorageManager.set('key', value);
const data = StorageManager.get('key');
StorageManager.remove('key');
```

### Validators
```javascript
ValidatorUtil.validateEmail(email);
ValidatorUtil.validatePassword(password);
const validator = new FormValidator(rules);
validator.validate(formData);
```

### Date Utilities
```javascript
DateUtil.format(date, 'YYYY-MM-DD');
DateUtil.formatRelative(date); // "2 hours ago"
DateUtil.addDays(date, 5);
```

## 🎨 Customization

### Colors
Edit CSS custom properties in `css/styles.css`:
```css
:root {
  --primary-color: #0f00e7;
  --secondary-color: #6366f1;
  /* ... */
}
```

### Animations
All animations are defined in `css/styles.css`. Customize durations and effects as needed.

### Default Settings
Modify default settings in `js/modules/profile.js` `getDefaultSettings()` method.

## 📱 Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## 🔐 Security Notes

- This is a frontend-only application
- All authentication is simulated - implement real backend authentication
- Never store sensitive data in localStorage without encryption
- Add HTTPS in production
- Implement proper CORS settings on backend

## 🤝 Development

### Adding New Features

1. Create new module in `js/modules/feature.js`
2. Import and initialize in `main.js`
3. Add corresponding styles to `css/styles.css`
4. Update HTML to use new features

### Code Style
- Use ES6 modules
- Follow camelCase for variables and functions
- Use meaningful names and comments
- Log important actions with emojis for visual feedback

## 📝 License

MIT License - see LICENSE file for details

## 🆘 Troubleshooting

### App not initializing
- Check browser console for errors
- Ensure all modules are imported correctly
- Verify HTML files are in correct location

### Storage not working
- Check if localStorage is enabled
- Clear storage if corrupted: `StorageManager.clear()`
- Check browser privacy settings

### Styling issues
- Clear browser cache
- Ensure CSS file is linked in HTML
- Check dark mode class on `<html>` element

## 📧 Support

For issues and questions, please check the console for detailed error messages and logs.

---

**Built with ❤️ by Kazipoa Team**

## 🎯 Demo Credentials

For testing purposes, use these demo accounts:

### Client Account
- Email: `client@kazipoa.tz`
- Password: `Demo@2026`

### Professional Account
- Email: `pro@kazipoa.tz`
- Password: `Demo@2026`

You can also use any email/password combination for testing - the system will create a demo user automatically.

## 📱 Complete Page Flow

### For Clients:
1. **Home** (`01.Index.html`) → Register/Login
2. **Registration** (`04.ClientID-registration.html`) → Email Verification
3. **Email Verification** (`10.Email-verification.html`) → OTP Verification
4. **OTP Verification** (`11.OTP-verification.html`) → Dashboard
5. **Dashboard** (`13.Dashboard.html`) → Create Booking/View Bookings
6. **Booking Setup** (`03.Booking-setup.html`) → Success
7. **Booking Success** (`06.Booking-success.html`) → View Bookings
8. **My Bookings** (`07.Mybookings.html`) → Manage Bookings
9. **Profile Setup** (`12.Profile-setup.html`) → Settings
10. **Profile Settings** (`15.Profile-settings.html`) → Update Preferences

### For Professionals:
1. **Home** (`01.Index.html`) → Register/Login
2. **Professional Registration** (`09.Pro-account-registration.html`) → Email Verification
3. **Professional Login** (`08.Pro-account-login.html`) → Dashboard
4. **Dashboard** (`13.Dashboard.html`) → Office/Analytics
5. **My Office** (`14.Myoffice.html`) → Manage Client Bookings
6. **Client Bookings** (`16.MyClient-Booking.html`) → Accept/Reject Bookings
7. **Professional Profile** (`02.Pro-account-profile.html`) → Update Profile
8. **Analytics** (`17.Analytics.html`) → View Performance Stats

## 🎨 Features Implemented

### Authentication System
- ✅ User registration (Client & Professional)
- ✅ Email verification simulation
- ✅ OTP verification with timer
- ✅ Session management (30-minute timeout)
- ✅ Auto-logout on session expiry
- ✅ Demo credentials for testing

### Booking System
- ✅ Create new bookings
- ✅ View booking history
- ✅ Cancel pending bookings
- ✅ Offline booking support
- ✅ Booking status management
- ✅ Professional acceptance/rejection

### User Interface
- ✅ Glass morphism design
- ✅ Dark/light theme switching
- ✅ Toast notifications (4 types)
- ✅ Loading states
- ✅ Form validation
- ✅ Ripple button effects
- ✅ Responsive design

### Dashboard Features
- ✅ Statistics overview
- ✅ Quick actions
- ✅ Recent activity
- ✅ Performance metrics
- ✅ Charts and graphs
- ✅ Data filtering

### Profile Management
- ✅ Profile editing
- ✅ Settings management
- ✅ Notification preferences
- ✅ Privacy controls
- ✅ Theme preferences
- ✅ Account security options
