import { Controller } from "@hotwired/stimulus"

// Auto-dismisses flash messages after 3 seconds with a fade-out effect
//
// Usage:
//   <div data-controller="auto-dismiss">Flash message here</div>
export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => {
      this.element.style.opacity = "0"
      setTimeout(() => this.element.remove(), 300)
    }, 3000)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}
