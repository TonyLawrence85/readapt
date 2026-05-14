import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["titleError"]

  connect() {
    document.querySelector('.frame').style.display = 'none'
  }

  loadingPage(event) {
    const form = event.target.closest('form')
    const titleInput = form?.querySelector('input[name*="[title]"]')

    if (titleInput && titleInput.value.trim() === '') {
      event.preventDefault()
      titleInput.classList.add('form-input--error')
      titleInput.focus()
      if (this.hasTitleErrorTarget) this.titleErrorTarget.hidden = false
      return
    }

    if (titleInput) titleInput.classList.remove('form-input--error')
    if (this.hasTitleErrorTarget) this.titleErrorTarget.hidden = true

    document.querySelector('.frame').style.display = 'block'
    typed3 = new Typed('#typed3', {
      strings: ['Chargement des paramètres: <strong>sur la couleur</strong>', 'Chargement des paramètres: <strong>la taille</strong>', 'Chargement des paramètres: <strong>espacement</strong>;'],
      typeSpeed: 50,
      backSpeed: 25,
      smartBackspace: true,
      loop: true
    })
  }
}
