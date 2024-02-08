import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = [ "..." ]

  connect() {
    console.log("blup");
  }

  close(e) {
    console.log("close");
    console.log(e);

    // let parent = e.target.parentElement;
    // if (e.target.tagName != 'BUTTON' && e.target.tagName != 'INPUT' && !parent.classList.contains('checkbox')) { // ignore buttons and inputs
    //   let tr = e.target.closest('tr');
    //   let id = tr.dataset.id;
    //   if (id !== undefined) {
    //     let component = tr.dataset.component;
    //     let path = "/" + component + "s/" + id + "/edit";
    //     if (e.button === 1) { // middle_btn
    //       let protocol_and_host = window.location.protocol + '//' + window.location.host;
    //       return window.open(protocol_and_host + path, '_blank');
    //     } else {
    //       return window.location.href = path;
    //     }
    //   }
    // }
  }

}
