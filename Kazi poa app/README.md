# 🚀 Kazipoa - Professional Booking Platform

A modern, dynamic frontend for a professional booking and service platform built with vanilla JavaScript, TailwindCSS, and advanced UI components.

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
Kazi poa app/
├── Pages/                 # HTML pages (do not modify)
│   ├── 01.Index.html
│   ├── 02.Pro-account-profile.html
│   ├── 03.Booking-setup.html
│   └── ... (14 more pages)
│
├── js/                    # JavaScript modules
│   ├── main.js           # App entry point
│   ├── modules/          # Feature modules
│   │   ├── auth.js       # Authentication
│   │   ├── booking.js    # Booking management
│   │   ├── profile.js    # Profile management
│   │   ├── navigation.js # Page routing
│   │   ├── theme.js      # Theme switching
│   │   └── ui.js         # UI management
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
│
├── package.json         # Project metadata
├── README.md           # This file
└── .gitignore         # Git ignore rules
```

## 🚀 Getting Started

### Prerequisites
- Modern web browser with ES6 module support
- Python 3 (for local development server)

### Installation

1. Clone or download the project
2. Navigate to the project directory:
   ```bash
   cd "Kazi poa app"
   ```

3. Start a local server:
   ```bash
   npm start
   # or
   python -m http.server 8000
   ```

4. Open your browser and navigate to `http://localhost:8000/Pages/01.Index.html`

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

1. Create new module in `js/modules/`
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
