import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { interval: Number, url: String }

  connect() {
    this.timer = setInterval(() => {
      window.location.reload()
    }, this.intervalValue)
  }

  disconnect() {
    clearInterval(this.timer)
  }
}
