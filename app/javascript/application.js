console.log("application.js");//blup
// Entry point for the build script in your package.json

// beercss@3.0.8
import "beercss/dist/cdn/beer.min.js"

import "@hotwired/turbo-rails"
import "./controllers"

// PWA
import "./custom/companion"

// fix for beercss forms with hotwire
document.addEventListener("turbo:load", function (e) {
  console.log("turbo:load");//blup
  if (ui != undefined) {
    ui();
  }
})
