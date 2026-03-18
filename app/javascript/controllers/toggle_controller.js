import { Controller } from "@hotwired/stimulus"

// Shows/hides a content area (used for the "Add task" form toggle)
//
// Usage:
//   <div data-controller="toggle">
//     <button data-action="click->toggle#toggle" data-toggle-target="button">Show</button>
//     <div data-toggle-target="content" class="hidden">...content...</div>
//   </div>
export default class extends Controller {
  static targets = ["content", "button"]

  toggle() {
    this.contentTarget.classList.toggle("hidden")
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.toggle("hidden")
    }
  }
}
