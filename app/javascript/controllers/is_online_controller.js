import { Controller } from "@hotwired/stimulus"

import { isOnline } from "../global/is_online"

var intervalID = 0;

async function handleIsOnline() {
  const dot = document.getElementById('is-online-dot');
  const text = document.getElementById('is-online-text');
  const online = await isOnline();
  //console.log('online =', online);
  if (online) {
    dot.style.color = 'chartreuse';
    text.innerHTML = 'online';
  } else {
    dot.style.color = 'red';
    text.innerHTML = 'offline';
  }
}

export default class extends Controller {
  // static targets = [ "..." ]

  connect() {
    /* Start timer if required */
    if (intervalID == 0) { // must only be started the very first time
      handleIsOnline(); // first interval call
      intervalID = setInterval(handleIsOnline, 3000);
    }
  }
}
