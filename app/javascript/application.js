// Entry point for the build script in your package.json

// beercss@3.0.8
import "beercss/dist/cdn/beer.min.js"

import "@hotwired/turbo-rails"
import "./controllers"

// PWA
import "./custom/companion"

// fix for beercss forms with hotwire
document.addEventListener("turbo:load", function (e) {
  if (ui != undefined) {
    ui();
  }
})




// //blup
// import { BrowserQRCodeReader } from '@zxing/library';
// const codeReader = new BrowserQRCodeReader();
// codeReader
//   .decodeFromInputVideoDevice(undefined, 'video')
//   .then((result) => {
//     // process the result
//     console.log(result.text)
//     document.getElementById('result').textContent = result.text
//     codeReader.reset(); //blup
//   })
//   .catch(err => {
//     console.error(err)
//     codeReader.reset(); //blup
//   });



// See: https://scanapp.org/html5-qrcode-docs/docs/intro
// To use Html5QrcodeScanner (more info below)
import {Html5QrcodeScanner} from "html5-qrcode";
function onScanSuccess(decodedText, decodedResult) {
  // handle the scanned code as you like, for example:
  console.log(`Code matched = ${decodedText}`, decodedResult);
}
function onScanFailure(error) {
  // handle scan failure, usually better to ignore and keep scanning.
  // for example:
  console.warn(`Code scan error = ${error}`);
}
let html5QrcodeScanner = new Html5QrcodeScanner(
  "reader",
  { fps: 10, qrbox: {width: 250, height: 250} },
  /* verbose= */ false);
html5QrcodeScanner.render(onScanSuccess, onScanFailure);
