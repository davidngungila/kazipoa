/**
 * Authentication Manager
 * Handles user authentication, session management, and user data
 */

import { StorageManager } from '../utils/storage.js';
import { ValidatorUtil } from '../utils/validators.js';

export class AuthManager {
  constructor() {
    this.currentUser = null;
    this.isAuthenticated = false;
    this.sessionTimeout = 30 * 60 * 1000; // 30 minutes
    this.sessionTimer = null;
  }

  async init() {
    // Restore session if exists
    this.currentUser = StorageManager.get('currentUser');
    this.isAuthenticated = !!this.currentUser;
    
    if (this.isAuthenticated) {
      this.startSessionTimer();
      console.log('✅ Session restored for user:', this.currentUser.id);
    }
  }

  async login(email, password, userType = 'client') {
    try {
      ValidatorUtil.validateEmail(email);
      ValidatorUtil.validatePassword(password);

      // Simulate API call with timeout
      const user = await this.simulateLogin(email, password, userType);
      
      this.currentUser = user;
      this.isAuthenticated = true;
      
      // Store user data
      StorageManager.set('currentUser', user);
      StorageManager.set('userType', userType);
      StorageManager.set('lastLoginTime', new Date().toISOString());
      
      this.startSessionTimer();
      
      console.log('✅ User logged in:', user.id);
      return { success: true, user };
    } catch (error) {
      console.error('❌ Login failed:', error.message);
      return { success: false, error: error.message };
    }
  }

  async register(userData) {
    try {
      ValidatorUtil.validateEmail(userData.email);
      ValidatorUtil.validatePassword(userData.password);
      
      if (!userData.name || userData.name.trim().length < 2) {
        throw new Error('Name must be at least 2 characters');
      }

      // Simulate API call
      const newUser = await this.simulateRegister(userData);
      
      // Auto login after registration
      this.currentUser = newUser;
      this.isAuthenticated = true;
      
      StorageManager.set('currentUser', newUser);
      StorageManager.set('userType', userData.userType || 'client');
      
      this.startSessionTimer();
      
      console.log('✅ User registered and logged in:', newUser.id);
      return { success: true, user: newUser };
    } catch (error) {
      console.error('❌ Registration failed:', error.message);
      return { success: false, error: error.message };
    }
  }

  async logout() {
    try {
      this.currentUser = null;
      this.isAuthenticated = false;
      
      StorageManager.remove('currentUser');
      StorageManager.remove('userType');
      StorageManager.remove('sessionToken');
      
      this.clearSessionTimer();
      
      console.log('✅ User logged out');
      window.dispatchEvent(new CustomEvent('user-logged-out'));
      
      return { success: true };
    } catch (error) {
      console.error('❌ Logout failed:', error.message);
      return { success: false, error: error.message };
    }
  }

  validateSession() {
    if (!this.isAuthenticated) return false;
    
    const lastLogin = StorageManager.get('lastLoginTime');
    const now = new Date().getTime();
    const loginTime = new Date(lastLogin).getTime();
    
    if (now - loginTime > this.sessionTimeout) {
      this.logout();
      return false;
    }
    
    // Reset timer
    this.clearSessionTimer();
    this.startSessionTimer();
    
    return true;
  }

  startSessionTimer() {
    this.clearSessionTimer();
    this.sessionTimer = setTimeout(() => {
      console.warn('⚠️ Session expired');
      this.logout();
      window.dispatchEvent(new CustomEvent('session-expired'));
    }, this.sessionTimeout);
  }

  clearSessionTimer() {
    if (this.sessionTimer) {
      clearTimeout(this.sessionTimer);
      this.sessionTimer = null;
    }
  }

  isUserType(type) {
    return StorageManager.get('userType') === type;
  }

  getCurrentUser() {
    return this.currentUser;
  }

  updateProfile(updates) {
    if (!this.currentUser) throw new Error('No user logged in');
    
    this.currentUser = { ...this.currentUser, ...updates };
    StorageManager.set('currentUser', this.currentUser);
    
    console.log('✅ Profile updated');
    return this.currentUser;
  }

  // Simulated API calls
  async simulateLogin(email, password, userType) {
    return new Promise((resolve) => {
      setTimeout(() => {
        // Demo users for testing
        const demoUsers = {
          'client@kazipoa.tz': {
            id: 'USR_client001',
            email: 'client@kazipoa.tz',
            name: 'John Mwangi',
            userType: 'client',
            phone: '+255712345678',
            avatar: '👨‍💼',
            createdAt: new Date(2025, 0, 15).toISOString(),
            isVerified: true,
            credits: 500, // TZS Credits
          },
          'pro@kazipoa.tz': {
            id: 'USR_pro001',
            email: 'pro@kazipoa.tz',
            name: 'Maria Baraza',
            userType: 'professional',
            phone: '+255723456789',
            avatar: '💇‍♀️',
            createdAt: new Date(2025, 1, 10).toISOString(),
            isVerified: true,
            rating: 4.8,
            reviewCount: 127,
            specialization: 'Hair Styling',
          },
        };

        // Check if demo user exists
        if (demoUsers[email] && password === 'Demo@2026') {
          resolve(demoUsers[email]);
        } else if (email && password) {
          // Allow any email/password for testing
          const user = {
            id: 'USR_' + Math.random().toString(36).substr(2, 9),
            email,
            name: email.split('@')[0].charAt(0).toUpperCase() + email.split('@')[0].slice(1),
            userType,
            createdAt: new Date().toISOString(),
            isVerified: true,
            phone: '',
            avatar: userType === 'professional' ? '👨‍🔧' : '👤',
          };
          resolve(user);
        } else {
          resolve(null);
        }
      }, 800);
    });
  }

  async simulateRegister(userData) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const user = {
          id: 'USR_' + Math.random().toString(36).substr(2, 9),
          email: userData.email,
          name: userData.name,
          userType: userData.userType || 'client',
          phone: userData.phone || '',
          createdAt: new Date().toISOString(),
          isVerified: false,
          avatar: userData.userType === 'professional' ? '👨‍🔧' : '👤',
        };
        resolve(user);
      }, 1000);
    });
  }
}
