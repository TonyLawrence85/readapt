import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "img"]

  showPreview() {
    const file = this.inputTarget.files[0]
    if (!file || !file.type.startsWith("image/")) return

    this.imgTarget.src = URL.createObjectURL(file)
    this.previewTarget.hidden = false
  }
}
