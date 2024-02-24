import { Controller } from "@hotwired/stimulus"

var intervalID = 0;

async function isOnline() {
  if (!window.navigator.onLine) return false;
  try {
    const response = await fetch("/1pixel.png")
    return response.ok;
  } catch (err) {
    return false;
  }
}

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
      intervalID = setInterval(handleIsOnline, 1000);
    }
  }
}
