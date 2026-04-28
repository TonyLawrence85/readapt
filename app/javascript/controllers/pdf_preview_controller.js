import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "container", "embed"]
  
  showPreview() {
    const file = this.inputTarget.files[0]
    if (!file || file.type !== "application/pdf") return

    this.embedTarget.src = URL.createObjectURL(file)
    this.containerTarget.hidden = false
  }
}
