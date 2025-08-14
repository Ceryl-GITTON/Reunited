# 🧪 Guide de Test - Package Reunited Countdown

## 📋 **Comment tester le package ?**

### 🚀 **1. Tests automatisés**

#### Installation des dépendances :
```bash
cd C:\Dedou\Reunited
C:\flutter\bin\flutter pub get
```

#### Exécution des tests unitaires :
```bash
C:\flutter\bin\flutter test packages/reunited_countdown/test/
```

#### Tests de build :
```bash
C:\flutter\bin\flutter analyze packages/reunited_countdown/
```

### 🎮 **2. Tests interactifs**

#### Option A : Application de test dédiée
```bash
# Lancer l'app de test
C:\flutter\bin\flutter run lib/test_package_app.dart -d web-server --web-port=8080
```

Puis ouvrir : http://localhost:8080

#### Option B : Script automatique
```bash
# Exécuter le script de test complet
test_package.bat
```

### 🎯 **3. Tests manuels à effectuer**

#### ✅ **Tests de base :**
1. **Affichage du countdown** : Vérifier que les jours/heures/minutes/secondes s'affichent
2. **Animations** : Vérifier que le cœur bat et la pulsation fonctionne
3. **Thèmes** : Tester les 3 thèmes prédéfinis (Romantic, Elegant, Vibrant)
4. **Changement de date** : Modifier la date cible et voir le countdown s'adapter

#### ✅ **Tests avancés :**
5. **Fuseaux horaires** : Tester France (DST), Indonésie, Local
6. **Thème personnalisé** : Créer un thème avec des couleurs custom
7. **Callbacks** : Vérifier que onCountdownComplete fonctionne
8. **Préférences** : Vérifier la sauvegarde des settings
9. **Responsive** : Tester sur différentes tailles d'écran

#### ✅ **Tests de robustesse :**
10. **Date passée** : Définir une date dans le passé
11. **Date très future** : Définir une date dans 10 ans
12. **Performance** : Afficher plusieurs widgets simultanément
13. **Mémoire** : Vérifier qu'il n'y a pas de fuites mémoire

### 🐛 **4. Débogage et validation**

#### Logs à surveiller :
```dart
// Dans la console Flutter, vérifier :
flutter: ⚙️ Config changed: 2025-08-15 18:30:00.000
flutter: 🎊 Advanced test completed successfully!
flutter: Timezone France test completed! 🌍
```

#### Erreurs communes à vérifier :
- ❌ Dépendances manquantes
- ❌ Conflits de versions
- ❌ Fuites mémoire
- ❌ Animations qui ne s'arrêtent pas
- ❌ Problèmes de timezone

### 📊 **5. Métriques de performance**

#### À mesurer :
- **Temps de build** : < 5 secondes
- **Taille du widget** : Raisonnable en mémoire
- **Fluidité animations** : 60 FPS
- **Temps de chargement** : < 1 seconde

### 🎨 **6. Tests visuels**

#### Screenshots à prendre :
1. Thème Romantic avec countdown actif
2. Thème Elegant avec sélecteur ouvert
3. Thème Vibrant avec date modifiée
4. Thème Custom avec animations désactivées
5. Message de completion (countdown = 0)

### ✨ **7. Validation finale**

#### Checklist de validation :
- [ ] Tous les tests unitaires passent
- [ ] Build sans erreurs ni warnings
- [ ] Interface utilisateur responsive
- [ ] Animations fluides
- [ ] Callbacks fonctionnels
- [ ] Sauvegarde persistante
- [ ] Documentation à jour
- [ ] Exemples fonctionnels

## 🚀 **Démarrage rapide**

Pour un test rapide (2 minutes) :
```bash
1. Ouvrir VS Code dans C:\Dedou\Reunited
2. Appuyer F5 pour lancer en debug
3. Ou exécuter : flutter run lib/test_package_app.dart
4. Choisir "Quick Demo (10s)" dans l'interface
5. Attendre 10 secondes pour voir le callback
```

## 📝 **Rapporter des bugs**

Si vous trouvez des problèmes :
1. Noter la configuration utilisée
2. Capturer les logs d'erreur
3. Prendre des screenshots si nécessaire
4. Documenter les étapes de reproduction

---

**Le package est maintenant prêt pour les tests ! 🎊**
