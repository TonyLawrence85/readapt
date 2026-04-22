import { Controller} from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["menu", "overlay"]
  open() {
    this.menuTarget.classList.add("slide-menu-drawer--open")
    this.overlayTarget.classList.add("overlay--visible")
  }

  close() {
    this.menuTarget.classList.remove("slide-menu-drawer--open")
    this.overlayTarget.classList.remove("overlay--visible")
  }
}
