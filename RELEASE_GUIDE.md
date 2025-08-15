# 🚀 Guide de Release - Reunited Countdown Widget

## 📱 À propos du Widget

Le **Reunited Countdown Widget** est un widget Android natif qui affiche un compte à rebours en temps réel pour vos retrouvailles. Il se met à jour automatiquement toutes les minutes et peut être ajouté directement sur l'écran d'accueil Android.

## 🔄 Processus de Release Automatique

### Option 1: Release Automatique via Script
```bash
# Exécuter le script de release
create-release.bat

# Suivre les instructions:
# 1. Entrer la version (ex: v1.2.0)
# 2. Le script build l'APK automatiquement
# 3. Choisir de pousser le tag pour GitHub Actions
```

### Option 2: Release Manuelle via GitHub
1. **Aller sur GitHub Actions** → `Build and Release Android APK`
2. **Cliquer "Run workflow"**
3. **Entrer la version** (ex: v1.2.0)
4. **Lancer le workflow**

### Option 3: Release via Git Tag
```bash
# Commit les changements
git add .
git commit -m "Release v1.2.0 - Nouvelles fonctionnalités"

# Créer et pousser le tag
git tag v1.2.0
git push origin main
git push origin v1.2.0
```

## 📦 Ce qui est Automatisé

✅ **Build Flutter** - Compilation APK release  
✅ **Renommage APK** - Avec numéro de version  
✅ **GitHub Release** - Création automatique  
✅ **Upload APK** - Attaché à la release  
✅ **Description** - Génération automatique  
✅ **Badge** - Mise à jour du statut  

## 📱 Installation du Widget

### Pour les utilisateurs finaux:
1. **Télécharger** l'APK depuis [GitHub Releases](https://github.com/Ceryl-GITTON/Reunited/releases)
2. **Activer** "Sources inconnues" dans Android
3. **Installer** l'APK
4. **Appui long** sur l'écran d'accueil → Widgets
5. **Sélectionner** "Reunited Countdown"
6. **Placer** sur l'écran d'accueil

## 🔧 Build Local

### Prérequis
- Flutter 3.24.1+
- Java JDK 17
- Android SDK 35

### Commandes
```bash
# Nettoyer
flutter clean

# Dépendances
flutter pub get

# Build APK
flutter build apk --release
```

## 📊 Monitoring

- **GitHub Actions**: [Voir les builds](https://github.com/Ceryl-GITTON/Reunited/actions)
- **Releases**: [Téléchargements](https://github.com/Ceryl-GITTON/Reunited/releases)
- **Issues**: [Bugs et demandes](https://github.com/Ceryl-GITTON/Reunited/issues)

## 🎯 Fonctionnalités du Widget

- ⏰ **Countdown précis** (jours:heures:minutes:secondes)
- 🎨 **Design moderne** avec gradient coloré
- 📱 **Redimensionnable** sur l'écran d'accueil
- 🔄 **Mise à jour auto** toutes les minutes
- 💕 **Clic pour ouvrir** l'application Flutter
- 🌍 **Multi-langue** (Français/Anglais/Indonésien)

## 📈 Versions

- **v1.0.0** - Widget Android natif initial
- **v1.1.0** - Optimisations performance
- **v1.2.0** - Design amélioré

---

💡 **Tip**: Utilisez `create-release.bat` pour un processus de release rapide et automatisé !
