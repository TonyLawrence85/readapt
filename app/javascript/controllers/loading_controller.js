import { Controller } from "@hotwired/stimulus"
import Typed from 'typed.js';
// Connects to data-controller="loading"
export default class extends Controller {
  connect() {
    console.log("hello");
  }

  loadingPage() {
    console.log("loading page")

    typed3 = new Typed('#typed3', {
      strings: ['My strings are: <i>strings</i> with', 'My strings are: <strong>HTML</strong>', 'My strings are: Chars &times; &copy;'],
      typeSpeed: 0,
      backSpeed: 0,
      smartBackspace: true, // this is a default
      loop: true
    });
  }
}
  