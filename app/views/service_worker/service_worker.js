importScripts(
  "https://storage.googleapis.com/workbox-cdn/releases/6.4.1/workbox-sw.js"
);

// We first define the strategies we will use and the registerRoute function
// https://developer.chrome.com/docs/workbox/modules/workbox-strategies/
const {CacheFirst, NetworkFirst} = workbox.strategies;
const {registerRoute} = workbox.routing;
// If we have critical pages that won't be changing very often, it's a good idea to use cache first with them
registerRoute(
  ({url}) => url.pathname.startsWith('/home'), //blup: static landing pages etc.
  new CacheFirst({
    cacheName: 'documents',
  })
)
// For every other page we use network first to ensure the most up-to-date resources
registerRoute(
  ({request, url}) => (request.destination === "document" || request.destination === ""),
  new NetworkFirst({
    cacheName: 'documents',
  })
)
// For assets (scripts and images), we use cache first
registerRoute(
  ({request}) => (request.destination === "script" || request.destination === "style"),
  new CacheFirst({
    cacheName: 'assets-styles-and-scripts',
  })
)
registerRoute(
  ({request}) => (request.destination === "image" &&
    // we fetch this image to check the network status, so we exclude it from cache
    !url.pathname.includes("/1pixel.png")),
  new CacheFirst({
    cacheName: 'assets-images',
  })
)




const {warmStrategyCache} = workbox.recipes;
const {setCatchHandler} = workbox.routing;
const strategy = new CacheFirst();
const urls = ['/offline.html'];
// Warm the runtime cache with a list of asset URLs
warmStrategyCache({urls, strategy});
// Trigger a 'catch' handler when any of the other routes fail to generate a response
setCatchHandler(async ({event}) => {
 switch (event.request.destination) {
   case 'document':
     return strategy.handle({event, request: urls[0]});
   default:
    return Response.error();
  }
});






function onInstall(event) {
  console.log('[Serviceworker]', "Installing!", event);
}

function onActivate(event) {
  console.log('[Serviceworker]', "Activating!", event);
}

function onFetch(event) {
  console.log('[Serviceworker]', "Fetching!", event);
}

self.addEventListener('install', onInstall);
self.addEventListener('activate', onActivate);
self.addEventListener('fetch', onFetch);












// Add a service worker for processing Web Push notifications:
//
// self.addEventListener("push", async (event) => {
//   const { title, options } = await event.data.json()
//   event.waitUntil(self.registration.showNotification(title, options))
// })
//
// self.addEventListener("notificationclick", function(event) {
//   event.notification.close()
//   event.waitUntil(
//     clients.matchAll({ type: "window" }).then((clientList) => {
//       for (let i = 0; i < clientList.length; i++) {
//         let client = clientList[i]
//         let clientPath = (new URL(client.url)).pathname
//
//         if (clientPath == event.notification.data.path && "focus" in client) {
//           return client.focus()
//         }
//       }
//
//       if (clients.openWindow) {
//         return clients.openWindow(event.notification.data.path)
//       }
//     })
//   )
// })
