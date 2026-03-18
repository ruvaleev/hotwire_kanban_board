import { Controller } from "@hotwired/stimulus"

// Counts characters in a text input and displays the count
//
// Usage:
//   <div data-controller="char-counter">
//     <textarea data-char-counter-target="input"
//               data-action="input->char-counter#count"></textarea>
//     <span data-char-counter-target="counter">0 characters</span>
//   </div>
export default class extends Controller {
  static targets = ["input", "counter"]

  connect() {
    this.count()
  }

  count() {
    const length = this.inputTarget.value.length
    this.counterTarget.textContent = `${length} character${length !== 1 ? "s" : ""}`
  }
}
