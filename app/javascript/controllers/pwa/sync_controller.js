import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from '@rails/request.js'
import { isOnline } from "../../global/is_online"
import { db } from "../../global/local_db"

export default class extends Controller {
  // static targets = [ "..." ]

  connect() {
  }

  async sync() {
    console.log('sync!');
    console.log(await db.forms.count());
    if (await db.forms.count() == 0 && !isOnline()) return
    const forms = await db.forms.toArray();
    const formsIdsToRemove = [];
    await Promise.all(forms.map(async (form) => {
    // const form = forms[0];//blup
      const href = form.href;
      const form_id = form.id;
      console.log(form_id);//blup
      console.log(form);
      delete form.id;
      delete form.href;
      // fetch() not working due to the rails X-CSRF-Token -> use FetchRequest from rails/request.js
      const req = new FetchRequest(form._method ? form._method : "post", href+'.json', {
        body: new URLSearchParams(form).toString(),
        contentType: "application/x-www-form-urlencoded",
      });
      const resp = await req.perform();
      if (resp.ok) {
        console.log('OK');
        formsIdsToRemove.push(form_id);
      }
    }));
    // after looping through all records, remove synchronized forms from the local DB
    await db.forms.bulkDelete(formsIdsToRemove);
    window.location.href = '/devices';
  }

}
