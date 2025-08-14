@echo off
echo ======================================
echo    BUILD ANDROID APK - REUNITED
echo ======================================
echo.

REM Configuration
set PROJECT_DIR=%~dp0
set FLUTTER_BIN=C:\flutter\bin\flutter
set APK_DIR=%PROJECT_DIR%build\app\outputs\flutter-apk

echo 📱 Construction de l'APK Android...
cd /d "%PROJECT_DIR%"

echo 🔧 Nettoyage des builds précédents...
%FLUTTER_BIN% clean

echo 📦 Installation des dépendances...
%FLUTTER_BIN% pub get

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur lors de l'installation des dépendances
    pause
    exit /b 1
)

echo 🏗️ Construction de l'APK de release...
%FLUTTER_BIN% build apk --release --target lib/simple_mobile_app.dart

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur lors de la construction de l'APK
    pause
    exit /b 1
)

echo.
echo ✅ APK Android créé avec succès !
echo.
echo 📁 Fichier APK disponible à :
echo %APK_DIR%\app-release.apk
echo.
echo 📱 Pour installer sur votre téléphone :
echo    1. Activez "Sources inconnues" dans les paramètres Android
echo    2. Transférez le fichier APK sur votre téléphone
echo    3. Appuyez sur le fichier APK pour l'installer
echo    4. L'application sera installée comme une vraie app native
echo.

REM Ouverture du dossier contenant l'APK
if exist "%APK_DIR%\app-release.apk" (
    echo 🎉 APK prêt ! Ouverture du dossier...
    explorer "%APK_DIR%"
) else (
    echo ❌ APK introuvable. Vérifiez les erreurs ci-dessus.
)

pause
