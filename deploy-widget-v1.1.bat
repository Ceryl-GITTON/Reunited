@echo off
echo ======================================
echo    BUILD ET DEPLOYMENT AUTOMATIQUE
echo ======================================
echo.

echo 🧹 Nettoyage...
C:\flutter\bin\flutter clean

echo 📦 Dependencies...
C:\flutter\bin\flutter pub get

echo 🔨 Build APK...
C:\flutter\bin\flutter build apk --release

if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ APK créée avec succès !
    
    echo 📋 Copie de l'APK...
    copy build\app\outputs\flutter-apk\app-release.apk reunited-countdown-widget-v1.1.apk
    
    echo 📤 Git add et commit...
    git add .
    git commit -m "Update widget with real-time countdown display - v1.1"
    
    echo 🚀 Push vers GitHub...
    git push origin main
    
    echo 🎉 Déployment terminé !
    echo 📱 APK disponible : reunited-countdown-widget-v1.1.apk
    
) else (
    echo ❌ Erreur lors du build APK
    pause
    exit /b 1
)

echo.
echo ✅ SUCCÈS : Widget avec compte à rebours en temps réel déployé !
pause
