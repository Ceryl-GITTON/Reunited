@echo off
echo 🔍 Diagnostic GitHub Pages - Reunited Countdown

echo 📂 Vérification de la structure des fichiers...
echo.

echo === Dossier web ===
if exist "web" (
    echo ✅ Dossier web existe
    dir web /b | findstr /v "^$" | more
) else (
    echo ❌ Dossier web manquant
)

echo.
echo === Fichiers essentiels ===
if exist "web\index.html" (
    echo ✅ index.html existe
    echo Taille: 
    for %%I in ("web\index.html") do echo %%~zI bytes
) else (
    echo ❌ index.html manquant
)

if exist "web\main.dart.js" (
    echo ✅ main.dart.js existe
    echo Taille: 
    for %%I in ("web\main.dart.js") do echo %%~zI bytes
) else (
    echo ❌ main.dart.js manquant - PROBLÈME PRINCIPAL
)

if exist "web\flutter.js" (
    echo ✅ flutter.js existe
) else (
    echo ❌ flutter.js manquant
)

echo.
echo === Construction Flutter Web ===
echo 🔨 Test de construction...
flutter --version | findstr Flutter

echo.
echo 🌐 Construction web en cours...
flutter build web --base-href="/Reunited/" --web-renderer canvaskit

if %errorlevel% equ 0 (
    echo ✅ Construction réussie
) else (
    echo ❌ Erreur de construction
)

echo.
echo 📋 Vérification post-construction...
if exist "build\web\main.dart.js" (
    echo ✅ main.dart.js généré dans build\web\
    for %%I in ("build\web\main.dart.js") do echo Taille: %%~zI bytes
    
    echo 📂 Copie vers web\...
    copy "build\web\main.dart.js" "web\main.dart.js" > nul
    copy "build\web\flutter.js" "web\flutter.js" > nul
    copy "build\web\flutter_bootstrap.js" "web\flutter_bootstrap.js" > nul
    copy "build\web\flutter_service_worker.js" "web\flutter_service_worker.js" > nul
    
    echo ✅ Fichiers copiés
) else (
    echo ❌ main.dart.js pas généré - PROBLÈME DE COMPILATION
)

echo.
echo 🔗 Test de l'URL GitHub Pages...
echo https://ceryl-gitton.github.io/Reunited/

pause
