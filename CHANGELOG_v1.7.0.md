# Changelog - Reunited Countdown v1.7.0

## 🎉 Version 1.7.0 - Widgets natifs Android/iOS !

### ✨ Nouvelles fonctionnalités
- **Widget d'écran d'accueil Android** - Compte à rebours en temps réel sur votre écran d'accueil
- **Support iOS complet** - Structure prête pour widgets iOS
- **Mise à jour automatique** - Le widget se met à jour toutes les secondes
- **Interface redesignée** - Gradient rose romantique avec animations

### 🔧 Améliorations techniques
- **Android Gradle Plugin 8.7.2** - Dernière version stable
- **Kotlin 2.1.0** - Performance optimisée
- **Java 17** - Support des dernières API Android
- **Dépendances à jour** - Toutes les dépendances transitives forcées aux dernières versions

### 🐛 Corrections
- **Erreurs de compilation résolues** - Plus de conflits XML ou Java
- **Icônes d'application** - Icône personnalisée avec dégradé rose
- **Support multiplateforme** - Web, Android, iOS (widgets sur mobile uniquement)

### 🚀 Utilisation du widget Android
1. Maintenez appuyé sur l'écran d'accueil
2. Sélectionnez "Widgets"
3. Cherchez "Reunited Countdown"
4. Glissez le widget sur votre écran

### 📱 Prochaines étapes
- Widget iOS Today Extension (prochaine version)
- Thèmes personnalisables
- Notifications de rappel

---
**Note technique** : Cette version abandonne le plugin `home_widget` complexe au profit d'une implémentation native plus stable avec SharedPreferences + MethodChannel.
