import { Controller } from "@hotwired/stimulus"
import { Html5Qrcode, Html5QrcodeSupportedFormats, Html5QrcodeScanType } from "html5-qrcode";

/* See: https://github.com/mebjas/html5-qrcode
 * haml target example:
  .qr-code-scanner{data: { controller: 'qr_code_scanner'}}
    #qr-code-reader{style: 'width: 400px; left: 50%; transform: translateX(-50%);'}
    = button_tag('Scan QR-Code', id: 'qr-code-reader-btn-start', style: 'height: 40px;', data: {action: 'click->qr_code_scanner#start'})
    = button_tag('Stop scanning', id: 'qr-code-reader-btn-stop', style: 'display: none; height: 40px;', data: {action: 'click->qr_code_scanner#stop'})
    #qr-code-reader-result{style: 'margin-top: 1rem;'}
 */

let html5QrCode = undefined;
let started = false;

function stop() {
  if (started) {
    html5QrCode.stop().then((ignore) => {
      started = false;
      document.getElementById('qr-code-reader-btn-start').style.display = 'initial';
      document.getElementById('qr-code-reader-btn-stop').style.display = 'none';
    }).catch((err) => {
      console.alert('stopping QR code scanner failed!')
    });
  }
}

export default class extends Controller {
  // static targets = [ "..." ]

  connect() {
    // // check compatibility
    // if (!("BarcodeDetector" in globalThis)) {
    //   console.log("Barcode Detector is not supported by this browser.");
    // } else {
    //   console.log("Barcode Detector supported!");
    // }
  }

  start() {
    if (!started) {
      html5QrCode = new Html5Qrcode("qr-code-reader");
      const config = {
        fps: 10,
        qrbox: {width: 200, height: 200},
        rememberLastUsedCamera: true,
        formatsToSupport: [Html5QrcodeSupportedFormats.QR_CODE],
        supportedScanTypes: [Html5QrcodeScanType.SCAN_TYPE_CAMERA], // only support camera (no file upload)
        showTorchButtonIfSupported: true, // shows flash light enable button (if available)
      };
      html5QrCode.start({ facingMode: "environment" }, config, this.onScanSuccess, this.onScanFailure);
      //html5QrCode.start({ facingMode: "user" }, config, this.onScanSuccess, this.onScanFailure); // front camera
      started = true;
      document.getElementById('qr-code-reader-btn-start').style.display = 'none';
      document.getElementById('qr-code-reader-btn-stop').style.display = 'initial';
    }
  }

  stop() {
    stop();
  }

  onScanSuccess(decodedText, decodedResult) {
    stop();
    console.log(`Code matched = ${decodedText}`, decodedResult);
    document.getElementById('qr-code-reader-result').textContent = decodedText;
    //window.location.href = decodedText; // validate result first
  }

  onScanFailure(error) {
    // handle scan failure, usually better to ignore and keep scanning
    //console.warn(`Code scan error = ${error}`);
  }

}
