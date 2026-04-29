import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { interval: Number, url: String, wait: String }

  connect() {
    this.timer = setInterval(() => {
      fetch(this.urlValue, { headers: { "Accept": "application/json" } })
        .then(r => r.json())
        .then(({ audio_ready, timestamps_ready }) => {
          const ready = this.waitValue === "timestamps" ? timestamps_ready : audio_ready
          if (ready) {
            clearInterval(this.timer)
            Turbo.visit(window.location.href)
          }
        })
        .catch(() => {})
    }, this.intervalValue)
  }

  disconnect() {
    clearInterval(this.timer)
  }
}
