@echo off
echo ===================================
echo   REUNITED COUNTDOWN - RELEASE
echo ===================================
echo.

set /p VERSION="Entrez la version (ex: v1.0.0): "
if "%VERSION%"=="" (
    echo Erreur: Version requise
    pause
    exit /b 1
)

echo.
echo 🧹 Nettoyage du projet...
call flutter clean

echo.
echo 📦 Installation des dependances...
call flutter pub get
cd packages\reunited_countdown
call flutter pub get
cd ..\..

echo.
echo 🔨 Construction de l'APK release...
call flutter build apk --release

if errorlevel 1 (
    echo.
    echo ❌ Erreur lors de la construction
    pause
    exit /b 1
)

echo.
echo 📱 Copie de l'APK avec nom de version...
copy "build\app\outputs\flutter-apk\app-release.apk" "reunited-countdown-widget-%VERSION%.apk"

echo.
echo ✅ APK créé avec succès !
echo 📂 Fichier: reunited-countdown-widget-%VERSION%.apk
echo.

echo 🚀 Voulez-vous pousser un tag pour déclencher la release automatique ?
set /p PUSH_TAG="(y/n): "

if /i "%PUSH_TAG%"=="y" (
    echo.
    echo 📤 Création et push du tag %VERSION%...
    git add .
    git commit -m "Release %VERSION% - Widget Android avec countdown natif"
    git tag %VERSION%
    git push origin main
    git push origin %VERSION%
    
    echo.
    echo 🎉 Tag %VERSION% poussé !
    echo 🔗 GitHub Actions va créer la release automatiquement
    echo 📱 Surveillez: https://github.com/Ceryl-GITTON/Reunited/actions
)

echo.
echo 🎯 RÉSUMÉ:
echo - APK local: reunited-countdown-widget-%VERSION%.apk
echo - Taille: 22+ MB
echo - Widget Android natif inclus
echo.
pause
