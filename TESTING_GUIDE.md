# Guide de Test - Reunited Countdown App

## APK Généré
- **Fichier**: `build\app\outputs\flutter-apk\app-release.apk`
- **Taille**: 50 MB
- **Date**: 17/08/2025

## Installation sur Android

### 1. Préparation du téléphone
```
Paramètres → Sécurité → Sources inconnues → Activer
```

### 2. Installation
1. Copiez `app-release.apk` sur votre téléphone
2. Ouvrez le fichier depuis l'explorateur de fichiers
3. Suivez les instructions d'installation

## Tests à effectuer

### ✅ Test de l'Application
- [ ] Lancement de l'application
- [ ] Sélection de la date de retrouvailles
- [ ] Changement de langue (FR/EN/ID)
- [ ] Animations du compte à rebours
- [ ] Calcul correct du temps restant

### ✅ Test du Widget
- [ ] Ajout du widget sur l'écran d'accueil
- [ ] Affichage correct du compte à rebours
- [ ] Mise à jour automatique du widget
- [ ] Fonctionnement après redémarrage du téléphone

### ✅ Test de Performance
- [ ] Temps de démarrage acceptable
- [ ] Fluidité des animations
- [ ] Consommation de batterie raisonnable
- [ ] Fonctionnement en arrière-plan

## Publication (Optionnel)

### Google Play Console
1. Créer un compte développeur Google Play (25€)
2. Préparer les assets (icônes, captures d'écran)
3. Upload de l'APK
4. Processus de validation Google

### Alternatives de test
- **Firebase App Distribution**: Test bêta gratuit
- **TestFlight** (iOS): Pour version iOS future
- **Direct APK sharing**: Partage direct avec testeurs

## Dépannage

### Problèmes d'installation
- Vérifier les sources inconnues
- Espace de stockage suffisant (50+ MB)
- Version Android compatible (API 21+)

### Widget ne s'affiche pas
- Redémarrer l'appareil
- Vérifier les permissions de l'app
- Réinstaller l'application

## Notes importantes
- L'APK est signé pour la release
- Widget mis à jour toutes les heures
- Support multilingue intégré
- Compatible Android 5.0+
