'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "5b17465a5a217d3a1f6062158618683d",
"index.html": "a6fb8d22ee992e516375dceb7ae8bda7",
"/": "a6fb8d22ee992e516375dceb7ae8bda7",
"main.dart.js": "4ac533cf6fa0669e87a374fc7399c7d0",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "506ac0cd8bccc5f7fe2b8569ddb08fca",
"assets/AssetManifest.json": "fa2a9705e9d6434c74441a6198d346d2",
"assets/NOTICES": "35192c8be28fde1a744dd3fd1c93b257",
"assets/FontManifest.json": "2f1ebedf6364e441385272a1fe631bb1",
"assets/packages/stripes_ui/assets/svg/pain_face_3.svg": "021a65dbad1f252080ac39d29d28c134",
"assets/packages/stripes_ui/assets/svg/pain_face_2.svg": "b58e041aaff3f05ecc0791ee33df8f29",
"assets/packages/stripes_ui/assets/svg/pain_face_0.svg": "bb123d42bb1990199ac2be96431cdf3e",
"assets/packages/stripes_ui/assets/svg/pain_face_1.svg": "b2e46785d5c00437460803ecf6f66215",
"assets/packages/stripes_ui/assets/svg/pain_face_5.svg": "793d3b994c133afd82b7364b95cfa24f",
"assets/packages/stripes_ui/assets/svg/pain_face_4.svg": "892e8fe5075d8151061b2494c893e469",
"assets/packages/stripes_ui/assets/images/poop2.png": "61fff2090ab6406888d465e3ccc8ab92",
"assets/packages/stripes_ui/assets/images/poop3.png": "9faf901ea5d3d3e61db18518540d3314",
"assets/packages/stripes_ui/assets/images/poop1.png": "a36e09c880034c4bf82575a08ff377ca",
"assets/packages/stripes_ui/assets/images/StripesLogo.png": "860d229afdbab0404997a73413aab4dd",
"assets/packages/stripes_ui/assets/images/poop4.png": "c7639e9f7fa3524b587ba6d51b2e7b00",
"assets/packages/stripes_ui/assets/images/poop5.png": "0eb7c02f1db48ee5f008bd7c4ba72411",
"assets/packages/stripes_ui/assets/images/poop7.png": "0e2b15b3fb47a97ed8dac6201d34ab88",
"assets/packages/stripes_ui/assets/images/poop6.png": "b580249f2281d5e440f1a3579946af80",
"assets/packages/stripes_ui/assets/images/Brown_Poop.png": "433510f39c3b7583a0bbc0b655b4fd76",
"assets/packages/stripes_ui/assets/images/Blue_Poop.png": "dccf6fa3743d97899af94cf4724f2447",
"assets/packages/amplify_auth_cognito_dart/lib/src/workers/workers.min.js.map": "dfeed5875e608e93e20d663066ad6eee",
"assets/packages/amplify_auth_cognito_dart/lib/src/workers/workers.min.js": "65e675d53cd30c88dd749e6cf0aae3fc",
"assets/packages/amplify_authenticator/assets/social-buttons/SocialIcons.ttf": "376fbf368ffe39e045978e3d3197efbd",
"assets/packages/amplify_authenticator/assets/social-buttons/google.png": "a1e1d65465c69a65f8d01226ff5237ec",
"assets/packages/amplify_secure_storage_dart/lib/src/worker/workers.min.js.map": "b7a8e0c431496ab98af6f321f82d1664",
"assets/packages/amplify_secure_storage_dart/lib/src/worker/workers.min.js": "6f00425226d3cbc0c3c51709ccff8cd4",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "1c1c4cf4b5fb3fb88344a0bb49f36d2c",
"assets/fonts/MaterialIcons-Regular.otf": "982a2fe1a25b7d7371ebfc53d04f3fd9",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "1a074e8452fe5e0d02b112e22cdcf455",
"canvaskit/chromium/canvaskit.js": "96ae916cd2d1b7320fff853ee22aebb0",
"canvaskit/chromium/canvaskit.wasm": "be0e3b33510f5b7b0cc76cc4d3e50048",
"canvaskit/canvaskit.js": "bbf39143dfd758d8d847453b120c8ebb",
"canvaskit/canvaskit.wasm": "42df12e09ecc0d5a4a34a69d7ee44314",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
