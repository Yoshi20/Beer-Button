import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = [ "..." ]

  // connect() {
  // }

  newOrderTargetConnected(t) {
    t.classList.add("fadeIn");
  }

  close(e) {
    /* Show fadeOut before submitting */
    e.preventDefault();
    let btn = e.target;
    let tr = btn.closest('tr');
    tr.classList.add("fadeOut");
    let form = btn.closest('form');
    setTimeout(function() {
      form.requestSubmit(); // to make use of turbo_stream
    }, 800);
  }

}
