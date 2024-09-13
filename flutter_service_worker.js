'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "f051c9cd5690915d4e1ce11bc9bee8c6",
"version.json": "5b17465a5a217d3a1f6062158618683d",
"index.html": "90c7d9c44bb4a46c90da9b8c5229f89c",
"/": "90c7d9c44bb4a46c90da9b8c5229f89c",
"main.dart.js": "315d43b2a0d9da31d3a8c1e4a311db03",
"sqlite3.wasm": "79a4cf7ac1cf1f9d5081474f5a7bb5ba",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "b2bbcb95cdf2d0dd3ca895ba73f5796f",
"sqflite_sw.js": "36d5275242d7461160d475d00c6b13ca",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "506ac0cd8bccc5f7fe2b8569ddb08fca",
"assets/AssetManifest.json": "65cf2d6afa217d7474821593cc74307b",
"assets/NOTICES": "1c97df6969f41cfbe712c4efd59eb784",
"assets/FontManifest.json": "44797b17e1a762036622e6221e8db127",
"assets/AssetManifest.bin.json": "e68b3ffe2ff976abe6cd7deca4d85948",
"assets/packages/stripes_ui/assets/svg/muffin_icon.svg": "0d849d96416ca14223becd65d13a43e0",
"assets/packages/stripes_ui/assets/svg/pain_face_3.svg": "021a65dbad1f252080ac39d29d28c134",
"assets/packages/stripes_ui/assets/svg/pain_face_2.svg": "b58e041aaff3f05ecc0791ee33df8f29",
"assets/packages/stripes_ui/assets/svg/pain_face_0.svg": "b3144f21122a00b4f1ebef9afa85622a",
"assets/packages/stripes_ui/assets/svg/pain_face_1.svg": "b2e46785d5c00437460803ecf6f66215",
"assets/packages/stripes_ui/assets/svg/pain_face_5.svg": "793d3b994c133afd82b7364b95cfa24f",
"assets/packages/stripes_ui/assets/svg/pain_face_4.svg": "892e8fe5075d8151061b2494c893e469",
"assets/packages/stripes_ui/assets/images/poop2.png": "61fff2090ab6406888d465e3ccc8ab92",
"assets/packages/stripes_ui/assets/images/poop3.png": "9faf901ea5d3d3e61db18518540d3314",
"assets/packages/stripes_ui/assets/images/poop1.png": "a36e09c880034c4bf82575a08ff377ca",
"assets/packages/stripes_ui/assets/images/StripesLogo.png": "860d229afdbab0404997a73413aab4dd",
"assets/packages/stripes_ui/assets/images/abdomin.png": "89faedef0368d23cf2c9ff9d9d8a1bd0",
"assets/packages/stripes_ui/assets/images/poop4.png": "c7639e9f7fa3524b587ba6d51b2e7b00",
"assets/packages/stripes_ui/assets/images/poop5.png": "0eb7c02f1db48ee5f008bd7c4ba72411",
"assets/packages/stripes_ui/assets/images/poop7.png": "0e2b15b3fb47a97ed8dac6201d34ab88",
"assets/packages/stripes_ui/assets/images/poop6.png": "b580249f2281d5e440f1a3579946af80",
"assets/packages/stripes_ui/assets/images/pain_faces_2.png": "86c31558be049bfef111d788e7467589",
"assets/packages/stripes_ui/assets/images/pain_faces_3.png": "e0e30d392caa056b9118e489431ffb4a",
"assets/packages/stripes_ui/assets/images/pain_faces_1.png": "5d308cd1dd19660f49174605fffa206f",
"assets/packages/stripes_ui/assets/images/pain_faces_0.png": "0942f97211194201c4f39af15488c57a",
"assets/packages/stripes_ui/assets/images/pain_faces_4.png": "6d22c2d6873a106689d0242e7acb9ebe",
"assets/packages/stripes_ui/assets/images/Brown_Poop.png": "433510f39c3b7583a0bbc0b655b4fd76",
"assets/packages/stripes_ui/assets/images/Blue_Poop.png": "dccf6fa3743d97899af94cf4724f2447",
"assets/packages/stripes_ui/assets/fonts/Inter/Inter-VariableFont_slnt,wght.ttf": "32204736a4290ec41200abe91e5190d1",
"assets/packages/amplify_auth_cognito_dart/lib/src/workers/workers.min.js.map": "c59bbc9b917a012d6f3f1965098e07ea",
"assets/packages/amplify_auth_cognito_dart/lib/src/workers/workers.min.js": "77727e3a27ad3662c8fe30922a27626e",
"assets/packages/amplify_authenticator/assets/social-buttons/SocialIcons.ttf": "376fbf368ffe39e045978e3d3197efbd",
"assets/packages/amplify_authenticator/assets/social-buttons/google.png": "a1e1d65465c69a65f8d01226ff5237ec",
"assets/packages/amplify_secure_storage_dart/lib/src/worker/workers.min%202.js": "fa742e283e40fa499a72f9a314f9f53a",
"assets/packages/amplify_secure_storage_dart/lib/src/worker/workers.min.js.map": "9b2bffbaa129cc1c87dc497827f159bd",
"assets/packages/amplify_secure_storage_dart/lib/src/worker/workers.min.js": "c21f04e68a1c1dcfecfad44bcd2e8953",
"assets/packages/amplify_secure_storage_dart/lib/src/worker/workers.min.js%202.map": "b77186f134bc5be76a9c7b6512461a00",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "554f5171801a6af39af86d351f4c57fe",
"assets/fonts/MaterialIcons-Regular.otf": "2e61b04384ba7aa5cfd4bb26abc3f8e8",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
