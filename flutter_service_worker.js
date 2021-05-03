'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "26d4016c6bbb83b1e44171f872e9cbcf",
"assets/assets/out.obj": "22cd18edcc6b650d3e44a6e59bcb4be5",
"assets/assets/splash.json": "2a039a1208f2bef3557ca873fa1f1928",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/NOTICES": "c18e544eebd44340ff5308eb09652125",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"favicon.png": "0211263b90bfadb62005ea4256e320f5",
"icons/android-icon-144x144.png": "6164e114f2c24e35a7e58a2b7f841d5e",
"icons/android-icon-192x192.png": "810dc61834d7ec00d0672a8f35529c71",
"icons/android-icon-36x36.png": "2f885b60e18d3f14efb906a0ae842c87",
"icons/android-icon-48x48.png": "5799ca2f196f5a00c1fb41120e5becd7",
"icons/android-icon-72x72.png": "244665c6968740292a49180ba8082ba6",
"icons/android-icon-96x96.png": "693d156156a7a2e1ffbc19a1feb56081",
"icons/apple-icon-114x114.png": "64d0f3674b2966a36f2fff7f3bded1eb",
"icons/apple-icon-120x120.png": "5af8f4133b90a0a9321aba4238ad5934",
"icons/apple-icon-144x144.png": "6164e114f2c24e35a7e58a2b7f841d5e",
"icons/apple-icon-152x152.png": "03d77b574e7e44c40c0461d352f9dc88",
"icons/apple-icon-180x180.png": "5b45a457356fc7b313be2efee0f1dadb",
"icons/apple-icon-57x57.png": "dcd8c7ccfdab8464e1b3a73eec1358bc",
"icons/apple-icon-60x60.png": "f728175300f140c80571f26ef259426f",
"icons/apple-icon-72x72.png": "244665c6968740292a49180ba8082ba6",
"icons/apple-icon-76x76.png": "dc54d04155ade775bf6667a10936328e",
"icons/apple-icon-precomposed.png": "b9cb5feb3fc0a2c69e9c204145e44a68",
"icons/apple-icon.png": "b9cb5feb3fc0a2c69e9c204145e44a68",
"icons/favicon-16x16.png": "0211263b90bfadb62005ea4256e320f5",
"icons/favicon-32x32.png": "c58f774ebe2a4edcb4387662b962b344",
"icons/favicon-96x96.png": "693d156156a7a2e1ffbc19a1feb56081",
"icons/favicon.ico": "5f6aced92111476e56cabc60c3a1baa4",
"icons/ms-icon-144x144.png": "6164e114f2c24e35a7e58a2b7f841d5e",
"icons/ms-icon-150x150.png": "90906c2f263fd082c6c91ca448473766",
"icons/ms-icon-310x310.png": "48fa741611370b601deaffdec96b9c21",
"icons/ms-icon-70x70.png": "6459e610f08bc1b869605f0767c922bc",
"index.html": "6cd830f1b7be8ff4fcce9b2204a2f6f5",
"/": "6cd830f1b7be8ff4fcce9b2204a2f6f5",
"main.dart.js": "c957c2700c009d7eec57834c34506657",
"manifest.json": "00d6897723c28f2e95a4a5a05ff76096",
"version.json": "0ab7bfda21c2fb905dbfc6c3c5378cf1"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
