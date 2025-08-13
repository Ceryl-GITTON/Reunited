# Reunited Countdown 💕

Une application mobile Flutter qui affiche un compte à rebours précis jusqu'aux retrouvailles avec votre petite amie !

## Fonctionnalités

- 📱 Compatible Android et iOS
- ⏰ Compte à rebours en temps réel (jours, heures, minutes, secondes)
- 💖 Interface avec animations de cœur qui bat
- 🎨 Design élégant avec dégradé rose romantique
- 📅 Sélecteur de date et heure pour personnaliser la date des retrouvailles
- 🎉 Animation spéciale quand le compte à rebours arrive à zéro

## Comment utiliser

1. **Modifier la date des retrouvailles** : Appuyez sur le bouton "Modifier la date des retrouvailles" pour choisir la date et l'heure exactes de vos retrouvailles.

2. **Voir le compte à rebours** : L'application affiche en temps réel le temps restant avec une précision à la seconde près.

3. **Profiter des animations** : Le cœur bat au rythme de l'amour et le widget principal pulse doucement.

## Installation et lancement

### Prérequis
- Flutter SDK installé
- Android Studio ou Xcode pour les émulateurs
- Un appareil Android ou iOS (optionnel)

### Commandes
```bash
# Installer les dépendances
flutter pub get

# Lancer sur émulateur Android
flutter run

# Lancer sur émulateur iOS (macOS uniquement)
flutter run

# Construire pour Android
flutter build apk

# Construire pour iOS (macOS uniquement)
flutter build ios
```

## Structure du projet

```
lib/
  main.dart           # Point d'entrée principal avec le widget de compte à rebours
android/              # Configuration Android
ios/                  # Configuration iOS
assets/               # Ressources (images, polices)
```

## Personnalisation

### Modifier la date par défaut
Dans `lib/main.dart`, ligne ~65, vous pouvez modifier la date par défaut :
```dart
_reunionDate = DateTime.now().add(const Duration(days: 30));
```

### Changer les couleurs
Les couleurs du thème se trouvent dans la section `MaterialApp` et peuvent être personnalisées selon vos préférences.

### Ajouter des polices
Placez vos fichiers de polices dans le dossier `fonts/` et mettez à jour le `pubspec.yaml`.

## Technologies utilisées

- **Flutter** : Framework de développement mobile cross-platform
- **Dart** : Langage de programmation
- **Material Design** : Pour l'interface utilisateur
- **intl** : Pour le formatage des dates

## Notes d'amour 💝

Cette application a été créée avec amour pour célébrer les moments précieux de retrouvailles. Chaque seconde compte quand on attend de serrer quelqu'un dans ses bras ! 

*"La distance n'est rien quand quelqu'un signifie tout"* ❤️

---

Fait avec 💕 pour des retrouvailles pleines d'émotion
