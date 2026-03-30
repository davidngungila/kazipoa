# 🎮 Kazipoa Prototype - Getting Started Guide

## What Is Kazipoa?

**Kazipoa** is a professional service booking platform connecting clients with service providers.

### How It Works:
1. **Clients** book services (haircuts, cleaning, plumbing, tutoring, etc.)
2. **Professionals** provide these services
3. **Instant booking** with confirmation
4. **Ratings & Reviews** for accountability
5. **Secure payments** between parties

---

## ⚡ Quick Start (3 Steps)

### Step 1: Add Script Tag to HTML Files

Add this line **before the closing `</body>` tag** in each HTML file:

```html
<script type="module" src="../js/main.js"></script>
```

**Example:**
```html
<!DOCTYPE html>
<html>
<head>
  <!-- ... -->
</head>
<body>
  <!-- Your page content -->
  
  <!-- Add this ONE line -->
  <script type="module" src="../js/main.js"></script>
</body>
</html>
```

### Step 2: Test the App

Open your browser and navigate to any page with the script added.

### Step 3: Use Demo Credentials

The app now has **working interactive features**!

---

## 🔐 Demo Accounts

### Client Account
- **Email:** `client@kazipoa.tz`
- **Password:** `Demo@2026`
- **Role:** Client (can book services)
- **Name:** John Mwangi

### Professional Account
- **Email:** `pro@kazipoa.tz`
- **Password:** `Demo@2026`
- **Role:** Professional (can offer services)
- **Name:** Maria Baraza
- **Specialization:** Hair Styling

### Alternative
- **Use any email/password** - the system accepts any credentials for testing

---

## 🎯 Interactive Features Now Available

### ✅ Login Page
- Real form submission
- Demo account auto-detection
- Redirects to Dashboard on success
- Shows helpful hints

### ✅ Registration Page
- Create new accounts on the fly
- Auto-login after registration
- Validates email/password

### ✅ Dashboard
- Shows user welcome message
- Displays booking statistics:
  - Total bookings
  - Pending bookings
  - Confirmed bookings
  - Completed bookings
- Shows recent bookings list
- Auto-injected content (no HTML modification needed!)

### ✅ My Bookings Page
- Lists all bookings with details
- Shows booking status with color coding
- Displays price, date, time, duration
- Shows professional name
- Interactive buttons (View Details, Rate Service, Cancel)
- Empty state handling

### ✅ Profile Page
- Pre-fills with current user data
- Update profile information
- Form validation

### ✅ Booking Page
- Create new bookings
- Select service type, date, time
- Add notes
- Automatic success page redirect

### ✅ Global Features
- **Back Button** - Works automatically
- **Navigation** - All buttons auto-linked
- **Logout** - Confirmation dialog
- **Notifications** - Success, error, warning messages
- **Loading States** - Spinner shows during operations
- **Theme Toggle** - Dark/light mode
- **Session Management** - 30-minute timeout
- **Offline Support** - Bookings saved offline, sync when back online

---

## 📱 Demo Flow

### For Clients:

```
Start → Login (client@kazipoa.tz)
      ↓
    Dashboard (see stats & recent bookings)
      ↓
    Create New Booking (click booking button)
      ↓
    View My Bookings (see all bookings)
      ↓
    Manage Profile (update info)
```

### For Professionals:

```
Start → Login (pro@kazipoa.tz)
      ↓
    Dashboard (see all bookings)
      ↓
    View My Office (manage services)
      ↓
    Analytics (view statistics)
```

---

## 🎨 UI Features

### Notifications
You'll see toast notifications for:
- ✅ Success messages (green)
- ❌ Error messages (red)
- ⚠️ Warning messages (yellow)
- ℹ️ Info messages (blue)

### Loading States
- Spinner appears during operations
- Auto-dismisses when complete

### Color Coding
- 🟢 **Green** = Confirmed/Completed
- 🟡 **Yellow** = Pending
- 🔵 **Blue** = Processing
- 🔴 **Red** = Cancelled

### Animations
- Smooth transitions
- Slide-in notifications
- Fade animations
- Ripple effects on buttons

---

## 🔧 What's Happening Behind the Scenes

The `InteractivePageManager` automatically:

1. **Detects page type** from URL
2. **Hooks form submissions** to app functions
3. **Injects dynamic content** (stats, bookings list)
4. **Wires up buttons** for navigation
5. **Handles authentication** checks
6. **Shows/hides content** based on login status

All without modifying a single HTML file!

---

## 📊 Sample Data

The app comes pre-loaded with sample bookings:

```javascript
BKG_001 - Hair Styling
  Professional: Maria Baraza
  Date: In 2 days
  Status: Confirmed
  Price: 50,000 TZS

BKG_002 - Home Cleaning
  Professional: James Kipchoge
  Date: Today
  Status: Completed
  Price: 80,000 TZS

BKG_003 - Plumbing
  Professional: Peter Nyambati
  Date: In 7 days
  Status: Pending
  Price: 150,000 TZS
```

---

## 💡 Pro Tips

### View User Info in Console
```javascript
kazipoaDebug.showUser()        // Current user
kazipoaDebug.showBookings()    // All bookings
kazipoaDebug.showProfile()     // User profile
```

### Force Login State
```javascript
// Open browser console (F12) and type:
kazipoaApp.auth.logout()
kazipoaApp.ui.showSuccess('Logged out')
```

### Create Custom Booking
```javascript
await kazipoaApp.booking.createBooking({
  serviceType: 'Massage',
  bookingDate: '2024-04-10',
  bookingTime: '15:00',
  duration: 90,
  notes: 'Deep tissue massage'
})
```

---

## 🐛 Troubleshooting

### Page not showing interactive features
- ✅ Check browser console (F12) for errors
- ✅ Verify script tag is added to HTML
- ✅ Make sure JS files are in correct folder structure
- ✅ Check file paths are correct (../../ or ../js/main.js)

### Login not working
- ✅ Try demo credentials: `client@kazipoa.tz` / `Demo@2026`
- ✅ Or try any email/password combination
- ✅ Check browser console for error messages

### Buttons not responding
- ✅ Check if script is loaded (F12 → Console→ type `kazipoaApp`)
- ✅ Verify app initialized (should see ✅ message in console)

### Data not persisting
- ✅ Check localStorage is enabled in browser
- ✅ Open DevTools → Application → LocalStorage to view saved data

---

## 🚀 Next Features to Add

1. **Backend Integration** - Connect to real API
2. **Search & Filter** - Find professionals
3. **Reviews & Ratings** - Leave feedback
4. **Payment Processing** - Secure payments
5. **Chat System** - Direct messaging
6. **Location-based** - Map integration
7. **Admin Panel** - Manage platform
8. **Analytics Dashboard** - Statistics for professionals

---

## 📞 Using the Global App Object

Access anything in your browser console:

```javascript
// Authentication
kazipoaApp.auth.getCurrentUser()
kazipoaApp.auth.logout()

// Bookings
kazipoaApp.booking.getBookings()
kazipoaApp.booking.getBookingStats()

// UI
kazipoaApp.ui.showSuccess('Message')
kazipoaApp.ui.showError('Error')
kazipoaApp.ui.showLoading('Loading...')

// Theme
kazipoaApp.theme.toggleTheme()
kazipoaApp.theme.isDarkMode()

// Navigation
kazipoaApp.navigation.redirectTo('/dashboard')
kazipoaApp.navigation.goBack()

// Profile
kazipoaApp.profile.updateProfile({name: 'New Name'})
kazipoaApp.profile.getSettings()
```

---

## 🎉 You're All Set!

Your Kazipoa prototype is now **fully functional** with:
- ✅ Interactive pages
- ✅ Working forms
- ✅ Real-time notifications
- ✅ Session management
- ✅ Sample data
- ✅ Professional UI

**Start using it now!** Add the script tag and explore! 🚀

---

## 📝 File Structure

```
js/
├── main.js                 # Entry point
├── modules/
│   ├── auth.js            # Authentication
│   ├── booking.js         # Bookings
│   ├── interactive.js     # Page interactions ⭐ NEW
│   ├── navigation.js      # Navigation
│   ├── profile.js         # Profile
│   ├── theme.js           # Theme
│   └── ui.js              # UI components
├── utils/
│   ├── api.js
│   ├── date.js
│   ├── dom.js
│   ├── storage.js
│   └── validators.js
└── components/
    ├── formHandler.js
    └── rippleButton.js
```

---

Made with ❤️ for the Kazipoa Community
