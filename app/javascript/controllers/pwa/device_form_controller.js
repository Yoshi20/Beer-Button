import { Controller } from "@hotwired/stimulus"
import { isOnline } from "../../global/is_online"
import { db } from "../../global/local_db"

export default class extends Controller {
  // static targets = [ "..." ]

  connect() {
  }

  async submit() {
    event.preventDefault();
    const e = event;
    const form = e.target.closest('form');
    console.log("blup: submit");
    this.isOnline = await isOnline(); // we check again in case it changed just before the submission
    if (true){//blup }!this.isOnline) {
      // const table_name = form.id.split('_')[1];
      const formData = new FormData(form);
      const formDataObj = {};
      formData.forEach((value, key) => (formDataObj[key] = value));
      console.log('formDataObj:',formDataObj);//blup

      // TODO: validate device data

      await db.open();

      // const existing_form = await db.forms.get({
      //   "dev_eui": formDataObj['device[dev_eui]']
      // }).catch('NotFoundError', function (err) { // allow no data error
      //   console.log('device does not exists yet');
      // });
      // console.log(existing_form);

      await db.forms.put(formDataObj);
      console.log('db.forms:', await db.forms.toArray());

      // let output = "";
      // for (const [key, value] of formData) { output += `${key}: ${value}\n`; }
      // console.log(output);

      window.location.href = '/devices';
    } else {
      form.submit();
    }
  }

}
