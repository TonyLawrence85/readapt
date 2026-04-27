import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["segment", "player"]

  static values = {
    timestamps: Array
  }

  connect() {
    // On écoute l'événement "plyr:ready" qui remonte depuis plyr_controller
    this.element.addEventListener("plyr:ready", (event) => {
      this.plyrInstance = event.detail.player

      this.plyrInstance.on("timeupdate", () => {
        const currentTime = this.plyrInstance.currentTime
        this.#highlightCurrentSegment(currentTime)
      })
    })
  }
  disconnect() {
    this.plyrInstance.off("timeupdate")
  }

  #highlightCurrentSegment(currentTime) {
    this.timestampsValue.forEach((timestamp, index) => {
      const segment = this.segmentTargets[index]

      if (!segment) return
      if (currentTime >= timestamp.start && currentTime <= timestamp.end) {
        segment.classList.add("karaoke-active")
        segment.scrollIntoView({behavior: "smooth", block: "nearest" })
      } else {
        segment.classList.remove("karaoke-active")
      }
    })
  }
}
