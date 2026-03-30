/**
 * Validator Utilities
 * Form validation and data validation helpers
 */

export class ValidatorUtil {
  static validateEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email || !regex.test(email)) {
      throw new Error('Invalid email format');
    }
    return true;
  }

  static validatePassword(password) {
    if (!password || password.length < 8) {
      throw new Error('Password must be at least 8 characters');
    }
    
    if (!/[A-Z]/.test(password)) {
      throw new Error('Password must contain at least one uppercase letter');
    }
    
    if (!/[0-9]/.test(password)) {
      throw new Error('Password must contain at least one number');
    }
    
    return true;
  }

  static validatePhone(phone) {
    const regex = /^[+]?[\d\s-()]+$/;
    if (!phone || !regex.test(phone)) {
      throw new Error('Invalid phone format');
    }
    return true;
  }

  static validateName(name) {
    if (!name || name.trim().length < 2) {
      throw new Error('Name must be at least 2 characters');
    }
    return true;
  }

  static validateURL(url) {
    try {
      new URL(url);
      return true;
    } catch {
      throw new Error('Invalid URL');
    }
  }

  static validateDate(date) {
    const dateObj = new Date(date);
    if (isNaN(dateObj.getTime())) {
      throw new Error('Invalid date');
    }
    return true;
  }

  static validateTime(time) {
    const regex = /^([01]\d|2[0-3]):[0-5]\d$/;
    if (!time || !regex.test(time)) {
      throw new Error('Invalid time format (HH:MM)');
    }
    return true;
  }

  static validateNumber(value, min, max) {
    const num = parseFloat(value);
    
    if (isNaN(num)) {
      throw new Error('Must be a valid number');
    }
    
    if (min !== undefined && num < min) {
      throw new Error(`Must be at least ${min}`);
    }
    
    if (max !== undefined && num > max) {
      throw new Error(`Must be at most ${max}`);
    }
    
    return true;
  }

  static validateLength(value, min, max) {
    const len = String(value).length;
    
    if (min !== undefined && len < min) {
      throw new Error(`Must be at least ${min} characters`);
    }
    
    if (max !== undefined && len > max) {
      throw new Error(`Must be at most ${max} characters`);
    }
    
    return true;
  }

  static validateRequired(value) {
    if (!value || (typeof value === 'string' && value.trim().length === 0)) {
      throw new Error('This field is required');
    }
    return true;
  }

  static validateMatch(value1, value2) {
    if (value1 !== value2) {
      throw new Error('Values do not match');
    }
    return true;
  }

  static validateFileSize(file, maxSizeMB) {
    const maxBytes = maxSizeMB * 1024 * 1024;
    if (file.size > maxBytes) {
      throw new Error(`File size must be less than ${maxSizeMB}MB`);
    }
    return true;
  }

  static validateFileType(file, allowedTypes) {
    if (!allowedTypes.includes(file.type)) {
      throw new Error(`File type must be one of: ${allowedTypes.join(', ')}`);
    }
    return true;
  }
}

/**
 * Form Validator Class
 * Validate entire forms with rules
 */
export class FormValidator {
  constructor(rules = {}) {
    this.rules = rules;
    this.errors = {};
  }

  validate(data) {
    this.errors = {};
    let isValid = true;

    for (const [field, fieldRules] of Object.entries(this.rules)) {
      const value = data[field];

      for (const rule of fieldRules) {
        try {
          this.executeRule(rule, value, data);
        } catch (error) {
          isValid = false;
          if (!this.errors[field]) {
            this.errors[field] = [];
          }
          this.errors[field].push(error.message);
        }
      }
    }

    return isValid;
  }

  executeRule(rule, value, data) {
    if (typeof rule === 'string') {
      switch (rule) {
        case 'required':
          ValidatorUtil.validateRequired(value);
          break;
        case 'email':
          ValidatorUtil.validateEmail(value);
          break;
        default:
          console.warn('Unknown rule:', rule);
      }
    } else if (typeof rule === 'object') {
      // Handle complex rules
      if (rule.type === 'min') {
        ValidatorUtil.validateLength(value, rule.value);
      } else if (rule.type === 'max') {
        ValidatorUtil.validateLength(value, undefined, rule.value);
      } else if (rule.type === 'pattern') {
        if (!rule.pattern.test(value)) {
          throw new Error(rule.message || 'Invalid format');
        }
      } else if (rule.type === 'custom') {
        if (!rule.validator(value, data)) {
          throw new Error(rule.message || 'Validation failed');
        }
      }
    } else if (typeof rule === 'function') {
      if (!rule(value, data)) {
        throw new Error('Validation failed');
      }
    }
  }

  getErrors() {
    return this.errors;
  }

  hasErrors() {
    return Object.keys(this.errors).length > 0;
  }

  getError(field) {
    return this.errors[field] || null;
  }

  clear() {
    this.errors = {};
  }
}
