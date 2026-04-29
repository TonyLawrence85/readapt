import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="loading"
export default class extends Controller {
  connect() {
    document.querySelector('.frame').style.display = 'none'
  }
  loadingPage() {
    document.querySelector('.frame').style.display = 'block'

    typed3 = new Typed('#typed3', {
    strings: ['Chargement des paramètres: <strong>sur la couleur</strong>', 'Chargement des paramètres: <strong>la taille</strong>', 'Chargement des paramètres: <strong>espacement</strong>;'],
    typeSpeed: 50,
    backSpeed: 25,
    smartBackspace: true, // this is a default
    loop: true
  });
  }
}
