import { Controller } from "@hotwired/stimulus"
// Connects to data-controller="loading"
export default class extends Controller {
  connect() {
    console.log("hello");
  }
  loadingPage() {
    console.log("loading page")

    typed6 = new Typed('#typed6', {
    strings: ['Je rephrase le texte en phrase plus courte...\n `Chargement des settings..` ^1000 \n Changement de police d\'écriture`\n`Ajout des couleurs...` ^1000 \n `Ajout des espacements`\n `Modification de la taille`\n `Création du texte en audio...`'],
    typeSpeed: 100,
    backSpeed: 0,
    loop: true
  });
  }
}
