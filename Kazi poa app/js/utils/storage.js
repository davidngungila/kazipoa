/**
 * Storage Manager
 * Unified interface for localStorage and sessionStorage
 */

export class StorageManager {
  static PREFIX = 'kazipoa_';

  static set(key, value, useSession = false) {
    try {
      const fullKey = this.PREFIX + key;
      const serialized = JSON.stringify(value);
      
      if (useSession) {
        sessionStorage.setItem(fullKey, serialized);
      } else {
        localStorage.setItem(fullKey, serialized);
      }
      
      console.log(`💾 Stored: ${key}`);
    } catch (error) {
      console.error('❌ Storage error:', error.message);
    }
  }

  static get(key, useSession = false) {
    try {
      const fullKey = this.PREFIX + key;
      const storage = useSession ? sessionStorage : localStorage;
      const serialized = storage.getItem(fullKey);
      
      if (serialized === null) return null;
      
      return JSON.parse(serialized);
    } catch (error) {
      console.error('❌ Storage retrieval error:', error.message);
      return null;
    }
  }

  static remove(key, useSession = false) {
    try {
      const fullKey = this.PREFIX + key;
      
      if (useSession) {
        sessionStorage.removeItem(fullKey);
      } else {
        localStorage.removeItem(fullKey);
      }
      
      console.log(`🗑️ Removed: ${key}`);
    } catch (error) {
      console.error('❌ Storage removal error:', error.message);
    }
  }

  static clear(useSession = false) {
    try {
      const storage = useSession ? sessionStorage : localStorage;
      const keys = Object.keys(storage);
      
      keys.forEach(key => {
        if (key.startsWith(this.PREFIX)) {
          storage.removeItem(key);
        }
      });
      
      console.log('🗑️ Storage cleared');
    } catch (error) {
      console.error('❌ Storage clear error:', error.message);
    }
  }

  static keys(useSession = false) {
    try {
      const storage = useSession ? sessionStorage : localStorage;
      return Object.keys(storage)
        .filter(key => key.startsWith(this.PREFIX))
        .map(key => key.replace(this.PREFIX, ''));
    } catch (error) {
      console.error('❌ Storage keys error:', error.message);
      return [];
    }
  }

  static exist(key, useSession = false) {
    const fullKey = this.PREFIX + key;
    const storage = useSession ? sessionStorage : localStorage;
    return storage.getItem(fullKey) !== null;
  }
}
