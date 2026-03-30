/**
 * DOM Utilities
 * Helper functions for DOM manipulation
 */

export class DOMUtil {
  static getElementById(id) {
    return document.getElementById(id);
  }

  static querySelector(selector) {
    return document.querySelector(selector);
  }

  static querySelectorAll(selector) {
    return document.querySelectorAll(selector);
  }

  static createElement(tag, attributes = {}, content = '') {
    const element = document.createElement(tag);
    
    Object.entries(attributes).forEach(([key, value]) => {
      if (key === 'class') {
        element.className = value;
      } else if (key === 'style' && typeof value === 'object') {
        Object.assign(element.style, value);
      } else if (key === 'data') {
        Object.entries(value).forEach(([dataKey, dataValue]) => {
          element.dataset[dataKey] = dataValue;
        });
      } else {
        element.setAttribute(key, value);
      }
    });

    if (content) {
      element.innerHTML = content;
    }

    return element;
  }

  static appendChild(parent, child) {
    if (typeof parent === 'string') {
      parent = document.querySelector(parent);
    }

    if (Array.isArray(child)) {
      child.forEach(c => parent.appendChild(c));
    } else {
      parent.appendChild(child);
    }
  }

  static setHTML(element, html) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }
    
    element.innerHTML = html;
  }

  static setText(element, text) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }
    
    element.textContent = text;
  }

  static addClass(element, className) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }
    
    if (Array.isArray(className)) {
      element.classList.add(...className);
    } else {
      element.classList.add(className);
    }
  }

  static removeClass(element, className) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }
    
    if (Array.isArray(className)) {
      element.classList.remove(...className);
    } else {
      element.classList.remove(className);
    }
  }

  static toggleClass(element, className) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }
    
    element.classList.toggle(className);
  }

  static hasClass(element, className) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }
    
    return element.classList.contains(className);
  }

  static setAttributes(element, attributes) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }

    Object.entries(attributes).forEach(([key, value]) => {
      if (value === null) {
        element.removeAttribute(key);
      } else {
        element.setAttribute(key, value);
      }
    });
  }

  static on(element, event, handler, options = {}) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }

    element.addEventListener(event, handler, options);
  }

  static off(element, event, handler) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }

    element.removeEventListener(event, handler);
  }

  static ready(callback) {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', callback);
    } else {
      callback();
    }
  }

  static remove(element) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }

    if (element) {
      element.remove();
    }
  }

  static hide(element) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }

    element.style.display = 'none';
  }

  static show(element) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }

    element.style.display = '';
  }

  static isVisible(element) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }

    return element && element.offsetParent !== null;
  }

  static scrollIntoView(element, smooth = true) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }

    element.scrollIntoView({ behavior: smooth ? 'smooth' : 'auto' });
  }

  static getOffset(element) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }

    const rect = element.getBoundingClientRect();
    return {
      top: rect.top + window.scrollY,
      left: rect.left + window.scrollX,
      width: rect.width,
      height: rect.height,
    };
  }

  static delegateEvent(parent, selector, event, handler) {
    if (typeof parent === 'string') {
      parent = document.querySelector(parent);
    }

    parent.addEventListener(event, (e) => {
      if (e.target.matches(selector)) {
        handler.call(e.target, e);
      }
    });
  }
}
