import { Controller } from "@hotwired/stimulus"
import * as pdfjsLib from "pdfjs-dist"

pdfjsLib.GlobalWorkerOptions.workerSrc = "/pdfjs/build/pdf.worker.mjs"

export default class extends Controller {
  static targets = ["container", "canvas"]

  async showPreview(event) {
    const file = event.target.files[0]
    if (!file) return

    const buffer = await file.arrayBuffer()
    const pdf = await pdfjsLib.getDocument({ data: buffer }).promise
    const page = await pdf.getPage(1)

    this.containerTarget.hidden = false

    const viewport = page.getViewport({ scale: 1.5 })
    this.canvasTarget.width = viewport.width
    this.canvasTarget.height = viewport.height

    await page.render({
      canvasContext: this.canvasTarget.getContext("2d"),
      viewport
    }).promise
  }
}
