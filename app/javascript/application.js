// Entry point for the build script in your package.json

// beercss@3.0.8
import "beercss/dist/cdn/beer.min.js"

import "@hotwired/turbo-rails"
import "./controllers"

// fix for beercss forms with hotwire
document.addEventListener("turbo:load", function (e) {
  if (ui != undefined) {
    ui();
  }
})
