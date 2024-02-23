
connect() {
  // same as above, we declare a db and online status
}

async sync() {
  if (await this.db.forms.count() == 0 && !this.connected) return
  const forms = await db.table('forms').toArray() // this is Dexie syntax
  const formsIdsToRemove = []
  await Promise.all(forms.map(form) = >{
    try {
      // make ajax request to your server
      if (response.ok) {
        formsIdsToRemove.push(form.id)
      }
    } catch(error) {
      // handle error
    }
  })
‍
  // after looping through all records, remove synchronized forms from IndexedDB
  for (let id of formsIdsToRemove) {
    await db.forms.delete(id)
  }
}

async displayOfflineForms() {
  const forms = await this.db.table('forms').toArray()
  forms.forEach(async(form) => {
    if (!this.listItemExists(form)) {
      this.listContainerTarget.innerHTML += (this.listItem(form))
    }
    if (this.formExistsInServer(form)) {
      this.removeSyncedItem(form)
    }
  })
}

listItem(form) {
  const template = this.listItemTemplateTarget.innerHTML
  const rendered = Mustache.render(template, {
    name: form.name,
    dom_id: form.id
  })
  return rendered
}
