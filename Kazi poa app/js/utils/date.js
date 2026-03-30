/**
 * Date Utilities
 * Helper functions for date and time operations
 */

export class DateUtil {
  static format(date, format = 'YYYY-MM-DD') {
    if (typeof date === 'string') {
      date = new Date(date);
    }

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');

    return format
      .replace('YYYY', year)
      .replace('MM', month)
      .replace('DD', day)
      .replace('HH', hours)
      .replace('mm', minutes)
      .replace('ss', seconds);
  }

  static formatTime(date, format = 'HH:mm') {
    if (typeof date === 'string') {
      date = new Date(date);
    }

    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');

    return format
      .replace('HH', hours)
      .replace('mm', minutes)
      .replace('ss', seconds);
  }

  static formatRelative(date) {
    if (typeof date === 'string') {
      date = new Date(date);
    }

    const now = new Date();
    const secondsAgo = Math.floor((now - date) / 1000);

    if (secondsAgo < 60) return 'Just now';
    if (secondsAgo < 3600) return Math.floor(secondsAgo / 60) + ' minutes ago';
    if (secondsAgo < 86400) return Math.floor(secondsAgo / 3600) + ' hours ago';
    if (secondsAgo < 604800) return Math.floor(secondsAgo / 86400) + ' days ago';

    return this.format(date);
  }

  static isToday(date) {
    if (typeof date === 'string') {
      date = new Date(date);
    }

    const today = new Date();
    return date.toDateString() === today.toDateString();
  }

  static isFuture(date) {
    if (typeof date === 'string') {
      date = new Date(date);
    }

    return date > new Date();
  }

  static isPast(date) {
    if (typeof date === 'string') {
      date = new Date(date);
    }

    return date < new Date();
  }

  static addDays(date, days) {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
  }

  static addHours(date, hours) {
    const result = new Date(date);
    result.setHours(result.getHours() + hours);
    return result;
  }

  static getDayName(date) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    if (typeof date === 'string') {
      date = new Date(date);
    }
    return days[date.getDay()];
  }

  static getMonthName(date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    if (typeof date === 'string') {
      date = new Date(date);
    }
    return months[date.getMonth()];
  }

  static getDifference(date1, date2, unit = 'days') {
    if (typeof date1 === 'string') date1 = new Date(date1);
    if (typeof date2 === 'string') date2 = new Date(date2);

    const ms = Math.abs(date2 - date1);

    switch (unit) {
      case 'seconds': return Math.floor(ms / 1000);
      case 'minutes': return Math.floor(ms / 60000);
      case 'hours': return Math.floor(ms / 3600000);
      case 'days': return Math.floor(ms / 86400000);
      default: return ms;
    }
  }
}
