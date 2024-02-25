/* Caching with Workbox ----------------------------------------------------- */
importScripts(
  "https://storage.googleapis.com/workbox-cdn/releases/6.4.1/workbox-sw.js"
);

// We first define the strategies we will use and the registerRoute function
// See: https://developer.chrome.com/docs/workbox/modules/workbox-strategies/
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
  ({request, url}) => (request.destination === "document" || request.destination === "" &&
    // we fetch this image to check the network status, so we exclude it from cache
    !url.pathname.includes("/1pixel.png")
  ),
  new NetworkFirst({
    cacheName: 'documents',
  })
)
// For assets (scripts & images etc.), we use cache first
registerRoute(
  ({request}) => (request.destination === "script" || request.destination === "style"),
  new CacheFirst({
    cacheName: 'assets-styles-and-scripts',
  })
)
registerRoute(
  ({request}) => (request.destination === "image"),
  new CacheFirst({
    cacheName: 'assets-images',
  })
)
registerRoute(
  ({request}) => (request.destination === "font"),
  new CacheFirst({
    cacheName: 'assets-fonts',
  })
)
registerRoute(
  ({request}) => (request.destination === "audio"),
  new CacheFirst({
    cacheName: 'assets-audios',
  })
)

/* Offline fallback --------------------------------------------------------- */
const {warmStrategyCache} = workbox.recipes;
const {setCatchHandler} = workbox.routing;
const strategy = new CacheFirst();
const urls = ['/offline'];
// Warm the runtime cache with a list of asset URLs
warmStrategyCache({urls, strategy});
// Trigger a 'catch' handler when any of the other routes fail to generate a response
setCatchHandler(async ({event}) => {
  console.log('setCatchHandler:', event);
  switch (event.request.destination) {
    case 'document':
      return strategy.handle({event, request: urls[0]});
    default:
      return Response.error();
  }
});

/* Service worker callbacks ------------------------------------------------- */
function onInstall(event) {
  console.log('[Serviceworker]', "Installing!", event);
}

function onActivate(event) {
  console.log('[Serviceworker]', "Activating!", event);
}

function onFetch(event) {
  const url = event.request.url;
  if (!url.includes('/1pixel.png') && !url.includes('/mini-profiler')) {
    console.log('[Serviceworker]', "Fetching!", event);
    console.log('url = ', url);
    console.log('destination = ', event.request.destination);
  }
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
