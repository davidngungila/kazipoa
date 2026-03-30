/**
 * Profile Manager
 * Handles user profile management and settings
 */

import { StorageManager } from '../utils/storage.js';

export class ProfileManager {
  constructor() {
    this.userProfile = null;
    this.settings = {};
  }

  async init() {
    // Load profile and settings from storage
    this.userProfile = StorageManager.get('userProfile') || {};
    this.settings = StorageManager.get('userSettings') || this.getDefaultSettings();
    
    console.log('👤 Profile manager initialized');
  }

  updateProfile(updates) {
    try {
      this.userProfile = { ...this.userProfile, ...updates };
      StorageManager.set('userProfile', this.userProfile);
      
      console.log('✅ Profile updated');
      window.dispatchEvent(new CustomEvent('profile-updated', { detail: this.userProfile }));
      
      return { success: true, profile: this.userProfile };
    } catch (error) {
      console.error('❌ Failed to update profile:', error.message);
      return { success: false, error: error.message };
    }
  }

  updateSettings(updates) {
    try {
      this.settings = { ...this.settings, ...updates };
      StorageManager.set('userSettings', this.settings);
      
      console.log('✅ Settings updated');
      window.dispatchEvent(new CustomEvent('settings-updated', { detail: this.settings }));
      
      return { success: true, settings: this.settings };
    } catch (error) {
      console.error('❌ Failed to update settings:', error.message);
      return { success: false, error: error.message };
    }
  }

  uploadProfilePicture(file) {
    try {
      if (!file.type.startsWith('image/')) {
        throw new Error('File must be an image');
      }

      if (file.size > 5 * 1024 * 1024) {
        throw new Error('Image must be less than 5MB');
      }

      // Simulate file upload
      const reader = new FileReader();
      reader.onload = (e) => {
        this.userProfile.profilePicture = e.target.result;
        StorageManager.set('userProfile', this.userProfile);
        window.dispatchEvent(new CustomEvent('profile-picture-updated'));
      };
      reader.readAsDataURL(file);

      return { success: true };
    } catch (error) {
      console.error('❌ Upload failed:', error.message);
      return { success: false, error: error.message };
    }
  }

  getProfile() {
    return this.userProfile;
  }

  getSettings() {
    return this.settings;
  }

  getSetting(key) {
    return this.settings[key];
  }

  getDefaultSettings() {
    return {
      theme: 'light',
      language: 'sw',
      notifications: {
        email: true,
        sms: true,
        push: true,
      },
      privacy: {
        showProfile: true,
        allowMessages: true,
      },
      twoFactorEnabled: false,
    };
  }

  resetPassword(currentPassword, newPassword) {
    try {
      // Validation would happen on server
      if (!newPassword || newPassword.length < 8) {
        throw new Error('Password must be at least 8 characters');
      }

      // Simulate API call
      console.log('🔐 Password reset initiated');
      return { success: true };
    } catch (error) {
      console.error('❌ Password reset failed:', error.message);
      return { success: false, error: error.message };
    }
  }
}
