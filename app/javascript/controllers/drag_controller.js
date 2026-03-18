import { Controller } from "@hotwired/stimulus"

// HTML5 Drag & Drop controller for moving tasks between columns
//
// The column container is the drop zone. Individual task cards are draggable.
// On drop, it submits a PATCH request to the move action via fetch with Turbo Stream.
//
// Usage (on the column's task container):
//   <div data-controller="drag"
//        data-drag-board-id-value="1"
//        data-drag-column-id-value="2">
//     <div data-drag-target="item" data-task-id="3" draggable="true">...</div>
//   </div>
export default class extends Controller {
  static targets = ["item"]
  static values = { boardId: Number, columnId: Number }

  connect() {
    this.element.addEventListener("dragover", this.dragOver.bind(this))
    this.element.addEventListener("drop", this.drop.bind(this))
    this.element.addEventListener("dragenter", this.dragEnter.bind(this))
    this.element.addEventListener("dragleave", this.dragLeave.bind(this))
  }

  // Called on each draggable item via Stimulus target connection
  itemTargetConnected(element) {
    element.addEventListener("dragstart", this.dragStart.bind(this))
  }

  dragStart(event) {
    event.dataTransfer.setData("text/plain", JSON.stringify({
      taskId: event.target.dataset.taskId,
      sourceColumnId: this.columnIdValue
    }))
    event.dataTransfer.effectAllowed = "move"
    event.target.style.opacity = "0.5"
    setTimeout(() => { event.target.style.opacity = "1" }, 0)
  }

  dragOver(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
  }

  dragEnter(event) {
    event.preventDefault()
    this.element.classList.add("bg-blue-50")
  }

  dragLeave(event) {
    // Only remove highlight if we actually left the container
    if (!this.element.contains(event.relatedTarget)) {
      this.element.classList.remove("bg-blue-50")
    }
  }

  async drop(event) {
    event.preventDefault()
    this.element.classList.remove("bg-blue-50")

    const data = JSON.parse(event.dataTransfer.getData("text/plain"))
    const { taskId, sourceColumnId } = data

    // Don't do anything if dropped in the same column
    if (parseInt(sourceColumnId) === this.columnIdValue) return

    const url = `/boards/${this.boardIdValue}/columns/${sourceColumnId}/tasks/${taskId}/move`
    const csrfToken = document.querySelector("meta[name='csrf-token']").content

    const response = await fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "X-CSRF-Token": csrfToken,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: `target_column_id=${this.columnIdValue}`
    })

    if (response.ok) {
      const html = await response.text()
      Turbo.renderStreamMessage(html)
    }
  }
}
