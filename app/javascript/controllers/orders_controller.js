import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = [ "..." ]

  // connect() {
  // }

  fadeIn(e) {
    e.target.closest('tr').classList.add("fadeIn");
  }

  fadeOut(e) {
    let tr = e.target.closest('tr');
    tr.classList.add("fadeOut");
    setTimeout(function() {
      tr.remove();
    }, 800);
  }

  close(e) {
    // e.preventDefault();

  }

}
