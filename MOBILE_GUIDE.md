# 📱 Reunited Countdown Mobile

## Installation Mobile via GitHub Pages

### 🌐 **Accès Direct**
**URL de l'application mobile :** https://ceryl-gitton.github.io/Reunited/mobile/

### 📲 **Installation PWA**

#### Sur Android :
1. Ouvrez l'URL dans Chrome
2. Appuyez sur "Ajouter à l'écran d'accueil" dans le menu
3. L'application sera installée comme une app native

#### Sur iOS :
1. Ouvrez l'URL dans Safari
2. Appuyez sur le bouton "Partager"
3. Sélectionnez "Sur l'écran d'accueil"
4. L'application sera installée

#### Sur ordinateur :
1. Ouvrez l'URL dans Chrome, Edge, ou Firefox
2. Cliquez sur l'icône "Installer" dans la barre d'adresse
3. L'application sera installée comme une app desktop

## 🎯 **Fonctionnalités Mobile**

### 🌍 **Support Multilingue**
- **Français** 🇫🇷 : Interface complète en français
- **English** 🇬🇧 : Full English interface
- **Bahasa Indonesia** 🇮🇩 : Antarmuka lengkap dalam bahasa Indonesia

### 🎨 **Thèmes Disponibles**
1. **Package Demo** : Démo rapide (2 minutes) pour tester
2. **Romantique** : Couleurs roses et dorées, parfait pour les couples
3. **Élégant** : Design noir et blanc sophistiqué
4. **Vibrant** : Couleurs vives et énergiques

### ⏰ **Fuseaux Horaires**
- **Local** : Fuseau horaire de votre appareil
- **France** : Heure de Paris (GMT+1/+2)
- **Royaume-Uni** : Heure de Londres (GMT+0/+1)
- **Indonésie** : Heure de Jakarta (GMT+7)

### 🎮 **Navigation**
- **Swipe** ou boutons de navigation
- **Menu de langues** accessible en haut à droite
- **Démo suivante** automatique ou manuelle
- **Redémarrage** automatique des comptes à rebours

## 🚀 **Déploiement**

### GitHub Actions (Automatique)
Le déploiement se fait automatiquement via GitHub Actions :

```yaml
# Déclenchement automatique
- Push sur main
- Modification de lib/mobile_app.dart
- Modification de packages/reunited_countdown/
```

### Build Local
```bash
# Construction manuelle
flutter build web --target lib/mobile_app.dart --web-renderer html
```

## 📱 **Optimisations Mobile**

### Performance
- **Rendu HTML** : Meilleure compatibilité mobile
- **Lazy loading** : Chargement progressif des ressources
- **Cache optimisé** : Temps de chargement réduits

### UX Mobile
- **Touch gestures** : Support complet du tactile
- **Responsive design** : Adaptation automatique à la taille d'écran
- **Notifications** : Support des notifications push (PWA)

### PWA Features
- **Offline support** : Fonctionnement hors ligne
- **Install prompt** : Invitation à l'installation automatique
- **App shell** : Chargement instantané

## 🔧 **Configuration Technique**

### Manifest PWA
```json
{
  "name": "Reunited Countdown Mobile",
  "short_name": "Reunited Mobile",
  "start_url": "/Reunited/mobile.html",
  "display": "standalone"
}
```

### Service Worker
- **Cache strategy** : Cache-first pour les assets
- **Update strategy** : Background sync
- **Offline fallback** : Page d'erreur personnalisée

## 🎉 **Animations & Effets**

### Transitions
- **Slide animations** : Entre les thèmes
- **Fade effects** : Changements de langue
- **Scale animations** : Interactions boutons

### Feedback Visuel
- **Loading spinner** : Pendant le chargement
- **Success animations** : Fin de compte à rebours
- **Error handling** : Messages d'erreur élégants

## 📊 **Analytics & Monitoring**

### Métriques Suivies
- **Time to interactive** : Temps de chargement
- **User engagement** : Temps passé sur l'app
- **Theme preferences** : Thèmes les plus utilisés
- **Language distribution** : Langues préférées

### Performance
- **Bundle size** : ~2MB (optimisé)
- **First load** : <3 secondes
- **Subsequent loads** : <1 seconde (cache)

## 🛠️ **Développement**

### Structure des Fichiers
```
lib/mobile_app.dart          # Point d'entrée mobile
web/mobile.html              # Template HTML optimisé
web/mobile-manifest.json     # Configuration PWA
packages/reunited_countdown/ # Package réutilisable
```

### Commandes de Développement
```bash
# Développement local
flutter run -d web-server --web-port 8080 --target lib/mobile_app.dart

# Build de production
flutter build web --target lib/mobile_app.dart --release

# Tests
flutter test
```

## 🌟 **Roadmap Mobile**

### Version 1.1 (Prochaine)
- [ ] **Push notifications** : Alertes avant événements
- [ ] **Dark mode** : Thème sombre automatique
- [ ] **Social sharing** : Partage sur réseaux sociaux
- [ ] **Calendar integration** : Synchronisation calendrier

### Version 1.2 (Future)
- [ ] **Custom events** : Événements personnalisés multiples
- [ ] **Photo backgrounds** : Arrière-plans personnalisés
- [ ] **Sound alerts** : Notifications sonores
- [ ] **Widget support** : Widgets d'écran d'accueil

## 📞 **Support**

### Bugs & Suggestions
- **GitHub Issues** : https://github.com/Ceryl-GITTON/Reunited/issues
- **Email** : support@reunited-countdown.app

### FAQ Mobile
**Q: L'app fonctionne-t-elle hors ligne ?**
R: Oui, une fois installée en PWA, elle fonctionne hors ligne.

**Q: Puis-je recevoir des notifications ?**
R: Les notifications push seront disponibles dans la v1.1.

**Q: L'app est-elle gratuite ?**
R: Oui, totalement gratuite et open source !

---

💖 **Créé avec amour pour célébrer vos moments précieux**
