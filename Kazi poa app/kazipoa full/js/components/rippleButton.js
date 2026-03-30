/**
 * Ripple Button Component
 * Adds ripple effect to buttons for better UX
 */

export class RippleButton {
  static init() {
    document.addEventListener('click', (e) => {
      const button = e.target.closest('button, [role="button"]');
      if (!button) return;

      const rect = button.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      this.createRipple(button, x, y);
    });
  }

  static createRipple(button, x, y) {
    // Skip if ripple effect disabled
    if (button.dataset.noRipple === 'true') return;

    const ripple = document.createElement('span');
    ripple.className = 'ripple-effect';
    ripple.style.left = x + 'px';
    ripple.style.top = y + 'px';

    // Ensure button has position relative
    const originalPosition = button.style.position;
    if (!originalPosition || originalPosition === 'static') {
      button.style.position = 'relative';
      button.style.overflow = 'hidden';
    }

    button.appendChild(ripple);

    // Remove ripple after animation
    setTimeout(() => {
      ripple.remove();
    }, 600);
  }
}
