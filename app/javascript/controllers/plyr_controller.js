import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["audio"]

  connect() {
    this.player = new window.Plyr(this.audioTarget, {
      controls: [
        "play",
        "rewind",
        "fast-forward",
        "progress",
        "current-time",
        "duration",
        "mute",
        "volume",
        "settings",
        "airplay"
      ],

      settings: ["speed"],

      speed: {
        selected: 1,
        options: [0.75, 1, 1.5]
      },

      seekTime: 2,

      i18n: {
        play: "Lecture",
        pause: "Pause",
        rewind: "Reculer de 10s",
        fastForward: "Avancer de 2s",
        mute: "Couper le son",
        unmute: "Rétablir le son",
        settings: "Paramètres",
        speed: "Vitesse"
      }
    })

    this.element.dispatchEvent(new CustomEvent("plyr:ready", {
    detail: { player: this.player },
    bubbles: true
    }))
  }

  disconnect() {
    this.player.destroy()
  }
}
