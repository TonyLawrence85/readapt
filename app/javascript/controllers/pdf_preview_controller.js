import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "container", "embed", "fallback"]

  showPreview() {
    const file = this.inputTarget.files[0]
    if (!file || file.type !== "application/pdf") return

    this.containerTarget.hidden = false

    if (this.#isMobile()) {
      this.embedTarget.hidden = true
      this.fallbackTarget.hidden = false
      this.fallbackTarget.textContent = `${file.name} — ${this.#formatSize(file.size)}`
    } else {
      this.embedTarget.src = URL.createObjectURL(file)
      this.embedTarget.hidden = false
      this.fallbackTarget.hidden = true
    }
  }

  #isMobile() {
    return /iPhone|iPad|iPod|Android/i.test(navigator.userAgent)
  }

  #formatSize(bytes) {
    return (bytes / 1024 / 1024).toFixed(1) + " Mo"
  }
}
