/**
 * UI Manager
 * Handles UI interactions, notifications, modals, and DOM manipulation
 */

export class UIManager {
  constructor() {
    this.modals = new Map();
    this.notifications = [];
    this.isLoading = false;
  }

  async init() {
    this.setupFormHandlers();
    this.setupModalHandlers();
    this.setupNotificationHandlers();
    
    console.log('🎯 UI manager initialized');
  }

  // Notification Methods
  showNotification(message, type = 'info', duration = 3000) {
    const notification = {
      id: 'notif_' + Math.random().toString(36).substr(2, 9),
      message,
      type, // 'info', 'success', 'warning', 'error'
      duration,
    };

    this.notifications.push(notification);

    // Create DOM element
    const element = this.createNotificationElement(notification);
    document.body.appendChild(element);

    // Remove after duration
    if (duration > 0) {
      setTimeout(() => {
        element.remove();
        this.notifications = this.notifications.filter(n => n.id !== notification.id);
      }, duration);
    }

    return notification.id;
  }

  showSuccess(message, duration = 3000) {
    return this.showNotification(message, 'success', duration);
  }

  showError(message, duration = 4000) {
    return this.showNotification(message, 'error', duration);
  }

  showWarning(message, duration = 3500) {
    return this.showNotification(message, 'warning', duration);
  }

  showInfo(message, duration = 3000) {
    return this.showNotification(message, 'info', duration);
  }

  createNotificationElement(notification) {
    const container = document.createElement('div');
    container.className = `notification notification-${notification.type} fixed bottom-4 right-4 z-50 p-4 rounded-lg shadow-lg flex items-center gap-3 animate-slideIn max-w-md`;
    
    const colors = {
      success: 'bg-green-100 text-green-800 border border-green-300',
      error: 'bg-red-100 text-red-800 border border-red-300',
      warning: 'bg-yellow-100 text-yellow-800 border border-yellow-300',
      info: 'bg-blue-100 text-blue-800 border border-blue-300',
    };

    container.className = `fixed bottom-4 right-4 z-50 p-4 rounded-lg shadow-lg flex items-center gap-3 max-w-md ${colors[notification.type]}`;
    
    const icon = this.getNotificationIcon(notification.type);
    container.innerHTML = `
      <span class="material-symbols-outlined text-xl">${icon}</span>
      <p class="text-sm font-medium">${this.escapeHtml(notification.message)}</p>
      <button class="ml-auto text-xl leading-none hover:opacity-70" data-close-notification>&times;</button>
    `;

    container.querySelector('[data-close-notification]').addEventListener('click', () => {
      container.remove();
    });

    return container;
  }

  getNotificationIcon(type) {
    const icons = {
      success: 'check_circle',
      error: 'error',
      warning: 'warning',
      info: 'info',
    };
    return icons[type] || 'info';
  }

  // Modal Methods
  showModal(id, title, content, options = {}) {
    const modal = {
      id,
      title,
      content,
      actions: options.actions || [],
      closeable: options.closeable !== false,
    };

    this.modals.set(id, modal);
    const element = this.createModalElement(modal);
    document.body.appendChild(element);

    return element;
  }

  closeModal(id) {
    const element = document.getElementById(`modal-${id}`);
    if (element) {
      element.remove();
      this.modals.delete(id);
    }
  }

  createModalElement(modal) {
    const wrapper = document.createElement('div');
    wrapper.id = `modal-${modal.id}`;
    wrapper.className = 'fixed inset-0 bg-black/50 z-40 flex items-center justify-center p-4 animate-fadeIn';

    const content = document.createElement('div');
    content.className = 'bg-white dark:bg-slate-800 rounded-lg shadow-xl max-w-md w-full animate-slideUp';
    
    content.innerHTML = `
      <div class="p-6">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-lg font-bold">${this.escapeHtml(modal.title)}</h2>
          ${modal.closeable ? '<button class="text-2xl leading-none hover:opacity-70" data-close-modal>&times;</button>' : ''}
        </div>
        <div class="mb-6 text-sm text-slate-600 dark:text-slate-300">
          ${modal.content}
        </div>
        <div class="flex gap-3 justify-end">
          ${modal.actions.map(action => `
            <button class="px-4 py-2 rounded-lg font-medium transition-colors ${action.primary ? 'bg-primary text-white hover:bg-primary/90' : 'bg-slate-100 dark:bg-slate-700 text-slate-900 dark:text-white hover:bg-slate-200'}" data-action="${action.id}">
              ${this.escapeHtml(action.label)}
            </button>
          `).join('')}
        </div>
      </div>
    `;

    wrapper.appendChild(content);

    // Event listeners
    if (modal.closeable) {
      wrapper.querySelector('[data-close-modal]').addEventListener('click', () => this.closeModal(modal.id));
      wrapper.addEventListener('click', (e) => {
        if (e.target === wrapper) this.closeModal(modal.id);
      });
    }

    modal.actions.forEach(action => {
      const btn = content.querySelector(`[data-action="${action.id}"]`);
      if (btn && action.handler) {
        btn.addEventListener('click', action.handler);
      }
    });

    return wrapper;
  }

  // Loading Methods
  showLoading(message = 'Loading...') {
    this.isLoading = true;
    
    const loader = document.createElement('div');
    loader.id = 'app-loader';
    loader.className = 'fixed inset-0 bg-black/30 z-50 flex items-center justify-center';
    loader.innerHTML = `
      <div class="bg-white dark:bg-slate-800 rounded-lg p-8 flex flex-col items-center gap-4">
        <div class="w-12 h-12 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
        <p class="text-sm font-medium text-slate-700 dark:text-slate-300">${this.escapeHtml(message)}</p>
      </div>
    `;
    
    document.body.appendChild(loader);
  }

  hideLoading() {
    this.isLoading = false;
    const loader = document.getElementById('app-loader');
    if (loader) loader.remove();
  }

  // Form Methods
  setupFormHandlers() {
    document.addEventListener('submit', async (e) => {
      if (e.target.hasAttribute('data-form-handler')) {
        e.preventDefault();
        
        const formType = e.target.dataset.formHandler;
        const formData = new FormData(e.target);
        const data = Object.fromEntries(formData);

        console.log(`📋 Form submitted: ${formType}`);
        window.dispatchEvent(new CustomEvent('form-submitted', { detail: { type: formType, data } }));
      }
    });
  }

  setupModalHandlers() {
    document.addEventListener('click', (e) => {
      const modalBtn = e.target.closest('[data-modal]');
      if (modalBtn) {
        const modalId = modalBtn.dataset.modal;
        // Modal would be shown based on implementation
        console.log('Modal requested:', modalId);
      }
    });
  }

  setupNotificationHandlers() {
    // Handled in init
  }

  // Utility Methods
  escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  setFormErrors(form, errors) {
    // Clear previous errors
    form.querySelectorAll('.form-error').forEach(el => el.remove());

    // Add new errors
    Object.entries(errors).forEach(([field, message]) => {
      const input = form.elements[field];
      if (input) {
        const errorEl = document.createElement('div');
        errorEl.className = 'form-error text-red-600 text-sm mt-1';
        errorEl.textContent = message;
        input.parentElement.appendChild(errorEl);
        input.classList.add('border-red-500');
      }
    });
  }

  clearFormErrors(form) {
    form.querySelectorAll('.form-error').forEach(el => el.remove());
    form.querySelectorAll('input, textarea, select').forEach(el => {
      el.classList.remove('border-red-500');
    });
  }

  getFormData(form) {
    return Object.fromEntries(new FormData(form));
  }

  resetForm(form) {
    form.reset();
    this.clearFormErrors(form);
  }

  disableForm(form, disable = true) {
    form.querySelectorAll('input, textarea, select, button').forEach(el => {
      el.disabled = disable;
    });
  }

  scrollToElement(element, behavior = 'smooth') {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }
    
    if (element) {
      element.scrollIntoView({ behavior, block: 'center' });
    }
  }

  toggleClass(element, className) {
    if (typeof element === 'string') {
      element = document.querySelector(element);
    }
    
    if (element) {
      element.classList.toggle(className);
    }
  }
}
