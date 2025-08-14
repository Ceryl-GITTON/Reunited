@echo off
echo ======================================
echo    REUNITED COUNTDOWN - BUILD APK
echo ======================================
echo.

REM Configuration
set PROJECT_DIR=%~dp0
set FLUTTER_BIN=C:\flutter\bin\flutter
set APK_DIR=%PROJECT_DIR%build\app\outputs\flutter-apk

echo 🧹 Nettoyage du projet...
%FLUTTER_BIN% clean

echo 📦 Récupération des dépendances...
%FLUTTER_BIN% pub get

echo 🔨 Construction de l'APK Android...
%FLUTTER_BIN% build apk --release

if exist "%APK_DIR%\app-release.apk" (
    echo.
    echo ✅ APK créé avec succès !
    echo 📱 Emplacement: %APK_DIR%\app-release.apk
    echo.
    echo 📊 Taille du fichier:
    dir "%APK_DIR%\app-release.apk" | find "app-release.apk"
    echo.
    echo 🎯 Pour installer sur votre téléphone:
    echo    1. Activez les "Sources inconnues" dans les paramètres
    echo    2. Transférez le fichier APK sur votre téléphone
    echo    3. Ouvrez le fichier pour l'installer
    echo    4. Ajoutez le widget depuis l'écran d'accueil !
    echo.
) else (
    echo ❌ Erreur lors de la création de l'APK
    pause
    exit /b 1
)

echo 🎉 Widget Countdown prêt à être installé !
pause
