import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = [ "..." ]

  connect() {
  }

  /* example haml:
    = file_field_tag :photo_file, accept: 'image/x-png,image/png,image/gif,image/jpeg', data: { action: 'change->file_field#handleFile'}
    %img{id: "image-preview", src: "", style: 'width: 300px;'}
  */
  handleFile(el) {
    const filePicker = el.target;
    const myFile = filePicker.files[0];
    console.log(myFile);
    /* convert to base64 */
    const fileReader = new FileReader();
    fileReader.readAsDataURL(myFile);
    // fileReader.readAsArrayBuffer(myFile);
    fileReader.onload = () => {
      console.log(fileReader.result);
      // const blob = new Blob([new Uint8Array(fileReader.result)]);
      // const blobURL = URL.createObjectURL(blob);
      // console.log(blobURL);

      document.getElementById('image-preview').src = fileReader.result;

    };
    fileReader.onerror = (error) => {
      console.error(error);
    };
  }

}
