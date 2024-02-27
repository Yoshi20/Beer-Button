console.log("custom/compantion.js");//blup

/* register a serviceWorker & background sync API */
if (navigator.serviceWorker) {
  navigator.serviceWorker.register("/service-worker.js", { scope: "/" })
   .then(() => navigator.serviceWorker.ready)
   .then((registration) => {
     if ("SyncManager" in window) {
       registration.sync.register("sync-forms");
     } else {
       window.alert("This browser does not support background sync.")
     }
   }).then(() => console.log("[Companion]", "Service worker registered!"));
}






// async function checkOngoingFetches() {
//   console.log('blup: checkOngoingFetches');
//   const reg = await navigator.serviceWorker.ready;
//   console.log(reg);
//   const ids = await reg.backgroundFetch.getIds();
//   console.log(ids);
//   ids.forEach(async (id) => {
//     await reg.backgroundFetch.get(id);
//   });
// }
//
// async function myDataFetches() {
//   console.log('blup: myDataFetches');
//   const reg = await navigator.serviceWorker.ready;
//   console.log(reg);
//   const bgFetch = await reg.backgroundFetch.fetch(
//     "my-fetch",
//     ["/devices.json"],
//     {
//       title: "devices",
//       icons: [
//         {
//           sizes: "300x300",
//           src: "/beer_1.png",
//           type: "image/png",
//         },
//       ],
//       downloadTotal: 60 * 1024 * 1024,
//     }
//   )
//   console.log(bgFetch);
//   // const devices = await bgFetch.json();
//   // console.log(devices);
//
//   // const reader = bgFetch.body.getReader();
//   // console.log(reader);
//   // while (true) {
//   //   const { done, value } = await reader.read();
//   //   console.log(value);
//   //   if (done) break;
//   //   // downloaded += value.length;
//   //   // chunks.push(value);
//   //   // const now = Date.now();
//   //   // const progress = downloaded / item.size;
//   //   // if (now - lastUpdated > 500 || progress === 1) {
//   //   //   updateItem(item.id, { progress });
//   //   //   lastUpdated = now;
//   //   // }
//   // }
// }

async function init() {
  // Attempt persistent storage
  if (navigator.storage && navigator.storage.persist) {
    console.log('navigator.storage.persist()');
    await navigator.storage.persist();
  }

  // if ('BackgroundFetchManager' in self) {
  //   checkOngoingFetches();
  //   myDataFetches();
  // }
}

init();
