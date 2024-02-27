import { Controller } from "@hotwired/stimulus"
import { Dexie } from "dexie" // dexie.js (indexedDB wrapper)
import { isOnline } from "../../global/is_online"


async function saveFormData() {
  if (!this.formValid()) {
    // check if form is valid before saving it
    return
  }
  if (!this.isOnline()) {
    // save record in IndexedDB
  }
}

export default class extends Controller {
  // static targets = [ "..." ]

  connect() {
    console.log("blup: connect");
    this.db = new Dexie("LocalDatabase");
    console.log('db:',this.db);
    this.db.version(1).stores({
      devices: "++id, name", // NOTE: Don’t declare all columns like in SQL. You only declare properties you want to index, that is properties you want to use in a where(…) query.
    });
    console.log('db.devices:',this.db.devices);

  }

  async submit() {
    console.log(event);
    const e = event;
    console.log(e.target);
    e.preventDefault();
    console.log("blup: submit");
    // we check again in case it changed just before the submission
    this.isOnline = await isOnline();
    if (true) {//blup !this.isOnline) {
      console.log(event);
      console.log(e.target);
      const form = e.target.closest('form');
      console.log(form);
      // const table_name = form.id.split('_')[1];
      // console.log(table_name);
      const formData = new FormData(form);
      console.log(formData);

      const formDataObj = {};
      formData.forEach((value, key) => (formDataObj[key] = value));
      console.log('formDataObj:',formDataObj);
      // const formDataObj2 = Object.fromEntries(formData.entries());
      // console.log(formDataObj2);




      await this.db.open();
      await this.db.devices.add(formDataObj);
      console.log('db.devices:', await this.db.devices.toArray());
      // console.log('db.devices:',this.db.devices.toArray().map(device => `${device.name} ${device.dev_eui}`));

      let output = "";
      for (const [key, value] of formData) {

        output += `${key}: ${value}\n`;
      }
      console.log(output);
      // saveFormData();
    } else {
      //blup submit()
    }
  }

}


// localStorage.setItem("isOnline", online);

//  data: { controller: "pwa_form", pwa_form_target: "form", action: "change->pwa_form#submit" }
//
//
//
// connect() {
//   // declare an indexedDB database, declare a boolean variable for the network status
//   this.db = findOrCreateDB();
//   this.isOnline = getIsOnlineFromLocalStorage();
//
//
//   this.db = new Dexie("LocalDatabase");
//   this.isOnline = localStorage.getItem("isOnline");
//
//   console.log('db:',this.db);
//   console.log('isOnline:',this.isOnline);
//
//
//
//
// }
//
// submit() {
//   // we check again in case it changed just before the submission
//   this.isOnline = getIsOnlineFromLocalStorage();
//   if (!this.isOnline) {
//     event.preventDefault()
//   }
// }
//
// async saveFormData() {
//   this.isOnline = getIsOnlineFromLocalStorage();
//   if (!this.formValid()) {
//     // check if form is valid before saving it
//     return
//   }
//   if (!this.isOnline()) {
//     // save record in IndexedDB
//   }
// }
