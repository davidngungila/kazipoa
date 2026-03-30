/**
 * Theme Manager
 * Handles dark/light theme switching and persistence
 */

import { StorageManager } from '../utils/storage.js';

export class ThemeManager {
  constructor() {
    this.currentTheme = 'light';
    this.themes = ['light', 'dark'];
  }

  async init() {
    // Get saved theme or system preference
    this.currentTheme = StorageManager.get('theme') || this.getSystemTheme();
    this.applyTheme(this.currentTheme);
    
    // Listen for system theme changes
    if (window.matchMedia) {
      window.matchMedia('(prefers-color-scheme: dark)').addListener((e) => {
        if (!StorageManager.get('theme')) {
          this.applyTheme(e.matches ? 'dark' : 'light');
        }
      });
    }

    console.log('🎨 Theme manager initialized:', this.currentTheme);
  }

  getSystemTheme() {
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }
    return 'light';
  }

  applyTheme(theme) {
    if (!this.themes.includes(theme)) {
      console.warn('⚠️ Invalid theme:', theme);
      return;
    }

    this.currentTheme = theme;
    const htmlElement = document.documentElement;

    if (theme === 'dark') {
      htmlElement.classList.add('dark');
    } else {
      htmlElement.classList.remove('dark');
    }

    StorageManager.set('theme', theme);
    window.dispatchEvent(new CustomEvent('theme-changed', { detail: { theme } }));
    
    console.log('✅ Theme applied:', theme);
  }

  toggleTheme() {
    const newTheme = this.currentTheme === 'light' ? 'dark' : 'light';
    this.applyTheme(newTheme);
    return newTheme;
  }

  getCurrentTheme() {
    return this.currentTheme;
  }

  isDarkMode() {
    return this.currentTheme === 'dark';
  }
}
