/**
 * Form Handler Component
 * Centralized form handling with validation and submission
 */

import { FormValidator } from '../utils/validators.js';

export class FormHandler {
  constructor(formElement, rules = {}) {
    this.form = formElement;
    this.validator = new FormValidator(rules);
    this.isSubmitting = false;
    this.init();
  }

  init() {
    this.form.addEventListener('submit', (e) => this.handleSubmit(e));
    this.setupFieldValidation();
  }

  setupFieldValidation() {
    const fields = this.form.querySelectorAll('input, textarea, select');
    
    fields.forEach(field => {
      field.addEventListener('change', () => this.validateField(field.name));
      field.addEventListener('blur', () => this.validateField(field.name));
    });
  }

  validateField(fieldName) {
    // Clear previous error
    const field = this.form.elements[fieldName];
    if (field) {
      field.classList.remove('border-red-500');
      const errorEl = field.parentElement.querySelector('.field-error');
      if (errorEl) errorEl.remove();
    }
  }

  async handleSubmit(e) {
    e.preventDefault();

    if (this.isSubmitting) return;

    const data = this.getFormData();

    // Validate
    if (!this.validator.validate(data)) {
      this.displayErrors();
      return;
    }

    this.isSubmitting = true;
    this.disableForm();

    try {
      const result = await this.onSubmit(data);
      
      if (result.success) {
        this.displaySuccess(result.message || 'Submitted successfully');
        this.form.reset();
      } else {
        this.displayError(result.error || 'Submission failed');
      }
    } catch (error) {
      this.displayError(error.message);
    } finally {
      this.isSubmitting = false;
      this.enableForm();
    }
  }

  getFormData() {
    return Object.fromEntries(new FormData(this.form));
  }

  displayErrors() {
    this.clearErrors();
    const errors = this.validator.getErrors();

    Object.entries(errors).forEach(([field, messages]) => {
      const input = this.form.elements[field];
      if (input) {
        input.classList.add('border-red-500');
        const errorEl = document.createElement('div');
        errorEl.className = 'field-error text-red-600 text-sm mt-1';
        errorEl.textContent = messages[0];
        input.parentElement.appendChild(errorEl);
      }
    });
  }

  clearErrors() {
    this.form.querySelectorAll('.field-error').forEach(el => el.remove());
    this.form.querySelectorAll('input, textarea, select').forEach(el => {
      el.classList.remove('border-red-500');
    });
  }

  displaySuccess(message) {
    console.log('✅', message);
    // Dispatch event for UI manager to show notification
    window.dispatchEvent(new CustomEvent('form-success', { detail: { message } }));
  }

  displayError(message) {
    console.error('❌', message);
    window.dispatchEvent(new CustomEvent('form-error', { detail: { message } }));
  }

  disableForm() {
    this.form.querySelectorAll('input, textarea, select, button').forEach(el => {
      el.disabled = true;
    });
  }

  enableForm() {
    this.form.querySelectorAll('input, textarea, select, button').forEach(el => {
      el.disabled = false;
    });
  }

  async onSubmit(data) {
    // Override in subclass or pass handler
    return { success: true };
  }
}
