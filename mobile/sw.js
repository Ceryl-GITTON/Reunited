// Service Worker pour Reunited Countdown avec support des widgets
const CACHE_NAME = 'reunited-countdown-v1.0.0';
const WIDGET_CACHE = 'reunited-widgets-v1.0.0';

// Fichiers à mettre en cache
const urlsToCache = [
  '/Reunited/',
  '/Reunited/mobile.html',
  '/Reunited/widget.html',
  '/Reunited/main.dart.js',
  '/Reunited/flutter.js',
  '/Reunited/flutter_bootstrap.js',
  '/Reunited/assets/assets/app_icon.png',
  '/Reunited/assets/favicon/android-chrome-192x192.png',
  '/Reunited/assets/favicon/android-chrome-512x512.png',
];

// Installation du service worker
self.addEventListener('install', (event) => {
  console.log('🚀 Service Worker installation');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('📦 Mise en cache des ressources principales');
        return cache.addAll(urlsToCache);
      })
      .then(() => {
        console.log('✅ Installation terminée');
        return self.skipWaiting();
      })
  );
});

// Activation du service worker
self.addEventListener('activate', (event) => {
  console.log('🔄 Service Worker activation');
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME && cacheName !== WIDGET_CACHE) {
            console.log('🗑️ Suppression du cache obsolète:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => {
      console.log('✅ Activation terminée');
      return self.clients.claim();
    })
  );
});

// Gestion des requêtes (Cache First Strategy)
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        // Retourner depuis le cache si disponible
        if (response) {
          return response;
        }
        
        // Sinon, récupérer depuis le réseau
        return fetch(event.request).then((response) => {
          // Vérifier si c'est une réponse valide
          if (!response || response.status !== 200 || response.type !== 'basic') {
            return response;
          }
          
          // Cloner la réponse pour la mettre en cache
          const responseToCache = response.clone();
          
          caches.open(CACHE_NAME)
            .then((cache) => {
              cache.put(event.request, responseToCache);
            });
          
          return response;
        });
      })
      .catch(() => {
        // En cas d'erreur, retourner une page de fallback
        if (event.request.destination === 'document') {
          return caches.match('/Reunited/mobile.html');
        }
      })
  );
});

// Gestion des messages pour les widgets
self.addEventListener('message', (event) => {
  const { type, data } = event.data;
  
  switch (type) {
    case 'widget-update':
      // Mettre à jour les données du widget
      updateWidgetData(data);
      break;
      
    case 'get-widget-data':
      // Envoyer les données du widget
      event.ports[0].postMessage({
        type: 'widget-data',
        data: getWidgetData()
      });
      break;
      
    case 'install-widget':
      // Gérer l'installation du widget
      handleWidgetInstallation(event);
      break;
      
    default:
      console.log('Message non reconnu:', type);
  }
});

// Fonctions utilitaires pour les widgets
function updateWidgetData(data) {
  caches.open(WIDGET_CACHE).then((cache) => {
    const widgetData = {
      targetDate: data.targetDate,
      locale: data.locale,
      theme: data.theme,
      lastUpdate: Date.now()
    };
    
    cache.put('/widget-data.json', new Response(JSON.stringify(widgetData), {
      headers: { 'Content-Type': 'application/json' }
    }));
    
    // Notifier tous les widgets ouverts
    self.clients.matchAll({ type: 'window' }).then((clients) => {
      clients.forEach((client) => {
        if (client.url.includes('widget.html')) {
          client.postMessage({
            type: 'widget-update',
            ...widgetData
          });
        }
      });
    });
  });
}

function getWidgetData() {
  return caches.open(WIDGET_CACHE).then((cache) => {
    return cache.match('/widget-data.json').then((response) => {
      if (response) {
        return response.json();
      }
      // Données par défaut
      return {
        targetDate: new Date(Date.now() + 2 * 60 * 1000).toISOString(),
        locale: 'fr',
        theme: 'romantic',
        lastUpdate: Date.now()
      };
    });
  });
}

function handleWidgetInstallation(event) {
  // Logic pour l'installation du widget
  console.log('📱 Installation du widget demandée');
  
  event.ports[0].postMessage({
    type: 'widget-install-response',
    success: true,
    message: 'Widget prêt à être ajouté à l\'écran d\'accueil'
  });
}

// Gestion des notifications push (pour futur usage)
self.addEventListener('push', (event) => {
  if (event.data) {
    const data = event.data.json();
    const options = {
      body: data.body || 'Votre compte à rebours se termine bientôt !',
      icon: '/Reunited/assets/favicon/android-chrome-192x192.png',
      badge: '/Reunited/assets/favicon/favicon-32x32.png',
      vibrate: [200, 100, 200],
      tag: 'countdown-notification',
      actions: [
        {
          action: 'open',
          title: 'Ouvrir l\'app'
        },
        {
          action: 'dismiss',
          title: 'Ignorer'
        }
      ]
    };
    
    event.waitUntil(
      self.registration.showNotification(data.title || 'Reunited Countdown', options)
    );
  }
});

// Gestion des clics sur les notifications
self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  
  if (event.action === 'open') {
    event.waitUntil(
      self.clients.openWindow('/Reunited/mobile.html')
    );
  }
});

console.log('🎯 Service Worker Reunited Countdown chargé avec support widgets');
